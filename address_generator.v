`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:18:27 06/29/2018 
// Design Name: 
// Module Name:    address_generator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module address_generator(
		input clk,
		input reset,
		input LOCKED,
		output [14:0] address
    );
	 
	 
	 //hyper parameter
	parameter row = 125;


	reg [1:0] step = 0;
	reg [14:0] cnt = 0;





	assign address = cnt + step * row;
	
	
	always@(posedge clk) 
		if(LOCKED)
		begin
		if(reset)
			begin
				cnt <= 0;
				step <= 0;
			end
		
				step <= step + 1;	
				
				if(step == 2)
				begin
					cnt <= cnt + 1;
					step <= 0;
				end
			
			if (address  >= 31250) begin
					cnt <= 0;
					step <= 0;
				end
				
		end
endmodule
