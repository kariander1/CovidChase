module	truckBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap
					
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA5, 8'hE9, 8'hE9, 8'hA8, 8'h8D, 8'h91, 8'h91, 8'h91, 8'h91, 8'h91, 8'h91, 8'h91, 8'h91, 8'h8C, 8'hA8, 8'hE9, 8'hE9, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hFC, 8'hF8, 8'hFC, 8'hFC, 8'hF8, 8'hFC, 8'hF8, 8'hFC, 8'hFC, 8'hFC, 8'hD8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hF8, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hF8, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hF8, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hF9, 8'hF9, 8'hD9, 8'hFD, 8'hF9, 8'hF9, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'hFC, 8'hFC, 8'hFC, 8'hF9, 8'hFD, 8'hFC, 8'hF9, 8'hFC, 8'hFC, 8'hF9, 8'hFC, 8'hFD, 8'hFD, 8'hFC, 8'hFC, 8'hF8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h44, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'hD8, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h24, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h64, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h60, 8'h29, 8'h29, 8'h60, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h60, 8'h29, 8'h25, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h60, 8'h2A, 8'h49, 8'h60, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h80, 8'h60, 8'h29, 8'h29, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h60, 8'h44, 8'h44, 8'h29, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h49, 8'h44, 8'h44, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h80, 8'h64, 8'h2E, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h2E, 8'h60, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h60, 8'h29, 8'h33, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h37, 8'h33, 8'h45, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h20, 8'h84, 8'h64, 8'h45, 8'h49, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h49, 8'h45, 8'h64, 8'h60, 8'h20, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h60, 8'h84, 8'h84, 8'h80, 8'h60, 8'h60, 8'h60, 8'h60, 8'h60, 8'h80, 8'h80, 8'h84, 8'h84, 8'h40, 8'h25, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h40, 8'h80, 8'h80, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h80, 8'h80, 8'h20, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h68, 8'h69, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h84, 8'h64, 8'h89, 8'h64, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6C, 8'h91, 8'h49, 8'h60, 8'h60, 8'h60, 8'h60, 8'h60, 8'h40, 8'h49, 8'h91, 8'h68, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};




// pipeline (ff) to get the pixel color from the array 	 
assign	drawingRequest=(RGBout != TRANSPARENT_ENCODING ); // get optional transparent command from the bitmpap   
//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBout <= TRANSPARENT_ENCODING;				
	end
	else begin
	
		
			if (InsideRectangle)  // inside an external bracket 
				RGBout <= object_colors[offsetY][offsetX];				
			else 
				RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
		
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 



			
	

endmodule