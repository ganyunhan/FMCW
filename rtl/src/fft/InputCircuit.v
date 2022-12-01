`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/20 09:58:08
// Design Name: 
// Module Name: InputCircuit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module InputCircuit
#(
	parameter   WIDTH = 16
)
(
	input				 clock       , // Master Clock
	input 				 reset       , // Active High Asynchronous Reset
	input 	[2:0] 		 mode_di_sel , // Point Select
	input 			     data_di_en  , // Input Data Enable
	input  [WIDTH-1 : 0] data_di_re  , // Input Data (Real)
	input  [WIDTH-1 : 0] data_di_im  , // Input Data (Imag)

	output 				 sel_do_32   ,
	output 				 sel_do_64   ,
	output 				 sel_do_128  ,
	output 				 sel_do_256  ,
	output 				 sel_do_512  ,
	output 				 sel_do_1024 ,
	output 				 data1_do_en , // Output Data1 Enable
	output 				 data2_do_en , // Output Data2 Enable
	output 				 data3_do_en , // Output Data3 Enable
	output [WIDTH-1 : 0] data1_do_re , // Output Data1 (Real) 
	output [WIDTH-1 : 0] data2_do_re , // Output Data2 (Real)
	output [WIDTH-1 : 0] data3_do_re , // Output Data3 (Real)
	output [WIDTH-1 : 0] data1_do_im , // Output Data1 (Imag)
	output [WIDTH-1 : 0] data2_do_im , // Output Data2 (Imag)
	output [WIDTH-1 : 0] data3_do_im , // Output Data3 (Imag)

	output [2:0] 	tw_addr_shift_do ,
	output [9:0]		 cnt_do_max	 , // Max=1023
	output [2:0] 		 mode_do_sel , // Point Select
	output [3:0] do_logn_minus_logm1 , // 
	output [3:0] do_logn_minus_logm2 , // 
	output [3:0] do_logn_minus_logm3 , // 
	output [3:0] do_logn_minus_logm4 , // 
	output [3:0] do_logn_minus_logm5   // 
);

//-----------------------------------------------------------------------
// mode_sel: 3'b000: 32   point FFT;	mode_sel: 3'b001: 64   point FFT;
// mode_sel: 3'b010: 128  point FFT;	mode_sel: 3'b011: 256  point FFT;
// mode_sel: 3'b100: 512  point FFT;	mode_sel: 3'b101: 1024 point FFT;
//-----------------------------------------------------------------------

localparam mode32   = 0;
localparam mode64   = 1;
localparam mode128  = 2;
localparam mode256  = 3;
localparam mode512  = 4;
localparam mode1024 = 5;


wire sel_32,sel_128,sel_512;
wire sel_64,sel_256,sel_1024;

assign sel_32  = (mode_di_sel==3'b000);
assign sel_128 = (mode_di_sel==3'b010);
assign sel_512 = (mode_di_sel==3'b100);

assign sel_64   = (mode_di_sel==3'b001);
assign sel_256  = (mode_di_sel==3'b011);
assign sel_1024 = (mode_di_sel==3'b101);


reg [2:0] 		 tw_addr_shift ;
reg [9:0]		 reg_cnt_max   ; // Max=1023
reg [3:0] 		reg_logn_minus_logm1 ; // 
reg [3:0] 		reg_logn_minus_logm2 ; // 
reg [3:0] 		reg_logn_minus_logm3 ; // 
reg [3:0] 		reg_logn_minus_logm4 ; // 
reg [3:0] 		reg_logn_minus_logm5 ; // 

reg 			  reg_data1_en ; // Reg Data1 Enable
reg 			  reg_data2_en ; // Reg Data2 Enable
reg 			  reg_data3_en ; // Reg Data3 Enable
reg [WIDTH-1 : 0] reg_data1_re ; // Reg Data1 (Real) 
reg [WIDTH-1 : 0] reg_data2_re ; // Reg Data2 (Real)
reg [WIDTH-1 : 0] reg_data3_re ; // Reg Data3 (Real)
reg [WIDTH-1 : 0] reg_data1_im ; // Reg Data1 (Imag)
reg [WIDTH-1 : 0] reg_data2_im ; // Reg Data2 (Imag)
reg [WIDTH-1 : 0] reg_data3_im ; // Reg Data3 (Imag)


always @(*) begin 
	case(mode_di_sel)
		// mode32:begin
		// 	{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd0,4'd0,4'd2,4'd0};//2:log2(32)-log2(8)
		// 	{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b0,1'b0,1'b1} : {1'b0,1'b0,1'b0};
		// 	{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {{WIDTH{1'b0}},{WIDTH{1'b0}},data_di_re} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {{WIDTH{1'b0}},{WIDTH{1'b0}},data_di_im} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	reg_cnt_max   = 10'd31;
		// 	tw_addr_shift = 3'd5;
		// end
		mode64:begin
			{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd0,4'd0,4'd2,4'd4};
			{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b0,1'b0,1'b1} : {1'b0,1'b0,1'b0};
			{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {{WIDTH{1'b0}},{WIDTH{1'b0}},data_di_re} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {{WIDTH{1'b0}},{WIDTH{1'b0}},data_di_im} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			reg_cnt_max=10'd63;
			tw_addr_shift= 3'd2;			
		end
		// mode128:begin
		// 	{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd0,4'd2,4'd4,4'd0};
		// 	{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b0,1'b1,1'b0} : {1'b0,1'b0,1'b0};
		// 	{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {{WIDTH{1'b0}},data_di_re,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {{WIDTH{1'b0}},data_di_im,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	reg_cnt_max   = 10'd127;
		// 	tw_addr_shift = 3'd3;
		// end
		mode256:begin
			{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd0,4'd2,4'd4,4'd6};
			{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b0,1'b1,1'b0} : {1'b0,1'b0,1'b0};
			{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {{WIDTH{1'b0}},data_di_re,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {{WIDTH{1'b0}},data_di_im,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			reg_cnt_max   = 10'd255;
			tw_addr_shift = 3'd0;
		end
		// mode512:begin
		// 	{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd2,4'd4,4'd6,4'd0};
		// 	{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b1,1'b0,1'b0} : {1'b0,1'b0,1'b0};
		// 	{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {data_di_re,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {data_di_im,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	reg_cnt_max   = 10'd511;
		// 	tw_addr_shift = 3'd1;
		// end
		// mode1024:begin
		// 	{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd2,4'd4,4'd6,4'd8};
		// 	{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b1,1'b0,1'b0} : {1'b0,1'b0,1'b0};
		// 	{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {data_di_re,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {data_di_im,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
		// 	reg_cnt_max   = 10'd1023;
		// 	tw_addr_shift = 3'd0;
		// end
		default:begin
			// {reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd2,4'd4,4'd6,4'd8};
			// {reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b1,1'b0,1'b0} : {1'b0,1'b0,1'b0};
			// {reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {data_di_re,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			// {reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {data_di_im,{WIDTH{1'b0}},{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			// reg_cnt_max   = 10'd1023;
			// tw_addr_shift = 3'd0;
			{reg_logn_minus_logm1,reg_logn_minus_logm2,reg_logn_minus_logm3,reg_logn_minus_logm4,reg_logn_minus_logm5}={4'd0,4'd0,4'd2,4'd4,4'd6};
			{reg_data1_en,reg_data2_en,reg_data3_en}=data_di_en ? {1'b0,1'b1,1'b0} : {1'b0,1'b0,1'b0};
			{reg_data1_re,reg_data2_re,reg_data3_re}=data_di_en ? {{WIDTH{1'b0}},data_di_re,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			{reg_data1_im,reg_data2_im,reg_data3_im}=data_di_en ? {{WIDTH{1'b0}},data_di_im,{WIDTH{1'b0}}} : {{WIDTH{1'b0}},{WIDTH{1'b0}},{WIDTH{1'b0}}};
			reg_cnt_max   = 10'd255;
			tw_addr_shift = 3'd2;
		end
	endcase
end


//-----------------------------------------------------------------------
//	Delay 1 cycle	
//-----------------------------------------------------------------------


reg sel_32_d1,sel_128_d1,sel_512_d1;
reg sel_64_d1,sel_256_d1,sel_1024_d1;
reg [2:0] tw_addr_shift_d1;
reg [9:0] reg_cnt_max_d1          ; // Max=1023
reg [2:0] reg_mode_sel_d1;
reg [3:0] reg_logn_minus_logm1_d1 ; // 
reg [3:0] reg_logn_minus_logm2_d1 ; // 
reg [3:0] reg_logn_minus_logm3_d1 ; // 
reg [3:0] reg_logn_minus_logm4_d1 ; // 
reg [3:0] reg_logn_minus_logm5_d1 ; // 


reg 			  reg_data1_en_d1 ; // Reg Data1 Enable
reg 			  reg_data2_en_d1 ; // Reg Data2 Enable
reg 			  reg_data3_en_d1 ; // Reg Data3 Enable
reg [WIDTH-1 : 0] reg_data1_re_d1 ; // Reg Data1 (Real) 
reg [WIDTH-1 : 0] reg_data2_re_d1 ; // Reg Data2 (Real)
reg [WIDTH-1 : 0] reg_data3_re_d1 ; // Reg Data3 (Real)
reg [WIDTH-1 : 0] reg_data1_im_d1 ; // Reg Data1 (Imag)
reg [WIDTH-1 : 0] reg_data2_im_d1 ; // Reg Data2 (Imag)
reg [WIDTH-1 : 0] reg_data3_im_d1 ; // Reg Data3 (Imag)


always @(posedge clock or posedge reset) begin 
	if(reset)begin
		{sel_32_d1,sel_128_d1,sel_512_d1 } <= {1'b0,1'b0,1'b0};
		{sel_64_d1,sel_256_d1,sel_1024_d1} <= {1'b0,1'b0,1'b0};
		tw_addr_shift_d1				   <= 3'd0 ;
		reg_cnt_max_d1                     <= 10'd0; // Max=1023 
		reg_mode_sel_d1					   <= 3'd0 ;
		reg_logn_minus_logm1_d1            <= 4'd0 ; //
		reg_logn_minus_logm2_d1            <= 4'd0 ; //
		reg_logn_minus_logm3_d1            <= 4'd0 ; //
		reg_logn_minus_logm4_d1            <= 4'd0 ; //
		reg_logn_minus_logm5_d1            <= 4'd0 ; //
		reg_data1_en_d1					   <= 1'b0 ; // Reg Data1 Enable 
		reg_data2_en_d1					   <= 1'b0 ; // Reg Data2 Enable 
		reg_data3_en_d1					   <= 1'b0 ; // Reg Data3 Enable 
		reg_data1_re_d1					   <= 16'd0; // Reg Data1 (Real)  
		reg_data2_re_d1					   <= 16'd0; // Reg Data2 (Real) 
		reg_data3_re_d1					   <= 16'd0; // Reg Data3 (Real) 
		reg_data1_im_d1					   <= 16'd0; // Reg Data1 (Imag) 
		reg_data2_im_d1					   <= 16'd0; // Reg Data2 (Imag) 
		reg_data3_im_d1					   <= 16'd0; // Reg Data3 (Imag) 
	end
	else begin
		{sel_32_d1,sel_128_d1,sel_512_d1 } <= {sel_32,sel_128,sel_512};
		{sel_64_d1,sel_256_d1,sel_1024_d1} <= {sel_64,sel_256,sel_1024};
		tw_addr_shift_d1				   <= tw_addr_shift		   ;
		reg_cnt_max_d1                     <= reg_cnt_max          ; // Max=1023 
		reg_mode_sel_d1					   <= mode_di_sel		   ;
		reg_logn_minus_logm1_d1            <= reg_logn_minus_logm1 ; //
		reg_logn_minus_logm2_d1            <= reg_logn_minus_logm2 ; //
		reg_logn_minus_logm3_d1            <= reg_logn_minus_logm3 ; //
		reg_logn_minus_logm4_d1            <= reg_logn_minus_logm4 ; //
		reg_logn_minus_logm5_d1            <= reg_logn_minus_logm5 ; //
		reg_data1_en_d1					   <= reg_data1_en ; // Reg Data1 Enable 
		reg_data2_en_d1					   <= reg_data2_en ; // Reg Data2 Enable 
		reg_data3_en_d1					   <= reg_data3_en ; // Reg Data3 Enable 
		reg_data1_re_d1					   <= reg_data1_re ; // Reg Data1 (Real)  
		reg_data2_re_d1					   <= reg_data2_re ; // Reg Data2 (Real) 
		reg_data3_re_d1					   <= reg_data3_re ; // Reg Data3 (Real) 
		reg_data1_im_d1					   <= reg_data1_im ; // Reg Data1 (Imag) 
		reg_data2_im_d1					   <= reg_data2_im ; // Reg Data2 (Imag) 
		reg_data3_im_d1					   <= reg_data3_im ; // Reg Data3 (Imag) 
	end
end

//-----------------------------------------------------------------------
//	OUTPUT
//-----------------------------------------------------------------------

assign sel_do_32           = sel_32_d1;
assign sel_do_64           = sel_64_d1;
assign sel_do_128          = sel_128_d1;
assign sel_do_256          = sel_256_d1;
assign sel_do_512          = sel_512_d1;
assign sel_do_1024         = sel_1024_d1;
assign data1_do_en         = reg_data1_en_d1;					 
assign data2_do_en         = reg_data2_en_d1;					 
assign data3_do_en         = reg_data3_en_d1;					 
assign data1_do_re         = reg_data1_re_d1;					  
assign data2_do_re         = reg_data2_re_d1;					 
assign data3_do_re         = reg_data3_re_d1;					 
assign data1_do_im         = reg_data1_im_d1;					 
assign data2_do_im         = reg_data2_im_d1;					 
assign data3_do_im         = reg_data3_im_d1;	

assign tw_addr_shift_do    = tw_addr_shift_d1;				   				 
assign cnt_do_max	       = reg_cnt_max_d1 ;
assign mode_do_sel         = reg_mode_sel_d1;
assign do_logn_minus_logm1 = reg_logn_minus_logm1_d1; 
assign do_logn_minus_logm2 = reg_logn_minus_logm2_d1; 
assign do_logn_minus_logm3 = reg_logn_minus_logm3_d1; 
assign do_logn_minus_logm4 = reg_logn_minus_logm4_d1; 
assign do_logn_minus_logm5 = reg_logn_minus_logm5_d1; 




endmodule