module	BIKER_TOP	(	
	input logic clk,
	input logic resetN,
	
	input logic randomMovement,
	input logic moveRight,
	input logic moveLeft,
	input logic collision,

	input logic startOfFrame,
	input logic playerRequestShoot,
	input logic enable,
	input logic oneTensSec,
	input logic startOfLevel,
	input logic startOfMovement,
	input logic endLevel,
	input logic playerSpeedPowerup,
	input logic [7:0] generatedColor,
	input logic [3:0]index,
	input int initialX,
	input int initialY,
	input logic [3:0] level,
	input logic [10:0] pixelX,
	input logic [10:0] pixelY,
		input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,
		input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors_turn,		

	output logic shootRequest,
	output logic [10:0] bikerTLX,
	output logic [10:0] bikerTLY,
	output logic drawingRequest,
	output	logic	[7:0] RGBout//rgb value from the bitmap  
	
);


logic	enableMovement;
logic	enableShoot;
logic	loadCoordinates;
	int speedX;
	int speedY;
logic	visble;
logic movingRight;
logic movingLeft;
logic	shootRequestFromMove;
logic	insideRectangle;
logic [10:0] bikerOffsetX;
logic [10:0] bikerOffsetY;
logic [7:0] colorMask;
logic [3:0] HitEdgeCode;
logic bikerRecDR;

assign	shootRequest = shootRequestFromMove & enableShoot;
assign	bikerRecDR = insideRectangle & visble;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

biker_moveCollision	BIKER_MOVE(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.moveRight(moveRight),
	.moveLeft(moveLeft),
	.randomMovement(randomMovement),
	.collision(collision),
	.oneTensSec(oneTensSec),
	.shoot(playerRequestShoot),
	.loadCoordinates(loadCoordinates),
	.enableMovement(enableMovement),
	.HitEdgeCode(HitEdgeCode),
	.index(index),
	.initialX(initialX),
	.initialY(initialY),
	.speedX(speedX),
	.speedY(speedY),
	.movingRight(movingRight),
	.movingLeft(movingLeft),
	.shootRequest(shootRequestFromMove),
	.topLeftX(bikerTLX),
	.topLeftY(bikerTLY));


biker_FSM	#(.LEVEL_SPEED_MODIFIER(5),.X_BASE_SPEED(131),
						.X_POWERUP_SPEED(70),.Y_BASE_SPEED(90))
BIKER_FSM
(
	.clk(clk),
	.resetN(resetN),
	.startOfLevel(startOfLevel),
	.enemyControlled(randomMovement),
	.enabled(enable),
	.startMovement(startOfMovement),
	.endLevel(endLevel),
	.startOfFrame(startOfFrame),
	.oneTensSec(oneTensSec),
	.playerSpeedPowerup(playerSpeedPowerup),
	.generatedColor(generatedColor),
	.index(index),
	.level(level),
	.loadCoordinates(loadCoordinates),
	.visible(visble),
	.enableShoot(enableShoot),
	.enableMove(enableMovement),
	.colorMask(colorMask),
	.speedX(speedX),
	.speedY(speedY));



square_object #(.OBJECT_COLOR(8'b01011011),.OBJECT_HEIGHT_Y(32)
	,.OBJECT_WIDTH_X(32))
	BIKER_SQUARE(
	.clk(clk),
	.resetN(resetN),
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(bikerTLX),
	.topLeftY(bikerTLY),
	.drawingRequest(insideRectangle),
	.offsetX(bikerOffsetX),
	.offsetY(bikerOffsetY)
	);


bikerDraw BIKER_DRAW(
					.clk(clk),
					.resetN(resetN),
					.offsetX(bikerOffsetX),// offset from top left  position 
					.offsetY(bikerOffsetY),
					.startOfFrame(startOfFrame),  // short pulse every start of frame 30Hz 
					.InsideRectangle(bikerRecDR), //input that the pixel is within a bracket 
					.colorMask(colorMask),	
					.turnRight(movingRight),
					.turnLeft(movingLeft),
					.object_colors(object_colors),
					.object_colors_turn(object_colors_turn),
					
					.drawingRequest(drawingRequest), //output that the pixel should be dispalyed 
					.RGBout(RGBout),  //rgb value from the bitmap 
					.HitEdgeCode(HitEdgeCode)

);

endmodule
