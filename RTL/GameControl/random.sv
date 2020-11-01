module random 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	rise,
	input logic [SIZE_BITS-1:0] seed,
	output  logic [SIZE_BITS-1:0]	dout	
  ) ;

  //generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
parameter int SIZE_BITS = 8;
parameter int MIN_VAL = 0;  //set the min and max values 
parameter int MAX_VAL = 479;
parameter int LEAP_START = 0;
parameter int LEAP_END = 1;

	logic [SIZE_BITS-1:0] counter;
	logic rise_d;
	

always_ff @(posedge clk or negedge resetN) begin
		if(!resetN) begin
			dout <= MIN_VAL[SIZE_BITS-1:0];
			counter <= seed;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+SIZE_BITS'('b1); // To remove warnings
			if(counter==LEAP_START)
				counter<=LEAP_END[SIZE_BITS-1:0];
			rise_d <= rise;
			if (rise && !rise_d) // rising edge 				
					dout <= counter;				
			if ( counter >= MAX_VAL[SIZE_BITS-1:0] ) 
				counter <=  MIN_VAL[SIZE_BITS-1:0] ; // set min and max mvalues 
			
		end
			
	
	end
	
 

 
endmodule

