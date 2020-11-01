//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	biker_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	moveRight,  // As long as this is preseed, the bike will move right
					input	logic	moveLeft, 	// As long as this is preseed, the bike will move left
					input logic randomMovement,					
					input logic collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic oneTensSec,					
					
					input int initialX,
					input int initialY,					
					input logic shoot,
					input logic [3:0] index, // Used as a seed for randomness
					input int speedX,
					input int speedY,
					input logic loadCoordinates,
					input logic enableMovement,
				
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,
					output	 logic movingRight,
					output	 logic movingLeft,
					output	 logic shootRequest
					
					
);

parameter int FRAME_MAX_WIDTH = 639;
parameter int FRAME_MAX_HEIGHT = 479;
parameter int BIKER_MAX_X = 591;
parameter int BIKER_MIN_X = 16;

logic generateNewMove;
logic generateShootRequest;
logic [7:0] countdown_sec;
logic [2:0] move;
logic [7:0] countdown_shoot;		
logic shootFlag='0;
// a module used to generate the  ball trajectory.  



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	FRAME_MAX_WIDTH * FIXED_POINT_MULTIPLIER;

int modifiedInitialX;
int XmodifiedSpeed;
int YmodifiedSpeed;
int currentSpeedX, topLeftX_FixedPoint; // local parameters 
int currentSpeedY, topLeftY_FixedPoint;


assign movingRight = (currentSpeedX>0 && enableMovement);
assign movingLeft = (currentSpeedX<0 && enableMovement);

assign modifiedInitialX = (initialX>=BIKER_MAX_X) ? (initialX-BIKER_MAX_X+BIKER_MIN_X) : initialX;



random #(.SIZE_BITS(8),.MIN_VAL(20),.MAX_VAL(70))
			countdownGenerator(
									.clk(clk),
									.resetN(resetN),
									.rise(generateNewMove),
									.seed(index<<2),
									.dout(countdown_sec));
									
random #(.SIZE_BITS(3),.MIN_VAL(0),.MAX_VAL(7)) 
			moveGenerator(
								.clk(clk),
								.resetN(resetN),
								.rise(generateNewMove),
								.seed(index),
								.dout(move));
aux_timer moveDelay(
							.clk(clk),
							.resetN(resetN),
							.ena_cnt(oneTensSec&&enableMovement),
							.loadN(~generateNewMove),
							.tc(generateNewMove),
							.data_in(countdown_sec));


	random #(.SIZE_BITS(8),.MIN_VAL(30),.MAX_VAL(100)) 
			shootCountdownGenerator(
								.clk(clk),
								.resetN(resetN),
								.rise(generateShootRequest),
								.seed(index<<2),
								.dout(countdown_shoot));
		
		
aux_timer countdownToShoot(
							.clk(clk),
							.resetN(resetN),
							.ena_cnt(oneTensSec),
							.loadN(~generateShootRequest),
							.tc(generateShootRequest),
							.data_in(countdown_shoot));
					
					
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation speed 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		currentSpeedX	<= 0;
		currentSpeedY	<= 0;
	end
	else 	begin
			
	
	if(!randomMovement) begin // Manual control
	
			if(startOfFrame) begin
					currentSpeedX	<= 0; // Default
					currentSpeedY	<= 0; // Default
						
					if(moveRight)
						currentSpeedX <= speedX;
					if(moveLeft)
						currentSpeedX <= -speedX;
			end
			shootRequest <= '0; // Default request
			if(shoot && !shootFlag) begin
				shootRequest <= '1;
				shootFlag <='1;
			end
			else if(!shoot)
				shootFlag <='0;
	end // Manual control
	else if(randomMovement) begin
		if(generateNewMove) begin
			currentSpeedX	<= 0; // Default
			currentSpeedY	<= 0; // Default
			case (move) 
				3'b000 : currentSpeedX <= speedX; // Move right
				3'b001 : currentSpeedX <= -speedX; // Move left
				3'b010 : currentSpeedY <= speedY; // move down
				3'b011 : currentSpeedY <= -speedY; // move up
				3'b100 : begin // Top right
					currentSpeedX <= speedX;
					currentSpeedY <= -speedY;
				end
				3'b101 : begin // Down right
					currentSpeedX <= speedX;
					currentSpeedY <= speedY;
				end
				3'b110 : begin // Down left
					currentSpeedX <= -speedX;
					currentSpeedY <= speedY;
				end
				3'b111 :  begin // Up left
					currentSpeedX <= -speedX;
					currentSpeedY <= -speedY;
				end
			endcase
		end
		shootRequest<=generateShootRequest;		
	end // Random movement
			
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  



// Collisions
		if(collision) begin	
				if ((HitEdgeCode [3] == 1) && currentSpeedX < 0 )  // hit left border of brick  
							currentSpeedX <= -currentSpeedX ; 
				
				else if ((HitEdgeCode [1] == 1) && currentSpeedX > 0)    // hit right border of brick  
							currentSpeedX <= -currentSpeedX ; //  while moving right
				
				else if (HitEdgeCode [2] == 1 && currentSpeedY < 0)  // hit top border of brick  
								currentSpeedY <= -currentSpeedY ;// while moving up 
					
					else if (HitEdgeCode [0] == 1 && currentSpeedY > 0)    // hit bottom border of brick  
							currentSpeedY <= -currentSpeedY ; //  while moving down
						
		end // Collision
	
	end 
	
		
end

// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= modifiedInitialX * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= initialY * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if(loadCoordinates) begin
			topLeftX_FixedPoint	<= modifiedInitialX * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<= initialY * FIXED_POINT_MULTIPLIER;
		end
		else if (startOfFrame && enableMovement) begin // perform  position integral only 30 times per second 
			
			if(!((topLeftX_FixedPoint+32*FIXED_POINT_MULTIPLIER) >= x_FRAME_SIZE && currentSpeedX >0 ||
				topLeftX_FixedPoint <= 0 && currentSpeedX < 0	)) begin
				
					// Not about to exceed limits
						topLeftX_FixedPoint  <= topLeftX_FixedPoint + currentSpeedX; 
				end
			
			
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + currentSpeedY; 
				
				
			

					
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
