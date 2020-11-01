module	treeDraw	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic [10:0] offsetY,
					input	logic InsideRectangle, //input that the pixel is within a bracket 
					input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic [7:0] RGBout  //rgb value from the bitmap
					
			
 ) ;
// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;
// generating a smiley bitmap



localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 



// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		
			RGBout <= TRANSPARENT_ENCODING;
		
		
	end
	else begin
	//	HitEdgeCode <= hit_colors[(offsetY) >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

		
		
			if (InsideRectangle)  // inside an external bracket 
				RGBout <= object_colors[offsetY][offsetX];	 
	
			else 
				RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
		
	end 
end

	
assign	drawingRequest=(RGBout != TRANSPARENT_ENCODING ); // get optional transparent command from the bitmpap   
	

endmodule