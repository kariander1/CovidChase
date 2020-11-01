
module	projectile_FSM	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	shootRequestPlayer,  // short pulse every start of frame 30Hz 
					input	logic	shootRequestEnemy,  // short pulse every start of frame 30Hz 
					input logic projectileEnd,  //collision if smiley hits an object					
					input logic [3:0] level,
					input logic endLevel,
					input logic speedPowerup,
					

					output logic visible,// output if projectile should be visible
					output logic loadCoordinates,
					output int speed,
					output logic beingShot
					
					
);
parameter int ENEMY_PROJECTILE_BASE_SPEED = 130;
parameter int PLAYER_PROJECTILE_BASE_SPEED = 300;
parameter int LEVEL_SPEED_MODIFIER = 10;
parameter int PLAYER_PROJECTILE_POWERUP_SPEED = 200;

enum logic [2:0] {wait_load,player_load,enemy_load, player_shot, enemy_shot} prState, nxtState;

	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= wait_load;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		
		visible = '0; 		
		speed =0;
		beingShot='1;
		loadCoordinates='0;
		
		case (prState)
				
			wait_load: begin
				beingShot='0;
				if(shootRequestPlayer)
					nxtState = player_load;
				else if(shootRequestEnemy)
					nxtState = enemy_load;
				end // wait_load
				
			player_load: begin
				loadCoordinates='1;
				nxtState = player_shot;
			end
			
			enemy_load: begin
				loadCoordinates='1;
				nxtState = enemy_shot;
			end
			
			player_shot: begin
		
				visible='1;
				speed = -PLAYER_PROJECTILE_BASE_SPEED- PLAYER_PROJECTILE_POWERUP_SPEED*speedPowerup;; // Moves upwards
				if(projectileEnd || endLevel)
					nxtState = wait_load;
				end // shot
			enemy_shot: begin		
			visible='1;
				speed = ENEMY_PROJECTILE_BASE_SPEED + LEVEL_SPEED_MODIFIER*level; // Moves downwards
				if(projectileEnd || endLevel)
					nxtState = wait_load;
				end // shot
					
			endcase
	end // always comb


endmodule
