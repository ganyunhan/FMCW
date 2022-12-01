`timescale 1ns / 1ps
//----------------------------------------------------------------------
//  FFT: 32 to 1024 Point FFT Using Radix-2^2 Single-Path Delay Feedback
//  Data must be input consecutively in natural order.
//  The result is scaled to 1/N and output in bit-reversed order.
//----------------------------------------------------------------------
module FFT #(
    parameter   WIDTH = 16
)(
    input               clock ,  //  Master Clock
    input               reset ,  //  Active High Asynchronous Reset
    input   [2:0]       di_sel,  //  Point Select
    input               di_en ,  //  Input Data Enable
    input   [WIDTH-1:0] di_re ,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im ,  //  Input Data (Imag)
    output              do_en ,  //  Output Data Enable
    output  [WIDTH-1:0] do_re ,  //  Output Data (Real)
    output  [WIDTH-1:0] do_im    //  Output Data (Imag)
);

//----------------------------------------------------------------------
//  The signal defination of module InputCircuit
//----------------------------------------------------------------------
wire               sel_do_32   ;
wire               sel_do_64   ;
wire               sel_do_128  ;
wire               sel_do_256  ;
wire               sel_do_512  ;
wire               sel_do_1024 ;
wire               data1_do_en ; // Output Data1 Enable
wire               data2_do_en ; // Output Data2 Enable
wire               data3_do_en ; // Output Data3 Enable
wire [WIDTH-1 : 0] data1_do_re ; // Output Data1 (Real) 
wire [WIDTH-1 : 0] data2_do_re ; // Output Data2 (Real)
wire [WIDTH-1 : 0] data3_do_re ; // Output Data3 (Real)
wire [WIDTH-1 : 0] data1_do_im ; // Output Data1 (Imag)
wire [WIDTH-1 : 0] data2_do_im ; // Output Data2 (Imag)
wire [WIDTH-1 : 0] data3_do_im ; // Output Data3 (Imag)
wire [2:0]    tw_addr_shift_do ;
wire [9:0]         cnt_do_max  ; // Max=1023
wire [2:0]         mode_do_sel ; // Point Select
wire [3:0] do_logn_minus_logm1 ; // 
wire [3:0] do_logn_minus_logm2 ; // 
wire [3:0] do_logn_minus_logm3 ; // 
wire [3:0] do_logn_minus_logm4 ; // 
wire [3:0] do_logn_minus_logm5 ; // 

//----------------------------------------------------------------------
//  The signal defination of module SdfUnit
//----------------------------------------------------------------------

wire            su_a1_do_en;
wire[WIDTH-1:0] su_a1_do_re;
wire[WIDTH-1:0] su_a1_do_im;
wire            su_a2_do_en;
wire[WIDTH-1:0] su_a2_do_re;
wire[WIDTH-1:0] su_a2_do_im;
wire            su_a3_do_en;
wire[WIDTH-1:0] su_a3_do_re;
wire[WIDTH-1:0] su_a3_do_im;
wire            su_a4_do_en;
wire[WIDTH-1:0] su_a4_do_re;
wire[WIDTH-1:0] su_a4_do_im;
wire            su_a5_do_en;
wire[WIDTH-1:0] su_a5_do_re;
wire[WIDTH-1:0] su_a5_do_im;



wire            su_b1_do_en;
wire[WIDTH-1:0] su_b1_do_re;
wire[WIDTH-1:0] su_b1_do_im;
wire            su_b2_do_en;
wire[WIDTH-1:0] su_b2_do_re;
wire[WIDTH-1:0] su_b2_do_im;
wire            su_b3_do_en;
wire[WIDTH-1:0] su_b3_do_re;
wire[WIDTH-1:0] su_b3_do_im;
wire            su_b4_do_en;
wire[WIDTH-1:0] su_b4_do_re;
wire[WIDTH-1:0] su_b4_do_im;
wire            su_b5_do_en;
wire[WIDTH-1:0] su_b5_do_re;
wire[WIDTH-1:0] su_b5_do_im;

//----------------------------------------------------------------------
//  The signal defination of module Mux2To1
//----------------------------------------------------------------------
wire[WIDTH-1:0] mux_do_a1_re;
wire[WIDTH-1:0] mux_do_a1_im;
wire[WIDTH-1:0] mux_do_a2_re;
wire[WIDTH-1:0] mux_do_a2_im;
wire[WIDTH-1:0] mux_do_a3_re;
wire[WIDTH-1:0] mux_do_a3_im;


wire[WIDTH-1:0] mux_do_b1_re;
wire[WIDTH-1:0] mux_do_b1_im;
wire[WIDTH-1:0] mux_do_b2_re;
wire[WIDTH-1:0] mux_do_b2_im;
wire[WIDTH-1:0] mux_do_b3_re;
wire[WIDTH-1:0] mux_do_b3_im;

wire[WIDTH-1:0] mux_do_re;
wire[WIDTH-1:0] mux_do_im;

//----------------------------------------------------------------------
// Delay 1 Cycle
//----------------------------------------------------------------------
reg             reg_do_en;
reg [WIDTH-1:0] reg_do_re;
reg [WIDTH-1:0] reg_do_im;
wire            sel_even_pow;
assign sel_even_pow = sel_do_1024|sel_do_256|sel_do_64;



InputCircuit #(.WIDTH(WIDTH))
Inst_InputCircuit
(
    .clock              ( clock               ), // Master Clock
    .reset              ( reset               ), // Active High Asynchronous Reset
    .mode_di_sel        ( di_sel              ), // Point Select
    .data_di_en         ( di_en               ), // Input Data Enable
    .data_di_re         ( di_re               ), // Input Data (Real)
    .data_di_im         ( di_im               ), // Input Data (Imag)
    .sel_do_32          ( sel_do_32           ),
    .sel_do_64          ( sel_do_64           ),
    .sel_do_128         ( sel_do_128          ),
    .sel_do_256         ( sel_do_256          ),
    .sel_do_512         ( sel_do_512          ),
    .sel_do_1024        ( sel_do_1024         ),
    .data1_do_en        ( data1_do_en         ), 
    .data2_do_en        ( data2_do_en         ), 
    .data3_do_en        ( data3_do_en         ), 
    .data1_do_re        ( data1_do_re         ), 
    .data2_do_re        ( data2_do_re         ), 
    .data3_do_re        ( data3_do_re         ), 
    .data1_do_im        ( data1_do_im         ), 
    .data2_do_im        ( data2_do_im         ), 
    .data3_do_im        ( data3_do_im         ), 
    .tw_addr_shift_do   ( tw_addr_shift_do    ),
    .cnt_do_max         ( cnt_do_max          ), // Max=1023
    .mode_do_sel        ( mode_do_sel         ), // Point Select
    .do_logn_minus_logm1( do_logn_minus_logm1 ), 
    .do_logn_minus_logm2( do_logn_minus_logm2 ), 
    .do_logn_minus_logm3( do_logn_minus_logm3 ), 
    .do_logn_minus_logm4( do_logn_minus_logm4 ), 
    .do_logn_minus_logm5( do_logn_minus_logm5 )  
);

//----------------------------------------------------------------------
//  Datapath of 64 point FFT,256 point FFT,and 1024 point FFT
//----------------------------------------------------------------------

Mux2To1 #(.WIDTH(WIDTH))
Stage_A1_MUX_Re(
.data_sel( sel_do_1024&data1_do_en ),
.data_a  ( data1_do_re             ),
.data_b  ( {WIDTH{1'b0}}           ),
.data_o  ( mux_do_a1_re            )
);

Mux2To1 #(.WIDTH(WIDTH))
Stage_A1_MUX_Im(
.data_sel( sel_do_1024&data1_do_en ),
.data_a  ( data1_do_im             ),
.data_b  ( {WIDTH{1'b0}}           ),
.data_o  ( mux_do_a1_im            )
);

SdfUnit #(.M(1024),.WIDTH(WIDTH) )    //  M: Twiddle Resolution
Inst_SdfUnit_A1(
    .clock        ( clock                                 ),  //  Master Clock
    .reset        ( reset                                 ),  //  Active High Asynchronous Reset
    .di_cnt_max   ( cnt_do_max                            ),  
    .di_twaddr_sft( tw_addr_shift_do                      ),  //  Shift bit to fit Twiddle1024_16B
    .di_mode_sel  ( mode_do_sel                           ),
    .di_logn_logm ( do_logn_minus_logm1                   ),  //  Log2(N)-Log2(M)
    .di_en        ( sel_do_1024&data1_do_en               ),  //  Input Data Enable
    .di_re        ( mux_do_a1_re                          ),  //  Input Data (Real)
    .di_im        ( mux_do_a1_im                          ),  //  Input Data (Imag)
    .do_en        ( su_a1_do_en                           ),  //  Output Data Enable
    .do_re        ( su_a1_do_re                           ),  //  Output Data (Real)
    .do_im        ( su_a1_do_im                           )   //  Output Data (Imag)
);

Mux2To1 #(.WIDTH(WIDTH))
Stage_A2_MUX_Re(
.data_sel( sel_do_256&data2_do_en ),
.data_a  ( data2_do_re            ),
.data_b  ( su_a1_do_re            ),
.data_o  ( mux_do_a2_re           )
);

Mux2To1 #(.WIDTH(WIDTH))
Stage_A2_MUX_Im(
.data_sel( sel_do_256&data2_do_en ),
.data_a  ( data2_do_im            ),
.data_b  ( su_a1_do_im            ),
.data_o  ( mux_do_a2_im           )
);

SdfUnit #(.M(256),.WIDTH(WIDTH) )     //  M: Twiddle Resolution
Inst_SdfUnit_A2(
    .clock        ( clock                                ),  //  Master Clock
    .reset        ( reset                                ),  //  Active High Asynchronous Reset
    .di_cnt_max   ( cnt_do_max                           ),
    .di_twaddr_sft( tw_addr_shift_do                     ),  //  Shift bit to fit Twiddle1024_16B
    .di_mode_sel  ( mode_do_sel                          ),
    .di_logn_logm ( do_logn_minus_logm2                  ),  //  Log2(N)-Log2(M)
    .di_en        ( (sel_do_256&data2_do_en)|su_a1_do_en ),  //  Input Data Enable
    .di_re        ( mux_do_a2_re                         ),  //  Input Data (Real)
    .di_im        ( mux_do_a2_im                         ),  //  Input Data (Imag)
    .do_en        ( su_a2_do_en                          ),  //  Output Data Enable
    .do_re        ( su_a2_do_re                          ),  //  Output Data (Real)
    .do_im        ( su_a2_do_im                          )   //  Output Data (Imag)
);

Mux2To1 #(.WIDTH(WIDTH))
Stage_A3_MUX_Re(
.data_sel( sel_do_64&data3_do_en ),
.data_a  ( data3_do_re           ),
.data_b  ( su_a2_do_re           ),
.data_o  ( mux_do_a3_re          )
);

Mux2To1 #(.WIDTH(WIDTH))
Stage_A3_MUX_Im(
.data_sel( sel_do_64&data3_do_en ),
.data_a  ( data3_do_im           ),
.data_b  ( su_a2_do_im           ),
.data_o  ( mux_do_a3_im          )
);

SdfUnit #(.M(64),.WIDTH(WIDTH))      //  M: Twiddle Resolution
Inst_SdfUnit_A3(
    .clock        ( clock                               ),  //  Master Clock
    .reset        ( reset                               ),  //  Active High Asynchronous Reset
    .di_cnt_max   ( cnt_do_max                          ),
    .di_twaddr_sft( tw_addr_shift_do                    ),  //  Shift bit to fit Twiddle1024_16B
    .di_mode_sel  ( mode_do_sel                         ),
    .di_logn_logm ( do_logn_minus_logm3                 ),  //  Log2(N)-Log2(M)
    .di_en        ( (sel_do_64&data3_do_en)|su_a2_do_en ),  //  Input Data Enable
    .di_re        ( mux_do_a3_re                        ),  //  Input Data (Real)
    .di_im        ( mux_do_a3_im                        ),  //  Input Data (Imag)
    .do_en        ( su_a3_do_en                         ),  //  Output Data Enable
    .do_re        ( su_a3_do_re                         ),  //  Output Data (Real)
    .do_im        ( su_a3_do_im                         )   //  Output Data (Imag)
);

SdfUnit #(.M(16),.WIDTH(WIDTH) )      //  M: Twiddle Resolution
Inst_SdfUnit_A4(
    .clock        (clock                               ),  //  Master Clock
    .reset        (reset                               ),  //  Active High Asynchronous Reset
    .di_cnt_max   (cnt_do_max                          ),
    .di_twaddr_sft(tw_addr_shift_do                    ),  //  Shift bit to fit Twiddle1024_16B
    .di_mode_sel  (mode_do_sel                         ),
    .di_logn_logm (do_logn_minus_logm4                 ),  //  Log2(N)-Log2(M)
    .di_en        (su_a3_do_en                         ),  //  Input Data Enable
    .di_re        (su_a3_do_re                         ),  //  Input Data (Real)
    .di_im        (su_a3_do_im                         ),  //  Input Data (Imag)
    .do_en        (su_a4_do_en                         ),  //  Output Data Enable
    .do_re        (su_a4_do_re                         ),  //  Output Data (Real)
    .do_im        (su_a4_do_im                         )   //  Output Data (Imag)
);

SdfUnit #(.M(4),.WIDTH(WIDTH) )       //  M: Twiddle Resolution
Inst_SdfUnit_A5(
    .clock        (clock                               ),  //  Master Clock
    .reset        (reset                               ),  //  Active High Asynchronous Reset
    .di_cnt_max   (cnt_do_max                          ),
    .di_twaddr_sft(tw_addr_shift_do                    ),  //  Shift bit to fit Twiddle1024_16B
    .di_mode_sel  (mode_do_sel                         ),
    .di_logn_logm (do_logn_minus_logm5                 ),  //  Log2(N)-Log2(M)
    .di_en        (su_a4_do_en                         ),  //  Input Data Enable
    .di_re        (su_a4_do_re                         ),  //  Input Data (Real)
    .di_im        (su_a4_do_im                         ),  //  Input Data (Imag)
    .do_en        (su_a5_do_en                         ),  //  Output Data Enable
    .do_re        (su_a5_do_re                         ),  //  Output Data (Real)
    .do_im        (su_a5_do_im                         )   //  Output Data (Imag)
);


//----------------------------------------------------------------------
//  Datapath of 32 point FFT,128 point FFT,and 512 point FFT
//----------------------------------------------------------------------

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B1_MUX_Re(
// .data_sel( sel_do_512&data1_do_en ),
// .data_a  ( data1_do_re            ),
// .data_b  ( {WIDTH{1'b0}}          ),
// .data_o  ( mux_do_b1_re           )
// );

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B1_MUX_Im(
// .data_sel( sel_do_512&data1_do_en ),
// .data_a  ( data1_do_im            ),
// .data_b  ( {WIDTH{1'b0}}          ),
// .data_o  ( mux_do_b1_im           )
// );


// SdfUnit #(.M(512),.WIDTH(WIDTH) )     //  M: Twiddle Resolution
// Inst_SdfUnit_B1(
//     .clock        ( clock                               ),  //  Master Clock
//     .reset        ( reset                               ),  //  Active High Asynchronous Reset
//     .di_cnt_max   ( cnt_do_max                          ),
//     .di_twaddr_sft( tw_addr_shift_do                    ),  //  Shift bit to fit Twiddle1024_16B
//     .di_mode_sel  ( mode_do_sel                         ),
//     .di_logn_logm ( do_logn_minus_logm1                 ),  //  Log2(N)-Log2(M)
//     .di_en        ( sel_do_512&data1_do_en              ),  //  Input Data Enable
//     .di_re        ( mux_do_b1_re                        ),  //  Input Data (Real)
//     .di_im        ( mux_do_b1_im                        ),  //  Input Data (Imag)
//     .do_en        ( su_b1_do_en                         ),  //  Output Data Enable
//     .do_re        ( su_b1_do_re                         ),  //  Output Data (Real)
//     .do_im        ( su_b1_do_im                         )   //  Output Data (Imag)
// );

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B2_MUX_Re(
// .data_sel( sel_do_128&data2_do_en ),
// .data_a  ( data2_do_re            ),
// .data_b  ( su_b1_do_re            ),
// .data_o  ( mux_do_b2_re           )
// );

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B2_MUX_Im(
// .data_sel( sel_do_128&data2_do_en ),
// .data_a  ( data2_do_im            ),
// .data_b  ( su_b1_do_im            ),
// .data_o  ( mux_do_b2_im           )
// );

// SdfUnit #(.M(128),.WIDTH(WIDTH) )     //  M: Twiddle Resolution
// Inst_SdfUnit_B2(
//     .clock        ( clock                                ),  //  Master Clock
//     .reset        ( reset                                ),  //  Active High Asynchronous Reset
//     .di_cnt_max   ( cnt_do_max                           ),
//     .di_twaddr_sft( tw_addr_shift_do                     ),  //  Shift bit to fit Twiddle1024_16B
//     .di_mode_sel  ( mode_do_sel                          ),
//     .di_logn_logm ( do_logn_minus_logm2                  ),  //  Log2(N)-Log2(M)
//     .di_en        ( (sel_do_128&data2_do_en)|su_b1_do_en ),  //  Input Data Enable
//     .di_re        ( mux_do_b2_re                         ),  //  Input Data (Real)
//     .di_im        ( mux_do_b2_im                         ),  //  Input Data (Imag)
//     .do_en        ( su_b2_do_en                          ),  //  Output Data Enable
//     .do_re        ( su_b2_do_re                          ),  //  Output Data (Real)
//     .do_im        ( su_b2_do_im                          )   //  Output Data (Imag)
// );

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B3_MUX_Re(
// .data_sel( sel_do_32&data3_do_en ),
// .data_a  ( data3_do_re           ),
// .data_b  ( su_b2_do_re           ),
// .data_o  ( mux_do_b3_re          )
// );

// Mux2To1 #(.WIDTH(WIDTH))
// Stage_B3_MUX_Im(
// .data_sel( sel_do_32&data3_do_en ),
// .data_a  ( data3_do_im           ),
// .data_b  ( su_b2_do_im           ),
// .data_o  ( mux_do_b3_im          )
// );

// SdfUnit #(.M(32),.WIDTH(WIDTH) )      //  M: Twiddle Resolution
// Inst_SdfUnit_B3(
//     .clock        ( clock                               ),  //  Master Clock
//     .reset        ( reset                               ),  //  Active High Asynchronous Reset
//     .di_cnt_max   ( cnt_do_max                          ),
//     .di_twaddr_sft( tw_addr_shift_do                    ),  //  Shift bit to fit Twiddle1024_16B
//     .di_mode_sel  ( mode_do_sel                         ),
//     .di_logn_logm ( do_logn_minus_logm3                 ),  //  Log2(N)-Log2(M)
//     .di_en        ( (sel_do_32&data3_do_en)|su_b2_do_en ),  //  Input Data Enable
//     .di_re        ( mux_do_b3_re                        ),  //  Input Data (Real)
//     .di_im        ( mux_do_b3_im                        ),  //  Input Data (Imag)
//     .do_en        ( su_b3_do_en                         ),  //  Output Data Enable
//     .do_re        ( su_b3_do_re                         ),  //  Output Data (Real)
//     .do_im        ( su_b3_do_im                         )   //  Output Data (Imag)
// );

// SdfUnit #(.M(8),.WIDTH(WIDTH) )       //  M: Twiddle Resolution
// Inst_SdfUnit_B4(
//     .clock        ( clock               ),  //  Master Clock
//     .reset        ( reset               ),  //  Active High Asynchronous Reset
//     .di_cnt_max   ( cnt_do_max          ),
//     .di_twaddr_sft( tw_addr_shift_do    ),  //  Shift bit to fit Twiddle1024_16B
//     .di_mode_sel  ( mode_do_sel         ),
//     .di_logn_logm ( do_logn_minus_logm4 ),  //  Log2(N)-Log2(M)
//     .di_en        ( su_b3_do_en         ),  //  Input Data Enable
//     .di_re        ( su_b3_do_re         ),  //  Input Data (Real)
//     .di_im        ( su_b3_do_im         ),  //  Input Data (Imag)
//     .do_en        ( su_b4_do_en         ),  //  Output Data Enable
//     .do_re        ( su_b4_do_re         ),  //  Output Data (Real)
//     .do_im        ( su_b4_do_im         )   //  Output Data (Imag)
// );

//  SdfUnit2 #(.WIDTH(WIDTH))
//  Inst_SdfUnit_B5 (
//     .clock( clock       ),  //  Master Clock
//     .reset( reset       ),  //  Active High Asynchronous Reset
//     .di_en( su_b4_do_en ),  //  Input Data Enable
//     .di_re( su_b4_do_re ),  //  Input Data (Real)
//     .di_im( su_b4_do_im ),  //  Input Data (Imag)
//     .do_en( su_b5_do_en ),  //  Output Data Enable
//     .do_re( su_b5_do_re ),  //  Output Data (Real)
//     .do_im( su_b5_do_im )   //  Output Data (Imag)
// );


Mux2To1 #(.WIDTH(WIDTH))
Stage_OUT_MUX_Re(
.data_sel( su_a5_do_en| & sel_even_pow ),
.data_a  ( su_a5_do_re                ),
.data_b  ( su_b5_do_re                ),
.data_o  ( mux_do_re                  )
);

Mux2To1#(.WIDTH(WIDTH))
Stage_OUT_MUX_Im(
.data_sel( su_a5_do_en & sel_even_pow ),
.data_a  ( su_a5_do_im                ),
.data_b  ( su_b5_do_im                ),
.data_o  ( mux_do_im                  )
);

//----------------------------------------------------------------------
// Delay 1 Cycle 
//----------------------------------------------------------------------
always @(posedge clock ) begin 
    reg_do_en <= (su_a5_do_en & sel_even_pow) | (su_b5_do_en & ~sel_even_pow) ;
    reg_do_re <= mux_do_re;
    reg_do_im <= mux_do_im;
end


assign do_en = reg_do_en;
assign do_re = reg_do_re; 
assign do_im = reg_do_im; 

endmodule
