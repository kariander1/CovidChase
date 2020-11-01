// (c) Technion IIT, Department of Electrical Engineering 2020 

// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty 50 output
// Turbo input sets both outputs 16 times faster
 // Alex Grinshpun Oct 2018
 // Dudy mar2020 
module one_sec_counter      	
	(
   // Input, Output Ports
	input  logic clk, 
	input  logic resetN, 
	input  logic turbo,
	output logic one_sec, 
	output logic duty50
   );
	
	localparam oneSecVal = 26'd50_000_000; //// large value for real time
//	localparam oneSecVal = 26'd32;          //smaller parameter for simulation
	localparam oneSecValTurbo = oneSecVal/16; 
	int oneSecCount ;
	int sec ;


always_comb
begin

	if (turbo ) 
		sec =  oneSecValTurbo;
	else
		sec = oneSecVal;
end

   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			one_sec <= 1'b0;
			duty50 <= 1'b0;
			oneSecCount <= 26'd0;
		end //asynch
		// Synchronic logic	
      else begin
				if (oneSecCount >= sec) begin
					one_sec <= 1'b1;
					duty50 <= ~duty50;
					oneSecCount <= 0;
				end
				else begin
					oneSecCount <= oneSecCount + 1;
					one_sec		<= 1'b0;
				end
		end //synch
	end // always
endmodule