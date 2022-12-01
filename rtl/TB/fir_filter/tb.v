`timescale 1ps/1ps
 
module tb ;
//input
reg          clk ;
reg          rst_n ;
reg          en ;
reg [15:0]   xin ;
//output
wire         valid ;
wire [27:0]  yout ;

parameter    SIN_DATA_NUM = 16384 ;      //仿真周期

reg [15:0] simulate [0:SIN_DATA_NUM-1];
reg [27:0] golden [0:SIN_DATA_NUM-1];

integer fp;
//=====================================
// 50MHz clk generating
localparam   TCLK_HALF     = 20;
initial begin
    clk = 1'b0 ;
    forever begin
        # TCLK_HALF ;
        clk = ~clk ;
    end
end

//============================
//  reset and finish
initial begin
    rst_n = 1'b0 ;
    # 30   rst_n = 1'b1 ;
end

initial begin
    $readmemb("../../../TB/fir_filter/mix_data.txt",simulate) ;
end

initial begin
    $readmemb("../../../TB/fir_filter/fir_golden_result.txt",golden) ;
end
//=======================================
// read signal data into register
integer i;
initial begin
    i = 0 ;
    en = 0 ;
    xin = 0 ;
    fp = $fopen("../../../TB/fir_filter/fir_result.txt");
    # 200 ;
    forever begin
        @(negedge clk) begin
            en = 1'b1 ;
            xin = simulate[i];
            if (i == SIN_DATA_NUM-1) begin  //data in periodly
                en = 1'b0 ;
                $fclose(fp);
                $finish ;
            end
            else begin
                i = i + 1 ;
            end
        end
    end
end

always @(*) begin
    if(valid) begin
        $fdisplay(fp,"%d",$signed(yout));
        $display("fir_data = %d",$signed(yout));
    end
end

initial	begin
	    $fsdbDumpfile("tb.fsdb");	    
        $fsdbDumpvars(0,"tb","+all");
end

fir_filter #(
     .WIDTH                 (16)
)
u_fir_filter(
     .clk                   (clk) //input                              
    ,.rst_n                 (rst_n) //input                                  
    ,.ready                 (en) //input                              
    ,.mix_data              (xin) //input  signed [WIDTH - 1: 0]       
    ,.fir_data              (yout) //output signed [28- 1: 0]           
    ,.valid                 (valid) //output                             
);
 
endmodule