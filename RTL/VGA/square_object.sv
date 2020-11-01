//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	signed [10:0] pixelX,// current VGA pixel 
					input 	logic	signed [10:0] pixelY,
					input 	logic signed [10:0] topLeftX, //position on the screen 
					input 	logic	signed [10:0] topLeftY,
					input	 	logic signed [10:0] objectWidthX,
					input		logic signed [10:0] objectHeightY,
					
					
					output 	logic signed	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic signed	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter logic USER_DIMENSIONS_AND_COLOR ='1;
parameter logic USER_TOP_LEFT ='0;
parameter  int OBJECT_WIDTH_X = 100;
parameter  int OBJECT_HEIGHT_Y = 100;
parameter  int OBJECT_TP_X = 100;
parameter  int OBJECT_TP_Y = 100;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
 logic signed [10:0] currentTopLeftX;
 logic signed [10:0] currentTopLeftY;
logic insideBracket ; 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign currentTopLeftX = USER_TOP_LEFT ? OBJECT_TP_X : topLeftX;
assign currentTopLeftY = USER_TOP_LEFT ? OBJECT_TP_Y : topLeftY;

assign rightX	= USER_DIMENSIONS_AND_COLOR ?(currentTopLeftX + OBJECT_WIDTH_X) : (currentTopLeftX + objectWidthX);
assign bottomY	= USER_DIMENSIONS_AND_COLOR ?(currentTopLeftY + OBJECT_HEIGHT_Y) : (currentTopLeftY + objectHeightY);



//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= currentTopLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= currentTopLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket ) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - currentTopLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - currentTopLeftY);
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
		
	end
end 
endmodule 