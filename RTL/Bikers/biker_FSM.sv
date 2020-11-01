module biker_FSM
	(
					input	logic	clk,
					input	logic	resetN,
					input [3:0] index, // used for seed
					input logic startOfLevel,
					input [3:0] level,
					input logic enemyControlled,
					input logic enabled,
					input logic startMovement,
					input logic endLevel,
					input logic startOfFrame,
					input logic oneTensSec,
					input [7:0] generatedColor,
					input logic playerSpeedPowerup,
					
					output [7:0] colorMask,
					output logic loadCoordinates,
					output int speedX,
					output int speedY,
					output logic visible,
					output logic enableShoot,
					output logic enableMove
					
   );

parameter int X_BASE_SPEED = 131;
parameter int Y_BASE_SPEED = 90;
parameter int LEVEL_SPEED_MODIFIER = 5;
parameter int X_POWERUP_SPEED = 70;

		localparam int FLASH_TIME = 5; // half second
	localparam logic [7:0] FLASH_COLOR_MASK = 8'b11100000;
	
enum logic [2:0] {waitForStart, loadColorAndCoordinates,waitForMove, bikerMove, bikerFlash1,bikerFlash2} prState, nxtState;
logic loadTimer;
logic finishFlash;


									

		aux_timer flashTimer(
			.clk(clk),
			.resetN(resetN),
			.ena_cnt(oneTensSec),
			.loadN(~loadTimer),
			.tc(finishFlash),
			.data_in(FLASH_TIME[7:0])); // One second flash
										
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= waitForStart;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 		
		
		loadCoordinates='0;
		speedX=0;
		speedY=0;
		visible='1;
		enableShoot='0;
		loadTimer='0;
		enableMove='0; 
		colorMask = enemyControlled ? generatedColor : 8'b00000000;
		case (prState)
		
			waitForStart: begin // This state is waiting for level to start		
				visible='0;
				if(startOfLevel && enabled) begin
					nxtState = loadColorAndCoordinates;				
				end
			end 
			
			loadColorAndCoordinates: begin
				loadCoordinates='1;
				visible='0;			
				nxtState = waitForMove;
			end 
				
			waitForMove: begin

				if(startMovement)
					nxtState = bikerMove;
			end 
				
				
			bikerMove: begin
				enableMove='1;
				enableShoot='1;
				speedX = X_BASE_SPEED+ playerSpeedPowerup*X_POWERUP_SPEED;
				speedY =Y_BASE_SPEED ;
				if(enemyControlled) begin
					speedX = speedX +level*LEVEL_SPEED_MODIFIER;
					speedY = speedY +level*LEVEL_SPEED_MODIFIER;
				end		
				

				if(!enabled) begin
					loadTimer='1;
					nxtState = bikerFlash1;					
				end
				if(endLevel) begin
					nxtState = waitForStart;		
				end
				
			end
			bikerFlash1: begin
				if(startOfFrame)
					nxtState=bikerFlash2;
			end
			
			bikerFlash2: begin
				colorMask=FLASH_COLOR_MASK ;
				if(startOfFrame)
					nxtState=bikerFlash1;
				if(finishFlash || endLevel)
					nxtState=waitForStart;
			end

		endcase
	end // always comb

endmodule
