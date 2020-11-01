module	powerupBitMap	(	
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
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCE, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC5, 8'hC4, 8'hC4, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hC4, 8'hE4, 8'hC5, 8'hC4, 8'hC9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCD, 8'hC4, 8'hE4, 8'hE4, 8'hC5, 8'hC5, 8'hA4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC4, 8'hE4, 8'hE4, 8'hC4, 8'hC5, 8'hC5, 8'hA4, 8'hA9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC5, 8'hE4, 8'hE4, 8'hE4, 8'hC4, 8'hC5, 8'hC4, 8'hA4, 8'hA4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hE4, 8'hE4, 8'hE4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hC4, 8'hE4, 8'hE4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hC4, 8'hE4, 8'hE4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'h84, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC4, 8'hE4, 8'hE4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hC9, 8'hE4, 8'hE4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'h89, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF6, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hC9, 8'hC4, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hC4, 8'hC4, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hC9, 8'hA0, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'h89, 8'hDB, 8'h76, 8'h56, 8'h56, 8'h56, 8'h57, 8'h57, 8'h57, 8'h57, 8'h37, 8'h7B, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hB6, 8'hA4, 8'hA4, 8'hA4, 8'h80, 8'h84, 8'hD6, 8'hDB, 8'h76, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h37, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hBA, 8'hB6, 8'hA9, 8'hA0, 8'hA0, 8'h80, 8'hB2, 8'hDF, 8'hFF, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h77, 8'h56, 8'h36, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h84, 8'h80, 8'h8D, 8'hDB, 8'hFF, 8'hDF, 8'h76, 8'h56, 8'h56, 8'h76, 8'h76, 8'h76, 8'h56, 8'h56, 8'h52, 8'h32, 8'h12, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h69, 8'h65, 8'hBA, 8'hDB, 8'hDB, 8'hDB, 8'h56, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h32, 8'h12, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h6D, 8'h69, 8'hB2, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h52, 8'h32, 8'h32, 8'h32, 8'h0E, 8'h76, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h6D, 8'h6E, 8'hDA, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'h52, 8'h32, 8'h32, 8'h52, 8'h32, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h0E, 8'h72, 8'hFF },
{8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h6D, 8'h6D, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h32, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h0E, 8'h72, 8'hFF },
{8'hFF, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h6D, 8'h49, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h96, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h0A, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h72, 8'h49, 8'h6D, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2E, 8'h2A, 8'h2E, 8'h0E, 8'h0A, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h6D, 8'h49, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h2E, 8'h0A, 8'h2A, 8'h2A, 8'h2A, 8'h2A, 8'h29, 8'h29, 8'h09, 8'h0A, 8'h2E, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h6D, 8'h49, 8'h49, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h6D, 8'h29, 8'h0A, 8'h09, 8'h09, 8'h09, 8'h09, 8'h09, 8'h09, 8'h09, 8'h09, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h6D, 8'hB6, 8'hFF, 8'h6D, 8'h6D, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h29, 8'h29, 8'h29, 8'h29, 8'h25, 8'h25, 8'h25, 8'h25, 8'h25, 8'h92, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h92, 8'h6D, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
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