module BIKERS_TOP
	(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 												
					input logic [ENEMY_BIKERS_COUNT-1:0] collisionVector,  //collision of each bike
					input logic oneTensSec,
					input logic startOfLevel,
					input	logic	playerCollision,  // As long as this is preseed, the bike will move right
					input	logic	moveRight,  // As long as this is preseed, the bike will move right
					input	logic	moveLeft, 	// As long as this is preseed, the bike will move left
					input logic requestShoot,			
				
					
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					
					input    logic [ENEMY_BIKERS_COUNT:0] enableVector,
					input    logic [3:0] level,
					input		logic startMovement,
					input logic endLevel,
					input logic playerSpeedPowerup,
					
					output	logic	[ENEMY_BIKERS_COUNT-1:0] drawingRequestVector, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic playerDrawingRequest, //output that the pixel should be dispalyed 
					output	logic [7:0] RGBplayer,  //rgb value from the bitmap 
					output	logic [ENEMY_BIKERS_COUNT-1:0] enemyShootRequest,
					output	logic playerShootRequest,
					output   logic [ENEMY_BIKERS_COUNT:0][10:0] bikersX,
					output   logic [ENEMY_BIKERS_COUNT:0][10:0] bikersY
					
					
   );
	
	parameter ENEMY_BIKERS_COUNT = 8;	
	localparam int INITIAL_X_MIN_VAL = 50;
	localparam int INITIAL_X_MAX_VAL = 575;
	localparam int INITIAL_Y_MIN_VAL = 50;
	localparam int INITIAL_Y_MAX_VAL = 375;
	localparam int PLAYER_DEFAULT_Y=430;
	localparam int PLAYER_DEFAULT_X=304;
	
	
	// Internal logics
	logic [0:31] [0:31] [7:0] objectColors;
	logic [0:31] [0:31] [7:0] objectColorsTurn;
	
	logic [ENEMY_BIKERS_COUNT:0] [7:0] rgbVector;	
	logic [ENEMY_BIKERS_COUNT:0] insideRectangleVector; // Gets into mux
	
	logic [10:0] generatedX;
	logic [10:0] generatedY;
	logic [7:0] generatedColor;

	// Assign outputs
	assign drawingRequestVector[ENEMY_BIKERS_COUNT-1:0] = insideRectangleVector[ENEMY_BIKERS_COUNT-1:0];
	assign playerDrawingRequest = insideRectangleVector[ENEMY_BIKERS_COUNT];
	assign RGBplayer = rgbVector[ENEMY_BIKERS_COUNT];
	

				
random #(.SIZE_BITS(8),.MIN_VAL(0),.MAX_VAL(255))
			colorRandom(
									.clk(clk),
									.resetN(resetN),
									.rise(startOfLevel),									
									.dout(generatedColor));
									
	random #(.SIZE_BITS(10),.MIN_VAL(INITIAL_X_MIN_VAL),.MAX_VAL(INITIAL_X_MAX_VAL))
			initialXgenerate(
									.clk(clk),
									.resetN(resetN),
									.rise(startOfLevel),
									.dout(generatedX)
									);
									
		random #(.SIZE_BITS(10),.MIN_VAL(INITIAL_Y_MIN_VAL),.MAX_VAL(INITIAL_Y_MAX_VAL))
			initialYgenerate(
									.clk(clk),
									.resetN(resetN),
									.rise(startOfLevel),
									.dout(generatedY)
									);
									
		bikers_mux BIKERS_MUX(				
					.inputInsideRectangle(insideRectangleVector),					 
					.RBGvector(rgbVector),				 
					.RGBout(RGBout)
								);
								
	bikerBitMap bitMaps(
					.object_colors(objectColors),// offset from top left  position 
					.object_colors_turn(objectColorsTurn)
					
								);
	BIKER_TOP player
			(
				.randomMovement('0) ,	// Player Controlled
				.collision(playerCollision) ,	// input  collision_sig				
				.resetN(resetN) ,	// input  resetN_sig
				.clk(clk) ,	// input  clk_sig
				.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
				.startOfLevel(startOfLevel) ,	// input  startOfLevel_sig
				.oneTensSec(oneTensSec) ,	// input  oneSec_sig
				.pixelX(pixelX) ,	// input [10:0] pixelX_sig
				.pixelY(pixelY) ,	// input [10:0] pixelY_sig
				.object_colors(objectColors),
				.object_colors_turn(objectColorsTurn),
				.moveRight(moveRight),
				.moveLeft(moveLeft),
				.enable(enableVector[ENEMY_BIKERS_COUNT]),


				.level(level),
				.initialX(PLAYER_DEFAULT_X),
				.initialY(PLAYER_DEFAULT_Y),				
				.endLevel(endLevel),
				.playerSpeedPowerup(playerSpeedPowerup),
				.startOfMovement(startMovement),
				
				.bikerTLX(bikersX[ENEMY_BIKERS_COUNT]),
				.bikerTLY(bikersY[ENEMY_BIKERS_COUNT]),
				.playerRequestShoot(requestShoot),
				.shootRequest(playerShootRequest),
				.generatedColor('0), // Leave player color				
				.drawingRequest(insideRectangleVector[ENEMY_BIKERS_COUNT]),
				.RGBout(rgbVector[ENEMY_BIKERS_COUNT])//rgb value from the bitmap 
			);
			
	genvar i;
	generate
		 for (i=0; i<ENEMY_BIKERS_COUNT; i=i+1) begin : generate_block_identifier
		 BIKER_TOP BIKER_inst
			(
				.randomMovement('1) ,	// All should be random
				.collision(collisionVector[i]) ,	// input  collision_sig				
				.resetN(resetN) ,	// input  resetN_sig
				.clk(clk) ,	// input  clk_sig
				.startOfFrame(startOfFrame) ,	// input  startOfFrame_sig
				.startOfLevel(startOfLevel) ,	// input  startOfLevel_sig
				.oneTensSec(oneTensSec) ,	// input  oneSec_sig
				.pixelX(pixelX) ,	// input [10:0] pixelX_sig
				.pixelY(pixelY) ,	// input [10:0] pixelY_sig
				.object_colors(objectColors),
				.object_colors_turn(objectColorsTurn),
				.moveRight('0),
				.moveLeft('0), // Used only in player controlled
				.enable(enableVector[i]),
				.index(i), // Used for making better randomness		
				.level(level),
				.endLevel(endLevel),
				.initialX(generatedX+i*64),
				.initialY(generatedY),
				.playerSpeedPowerup('0),
				.startOfMovement(startMovement),
				.bikerTLX(bikersX[i]),
				.bikerTLY(bikersY[i]),
				.playerRequestShoot('0),
				.shootRequest(enemyShootRequest[i]),
				.generatedColor(generatedColor+i*64), 				
				.drawingRequest(insideRectangleVector[i]),
				.RGBout(rgbVector[i])//rgb value from the bitmap  
			);
	end 
	endgenerate
	
					
endmodule
