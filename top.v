`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:32 12/24/2017 
// Design Name: 
// Module Name:    top 
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
module top(
    input clk,
	 input rx,
	 input [2:0] select1,
	 //vga
	 output reg [5:0] rgb,
	 output hsync,
	 output vsync,
	 //dubug
	 output [7:0]sim
    );
	 
	 
clocking clk_wiz
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    .CLK_OUT1(CLK_OUT1),     // OUT
    .CLK_OUT2(CLK_OUT2),     // OUT
    .LOCKED(LOCKED));      // OUT


wire [7:0]  data;
wire 	[7:0] data_rx;
wire [10:0]pixel_x, pixel_y;

reg rd_en=0;
reg RxD_data_re;
 
async_receiver # (.Baud(115200)) uart_rec (
    .clk(CLK_OUT1), 
    .RxD(rx), 
    .RxD_data_ready(RxD_data_ready), 
    .RxD_data(data_rx), 
    .RxD_idle(), 
    .RxD_endofpacket(endof)
    );
assign sim = addra[7:0];
reg [14 : 0] addra;


always @(posedge CLK_OUT1)
	RxD_data_re <= RxD_data_ready;
	
	
initial addra = 0;
always @(posedge CLK_OUT1)
	begin
		if(RxD_data_re)
			addra <= addra + 1;
		if(addra == 31250)
			addra <= 0;
	end


wire [10:0] px,py;
reg [10:0] x=0,y=0;

	
VGA my_vga(
    .clk(CLK_OUT1), 
    .pixel_x(px), 
    .pixel_y(py), 
    .videoon(videoon), 
    .h_synq(hsync), 
    .v_synq(vsync)
    );	
	 

wire [7 : 0] dina;
wire [12 : 0] addrb;
wire [7 : 0] dinb;
wire [7 : 0] doutb;
wire [14:0] address;
wire myreset;

address_generator instance_name (
    .clk(CLK_OUT2),
	 .reset(myreset),
    .LOCKED(LOCKED), 
    .address(address)
    );




myram myram1 (
  .clka(CLK_OUT1), // input clka
  .wea(RxD_data_re), // input [0 : 0] wea
  .addra(addra), // input [12 : 0] addra
  .dina(data_rx), // input [7 : 0] dina
  .douta(douta), // output [7 : 0] douta
  .clkb(CLK_OUT2), // input clkb
  .web(0), // input [0 : 0] web
  .addrb(address), // input [12 : 0] addrb
  .dinb(), // input [7 : 0] dinb
  .doutb(doutb) // output [7 : 0] doutb
);	 
//address of last ram
wire [8:0] pixel_out;
conv myconv (
	 .select(select1),
  	 .LOCKED(LOCKED),
    .pixel_in(doutb), 
    .clk(CLK_OUT2), 
    .pixel_out(pixel_out), 
    .valid(valid)
    );

reg [14:0] addaram2 =0;
always @(posedge CLK_OUT2)
begin
	if(valid == 1)
		addaram2 <= addaram2 + 1;
	if(addaram2 == 31250)
		addaram2 <=0;
end

assign myreset = (addaram2 == 31250)?1:0; 
wire [8:0] doutb2;
myram ram2 (
  .clka(CLK_OUT2), // input clka
  .wea(valid), // input [0 : 0] wea
  .addra(addaram2), // input [12 : 0] addra
  .dina(pixel_out), // input [7 : 0] dina
  .douta(), // output [7 : 0] douta
  .clkb(CLK_OUT1), // input clkb
  .web(0), // input [0 : 0] web
  .addrb(x*125 + y), // input [12 : 0] addrb
  .dinb(), // input [7 : 0] dinb
  .doutb(doutb2) // output [7 : 0] doutb
);	 


wire [1:0] gray;
assign gray = (doutb2>>6) & 3;

always@(posedge CLK_OUT1)
	begin
	  if (videoon)
			if(px>=195 && px<445 && py>=155 && py<280)
				begin
					rgb <= {gray,gray,gray};
					x <= px -195;
					y <= py - 155;
				end
			else
				begin
					rgb <= 6'b101011;
					x <= x;
					y <= y;
				end
	  else
		  rgb  <= 6'b000000;
	end

endmodule

