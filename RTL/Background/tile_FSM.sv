

module	tile_FSM	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	exceed, 
					input logic startofLevel,  	
					input logic [3:0] index,
					input logic oneTensSec,				
					input logic endLevel,
					

					output loadAttributes,
					output logic visible,					
					output signed [10:0] topLeftX,
					output signed [10:0] topLeftY,
					output signed [10:0] rectangleWidth,
					output signed [10:0] rectangleHeight,
					output [2:0] generatedColorCode
					
					
										
);

enum logic [2:0] {wait_forStart, wait_forX, tree_moving} prState, nxtState;
localparam int TILE_MIN_X = 0;
localparam int TILE_MAX_X = 500;
localparam int TILE_MIN_TIME_TO_REAPPEAR = 1; //  second
localparam int TILE_MAX_TIME_TO_REAPPEAR = 40; // 4 seconds
logic generateCountdown;
logic [7:0] countDown;
logic finishWait;
logic generateTileAttributes;
									
random #(.SIZE_BITS(8),.MIN_VAL(TILE_MIN_TIME_TO_REAPPEAR),
			.MAX_VAL(TILE_MAX_TIME_TO_REAPPEAR)) // 0.5 to 5 seconds
			
			waitForReappearGenerator(
								.clk(clk),
								.resetN(resetN),
								.rise(generateCountdown),
								.seed(index<<1),
								.dout(countDown));
aux_timer reappearTimer(
							.clk(clk),
							.resetN(resetN),
							.ena_cnt(oneTensSec),
							.loadN(~generateCountdown),
							.tc(finishWait),
							.data_in(countDown));
							
							
random #(.SIZE_BITS(11),.MIN_VAL(TILE_MIN_X),.MAX_VAL(TILE_MAX_X))
		initialXgenerate(
								.clk(clk),
								.resetN(resetN),
								.rise(generateTileAttributes),
								.seed((index<<5)),
								.dout(topLeftX)
								);

 random #(.SIZE_BITS(11),.MIN_VAL(32),
									.MAX_VAL(640)) 
			
			generateWidth(
								.clk(clk),
								.resetN(resetN),
								.rise(generateTileAttributes),
								.seed(index*64),
								.dout(rectangleWidth));
								
	random #(.SIZE_BITS(11),.MIN_VAL(32),
									.MAX_VAL(480)) 
			
			generateHeight(
								.clk(clk),
								.resetN(resetN),
								.rise(generateTileAttributes),
								.seed(index*64),
								.dout(rectangleHeight));	
		
	random #(.SIZE_BITS(3),.MIN_VAL(0),
									.MAX_VAL(6)) 
			
			generateColor(
								.clk(clk),
								.resetN(resetN),
								.rise(generateTileAttributes),
								.seed(index),
								.dout(generatedColorCode));	
								
assign topLeftY = -rectangleHeight+10'h20; // +32 pixel for bitmap
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
		
		
		generateTileAttributes='0;	
		visible='0;
		loadAttributes='0;
		generateCountdown='0;
		case (prState)
		
			wait_forStart: begin // This state is waiting for level to start		
			generateCountdown ='1;
				if(startofLevel) begin
					nxtState = wait_forX;				
				end
			end 
			
			wait_forX: begin
				loadAttributes='1;
				generateTileAttributes='1; // Generate as long as waiting
				if(finishWait)
					nxtState = tree_moving;
				if(endLevel)
					nxtState = wait_forStart;
			end 
				
				
			tree_moving: begin
				
				visible='1;
				if(exceed) begin
					generateCountdown ='1;
					nxtState = wait_forX;
				end
				if(endLevel)
					nxtState = wait_forStart;
			end
			

		endcase
	end // always comb


endmodule
