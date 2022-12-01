module fir_filter #(
     parameter                          WIDTH = 16
)(
     input                              clk
    ,input                              rst_n
    ,input                              ready
    ,input  signed [WIDTH - 1: 0]       mix_data
    ,output signed [28- 1: 0]           fir_data
    ,output                             valid
);

//initial the coefficient of fir filter
integer i,j;
reg  signed [WIDTH - 1: 0] mix_data_array [16- 1: 0];
reg         [ 4- 1    : 0] ready_r;
reg  signed [WIDTH    : 0] add_reg        [ 8- 1: 0];
reg  signed [24       : 0] mout           [ 8- 1: 0];
reg  signed [28- 1    : 0] sum1;
reg  signed [28- 1    : 0] sum2;
reg  signed [28- 1    : 0] fir_out;
reg         [ 4- 1    : 0] valid_mult_r;

wire signed [12- 1: 0]     coe            [ 8- 1: 0];

// assign coe[0]  = 12'd11 ;
// assign coe[1]  = 12'd31 ;
// assign coe[2]  = 12'd63 ;
// assign coe[3]  = 12'd104;
// assign coe[4]  = 12'd152;
// assign coe[5]  = 12'd198;
// assign coe[6]  = 12'd235;
// assign coe[7]  = 12'd255;

assign coe[0]  =  12'd40  ;
assign coe[1]  = -12'd41  ;
assign coe[2]  =  12'd31  ;
assign coe[3]  = -12'd14  ;
assign coe[4]  = -12'd18  ;
assign coe[5]  =  12'd69  ;
assign coe[6]  = -12'd174 ;
assign coe[7]  =  12'd614 ;

//data ready delay
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ready_r[3:0] <= 'b0 ;
    end
    else begin
        ready_r[3:0] <= {ready_r[2:0], ready} ;
    end
end

//shift reg of input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 15; i = i + 1) begin
            mix_data_array[i] <= 0;
        end
    end else if (ready) begin
        mix_data_array[0] <= mix_data;
        for (j = 0; j < 15; j = j + 1) begin
            mix_data_array[j + 1] <= mix_data_array[j];
        end
    end
end

//Only 8 multipliers needed because of the symmetry of FIR filter coefficient
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            add_reg[i] <= 0;
        end
    end
    else if (ready_r[0]) begin
        for (i = 0; i < 8; i = i + 1) begin
            add_reg[i] <= mix_data_array[i] + mix_data_array[15 - i] ;
        end
    end
end

//8 multipliers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i = i + 1) begin
            mout[i] <= 25'b0 ;
        end
    end
    else if (ready_r[1]) begin
        for (i = 0; i < 8; i = i + 1) begin
            mout[i] <= coe[i] * add_reg[i] ;
        end
    end
end

assign valid_mult = ready_r[2];

//data valid delay
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_mult_r[3:0] <= 4'b0 ;
    end
    else begin
        valid_mult_r[3:0] <= {valid_mult_r[2:0], valid_mult} ;
    end
end

//sum of the data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 28'd0 ;
        sum2 <= 28'd0 ;
        fir_out <= 28'd0 ;
    end
    else if(valid_mult) begin
        sum1 <= mout[0] + mout[1] + mout[2] + mout[3] ;
        sum2 <= mout[4] + mout[5] + mout[6] + mout[7] ;
        fir_out <= sum1 + sum2 ;
    end
end

assign fir_data = fir_out;
assign valid = valid_mult_r[0];

endmodule //fir_filter