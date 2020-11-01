module	projectile_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if smiley hits an object
					input	logic	loadInitialCoordinates,
					input logic signed [10:0] intialX,
					input logic signed [10:0] intialY,
					input int speed,
					
					output	 logic signed 	[10:0]	topLeftX,// output the top left corner 
					output	 logic signed	[10:0]	topLeftY,
					output logic projectileEnd
					
);



const int	FIXED_POINT_MULTIPLIER	=	64;
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int  topLeftX_FixedPoint; // local parameters 
int  topLeftY_FixedPoint;


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<= intialX * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= intialY * FIXED_POINT_MULTIPLIER;
	end
	else begin	
		if(loadInitialCoordinates) begin
			topLeftX_FixedPoint	<= intialX * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<= intialY * FIXED_POINT_MULTIPLIER;
		end
		else if (startOfFrame) begin // perform  position integral only 30 times per second 

				topLeftY_FixedPoint  <= topLeftY_FixedPoint + speed; 
				
					
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    
assign projectileEnd = collision || (topLeftY_FixedPoint >= y_FRAME_SIZE) || (topLeftY_FixedPoint<=0);

endmodule
