

module	trees_mux	(	

					input		logic	[TREES_COUNT-1:0] inputInsideRectangle,					 
					input		logic	[TREES_COUNT-1:0] [7:0] RBGvector,					 
					
					output	logic	drawingRequest,
					output logic [7:0] RGBout
					
					
);


parameter TREES_COUNT = 16;

assign drawingRequest = (inputInsideRectangle>0);
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
	RGBout = RBGvector[11];
else if(inputInsideRectangle[12])
	RGBout = RBGvector[12];
else if(inputInsideRectangle[13])
	RGBout = RBGvector[13];
else if(inputInsideRectangle[14])
	RGBout = RBGvector[14];
else if(inputInsideRectangle[15])
	RGBout = RBGvector[15];
else
	RGBout=8'hff;

end


endmodule


