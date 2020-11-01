//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	back_ground_drawSquare	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,
					

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq ,
					output	logic		streetDrawReq
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	topBracketOffest =	32;
const int	sideBracketsOffset =	16;
const int	lowerBracketOffset =	60;

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;

localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] LIGHT_COLOR = 3'b000 ;// bitmap of a light color

assign BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= DARK_COLOR ;	
				greenBits <= DARK_COLOR  ;	
				blueBits <= DARK_COLOR[1:0] ;	 //No warning
	end 
	else begin
	
	// defaults 
		greenBits <= 3'b110 ; 
		redBits <= 3'b010 ;
		blueBits <= LIGHT_COLOR[1:0];
		boardersDrawReq <= 	1'b0 ; 
		streetDrawReq <= '0;
					
	
		// draw  four lines with "bracketOffset" offset from the border 
		
		if (        pixelX == sideBracketsOffset || // Left botder
						pixelY == topBracketOffest || // Upper border
						pixelX == (xFrameSize-sideBracketsOffset) ||  // Right border
						pixelY == (yFrameSize-lowerBracketOffset))  // Lower border
			begin 
					boardersDrawReq <= 	1'b1 ; // pulse if drawing the boarders 
			end
	
		
		if(pixelX>=304 && pixelX<=336) begin // Draw street
			redBits <=  LIGHT_COLOR ;
			greenBits<= LIGHT_COLOR ; 
			blueBits <= LIGHT_COLOR[1:0] ; 
			streetDrawReq <= '1;
		end
	
	end; 	
end 
endmodule

