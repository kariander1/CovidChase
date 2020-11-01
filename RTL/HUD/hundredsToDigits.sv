

module	hundredsToDigits	(	
 
				
					input logic [11:0] number,
					output logic [3:0] ones,
					output logic [3:0] tens,
					output logic [3:0] hundreds
					
							
);

	
assign ones = number[3:0];
assign tens = number[7:4];
assign hundreds = number[11:8];

endmodule			