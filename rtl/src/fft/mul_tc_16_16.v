// `include "../rtl/wallace_32_8.v"
// `include "../rtl/booth_decoder_8.v"
// `include "../rtl/adder32.v"

module mul_tc_16_16 (
    input wire [15:0]  a         ,//输入数据，二进制补码
    input wire [15:0]  b         ,//输入数据，二进制补码
    output wire [31:0] product    //输出乘积a * b，二进制补码
);

// 8个booth两位乘，得到8个16位部分积，并将16个部分积扩展到32位
wire [7:0] cout_t;
wire [31:0] xout_t[7:0];
booth_decoder_8 u_booth_decoder_8(
    .xin  (a        ),
    .yin  (b        ),
    .cout (cout_t   ),//[7:0]  cout
    // .xout (xout_t ) //[15:0] xout[7:0]
    .xout0(xout_t[0]),
    .xout1(xout_t[1]),
    .xout2(xout_t[2]),
    .xout3(xout_t[3]),
    .xout4(xout_t[4]),
    .xout5(xout_t[5]),
    .xout6(xout_t[6]),
    .xout7(xout_t[7]) 
);

// 32位的wallace树，将8个部分积的和压缩成2个数的和
wire [31:0] C_t;
wire [31:0] S_t;
wire [5:0]  wallace_cout_t;
wallace_32_8 u_wallace_32_8(
    // .xin  (xout_t  ),
    .xin0 (xout_t[0])       ,
    .xin1 (xout_t[1])       ,
    .xin2 (xout_t[2])       ,
    .xin3 (xout_t[3])       ,
    .xin4 (xout_t[4])       ,
    .xin5 (xout_t[5])       ,
    .xin6 (xout_t[6])       ,
    .xin7 (xout_t[7])       ,
    .cin  (cout_t[5:0]  )   ,
    .C    (C_t    )         ,
    .S    (S_t    )         ,
    .cout (wallace_cout_t )  
);

// 使用32位超前进位加法器将计算乘法结果
adder32 u_adder32(
    .a    (S_t    ),
    .b    ({C_t[30:0],cout_t[6]} ),
    .cin  (cout_t[7]  ),
    .out  (product  ),
    .cout ( )
);


endmodule