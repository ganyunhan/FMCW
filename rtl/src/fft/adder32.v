`include "../rtl/adder4.v"
module adder32(
    input  wire [31:0]  a   ,//输入数据，二进制补码
    input  wire [31:0]  b   ,//输入数据，二进制补码
    input  wire         cin ,//来自低位的进位输入
    output wire [31:0]  out ,//输出和a + b，二进制补码（不包含最高位的进位）
    output wire         cout //输出和a + b，的进位
);



// level1
wire [31:0] p1 = a|b;
wire [31:0] g1 = a&b;
wire [31:0] c;//每一位的进位输出
wire [7:0] p2, g2;
wire [1:0] p3, g3;
assign c[0] = cin;

genvar j;
generate
    for (j = 0; j<8; j=j+1) begin
        adder4 u_adder4_l1 (.p(p1[(4*j+3)-:4]),.g(g1[(4*j+3)-:4]),.cin(c[j*4]),.P(p2[j]),.G(g2[j]),.cout(c[(4*j+3)-:3]));
    end
endgenerate

// level2
generate
    for (j = 0; j<2; j=j+1) begin
        adder4 u_adder4_l2 (.p(p2[(4*j+3)-:4]),.g(g2[(4*j+3)-:4]),.cin(c[j*16]),.P(p3[j]),.G(g3[j]),.cout({c[j*16+12],c[j*16+8],c[j*16+4]}));
    end
endgenerate

// level3
assign c[16]=g3[0]|(p3[0]&c[0]);

// 得到进位后计算加法和
assign cout = (a[31]&b[31]) | (a[31]&c[31]) | (b[31]&c[31]);
assign out = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);

endmodule