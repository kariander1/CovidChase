//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	background_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		// bikes 
					input 	logic streetrequest,
					input		logic	[7:0] groundRGB, 
					
					input		logic	[9:0] streetTilesRequest, // two set of inputs per unit
					input		logic	[9:0] [7:0] streetTilesRGB, 				
					
					input		logic	[3:0] groundTileRequest, // two set of inputs per unit
					input		logic	[3:0][7:0] groundTileRGB, 				
				
			
					output	logic	[7:0] outRGB

					
);



//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			outRGB	<= 8'b0;
	end
	else begin	
					// White street tiles draw, requested no loop for this
		if(streetTilesRequest[0])
			outRGB<= streetTilesRGB[0];
		else if(streetTilesRequest[1])
			outRGB<= streetTilesRGB[1];
		else if(streetTilesRequest[2])
			outRGB<= streetTilesRGB[2];
		else if(streetTilesRequest[3])
			outRGB<= streetTilesRGB[3];
		else if(streetTilesRequest[4])
			outRGB<= streetTilesRGB[4];
		else if(streetTilesRequest[5])
			outRGB<= streetTilesRGB[5];
		else if(streetTilesRequest[6])
			outRGB<= streetTilesRGB[6];
		else if(streetTilesRequest[7])
			outRGB<= streetTilesRGB[7];
		else if(streetTilesRequest[8])
			outRGB<= streetTilesRGB[8];
		else if(streetTilesRequest[9])
			outRGB<= streetTilesRGB[9];			
				// Draw black street
		else if(streetrequest)
			outRGB <= groundRGB;		
						// Random ground tiles draw
		else if(groundTileRequest[0])
				outRGB<= groundTileRGB[0];
		else if(groundTileRequest[1])
				outRGB<= groundTileRGB[1];				
		else if(groundTileRequest[2])
					outRGB<= groundTileRGB[2];				
		else if(groundTileRequest[3])
					outRGB<= groundTileRGB[3];								
		else
			outRGB <= groundRGB; 	 
	end
end

endmodule


