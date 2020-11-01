

module	colorCodeToRGB	(	
 
					
					input logic [2:0] generatedColorCode,
					output logic [7:0] RGBout
					
					
										
);
	
always_comb begin
	
		case(generatedColorCode) // backround colors
			3'b000 : RGBout <= 8'b11001100;
			3'b001 : RGBout <= 8'b01011001;
			3'b010 : RGBout <= 8'b11011010;
			3'b011 : RGBout <= 8'b01011011;
			3'b100 : RGBout <= 8'b01001101;
			3'b101 : RGBout <= 8'b01111000;
			3'b110 : RGBout <= 8'b11011000;
			3'b111 : RGBout <= 8'b11101110;			
		endcase
	
end
endmodule
	