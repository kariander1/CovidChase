// (c) Technion IIT, Department of Electrical Engineering 2020 

// Implements a slow clock as an one-second counter with
// a one-secound output pulse and a 0.5 Hz duty 50 output
// Turbo input sets both outputs 16 times faster
 // Alex Grinshpun Oct 2018
 // Dudy mar2020 
module onetens_sec_counter      	
	(
   // Input, Output Ports
	input  logic clk, 
	input  logic resetN, 
	input  logic turbo,
	output logic onetens_sec, 
	output logic duty50
   );
	
	localparam onetensSecVal = 26'd50_000_000 / 10; //// large value for real time
//	localparam onetensSecVal = 26'd32 / 10;          //smaller parameter for simulation
	localparam onetensSecValTurbo = onetensSecVal/16; 
	int onetensSecCount ;
	int secten ;


always_comb
begin

	if (turbo ) 
		secten =  onetensSecValTurbo;
	else
		secten = onetensSecVal;
end

   always_ff @( posedge clk or negedge resetN )
   begin
	
      // Asynchronic reset
      if ( !resetN ) begin
			onetens_sec <= 1'b0;
			duty50 <= 1'b0;
			onetensSecCount <= 26'd0;
		end //asynch
		// Synchronic logic	
      else begin
				if (onetensSecCount >= secten) begin
					onetens_sec <= 1'b1;
					duty50 <= ~duty50;
					onetensSecCount <= 0;
				end
				else begin
					onetensSecCount <= onetensSecCount + 1;
					onetens_sec		<= 1'b0;
				end
		end //synch
	end // always
endmodule