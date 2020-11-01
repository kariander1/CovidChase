module PROJECTILES_TOP
	(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 												
					input logic [ENEMY_BIKES_COUNT+PLAYER_PROJECTILES_COUNT-1:0] collisionVector,  //collision of each bike			
					
					
					input	logic	shootRequestPlayer,  // As long as this is preseed, the bike will move right
					input	logic	[ENEMY_BIKES_COUNT-1:0] shootRequestEnemy, 	// As long as this is preseed, the bike will move left
						
					input [ENEMY_BIKES_COUNT:0][10:0] bikersXVector,
					input [ENEMY_BIKES_COUNT:0][10:0] bikersYVector,
					
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input logic [3:0] level,
					input logic endLevel,
					input logic speedPowerup,
					
					output	logic	[ENEMY_BIKES_COUNT-1:0] drawingRequestEnemyVector, //output that the pixel should be dispalyed 
					output	logic	[PLAYER_PROJECTILES_COUNT-1:0] drawingRequestPlayerVector, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout//rgb value from the bitmap  
					
   );
	
	parameter ENEMY_BIKES_COUNT = 8;
	parameter PLAYER_PROJECTILES_COUNT = 4;

	logic [ENEMY_BIKES_COUNT+PLAYER_PROJECTILES_COUNT-1:0] insideRectangleVector;
	logic [ENEMY_BIKES_COUNT+PLAYER_PROJECTILES_COUNT-1:0] [7:0] rgbVector;
	logic [PLAYER_PROJECTILES_COUNT-1:0] playerProjectilesBeingShot;
	logic [PLAYER_PROJECTILES_COUNT-1:0] playerProjectileRequestVector;
	logic [0:31] [0:31] [7:0] objectColorsPlayer;
	logic [0:31] [0:31] [7:0] objectColorsEnemy;
		
					
	// Assign outputs
	assign drawingRequestEnemyVector[ENEMY_BIKES_COUNT-1:0] = insideRectangleVector[ENEMY_BIKES_COUNT-1:0];
	assign drawingRequestPlayerVector[PLAYER_PROJECTILES_COUNT-1:0] = insideRectangleVector[(ENEMY_BIKES_COUNT+ PLAYER_PROJECTILES_COUNT-1):ENEMY_BIKES_COUNT];

// Calc shoot index
	always_comb begin	 // Requested not to do for
		playerProjectileRequestVector=0;
		if(shootRequestPlayer) begin
			if(!playerProjectilesBeingShot[0])
				playerProjectileRequestVector=4'b0001;
			else if(!playerProjectilesBeingShot[1])
				playerProjectileRequestVector=4'b0010;
			else if(!playerProjectilesBeingShot[2])
				playerProjectileRequestVector=4'b0100;
			else if(!playerProjectilesBeingShot[3])
				playerProjectileRequestVector=4'b1000;
			
			
		end	
	end
	
	projectileBitMap bitMaps(
					.object_colors_player(objectColorsPlayer),
					.object_colors_enemy(objectColorsEnemy)
								);
								
	projectiles_mux PROJECTILES_MUX(				
					.inputInsideRectangle(insideRectangleVector),					 
					.RBGvector(rgbVector),				 
					.RGBout(RGBout)
								);
								
	
	genvar i;
	generate
		 for (i=0; i<ENEMY_BIKES_COUNT; i=i+1) begin : generate_block_identifier
		 
 
		 PROJECTILE_TOP PROJECTILE_inst
			(						
					.resetN(resetN) ,	// input  resetN_sig
					.clk(clk) ,	// input  clk_sig
					.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
					.pixelX(pixelX) ,	// input [10:0] pixelX_sig
					.pixelY(pixelY) ,	// input [10:0] pixelY_sig
					.collision(collisionVector[i]) ,	// input  collision_sig
					.initial_x(bikersXVector[i]) ,	// input [10:0] initial_x_sig
					.initial_y(bikersYVector[i]) ,	// input [10:0] initial_y_sig
					.object_colors(objectColorsEnemy),
					.shootRequestEnemy(shootRequestEnemy[i]) ,	// input  shootRequestEnemy_sig
					.shootRequestPlayer('0) ,	// input  shootRequestPlayer_sig
					.speedPowerup('0),					
					.level(level),
					.endLevel(endLevel),
					.drawingRequest(insideRectangleVector[i]) ,	// output  projectileRecDR_sig
					.RGBout(rgbVector[i]) 	
				
			);
	end 
	endgenerate
	generate
		 for (i=ENEMY_BIKES_COUNT; i<ENEMY_BIKES_COUNT+PLAYER_PROJECTILES_COUNT; i=i+1) begin : player_projectile_block_identifier
		 PROJECTILE_TOP PROJECTILE_inst
			(
					.resetN(resetN) ,	// input  resetN_sig
					.clk(clk) ,	// input  clk_sig
					.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
					.pixelX(pixelX) ,	// input [10:0] pixelX_sig
					.pixelY(pixelY) ,	// input [10:0] pixelY_sig
					.collision(collisionVector[i]) ,	// input  collision_sig
					.initial_x(bikersXVector[ENEMY_BIKES_COUNT]) ,	// input [10:0] initial_x_sig
					.initial_y(bikersYVector[ENEMY_BIKES_COUNT]) ,	// input [10:0] initial_y_sig
					.object_colors(objectColorsPlayer),
					
					.shootRequestEnemy('0) ,	// input  shootRequestEnemy_sig
					.shootRequestPlayer(playerProjectileRequestVector[i-ENEMY_BIKES_COUNT]) ,	// input  shootRequestPlayer_sig
					
					.level(level),
					.speedPowerup(speedPowerup),
					.endLevel(endLevel),
					.drawingRequest(insideRectangleVector[i]) ,	// output  projectileRecDR_sig
					.RGBout(rgbVector[i]) 	,
					.beingShot(playerProjectilesBeingShot[i-ENEMY_BIKES_COUNT])	
								
			);
	end 
	endgenerate
					
endmodule
