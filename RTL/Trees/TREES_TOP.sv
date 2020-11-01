module TREES_TOP
	(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 												
					input logic oneTensSec,
					input logic startOfLevel,
					input int levelSpeed,
						
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input logic endLevel,
					input logic [TREES_COUNT-1:0] enableTreesVector,
					
					output	logic	 drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
					
   );
	
	parameter TREES_COUNT =16;

	logic [TREES_COUNT-1:0] insideRectangleVector;
	logic [TREES_COUNT-1:0] [7:0] rgbVector;
	

logic [0:31] [0:31] [7:0] objectColors;
	
	trees_mux TREES_MUX(									
					.inputInsideRectangle(insideRectangleVector),					 
					.RBGvector(rgbVector),					 
					
					.drawingRequest(drawingRequest),
					.RGBout(RGBout)
								);
								
								
	treeBitMap bitMaps(
					.object_colors(objectColors)
								);
	genvar i;
	generate
		 for (i=0; i<TREES_COUNT; i=i+1) begin : generate_block_identifier
		 
 
		 TREE_TOP TREE_inst
			(						
				.resetN(resetN) ,	// input  resetN_sig
				.clk(clk) ,	// input  clk_sig
				.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
				.pixelX(pixelX) ,	// input [10:0] pixelX_sig
				.pixelY(pixelY) ,	// input [10:0] pixelY_sig		
				.object_colors(objectColors),
				.seedindex(i),
				.startofLevel(startOfLevel),
				.oneTensSec(oneTensSec),
				.treeSpeed(levelSpeed),
				.enable(enableTreesVector[i]),
				.endLevel(endLevel),
				.drawingRequest(insideRectangleVector[i]) ,	// output [10:0] bikerOffsetX_sig
				.RGBout(rgbVector[i]) 	// output [10:0] bikerOffsetY_sig
				
			);
	end 
	endgenerate
	
					
endmodule
