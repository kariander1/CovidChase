

module	bikerDraw	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic [7:0] colorMask,	
					input logic turnRight,
					input logic turnLeft,
					input	logic	[0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,
					input	logic	[0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors_turn,
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	 [7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

 logic frameCounter ='0;
 logic [1:0] offset_delta=2'b10;
 logic [10:0] refinedY;
 logic [10:0] refinedX;
 logic [7:0] refinedColor;
 logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] chosen_bitmap;
// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^6 = 64 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;



localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

// This is for knowing from which side the contact is
logic [0:3] [0:3] [3:0] hit_colors = 
{16'hC446,     
 16'h8C62,    
 16'h8932,
 16'h9113};

 

 assign	drawingRequest=(RGBout != TRANSPARENT_ENCODING ); // get optional transparent command from the bitmpap   
 assign refinedY=offsetY+offset_delta;
 assign refinedX = turnLeft ? OBJECT_WIDTH_X-offsetX :offsetX;
 assign chosen_bitmap = (turnLeft || turnRight) ? object_colors_turn :object_colors;
 assign refinedColor = (chosen_bitmap[refinedY][refinedX]== TRANSPARENT_ENCODING) ?
					TRANSPARENT_ENCODING : (chosen_bitmap[refinedY][refinedX]+colorMask);
// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
	
				RGBout <=	TRANSPARENT_ENCODING; // Default color is transparent so it won't be drawn
		
	end
	else begin
		if(startOfFrame) begin
			frameCounter <= frameCounter +1; 
			if(!frameCounter) //Every second frame change delta
				offset_delta<=2'b10 - offset_delta;
		end
		
					

			HitEdgeCode <= hit_colors[(offsetY) >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  
			if (InsideRectangle) begin // inside an external bracket 
				if(refinedY>=OBJECT_HEIGHT_Y) // If pixel with offset larger than bitmap
						RGBout <= TRANSPARENT_ENCODING ;
				else
						RGBout <= refinedColor ; // Apply with color mask	 	
				

			end
			else 
				RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
			
		
	end 
end




endmodule