module booth_decoder (
    input  wire [15:0] xin ,//乘数x
    input  wire [2: 0] yin ,//从程序y选取的，3bit控制信号
    output wire        cout,//得到的部分积如果是负数的话，需要“取反加一”，这里用来指示是否“加一”
    output wire [16:0] xout //booth编码后得到的1个部分积（待修正）
);
    // wire x_none = (~yin[2]&~yin[1]&~yin[0])|(yin[2]&yin[1]&yin[0]);
    wire x_add1 = (~yin[2]&~yin[1]&yin[0])|(~yin[2]&yin[1]&~yin[0]);
    wire x_add2 = (~yin[2]&yin[1]&yin[0]);
    wire x_sub2 = (yin[2]&~yin[1]&~yin[0]);
    wire x_sub1 = (yin[2]&~yin[1]&yin[0])|(yin[2]&yin[1]&~yin[0]);

    assign xout = {17{x_add1}} & {xin[15],xin}//加法为正数，符号位为0
                | {17{x_add2}} & {xin[15:0],1'b0}
                | {17{x_sub1}} & {~xin[15],~xin} 
                | {17{x_sub2}} & ({~xin[15:0],1'b1}) 
                ;
    assign cout = x_sub1|x_sub2;
endmodule