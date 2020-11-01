module aux_timer
	(
	input logic clk,
	input logic resetN,
	input logic ena_cnt,
	input logic loadN,
	input logic [7:0] data_in,
	output logic tc
   );
	
	logic [7:0] count;
	
// Down counter
always_ff @(posedge clk or negedge resetN)
  begin
	
	if ( !resetN )	begin // Asynchronic reset
				count <=  0;
				if(!loadN) begin
					count <=data_in;
				end
			end
      else 	begin		// Synchronic logic	
				
				if(!loadN) begin
					count <= data_in;
				end
				else if(ena_cnt == '1 ) begin
					count <= (count =='0) ? '0 : count- 8'b1; // Remain zero if reached 0
				end
				
				
		end //Synch
	end //always	
	

	
	// Asynchronic tc
	assign tc = (count == '0 && resetN); // tc should not be '1 if resetN is pushed as answered in forum

					
			
					
endmodule
