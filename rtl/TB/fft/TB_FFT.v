`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/20 16:28:00
// Design Name: 
// Module Name: TB_FFT
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



module TB_FFT #(
    parameter   N = 256
);

localparam      NN = log2(N);   //  Count Bit Width of FFT Point

//  log2 constant function
function integer log2;
    input integer x;
    integer value;
    begin
        value = x-1;
        for (log2=0; value>0; log2=log2+1)
            value = value>>1;
    end
endfunction

//  Internal Regs and Nets
reg         clock;
reg         reset;
reg [2:0]  	di_sel;
reg         di_en;
reg [15:0]  di_re;
reg [15:0]  di_im;
wire        do_en;
wire[15:0]  do_re;
wire[15:0]  do_im;

reg [31:0]  imem[0:N-1];//real and img
// reg  [31:0]  omem[0:N-1];

// reg  [15:0]  imem[0:2*N-1];
reg [15:0]  omem[0:2*N-1];

always #10 clock=~clock;

initial begin
    $readmemh("../../../TB/fft/simulate.txt",imem);
end

initial begin 
    clock=0;
    reset=1;
    di_en=0;
    di_re=16'd0;
    di_im=16'd0;
    di_sel=3'b011;

    repeat(10) @(posedge clock);
        reset=0;
    repeat(10) @(posedge clock);    
        GenerateInputData;
end

//Output Data Capture
initial begin : OCAP
    integer     n;
    forever begin
        n = 0;
        while (do_en !== 1) @(negedge clock);
        while ((do_en == 1) && (n < N)) begin
            omem[2*n  ] = do_re;
            omem[2*n+1] = do_im;
            n = n + 1;
            @(negedge clock);
        end
    end
end

initial begin : STIM
    wait (reset == 1);
    wait (reset == 0);
    repeat(10) @(posedge clock);

    fork
        begin
            wait (do_en == 1);
            repeat(N) @(posedge clock);
            SaveOutputData("./fft_output.txt");
        end
    join

    repeat(10) @(posedge clock);
    $finish;
end

initial	begin
	    $fsdbDumpfile("tb.fsdb");	    
        $fsdbDumpvars(0,"TB_FFT","+all");
end

//----------------------------------------------------------------------
//  Module Instances
//----------------------------------------------------------------------
FFT FFT (
    .clock  (clock  ),  //  i
    .reset  (reset  ),  //  i
    .di_sel	(di_sel ),  //  i
    .di_en  (di_en  ),  //  i
    .di_re  (di_re  ),  //  i
    .di_im  (di_im  ),  //  i
    .do_en  (do_en  ),  //  o
    .do_re  (do_re  ),  //  o
    .do_im  (do_im  )   //  o
);

task GenerateInputData;
    integer n;
    begin
        for (n = 0; n < N; n = n + 1) begin
            @(posedge clock)begin
                di_en <= 1;
                di_re <= imem[n][31:16];
                di_im <= imem[n][15:0];
            end
        end
        @(posedge clock) begin
            di_en <= 'b0;
            di_re <= 'b0;
            di_im <= 'b0;
        end
    end
endtask

task SaveOutputData;
    // input[80*8:1]    filename;
    input[180*8:1]  filename;
    integer         fp, n, m, i;
    begin
        fp = $fopen(filename);
        m = 0;
        for (n = 0; n < N; n = n + 1) begin
            for (i = 0; i < NN; i = i + 1) m[NN-1-i] = n[i];
            // $fdisplay(fp, "%h  %h  // %d", omem[2*m], omem[2*m+1], n[NN-1:0]);
            $fdisplay(fp, "%h  %h " , omem[2*m], omem[2*m+1]);
        end
        $fclose(fp);
    end
endtask

endmodule

