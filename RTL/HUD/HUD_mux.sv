//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

module	HUD_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		// bikes 
					input		logic panelDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] panelRGB, 
					
					input		logic	livesDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] livesRGB, 
					
					input		logic	heartDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] heartRGB, 
					
					input		logic	[1:0] levelDrawingRequest, // two set of inputs per unit
					input		logic	[1:0][7:0] levelRGB, 
					
					input		logic	[2:0] scoreDrawingRequest, // two set of inputs per unit
					input		logic	[2:0][7:0] scoreRGB, 
					
					input		logic	countdownDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] countdownRGB, 
					
					
					output   logic HUDdrawingRequest,
					output	logic	[7:0] outRGB

					
);



assign HUDdrawingRequest = panelDrawingRequest || livesDrawingRequest || heartDrawingRequest
										|| scoreDrawingRequest || countdownDrawingRequest|| levelDrawingRequest;


//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			outRGB	<= 8'b0;
	end
	else begin		
		if(livesDrawingRequest)
			outRGB <= livesRGB;  //first priority 
		else if(heartDrawingRequest)
			outRGB <= heartRGB;  //second priority 
		else if(levelDrawingRequest[0]) 
			outRGB <= levelRGB[0]; 
		else if(levelDrawingRequest[1]) 
			outRGB <= levelRGB[1];
		else if(scoreDrawingRequest[0])
			outRGB <= scoreRGB[0];  
		else if(scoreDrawingRequest[1])
			outRGB <= scoreRGB[1];
		else if(scoreDrawingRequest[2])
			outRGB <= scoreRGB[2];
		else if(panelDrawingRequest)
			outRGB <= panelRGB;  
		else if(panelDrawingRequest)
			outRGB <= panelRGB;  
		
	end
	
end

endmodule


