module half_adder (
    input  wire [1:0]  cin ,
    output wire        Cout,
    output wire        S    
);
    assign S    = (cin[0]&~cin[1])|(~cin[0]&cin[1]);
    assign Cout = cin[0]&cin[1];
endmodule