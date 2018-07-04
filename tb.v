`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:04:17 06/29/2018
// Design Name:   top
// Module Name:   G:/v2.9/tb.v
// Project Name:  v2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg rx;

	// Outputs
	wire [5:0] rgb;
	wire hsync;
	wire vsync;
	wire [7:0] sim;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rx(rx), 
		.rgb(rgb), 
		.hsync(hsync), 
		.vsync(vsync), 
		.sim(sim)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rx = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always #10 clk=~clk;
      
endmodule

