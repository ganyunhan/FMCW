//----------------------------------------------------------------------
//  DelayBuffer: Generate Constant Delay
//----------------------------------------------------------------------
module DelayBuffer #(
    parameter   DEPTH = 32,
    parameter   WIDTH = 16
)(
    input               clock,  //  Master Clock
    input               reset,  //  Reset Signal
    input   [WIDTH-1:0] di_re,  //  Data Input (Real)
    input   [WIDTH-1:0] di_im,  //  Data Input (Imag)
    output  [WIDTH-1:0] do_re,  //  Data Output (Real)
    output  [WIDTH-1:0] do_im   //  Data Output (Imag)
);

reg [WIDTH-1:0] buf_re[0:DEPTH-1];
reg [WIDTH-1:0] buf_im[0:DEPTH-1];
integer n;
integer n1;


//  Shift Buffer
always @(posedge clock) begin
    if(reset)begin
        for (n1 = DEPTH-1; n1 >= 0; n1 = n1 - 1) begin
            buf_re[n1]<='b0;
            buf_im[n1]<='b0;
        end
    end
    else begin
        for (n = DEPTH-1; n > 0; n = n - 1) begin
            buf_re[n] <= buf_re[n-1];
            buf_im[n] <= buf_im[n-1];
        end
        buf_re[0] <= di_re;
        buf_im[0] <= di_im;
    end
end

assign  do_re = buf_re[DEPTH-1];
assign  do_im = buf_im[DEPTH-1];

endmodule
