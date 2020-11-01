module streetTiles
	(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 												
					input logic startOfLevel,
					input int levelSpeed,
						
				
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,				
					
					output	logic	[9:0] drawingRequestVector, //output that the pixel should be dispalyed 
					output	logic	[9:0][7:0] RGBoutVector  //rgb value from the bitmap 
					
   );

	localparam int TILES_X=316;  	
	logic signed [9:0][10:0] tilesTPX;
	logic signed [9:0][10:0] tilesTPY;
	genvar i;
	generate
		 for (i=0; i<10; i=i+1) begin : generate_block_identifier
		 
 
		 backgroundTile_moveCollision TREE_inst
			(
				
				.clk(clk),
				.resetN(resetN),
				.startOfFrame(startOfFrame),// short pulse every start of frame 30Hz 										
				.speed(levelSpeed),
					
					.initialX(TILES_X),
					.initialY(i*48),
					.visible('1),
					.load('0),
					.topLeftX(tilesTPX[i]),// output the top left corner 
					.topLeftY(tilesTPY[i])// output the top left corner 
				
				
			);
			
	square_object  #(.OBJECT_WIDTH_X(8),.OBJECT_HEIGHT_Y(32),.OBJECT_COLOR(8'hff))
	SQUARE_inst
			(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),// current VGA pixel 
					.pixelY(pixelY),
					.topLeftX(tilesTPX[i]), //position on the screen 
					.topLeftY(tilesTPY[i]), //position on the screen 
					.drawingRequest(drawingRequestVector[i]), // indicates pixel inside the bracket
					.RGBout(RGBoutVector[i]) //optional color output for mux 
			);
	end 
	endgenerate
	
endmodule
