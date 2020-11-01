
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller_all	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_player,
			input	logic	drawing_request_borders,
			input logic drawing_request_truck,
			input	logic	[ENEMY_BIKES_COUNT-1:0] drawing_request_bikers,
			input	logic	drawing_request_tree, // 1 logic to represent all
			input	logic	[ENEMY_BIKES_COUNT-1:0] drawing_request_enemy_projectiles,
			input	logic	[PLAYER_PROJECTILE_COUNT-1:0] drawing_request_player_projectiles,
			input	logic drawing_request_powerup,
		
			input	logic	loadLevel,
			input logic [3:0] inputLevel,
			input logic startGame,
			input logic endLevel,
			input logic godMode,
			input logic oneTensSec,
			
			
			
			output logic [ENEMY_BIKES_COUNT-1:0] bikersCollision, // active in case of collision between two objects
			output logic [(ENEMY_BIKES_COUNT+PLAYER_PROJECTILE_COUNT-1):0] projectilesCollision,// +4 for player projectiles
			output logic playerCollision, // active in case of collision between two objects
			
			
			output logic soundEnable,
			output logic [3:0] soundSelect,			
		
			
			output [ENEMY_BIKES_COUNT:0] enableBikersVector, // +1 for player bike
			output [3:0] lives,
			output [11:0] score, // in hundreds
			output [7:0] levelDisplay, // in tens
			output int levelSpeed,
			output logic [3:0] level,
			output  enablePowerup,
			output [15:0] enableTreesVector,
			output projectileSpeedPowerup,
			output playerSpeedPowerup
);

localparam logic [3:0] HIT_SOUND = 4'h8 ;
localparam logic [3:0] PLAYER_HIT_SOUND = 4'h7 ;
localparam logic [3:0] COUNTDOWN_SOUND = 4'h0 ;
localparam logic [3:0] PICKUP_SOUND = 4'h5 ;

localparam int INVINCIBLE_TIME = 10; // One sec
localparam int POWERUP_TIME = 50; // Five sec

parameter TREES_COUNT = 16;
parameter INITIAL_TREES_COUNT = 6;
parameter ENEMY_BIKES_COUNT = 8;
parameter PLAYER_PROJECTILE_COUNT = 4;
parameter MAX_LEVEL = 16;
parameter MAX_LIVES = 9;
parameter [3:0] PLAYER_LIVES = 4'b0011;
parameter int LEVEL_BASE_SPEED =90;
parameter int LEVEL_SPEED_MODIFIER = 10;
parameter int LEVEL_SPEED_POWERUP = 30;

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 
logic [ENEMY_BIKES_COUNT-1:0] enemyHit;
logic [MAX_LEVEL-1:0] levelForEnable;
logic loadTimer;
logic loadTimerPowerup;
logic vulnerable;
logic powerupCatch;
logic powerEnd;
logic levelSpeedDown;
logic [1:0] powerupType;

aux_timer flashTimer(
			.clk(clk),
			.resetN(resetN),
			.ena_cnt(oneTensSec),
			.loadN(~loadTimer),
			.tc(vulnerable),
			.data_in(INVINCIBLE_TIME)); // One second
			
			
aux_timer PowerupTimer(
			.clk(clk),
			.resetN(resetN),
			.ena_cnt(oneTensSec),
			.loadN(~loadTimerPowerup),
			.tc(powerEnd),
			.data_in(POWERUP_TIME));		
			
											
random #(.SIZE_BITS(2),.MIN_VAL(0),.MAX_VAL(3))
		powerupRand(
								.clk(clk),
								.resetN(resetN),
								.rise(oneTensSec), // Should always generate, will take value when enabled
								.dout(powerupType)
								);							
								
			
//assign soundEnable = SingleHitPulse;
assign enableBikersVector[ENEMY_BIKES_COUNT] = (lives>0);
assign levelSpeed = LEVEL_BASE_SPEED +LEVEL_SPEED_MODIFIER*level - LEVEL_SPEED_POWERUP*levelSpeedDown ;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		enableBikersVector[ENEMY_BIKES_COUNT-1:0]<=8'h0; // Should change according to level
		enableTreesVector[TREES_COUNT-1:0] <= 16'h0;
		flag	<= 1'b0;		
		soundSelect <= HIT_SOUND;
		lives <=PLAYER_LIVES;
		score <=0;
		loadTimer<='0;
		levelDisplay<='0;
		enablePowerup <=1'b1;
		levelForEnable<='0;
		levelSpeedDown<='0;
		playerSpeedPowerup<='0;
		projectileSpeedPowerup<='0;
		soundEnable<='0;
	end 
	else begin 
			// Defaults
			loadTimer <= 1'b0;			
			loadTimerPowerup<='0;
			soundEnable<='0;
			if(startGame) begin
				level<= inputLevel;			
				levelForEnable<= 16'hffff >> (MAX_LEVEL-inputLevel-1); // Sign Extension zero
				loadTimer<='0;
				lives <=PLAYER_LIVES;
				levelDisplay<=1;
				score <=0;
				levelSpeedDown<='0;
				playerSpeedPowerup<='0;
				projectileSpeedPowerup<='0;
			end
			else if(loadLevel) begin	
				// Loads the enable vector based on the levelForEnable
				enableBikersVector[ENEMY_BIKES_COUNT-1:0] <= levelForEnable[ENEMY_BIKES_COUNT-1:0];
				
				enableTreesVector[TREES_COUNT-1:0] <=
											(levelForEnable[TREES_COUNT-1:0] | {INITIAL_TREES_COUNT{'1}} );
				
				soundSelect <=COUNTDOWN_SOUND;			
			
			end
			else if(endLevel) begin
				if(level<4'b1111) begin //Increment level
					level<=level+4'b1;
					levelForEnable<= (levelForEnable<<1) +MAX_LEVEL'('b1); // E.G 00011 -> 00111 for enabling the next biker/tree
					if(levelDisplay[3:0]==9) begin
						levelDisplay[7:4] <=levelDisplay[7:4]+4'b1;
						levelDisplay[3:0]<= 0;
					end
					else
						levelDisplay <= levelDisplay+8'b1;
				end
			end
			
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
			
		
			
			
			if(!flag) begin // Synchronious logic based on flag
			
			
				// Enemy hit logic
				//
				if (enemyHit>0) begin 
					flag	<= 1'b1; // to enter only once 					
					soundSelect <=HIT_SOUND;
					soundEnable<='1;
					// Increment score
					if(score[3:0]==4'b1001) begin // If ones digit is 9
						score[3:0] <= 4'b0000; // zero the ones
						if (score[7:4]==4'b1001) begin // If tens digit is 9
							score[7:4] <= 4'b0000; // zero the tens
							score[11:8] <= score[11:8]+ 4'b1; // increment hundreds
						end
						else begin // increment tens
							score[7:4]<=score[7:4] +4'b1;
						end
						
					end
					else
						score<=score+12'b1; // increment ones
				end
				
				// Player hit logic
				//
				if(playerCollision && vulnerable && !godMode) begin
					flag	<= 1'b1; // to enter only once 					
					soundSelect <=PLAYER_HIT_SOUND;				
					soundEnable<='1;
					lives <= lives -4'b1;
					loadTimer <= '1;
				end		
		
				// Powerup capture logic
				//
					if(powerupCatch) begin
						flag<='1;
						enablePowerup <='0;
						soundSelect <=PICKUP_SOUND;				
						soundEnable<='1;				
						loadTimerPowerup<='1;
						case (powerupType) // Powerup logic
								2'b00: begin
									if(lives < MAX_LIVES) 
										lives <= lives +4'b1;
									else begin// So that powerup won't be wasted								
										projectileSpeedPowerup <='1;
									end			
								end
								2'b01: begin										
									projectileSpeedPowerup <='1;
								end
								2'b10: begin							
									levelSpeedDown<='1;
								end
								2'b11: begin							
									playerSpeedPowerup <='1;
								end
							endcase			
					end
					else begin
						enablePowerup <='1; // enabe again for respawning
						
							// Enable powerups as long as timer did not finish
							//
						projectileSpeedPowerup<=projectileSpeedPowerup && !powerEnd; 
						levelSpeedDown <= levelSpeedDown && !powerEnd;
						playerSpeedPowerup <= playerSpeedPowerup && !powerEnd;
					end
			end // Flag
			

			
			// Update enable vector for bikers if hit, using bitwise operators
			if(!loadLevel)
			enableBikersVector[ENEMY_BIKES_COUNT-1:0] <=
										enableBikersVector[ENEMY_BIKES_COUNT-1:0] &	(~enemyHit);
			

	end 
end


// PLayer hits at least a tree or an enemy projectile
assign playerCollision = (drawing_request_player && 
				(drawing_request_truck || drawing_request_tree || drawing_request_enemy_projectiles));

// Assigns with bitwise operators and sign extensions

// player catches the powerup			
assign powerupCatch = (drawing_request_powerup && drawing_request_player); 

// enemy bikes collide with border or tree
assign bikersCollision[ENEMY_BIKES_COUNT-1:0] = 
			drawing_request_bikers & 
			{ENEMY_BIKES_COUNT{drawing_request_borders ||drawing_request_tree}};

// Enemy projectiles hit tree or player
assign projectilesCollision[ENEMY_BIKES_COUNT-1:0] = 
			drawing_request_enemy_projectiles &
			{ENEMY_BIKES_COUNT{drawing_request_player || drawing_request_tree}};

// Enemy is hit by player projectile			
assign enemyHit =(drawing_request_bikers &
				{ENEMY_BIKES_COUNT{drawing_request_player_projectiles>0}}); // At least one of the projectiles

// Player projectiles hit a biker or tree
assign projectilesCollision[(ENEMY_BIKES_COUNT+PLAYER_PROJECTILE_COUNT-1):ENEMY_BIKES_COUNT] =
						drawing_request_player_projectiles & 
						{PLAYER_PROJECTILE_COUNT{ drawing_request_bikers || drawing_request_tree}};
		

endmodule
