// `include "../rtl/booth_decoder.v"
module booth_decoder_8 (
    input  wire [15:0] xin       ,//乘数x
    input  wire [15:0] yin       ,//乘数y，依序取其3bit进行译码得到booth编码的选择信号
    output wire [7:0]  cout      ,//得到的部分积如果是负数的话，需要“取反加一”，这里用来指示是否“加一”
    // output wire [31:0] xout[7:0]  //booth编码后得到的8个部分积（待修正）
    output wire [31:0] xout0     ,
    output wire [31:0] xout1     ,
    output wire [31:0] xout2     ,
    output wire [31:0] xout3     ,
    output wire [31:0] xout4     ,
    output wire [31:0] xout5     ,
    output wire [31:0] xout6     ,
    output wire [31:0] xout7      
);
wire [31:0] xout[7:0];
assign xout0 = xout[0];
assign xout1 = xout[1];
assign xout2 = xout[2];
assign xout3 = xout[3];
assign xout4 = xout[4];
assign xout5 = xout[5];
assign xout6 = xout[6];
assign xout7 = xout[7];

wire [16:0] yin_t = {yin,1'b0};
wire [16:0] xout_t[7:0];
genvar j;
generate
    for(j=0; j<8; j=j+1)
    begin:booth_decoder_loop
        booth_decoder u_booth_decoder(
        	.xin  (xin  ),
            .yin  (yin_t[(j+1)*2-:3]),
            .xout (xout_t[j]),
            .cout (cout[j] )
        );
        assign xout[j]={{(15-j*2){xout_t[j][16]}},xout_t[j],{(j*2){cout[j]}}};
        // 低位默认是0，负数的话，进行取反
    end
endgenerate
endmodule