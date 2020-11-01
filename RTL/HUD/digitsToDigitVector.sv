

module	digitToDigitVector	(	
 
					
					input logic [3:0] livesDisplay,
					input logic [7:0] levelDisplay,
					input logic [11:0] scoreDisplay,
					input logic [3:0] countdownDisplay,
					
					output logic [DIGITS_COUNT -1:0][3:0] digitVector
					
										
);

parameter DIGITS_COUNT = 7;	

assign digitVector[0] =livesDisplay;
assign digitVector[1] =levelDisplay[3:0];
assign digitVector[2] =levelDisplay[7:4];
assign digitVector[3] =scoreDisplay[3:0];
assign digitVector[4] =scoreDisplay[7:4];
assign digitVector[5] =scoreDisplay[11:8];
assign digitVector[6] =countdownDisplay;
endmodule
	