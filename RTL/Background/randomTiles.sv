module randomTiles
	(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 												
					input logic startOfLevel,
					input int levelSpeed,
					input logic endLevel,
					input logic oneTensSec,
						
				
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,				
					
					output	logic	[3:0] drawingRequestVector, //output that the pixel should be dispalyed 
					output	logic	[3:0][7:0] RGBoutVector  //rgb value from the bitmap 
					
   );		
		
							
							
	
	
	genvar i;
	generate
		 for (i=0; i<4; i=i+1) begin : generate_block_identifier
		 
	TILE_TOP TILE_TOP_inst
	(
	
		.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
		.pixelX(pixelX) ,	// input [10:0] pixelX_sig
		.pixelY(pixelY) ,	// input [10:0] pixelY_sig
		.clk(clk) ,	// input  clk_sig
		.resetN(resetN) ,	// input  resetN_sig
		.startofLevel(startOfLevel) ,	// input  startofLevel_sig
		.oneTensSec(oneTensSec) ,	// input  oneTensSec_sig
		.endLevel(endLevel) ,	// input  endLevel_sig
		.speed(levelSpeed) ,	// input [31:0] speed_sig
		.index(i[2:0]) ,	// input [2:0] seedindex_sig
		.tileRGB(RGBoutVector[i]) ,	// output [7:0] tileRGB_sig
		.tileRecDR(drawingRequestVector[i]) 	// output  tileRecDR_sig
	);

	end 
	endgenerate
	
endmodule
