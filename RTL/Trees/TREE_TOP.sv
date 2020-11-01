module	TREE_TOP	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] pixelX,// offset from top left  position 
					input logic [10:0] pixelY,
					input logic startOfFrame,					
					input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,
					input logic oneTensSec,
					input logic startofLevel,
					input logic endLevel,
					input logic enable,
					input logic [3:0] seedindex,
					input int treeSpeed,
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic [7:0] RGBout  //rgb value from the bitmap
					
			
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

logic	exceed;
logic	[10:0] treeTLX;
logic	[10:0] treeTLY;
logic [10:0] treeOffsetX;
logic [10:0] treeOffsetY;
logic	visible;
logic	load;
int objectSpeed;
logic	[10:0] generatedX;
logic	insideRectangle;
logic 	treeRecDR;




fallingObject_moveCollision   #(.INITIAL_Y(0),.SPEED_MODIFIER(1))
	treeMoveCollision(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.load(load),
	.visible(visible),
	.speed(objectSpeed),
	.topLeftXRand(generatedX),
	.exceed(exceed),
	.topLeftX(treeTLX),
	.topLeftY(treeTLY));



randomFallingObject_FSM	#(.LEAP_END(336),.LEAP_START(272),.MIN_TIME_TO_REAPPEAR(5)
								,.MAX_TIME_TO_REAPPEAR(20),.MIN_X(48),.MAX_X(592))
treeFSM(
	.clk(clk),
	.resetN(resetN),
	.exceed(exceed),
	.startofLevel(startofLevel),
	.oneTensSec(oneTensSec),
	.endLevel(endLevel),
	.enable(enable),
	.index(seedindex),
	.objectSpeed(treeSpeed),
	.loadX(load),
	.visible(visible),
	.speed(objectSpeed),
	.topLeftX(generatedX));

assign treeRecDR = insideRectangle & visible;


square_object	#(.OBJECT_COLOR(8'b01011011),.OBJECT_HEIGHT_Y(32),.OBJECT_TP_X(100)
								,.OBJECT_TP_Y(100),.OBJECT_WIDTH_X(32),.USER_DIMENSIONS_AND_COLOR(1'b1)
								,.USER_TOP_LEFT(1'b0))
treeSquareObject(
	.clk(clk),
	.resetN(resetN),	
	.pixelX(pixelX),
	.pixelY(pixelY),
	.topLeftX(treeTLX),
	.topLeftY(treeTLY),
	.drawingRequest(insideRectangle),
	.offsetX(treeOffsetX),
	.offsetY(treeOffsetY)
	);

treeDraw treeDrawInstance(
	.clk(clk),
	.resetN(resetN),
	
	.offsetX(treeOffsetX),// offset from top left  position 
	.offsetY(treeOffsetY),
	.InsideRectangle(treeRecDR), //input that the pixel is within a bracket 
	 .object_colors(object_colors),
					
		.drawingRequest(drawingRequest), //output that the pixel should be dispalyed 
		.RGBout(RGBout)  //rgb value from the bitmap

);
endmodule
