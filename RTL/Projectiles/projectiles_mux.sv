
module	projectiles_mux	(	

					input		logic	[PLAYER_PROJECTILES+ENEMY_PROJECTILES-1:0] inputInsideRectangle,					 
					input		logic	[PLAYER_PROJECTILES+ENEMY_PROJECTILES-1:0] [7:0] RBGvector,					 
					
					
					output logic [7:0] RGBout
					
					
);

	parameter ENEMY_PROJECTILES = 8;
	parameter PLAYER_PROJECTILES = 4;

	
always_comb begin

// Requested not to do 'for' loop

if(inputInsideRectangle[0])
	RGBout = RBGvector[0];
else if(inputInsideRectangle[1])
	RGBout = RBGvector[1];
else if(inputInsideRectangle[2])
	RGBout = RBGvector[2];
else if(inputInsideRectangle[3])
	RGBout = RBGvector[3];
else if(inputInsideRectangle[4])
	RGBout = RBGvector[4];
else if(inputInsideRectangle[5])
	RGBout = RBGvector[5];
else if(inputInsideRectangle[6])
	RGBout = RBGvector[6];
else if(inputInsideRectangle[7])
	RGBout = RBGvector[7];
else if(inputInsideRectangle[8])
	RGBout = RBGvector[8];
else if(inputInsideRectangle[9])
	RGBout = RBGvector[9];
else if(inputInsideRectangle[10])
	RGBout = RBGvector[10];
else if(inputInsideRectangle[11])
	RGBout = RBGvector[11]; // Player projectiles after enemy
else
	RGBout=8'hff;

end


endmodule


