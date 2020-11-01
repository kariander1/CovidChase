
module	objects_mux_all	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		// bikes 
					input		logic	[ENEMY_BIKES_COUNT-1:0] bikersDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] bikerRGB, 
					
					input		logic	playerDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] playerRGB, 
					
					input		logic	treeDrawingRequest, // two set of inputs per unit
					input		logic [7:0] treeRGB, 
					
					input    logic [ENEMY_BIKES_COUNT-1:0] enemyProjectilesRequest,					
					input    logic [PLAYER_PROJECTILES_COUNT-1:0] playerProjectilesRequest,
					input    logic [7:0] ProjectileRGB,
					
		
					input    logic	HUDdrawingRequest,
					input		logic	[7:0] HUDrgb, 
					
					input    logic	truckDrawingRequest,
					input		logic	[7:0] truckRGB, 
					
					input    logic	powerupDrawingRequest,
					input		logic	[7:0] powerupRGB, 

		// background 
					input		logic	[7:0] backGroundRGB, 

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
					
);


parameter ENEMY_BIKES_COUNT = 8;
parameter TREES_COUNT = 16;
parameter PLAYER_PROJECTILES_COUNT = 4;
logic [7:0] tmpRGB;



assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		
		if(HUDdrawingRequest)
			tmpRGB <= HUDrgb; 	
		else if(treeDrawingRequest)
		
					tmpRGB<= treeRGB;
			
		else if(truckDrawingRequest)
			tmpRGB <= truckRGB; 	
		else if(playerDrawingRequest)
			tmpRGB <= playerRGB;  
		else if(bikersDrawingRequest)  // This synthesizes to a wide or on all bits<=> |bikersDrawingRequest					
					tmpRGB<= bikerRGB;	
		else if(enemyProjectilesRequest || playerProjectilesRequest )
			tmpRGB<=ProjectileRGB;		
		else if(powerupDrawingRequest)		
				tmpRGB<= powerupRGB;
		else
			tmpRGB <= backGroundRGB ; // last priority 
		end 
	end

endmodule


