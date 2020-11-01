module	fallingObject_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 					
					input	logic	load,
					input	logic	visible,	
					input int speed,
					input signed [10:0] topLeftXRand,
					
					output	logic	exceed,
					

					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY
					
);


parameter int INITIAL_Y = 0; // Should remain 0 for generating on top of screen
parameter int SPEED_MODIFIER =1;

const int	FIXED_POINT_MULTIPLIER	=	64;
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int  topLeftX_FixedPoint; // local parameters 
int  topLeftY_FixedPoint;



								
							
									
//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

assign exceed = topLeftY_FixedPoint >= y_FRAME_SIZE;
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= topLeftXRand * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	
	else begin		
	   if (load) begin
		
			topLeftX_FixedPoint	<= topLeftXRand * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;

		end		
		if ((startOfFrame) && (visible)) begin // perform  position integral only 30 times per second 
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + speed*SPEED_MODIFIER; 
					
			end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
