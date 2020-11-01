module	PROJECTILE_TOP	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] pixelX,// offset from top left  position 
					input logic [10:0] pixelY,
					input logic	[10:0] initial_x,// offset from top left  position 
					input logic [10:0] initial_y,
					input logic startOfFrame,					
					input logic collision,
					
					input logic	shootRequestEnemy,
					input logic shootRequestPlayer,
					input logic speedPowerup,
					input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,
					
					
					
					input logic endLevel,
					
					input logic [3:0] level,
					output logic beingShot,
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic [7:0] RGBout  //rgb value from the bitmap
					
			
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;


logic	beginShot;
logic	projectileEnd;
logic	visible;
logic	loadCoordinates;
int speed;
logic	squareInsideRectangle;
logic	[10:0] projectileTopLeftX;
logic	[10:0] projectileTopLeftY;
logic [10:0] projectileOffsetX;
logic [10:0] projectileOffsetY;
logic projectileRecDR;

assign	projectileRecDR = squareInsideRectangle & visible;
assign	beingShot = beginShot;

projectile_FSM	 #(.ENEMY_PROJECTILE_BASE_SPEED(130),.LEVEL_SPEED_MODIFIER(10)
						,.PLAYER_PROJECTILE_BASE_SPEED(300),.PLAYER_PROJECTILE_POWERUP_SPEED(200))
projectile_FSM_INST( 
	.clk(clk),
	.resetN(resetN),
	.shootRequestPlayer(shootRequestPlayer),
	.shootRequestEnemy(shootRequestEnemy),
	.projectileEnd(projectileEnd),
	.endLevel(endLevel),
	.speedPowerup(speedPowerup),
	.level(level),
	.visible(visible),
	.loadCoordinates(loadCoordinates),
	.beingShot(beginShot),
	.speed(speed));


projectile_moveCollision	

projectile_move_inst(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.collision(collision),
	.loadInitialCoordinates(loadCoordinates),
	.intialX(initial_x),
	.intialY(initial_y),
	.speed(speed),
	.projectileEnd(projectileEnd),
	.topLeftX(projectileTopLeftX),
	.topLeftY(projectileTopLeftY));


square_object	#(.OBJECT_COLOR(8'b01011011),.OBJECT_HEIGHT_Y(32)
						,.OBJECT_WIDTH_X(32))

projectile_sqaure_inst(
	.clk(clk),
	.resetN(resetN),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(projectileTopLeftX),
	.topLeftY(projectileTopLeftY),
	.drawingRequest(squareInsideRectangle),
	.offsetX(projectileOffsetX),
	.offsetY(projectileOffsetY)
	);


projectileDraw projectileDrawInstance(
	.clk(clk),
	.resetN(resetN),	
	.offsetX(projectileOffsetX),// offset from top left  position 
	.offsetY(projectileOffsetY),
	.InsideRectangle(projectileRecDR), //input that the pixel is within a bracket 
	.object_colors(object_colors),		
	.drawingRequest(drawingRequest), //output that the pixel should be dispalyed 
	.RGBout(RGBout)  //rgb value from the bitmap

);


endmodule
