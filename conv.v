`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:05 06/28/2018 
// Design Name: 
// Module Name:    conv 
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
module conv(
	input [2:0]select,
	input [7:0] pixel_in,
	input clk,
	input LOCKED,
	output [7:0] pixel_out,
	output valid
    );
	 
	 
	


	reg signed [7:0] r_00 = 0;reg signed [7:0] r_01 = 0;reg signed [7:0] r_02 = 0;
	reg signed [7:0] r_10 = 0;reg signed [7:0] r_11 = 0;reg signed [7:0] r_12 = 0;
	reg signed [7:0] r_20 = 0;reg signed [7:0] r_21 = 0;reg signed [7:0] r_22 = 0;
	
	
	integer kernel_00 = 0; integer kernel_01 = -1; integer kernel_02 = 0;
	integer kernel_10 = -1; integer kernel_11 = 5; integer kernel_12 = -1;
	integer kernel_20 = 0; integer kernel_21 = -1; integer kernel_22 = 0;
	
	integer kernel2_00 = 1; integer kernel2_01 = 0; integer kernel2_02 = -1;
	integer kernel2_10 = 2; integer kernel2_11 = 0; integer kernel2_12 = -2;
	integer kernel2_20 = 1; integer kernel2_21 = 0; integer kernel2_22 = -1;

	integer kernel3_00 = 1; integer kernel3_01 = 2; integer kernel3_02 = 1;
	integer kernel3_10 = 2; integer kernel3_11 = 4; integer kernel3_12 = 2;
	integer kernel3_20 = 1; integer kernel3_21 = 2; integer kernel3_22 = 1;
	
	

	wire [11:0] ver,hor;
	wire [11:0] tresh;
	reg [1:0] n = 0;
	wire [7:0] filter1, filter2, filter3;



	assign ver = ((r_00 + r_01 * 2 + r_02 - r_20 - r_21 * 2 - r_22 ) > 0)? (r_00 + r_01 * 2 + r_02 - r_20 - r_21 * 2 - r_22) : -(r_00 + r_01 * 2 + r_02 - r_20 - r_21 * 2 - r_22 ); 
	assign hor = ((r_00 - r_02 + r_10 * 2 - r_12 * 2 + r_20 - r_22 ) > 0)? (r_00 - r_02 + r_10 * 2 - r_12 * 2 + r_20 - r_22) : -(r_00 - r_02 + r_10 * 2 - r_12 * 2 + r_20 - r_22 );
	assign tresh=(ver+hor < 70)?8'b11111111:0;
	assign filter1 = ((r_00 * kernel_00) + (r_01 * kernel_01) + (r_02 * kernel_02) + 
							(r_10 * kernel_10) + (r_11 * kernel_11) + (r_12 * kernel_12) + 
							(r_20 * kernel_20) + (r_21 * kernel_21) + (r_22 * kernel_22));

							
							
	assign filter2 = ((r_00 * kernel2_00) + (r_01 * kernel2_01) + (r_02 * kernel2_02) + 
							(r_10 * kernel2_10) + (r_11 * kernel2_11) + (r_12 * kernel2_12) + 
							(r_20 * kernel2_20) + (r_21 * kernel2_21) + (r_22 * kernel2_22));
							
	assign filter3 = ((r_00 * kernel3_00) + (r_01 * kernel3_01) + (r_02 * kernel3_02) +
							(r_10 * kernel3_10) + (r_11 * kernel3_11) + (r_12 * kernel3_12) + 
							(r_20 * kernel3_20) + (r_21 * kernel3_21) + (r_22 * kernel3_22));
							



	assign pixel_out = (select[0])?filter1:(select[1])?tresh:(select[2])?filter3:r_11;
	//assign d_guss_blur=(r0 + 2*r1 + r2 + 2*r3 + 4*r4 + 2*r5 + r6 + 2*r7 + r8)/16;





	always @(posedge clk)
	begin
	if(LOCKED)
	begin
		if(n == 0)
			r_02 <= pixel_in;
		else if(n == 1)
			r_12 <= pixel_in;
		else if(n == 2)
		begin
			r_22 <= pixel_in;
			r_00 <= r_01;
			r_10 <= r_11;
			r_20 <= r_21;
			r_01 <= r_02;
			r_11 <= r_12;
			r_21 <= r_22;
		end
		n <= n + 1;	
				
		if(n >= 2)
			n <= 0;  
	end
	end	

			
			
			
	assign valid  = (n==2)?1:0;
//			if(pixel_y >= 352) begin
//				 n <= 0;
//				 c <= 0;
//			end
		


endmodule
