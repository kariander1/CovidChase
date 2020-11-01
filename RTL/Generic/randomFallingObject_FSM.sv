

module	randomFallingObject_FSM	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	exceed, // pulse for tree that exceed from the screen
					input logic startofLevel,  	
					input logic [3:0] index,
					input logic oneTensSec,					
					input int objectSpeed,
					input logic endLevel,
					input logic enable,
					

					output loadX,
					output logic visible,
					output int speed,
					output signed [10:0] topLeftX
					
					
										
);

enum logic [2:0] {wait_forStart, wait_forX, moving} prState, nxtState;
localparam int COUNTDOWN_BITS =8;
parameter int MIN_X = 304;
parameter int MAX_X = 304;
parameter int LEAP_START = 0;
parameter int LEAP_END = 1;
parameter int MIN_TIME_TO_REAPPEAR = 50;
parameter int MAX_TIME_TO_REAPPEAR = 150;
logic generateCountdown;
logic [COUNTDOWN_BITS-1:0] countDown;
logic finishWait;
logic generateX;
									
random #(.SIZE_BITS(COUNTDOWN_BITS),.MIN_VAL(MIN_TIME_TO_REAPPEAR),
			.MAX_VAL(MAX_TIME_TO_REAPPEAR)) // 0.5 to 5 seconds
			
			waitForReappearGenerator(
								.clk(clk),
								.resetN(resetN),
								.rise(generateCountdown),
								.seed(index*2),
								.dout(countDown));
aux_timer reappearTimer(
							.clk(clk),
							.resetN(resetN),
							.ena_cnt(oneTensSec),
							.loadN(~generateCountdown),
							.tc(finishWait),
							.data_in(countDown));
							
							
random #(.SIZE_BITS(11),.MIN_VAL(MIN_X),.MAX_VAL(MAX_X) ,
			.LEAP_START(LEAP_START),
			.LEAP_END(LEAP_END))
		initialXgenerate(
								.clk(clk),
								.resetN(resetN),
								.rise(generateX),
								.seed((index*32)),
								.dout(topLeftX)
								);
							
	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= wait_forStart;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		
		speed=0;
		generateX='0;	
		visible='0;
		loadX='0;
		generateCountdown='0;
		case (prState)
		
			wait_forStart: begin // This state is waiting for level to start		
			generateCountdown ='1;
				if(startofLevel) begin
					nxtState = wait_forX;				
				end
			end 
			
			wait_forX: begin
				loadX='1;
				generateX='1; // Generate as long as waiting
				if(finishWait && enable)
					nxtState = moving;
				if(endLevel)
					nxtState = wait_forStart;
			end 
				
				
			moving: begin
				speed =objectSpeed;
				visible='1;
				if(exceed || !enable) begin
					generateCountdown ='1;
					nxtState = wait_forX;
				end
				if(endLevel)
					nxtState = wait_forStart;
			end
			

		endcase
	end // always comb


endmodule
