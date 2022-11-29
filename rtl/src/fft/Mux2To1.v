`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/20 14:51:24
// Design Name: 
// Module Name: Mux2To1
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


module Mux2To1#(
    parameter   WIDTH = 16
)
(
 input  data_sel,
 input  [WIDTH-1:0] data_a,
 input  [WIDTH-1:0] data_b,
 output [WIDTH-1:0] data_o
);

assign data_o = data_sel ? data_a : data_b;
endmodule
