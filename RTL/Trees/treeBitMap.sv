module	treeBitMap	(	
				output	logic	[0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;   


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;
// generating a smiley bitmap





assign object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h95, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h4C, 8'h95, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h4D, 8'h71, 8'h4C, 8'h28, 8'h48, 8'h28, 8'h4C, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h4D, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h48, 8'h28, 8'h28, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4D, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h4C, 8'h2C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h48, 8'h28, 8'h2C, 8'h96, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h95, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h95, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h4C, 8'h4C, 8'h48, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h95, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h28, 8'h4C, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h95, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h28, 8'h4C, 8'h71, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'h95, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h48, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h2C, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'hFF, 8'hFF },
{8'h91, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h4C, 8'h95, 8'hFF },
{8'h4D, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h95 },
{8'hFF, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h28, 8'h48, 8'h48, 8'h4C, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4C, 8'hFF },
{8'hFF, 8'hFF, 8'h4D, 8'h4C, 8'h28, 8'h28, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h4C, 8'h4C, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h48, 8'h28, 8'h28, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h4D },
{8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h28, 8'h24, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h48, 8'h4C, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h28, 8'h48, 8'h91, 8'h48, 8'h28, 8'h28, 8'h28, 8'h28, 8'h48, 8'h91, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h71, 8'h71, 8'h4D, 8'h24, 8'h24, 8'h28, 8'h28, 8'h28, 8'h48, 8'h28, 8'h28, 8'h28, 8'h24, 8'h28, 8'h28, 8'h48, 8'h4D, 8'h92, 8'h69, 8'h48, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4D, 8'h28, 8'h24, 8'h28, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h49, 8'h91, 8'h44, 8'h44, 8'h91, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'h24, 8'h28, 8'h4D, 8'h44, 8'h24, 8'h49, 8'h71, 8'h69, 8'h91, 8'h48, 8'h44, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h44, 8'h49, 8'hFF, 8'h8D, 8'h44, 8'hFF, 8'hFF, 8'h49, 8'h44, 8'h44, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h44, 8'h44, 8'h91, 8'hFF, 8'hFF, 8'h44, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h48, 8'h24, 8'hFF, 8'h91, 8'h24, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h44, 8'h6D, 8'h69, 8'h48, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h68, 8'h44, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h8D, 8'h44, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h92, 8'h44, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h91, 8'h44, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h44, 8'h44, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h44, 8'h44, 8'h44, 8'h44, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h44, 8'h24, 8'h24, 8'h24, 8'h24, 8'h24, 8'h49, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h6D, 8'h6D, 8'h6D, 8'h24, 8'h6D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};





endmodule