module	heartBitMap	(	
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

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h60, 8'h00, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h64, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA4, 8'hA4, 8'hA4, 8'hA4, 8'hC5, 8'h60, 8'h00, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h64, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h45, 8'h60, 8'h89, 8'hD6, 8'hD6, 8'hD6, 8'hCD, 8'hA4, 8'h84, 8'h60, 8'h45, 8'h49, 8'h64, 8'h60, 8'hA4, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h84, 8'h60, 8'h45, 8'h49, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hC4, 8'hCD, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hA4, 8'hA5, 8'hC5, 8'h40, 8'h00, 8'h60, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA4, 8'hCD, 8'hFF, 8'hFB, 8'hD6, 8'hCD, 8'hA4, 8'hA5, 8'hA5, 8'h64, 8'h40, 8'h84, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA4, 8'hCD, 8'hFF, 8'hD2, 8'hA0, 8'hA4, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA4, 8'hCD, 8'hFF, 8'hD2, 8'hA4, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h20, 8'h60, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h40, 8'h20, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h40, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hC5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h45, 8'h40, 8'h84, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h64, 8'h40, 8'h45, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h00, 8'h40, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h20, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h24, 8'h45, 8'h84, 8'hA4, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h84, 8'h84, 8'h44, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h00, 8'h60, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h40, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h60, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h40, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h60, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h40, 8'h00, 8'h92, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h60, 8'hC5, 8'hA5, 8'hA5, 8'hA5, 8'hC5, 8'h40, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h20, 8'h84, 8'hC5, 8'h64, 8'h20, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h60, 8'hC5, 8'h40, 8'h00, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h25, 8'h65, 8'h60, 8'h44, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h49, 8'h00, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};
  

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	TRANSPARENT_ENCODING;
	end
	else begin	
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX];	 
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule