
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_FSM	(
			
			input		logic	clk,
			input		logic	resetN,
			input	logic	oneSec,
			input logic [ENEMY_BIKES_COUNT:0] bikersEnableVector,
			input    logic userStart,
				
				output logic startOfLevel,
				output logic startOfMovement,
				output logic [3:0 ]HUDcountdown,
				output logic HUDcountdownEnable,
				output logic loadLevel,
				output logic startGame,
				output logic endLevel,
				output logic playSound,
				output logic enableLogo
				
		
);

parameter ENEMY_BIKES_COUNT = 16;
enum logic [3:0] {welcomeTone,welcomeScreen,loadlLevel,startLevel,countdown3,countdown2
									,countdown1,levelMove,levelPlay} prState, nxtState;

always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= welcomeTone;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 		
		HUDcountdownEnable='0;
		HUDcountdown =4'b0000;
		startOfLevel='0;
		startOfMovement='0;
		loadLevel='0;
		startGame= '0;
		endLevel='0;
		playSound='0;
		enableLogo='0;
		case (prState)	
		welcomeTone:	begin		
			playSound='1; // Play welcome tone
			nxtState = welcomeScreen;
			end
		welcomeScreen: begin // This state is waiting for level to start	
			startGame= '1;	
			enableLogo='1;
				if(userStart) begin
					nxtState = loadlLevel;				
				end
		end
		loadlLevel:begin
			loadLevel='1;
			
			nxtState = startLevel;
		end 
		startLevel:begin
			startOfLevel='1;
			if(oneSec) begin
				playSound ='1;
				nxtState = countdown3;
			end
		end 
		countdown3: begin
			HUDcountdown=4'h3;
			HUDcountdownEnable='1;
			if(oneSec) begin
				playSound ='1;
				nxtState = countdown2;
			end
		end 
		countdown2:begin
			HUDcountdown=4'h2;
			HUDcountdownEnable='1;
			if(oneSec) begin
				playSound ='1;
				nxtState = countdown1;
			end
		end 
		countdown1:begin
			HUDcountdown=4'h1;
			HUDcountdownEnable='1;
			if(oneSec) begin
				playSound ='1;
				nxtState = levelMove;
			end
		end
		levelMove:begin
			startOfMovement='1;
			nxtState = levelPlay;
		end 
		levelPlay:		begin	
			if(bikersEnableVector[ENEMY_BIKES_COUNT-1:0] == 0) begin
				endLevel ='1;
				nxtState = loadlLevel; // Start next level
			end
			if(!bikersEnableVector[ENEMY_BIKES_COUNT]) begin
				endLevel ='1;
				nxtState = welcomeScreen;
				
				end
			
		end	
		endcase
	end // always comb
endmodule
