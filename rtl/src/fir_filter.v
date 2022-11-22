module fir_filter #(
     parameter                          WIDTH = 16
    ,parameter                          
)(
     input                              clk
    ,input                              rst_n
    ,input                              ena
    ,input  signed [WIDTH - 1: 0]       mix_data
    ,output signed [WIDTH - 1: 0]       fir_data
    ,output                             valid
);



endmodule //fir_filter