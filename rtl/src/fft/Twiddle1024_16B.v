//----------------------------------------------------------------------
//  Twiddle: 1024-Point Twiddle Table for Radix-2^2 Butterfly
//----------------------------------------------------------------------
module Twiddle #(
    parameter   WIDTH =16,
    parameter   TW_FF = 1   //  Use Output Register
)(
    input           clock,  //  Master Clock
    input   [9:0]   addr,   //  Twiddle Factor Number
    output  [WIDTH-1:0]  tw_re,  //  Twiddle Factor (Real)
    output  [WIDTH-1:0]  tw_im   //  Twiddle Factor (Imag)
);

wire[WIDTH-1:0]  wn_re[0:255];   //  Twiddle Table (Real)
wire[WIDTH-1:0]  wn_im[0:255];   //  Twiddle Table (Imag)
wire[WIDTH-1:0]  mx_re;          //  Multiplexer output (Real)
wire[WIDTH-1:0]  mx_im;          //  Multiplexer output (Imag)
reg [WIDTH-1:0]  ff_re;          //  Register output (Real)
reg [WIDTH-1:0]  ff_im;          //  Register output (Imag)

assign  mx_re = wn_re[addr];
assign  mx_im = wn_im[addr];

always @(posedge clock) begin
    ff_re <= mx_re;
    ff_im <= mx_im;
end

assign  tw_re = TW_FF ? ff_re : mx_re;
assign  tw_im = TW_FF ? ff_im : mx_im;

//----------------------------------------------------------------------
//  Twiddle Factor Value
//----------------------------------------------------------------------
//  Multiplication is bypassed when twiddle address is 0.
//  Setting wn_re[0] = 0 and wn_im[0] = 0 makes it easier to check the waveform.
//  It may also reduce power consumption slightly.
//
//      wn_re = cos(-2pi*n/1024)            wn_im = sin(-2pi*n/1024)
// assign  wn_re[ 0]   = 16'h0000;   assign  wn_im[ 0]   = 16'h0000;   //  0  1.000 -0.000
// assign  wn_re[ 1]   = 16'h7FFF;   assign  wn_im[ 1]   = 16'hFF36;   //  1  1.000 -0.006
// assign  wn_re[ 2]   = 16'h7FFD;   assign  wn_im[ 2]   = 16'hFE6D;   //  2  1.000 -0.012
// assign  wn_re[ 3]   = 16'h7FFA;   assign  wn_im[ 3]   = 16'hFDA4;   //  3  1.000 -0.018
// assign  wn_re[ 4]   = 16'h7FF6;   assign  wn_im[ 4]   = 16'hFCDB;   //  4  1.000 -0.025
// assign  wn_re[ 5]   = 16'h7FF0;   assign  wn_im[ 5]   = 16'hFC12;   //  5  1.000 -0.031
// assign  wn_re[ 6]   = 16'h7FE9;   assign  wn_im[ 6]   = 16'hFB49;   //  6  0.999 -0.037
// assign  wn_re[ 7]   = 16'h7FE1;   assign  wn_im[ 7]   = 16'hFA80;   //  7  0.999 -0.043
// assign  wn_re[ 8]   = 16'h7FD9;   assign  wn_im[ 8]   = 16'hF9B8;   //  8  0.999 -0.049
// assign  wn_re[ 9]   = 16'h7FCE;   assign  wn_im[ 9]   = 16'hF8EF;   //  9  0.998 -0.055
// assign  wn_re[10]   = 16'h7FC2;   assign  wn_im[10]   = 16'hF826;   // 10  0.998 -0.061
// assign  wn_re[11]   = 16'h7FB5;   assign  wn_im[11]   = 16'hF75D;   // 11  0.998 -0.067
// assign  wn_re[12]   = 16'h7FA7;   assign  wn_im[12]   = 16'hF695;   // 12  0.997 -0.074
// assign  wn_re[13]   = 16'h7F97;   assign  wn_im[13]   = 16'hF5CC;   // 13  0.997 -0.080
// assign  wn_re[14]   = 16'h7F87;   assign  wn_im[14]   = 16'hF504;   // 14  0.996 -0.086
// assign  wn_re[15]   = 16'h7F75;   assign  wn_im[15]   = 16'hF43C;   // 15  0.996 -0.092
// assign  wn_re[16]   = 16'h7F62;   assign  wn_im[16]   = 16'hF374;   // 16  0.995 -0.098
// assign  wn_re[17]   = 16'h7F4D;   assign  wn_im[17]   = 16'hF2AC;   // 17  0.995 -0.104
// assign  wn_re[18]   = 16'h7F38;   assign  wn_im[18]   = 16'hF1E4;   // 18  0.994 -0.110
// assign  wn_re[19]   = 16'h7F21;   assign  wn_im[19]   = 16'hF11C;   // 19  0.993 -0.116
// assign  wn_re[20]   = 16'h7F09;   assign  wn_im[20]   = 16'hF054;   // 20  0.992 -0.122
// assign  wn_re[21]   = 16'h7EF0;   assign  wn_im[21]   = 16'hEF8D;   // 21  0.992 -0.128
// assign  wn_re[22]   = 16'h7ED5;   assign  wn_im[22]   = 16'hEEC6;   // 22  0.991 -0.135
// assign  wn_re[23]   = 16'h7EBA;   assign  wn_im[23]   = 16'hEDFE;   // 23  0.990 -0.141
// assign  wn_re[24]   = 16'h7E9D;   assign  wn_im[24]   = 16'hED38;   // 24  0.989 -0.147
// assign  wn_re[25]   = 16'h7E7F;   assign  wn_im[25]   = 16'hEC71;   // 25  0.988 -0.153
// assign  wn_re[26]   = 16'h7E5F;   assign  wn_im[26]   = 16'hEBAA;   // 26  0.987 -0.159
// assign  wn_re[27]   = 16'h7E3F;   assign  wn_im[27]   = 16'hEAE4;   // 27  0.986 -0.165
// assign  wn_re[28]   = 16'h7E1D;   assign  wn_im[28]   = 16'hEA1D;   // 28  0.985 -0.171
// assign  wn_re[29]   = 16'h7DFA;   assign  wn_im[29]   = 16'hE957;   // 29  0.984 -0.177
// assign  wn_re[30]   = 16'h7DD6;   assign  wn_im[30]   = 16'hE892;   // 30  0.983 -0.183
// assign  wn_re[31]   = 16'h7DB0;   assign  wn_im[31]   = 16'hE7CC;   // 31  0.982 -0.189
// assign  wn_re[32]   = 16'h7D8A;   assign  wn_im[32]   = 16'hE707;   // 32  0.981 -0.195
// assign  wn_re[33]   = 16'h7D62;   assign  wn_im[33]   = 16'hE642;   // 33  0.980 -0.201
// assign  wn_re[34]   = 16'h7D39;   assign  wn_im[34]   = 16'hE57D;   // 34  0.978 -0.207
// assign  wn_re[35]   = 16'h7D0F;   assign  wn_im[35]   = 16'hE4B8;   // 35  0.977 -0.213
// assign  wn_re[36]   = 16'h7CE3;   assign  wn_im[36]   = 16'hE3F4;   // 36  0.976 -0.219
// assign  wn_re[37]   = 16'h7CB7;   assign  wn_im[37]   = 16'hE330;   // 37  0.974 -0.225
// assign  wn_re[38]   = 16'h7C89;   assign  wn_im[38]   = 16'hE26C;   // 38  0.973 -0.231
// assign  wn_re[39]   = 16'h7C5A;   assign  wn_im[39]   = 16'hE1A9;   // 39  0.972 -0.237
// assign  wn_re[40]   = 16'h7C2A;   assign  wn_im[40]   = 16'hE0E6;   // 40  0.970 -0.243
// assign  wn_re[41]   = 16'h7BF8;   assign  wn_im[41]   = 16'hE023;   // 41  0.969 -0.249
// assign  wn_re[42]   = 16'h7BC5;   assign  wn_im[42]   = 16'hDF60;   // 42  0.967 -0.255
// assign  wn_re[43]   = 16'h7B92;   assign  wn_im[43]   = 16'hDE9E;   // 43  0.965 -0.261
// assign  wn_re[44]   = 16'h7B5D;   assign  wn_im[44]   = 16'hDDDC;   // 44  0.964 -0.267
// assign  wn_re[45]   = 16'h7B26;   assign  wn_im[45]   = 16'hDD1A;   // 45  0.962 -0.273
// assign  wn_re[46]   = 16'h7AEF;   assign  wn_im[46]   = 16'hDC59;   // 46  0.960 -0.279
// assign  wn_re[47]   = 16'h7AB6;   assign  wn_im[47]   = 16'hDB98;   // 47  0.959 -0.284
// assign  wn_re[48]   = 16'h7A7D;   assign  wn_im[48]   = 16'hDAD8;   // 48  0.957 -0.290
// assign  wn_re[49]   = 16'h7A42;   assign  wn_im[49]   = 16'hDA17;   // 49  0.955 -0.296
// assign  wn_re[50]   = 16'h7A05;   assign  wn_im[50]   = 16'hD957;   // 50  0.953 -0.302
// assign  wn_re[51]   = 16'h79C8;   assign  wn_im[51]   = 16'hD898;   // 51  0.951 -0.308
// assign  wn_re[52]   = 16'h798A;   assign  wn_im[52]   = 16'hD7D9;   // 52  0.950 -0.314
// assign  wn_re[53]   = 16'h794A;   assign  wn_im[53]   = 16'hD71A;   // 53  0.948 -0.320
// assign  wn_re[54]   = 16'h7909;   assign  wn_im[54]   = 16'hD65C;   // 54  0.946 -0.325
// assign  wn_re[55]   = 16'h78C7;   assign  wn_im[55]   = 16'hD59E;   // 55  0.944 -0.331
// assign  wn_re[56]   = 16'h7885;   assign  wn_im[56]   = 16'hD4E1;   // 56  0.942 -0.337
// assign  wn_re[57]   = 16'h7840;   assign  wn_im[57]   = 16'hD423;   // 57  0.939 -0.343
// assign  wn_re[58]   = 16'h77FA;   assign  wn_im[58]   = 16'hD367;   // 58  0.937 -0.348
// assign  wn_re[59]   = 16'h77B4;   assign  wn_im[59]   = 16'hD2AA;   // 59  0.935 -0.354
// assign  wn_re[60]   = 16'h776C;   assign  wn_im[60]   = 16'hD1EE;   // 60  0.933 -0.360
// assign  wn_re[61]   = 16'h7723;   assign  wn_im[61]   = 16'hD133;   // 61  0.931 -0.366
// assign  wn_re[62]   = 16'h76D9;   assign  wn_im[62]   = 16'hD078;   // 62  0.929 -0.371
// assign  wn_re[63]   = 16'h768E;   assign  wn_im[63]   = 16'hCFBE;   // 63  0.926 -0.377
// assign  wn_re[64]   = 16'h7642;   assign  wn_im[64]   = 16'hCF04;   // 64  0.924 -0.383
// assign  wn_re[65]   = 16'h75F4;   assign  wn_im[65]   = 16'hCE4A;   // 65  0.922 -0.388
// assign  wn_re[66]   = 16'h75A5;   assign  wn_im[66]   = 16'hCD91;   // 66  0.919 -0.394
// assign  wn_re[67]   = 16'h7555;   assign  wn_im[67]   = 16'hCCD9;   // 67  0.917 -0.400
// assign  wn_re[68]   = 16'h7504;   assign  wn_im[68]   = 16'hCC21;   // 68  0.914 -0.405
// assign  wn_re[69]   = 16'h74B2;   assign  wn_im[69]   = 16'hCB69;   // 69  0.912 -0.411
// assign  wn_re[70]   = 16'h745F;   assign  wn_im[70]   = 16'hCAB2;   // 70  0.909 -0.416
// assign  wn_re[71]   = 16'h740B;   assign  wn_im[71]   = 16'hC9FB;   // 71  0.907 -0.422
// assign  wn_re[72]   = 16'h73B6;   assign  wn_im[72]   = 16'hC946;   // 72  0.904 -0.428
// assign  wn_re[73]   = 16'h735F;   assign  wn_im[73]   = 16'hC890;   // 73  0.901 -0.433
// assign  wn_re[74]   = 16'h7307;   assign  wn_im[74]   = 16'hC7DB;   // 74  0.899 -0.439
// assign  wn_re[75]   = 16'h72AF;   assign  wn_im[75]   = 16'hC727;   // 75  0.896 -0.444
// assign  wn_re[76]   = 16'h7255;   assign  wn_im[76]   = 16'hC673;   // 76  0.893 -0.450
// assign  wn_re[77]   = 16'h71FA;   assign  wn_im[77]   = 16'hC5BF;   // 77  0.890 -0.455
// assign  wn_re[78]   = 16'h719E;   assign  wn_im[78]   = 16'hC50D;   // 78  0.888 -0.461
// assign  wn_re[79]   = 16'h7141;   assign  wn_im[79]   = 16'hC45A;   // 79  0.885 -0.466
// assign  wn_re[80]   = 16'h70E3;   assign  wn_im[80]   = 16'hC3A9;   // 80  0.882 -0.471
// assign  wn_re[81]   = 16'h7083;   assign  wn_im[81]   = 16'hC2F8;   // 81  0.879 -0.477
// assign  wn_re[82]   = 16'h7023;   assign  wn_im[82]   = 16'hC247;   // 82  0.876 -0.482
// assign  wn_re[83]   = 16'h6FC1;   assign  wn_im[83]   = 16'hC197;   // 83  0.873 -0.488
// assign  wn_re[84]   = 16'h6F5F;   assign  wn_im[84]   = 16'hC0E8;   // 84  0.870 -0.493
// assign  wn_re[85]   = 16'h6EFB;   assign  wn_im[85]   = 16'hC03A;   // 85  0.867 -0.498
// assign  wn_re[86]   = 16'h6E96;   assign  wn_im[86]   = 16'hBF8C;   // 86  0.864 -0.504
// assign  wn_re[87]   = 16'h6E30;   assign  wn_im[87]   = 16'hBEDE;   // 87  0.861 -0.509
// assign  wn_re[88]   = 16'h6DCA;   assign  wn_im[88]   = 16'hBE32;   // 88  0.858 -0.514
// assign  wn_re[89]   = 16'h6D62;   assign  wn_im[89]   = 16'hBD85;   // 89  0.855 -0.519
// assign  wn_re[90]   = 16'h6CF9;   assign  wn_im[90]   = 16'hBCDA;   // 90  0.851 -0.525
// assign  wn_re[91]   = 16'h6C8F;   assign  wn_im[91]   = 16'hBC2F;   // 91  0.848 -0.530
// assign  wn_re[92]   = 16'h6C24;   assign  wn_im[92]   = 16'hBB85;   // 92  0.845 -0.535
// assign  wn_re[93]   = 16'h6BB8;   assign  wn_im[93]   = 16'hBADB;   // 93  0.842 -0.540
// assign  wn_re[94]   = 16'h6B4A;   assign  wn_im[94]   = 16'hBA32;   // 94  0.838 -0.545
// assign  wn_re[95]   = 16'h6ADC;   assign  wn_im[95]   = 16'hB98A;   // 95  0.835 -0.550
// assign  wn_re[96]   = 16'h6A6E;   assign  wn_im[96]   = 16'hB8E3;   // 96  0.831 -0.556
// assign  wn_re[97]   = 16'h69FD;   assign  wn_im[97]   = 16'hB83C;   // 97  0.828 -0.561
// assign  wn_re[98]   = 16'h698C;   assign  wn_im[98]   = 16'hB796;   // 98  0.825 -0.566
// assign  wn_re[99]   = 16'h6919;   assign  wn_im[99]   = 16'hB6F0;   // 99  0.821 -0.571
// assign  wn_re[100]  = 16'h68A6;   assign  wn_im[100]  = 16'hB64B;   // 100  0.818 -0.576
// assign  wn_re[101]  = 16'h6832;   assign  wn_im[101]  = 16'hB5A7;   // 101  0.814 -0.581
// assign  wn_re[102]  = 16'h67BD;   assign  wn_im[102]  = 16'hB504;   // 102  0.810 -0.586
// assign  wn_re[103]  = 16'h6746;   assign  wn_im[103]  = 16'hB461;   // 103  0.807 -0.591
// assign  wn_re[104]  = 16'h66D0;   assign  wn_im[104]  = 16'hB3C0;   // 104  0.803 -0.596
// assign  wn_re[105]  = 16'h6657;   assign  wn_im[105]  = 16'hB31E;   // 105  0.800 -0.601
// assign  wn_re[106]  = 16'h65DD;   assign  wn_im[106]  = 16'hB27E;   // 106  0.796 -0.606
// assign  wn_re[107]  = 16'h6563;   assign  wn_im[107]  = 16'hB1DE;   // 107  0.792 -0.610
// assign  wn_re[108]  = 16'h64E8;   assign  wn_im[108]  = 16'hB140;   // 108  0.788 -0.615
// assign  wn_re[109]  = 16'h646C;   assign  wn_im[109]  = 16'hB0A1;   // 109  0.785 -0.620
// assign  wn_re[110]  = 16'h63EF;   assign  wn_im[110]  = 16'hB004;   // 110  0.781 -0.625
// assign  wn_re[111]  = 16'h6371;   assign  wn_im[111]  = 16'hAF68;   // 111  0.777 -0.630
// assign  wn_re[112]  = 16'h62F2;   assign  wn_im[112]  = 16'hAECC;   // 112  0.773 -0.634
// assign  wn_re[113]  = 16'h6271;   assign  wn_im[113]  = 16'hAE31;   // 113  0.769 -0.639
// assign  wn_re[114]  = 16'h61F1;   assign  wn_im[114]  = 16'hAD96;   // 114  0.765 -0.644
// assign  wn_re[115]  = 16'h616F;   assign  wn_im[115]  = 16'hACFD;   // 115  0.761 -0.649
// assign  wn_re[116]  = 16'h60EC;   assign  wn_im[116]  = 16'hAC64;   // 116  0.757 -0.653
// assign  wn_re[117]  = 16'h6068;   assign  wn_im[117]  = 16'hABCC;   // 117  0.753 -0.658
// assign  wn_re[118]  = 16'h5FE3;   assign  wn_im[118]  = 16'hAB35;   // 118  0.749 -0.662
// assign  wn_re[119]  = 16'h5F5E;   assign  wn_im[119]  = 16'hAA9F;   // 119  0.745 -0.667
// assign  wn_re[120]  = 16'h5ED7;   assign  wn_im[120]  = 16'hAA0A;   // 120  0.741 -0.672
// assign  wn_re[121]  = 16'h5E50;   assign  wn_im[121]  = 16'hA975;   // 121  0.737 -0.676
// assign  wn_re[122]  = 16'h5DC7;   assign  wn_im[122]  = 16'hA8E2;   // 122  0.733 -0.681
// assign  wn_re[123]  = 16'h5D3E;   assign  wn_im[123]  = 16'hA84F;   // 123  0.728 -0.685
// assign  wn_re[124]  = 16'h5CB4;   assign  wn_im[124]  = 16'hA7BD;   // 124  0.724 -0.690
// assign  wn_re[125]  = 16'h5C29;   assign  wn_im[125]  = 16'hA72B;   // 125  0.720 -0.694
// assign  wn_re[126]  = 16'h5B9D;   assign  wn_im[126]  = 16'hA69B;   // 126  0.716 -0.698
// assign  wn_re[127]  = 16'h5B10;   assign  wn_im[127]  = 16'hA60C;   // 127  0.711 -0.703
// assign  wn_re[128]  = 16'h5A82;   assign  wn_im[128]  = 16'hA57E;   // 128  0.707 -0.707
// assign  wn_re[129]  = 16'h59F3;   assign  wn_im[129]  = 16'hA4EF;   // 129  0.703 -0.711
// assign  wn_re[130]  = 16'h5964;   assign  wn_im[130]  = 16'hA462;   // 130  0.698 -0.716
// assign  wn_re[131]  = 16'h58D4;   assign  wn_im[131]  = 16'hA3D6;   // 131  0.694 -0.720
// assign  wn_re[132]  = 16'h5842;   assign  wn_im[132]  = 16'hA34B;   // 132  0.690 -0.724
// assign  wn_re[133]  = 16'h57B0;   assign  wn_im[133]  = 16'hA2C1;   // 133  0.685 -0.728
// assign  wn_re[134]  = 16'h571D;   assign  wn_im[134]  = 16'hA238;   // 134  0.681 -0.733
// assign  wn_re[135]  = 16'h568A;   assign  wn_im[135]  = 16'hA1AF;   // 135  0.676 -0.737
// assign  wn_re[136]  = 16'h55F6;   assign  wn_im[136]  = 16'hA129;   // 136  0.672 -0.741
// assign  wn_re[137]  = 16'h5560;   assign  wn_im[137]  = 16'hA0A1;   // 137  0.667 -0.745
// assign  wn_re[138]  = 16'h54CA;   assign  wn_im[138]  = 16'hA01C;   // 138  0.662 -0.749
// assign  wn_re[139]  = 16'h5433;   assign  wn_im[139]  = 16'h9F97;   // 139  0.658 -0.753
// assign  wn_re[140]  = 16'h539B;   assign  wn_im[140]  = 16'h9F13;   // 140  0.653 -0.757
// assign  wn_re[141]  = 16'h5302;   assign  wn_im[141]  = 16'h9E90;   // 141  0.649 -0.761
// assign  wn_re[142]  = 16'h5269;   assign  wn_im[142]  = 16'h9E0E;   // 142  0.644 -0.765
// assign  wn_re[143]  = 16'h51CE;   assign  wn_im[143]  = 16'h9D8E;   // 143  0.639 -0.769
// assign  wn_re[144]  = 16'h5134;   assign  wn_im[144]  = 16'h9D0E;   // 144  0.634 -0.773
// assign  wn_re[145]  = 16'h5097;   assign  wn_im[145]  = 16'h9C8E;   // 145  0.630 -0.777
// assign  wn_re[146]  = 16'h4FFB;   assign  wn_im[146]  = 16'h9C10;   // 146  0.625 -0.781
// assign  wn_re[147]  = 16'h4F5E;   assign  wn_im[147]  = 16'h9B93;   // 147  0.620 -0.785
// assign  wn_re[148]  = 16'h4EBF;   assign  wn_im[148]  = 16'h9B17;   // 148  0.615 -0.788
// assign  wn_re[149]  = 16'h4E21;   assign  wn_im[149]  = 16'h9A9C;   // 149  0.610 -0.792
// assign  wn_re[150]  = 16'h4D81;   assign  wn_im[150]  = 16'h9A22;   // 150  0.606 -0.796
// assign  wn_re[151]  = 16'h4CE1;   assign  wn_im[151]  = 16'h99A8;   // 151  0.601 -0.800
// assign  wn_re[152]  = 16'h4C40;   assign  wn_im[152]  = 16'h9930;   // 152  0.596 -0.803
// assign  wn_re[153]  = 16'h4B9E;   assign  wn_im[153]  = 16'h98B9;   // 153  0.591 -0.807
// assign  wn_re[154]  = 16'h4AFB;   assign  wn_im[154]  = 16'h9842;   // 154  0.586 -0.810
// assign  wn_re[155]  = 16'h4A58;   assign  wn_im[155]  = 16'h97CD;   // 155  0.581 -0.814
// assign  wn_re[156]  = 16'h49B4;   assign  wn_im[156]  = 16'h9759;   // 156  0.576 -0.818
// assign  wn_re[157]  = 16'h490F;   assign  wn_im[157]  = 16'h96E6;   // 157  0.571 -0.821
// assign  wn_re[158]  = 16'h4869;   assign  wn_im[158]  = 16'h9673;   // 158  0.566 -0.825
// assign  wn_re[159]  = 16'h47C3;   assign  wn_im[159]  = 16'h9602;   // 159  0.561 -0.828
// assign  wn_re[160]  = 16'h471D;   assign  wn_im[160]  = 16'h9592;   // 160  0.556 -0.831
// assign  wn_re[161]  = 16'h4675;   assign  wn_im[161]  = 16'h9523;   // 161  0.550 -0.835
// assign  wn_re[162]  = 16'h45CD;   assign  wn_im[162]  = 16'h94B5;   // 162  0.545 -0.838
// assign  wn_re[163]  = 16'h4524;   assign  wn_im[163]  = 16'h9447;   // 163  0.540 -0.842
// assign  wn_re[164]  = 16'h447A;   assign  wn_im[164]  = 16'h93DB;   // 164  0.535 -0.845
// assign  wn_re[165]  = 16'h43D0;   assign  wn_im[165]  = 16'h9370;   // 165  0.530 -0.848
// assign  wn_re[166]  = 16'h4325;   assign  wn_im[166]  = 16'h9306;   // 166  0.525 -0.851
// assign  wn_re[167]  = 16'h427A;   assign  wn_im[167]  = 16'h929D;   // 167  0.519 -0.855
// assign  wn_re[168]  = 16'h41CE;   assign  wn_im[168]  = 16'h9236;   // 168  0.514 -0.858
// assign  wn_re[169]  = 16'h4121;   assign  wn_im[169]  = 16'h91CF;   // 169  0.509 -0.861
// assign  wn_re[170]  = 16'h4073;   assign  wn_im[170]  = 16'h9169;   // 170  0.504 -0.864
// assign  wn_re[171]  = 16'h3FC5;   assign  wn_im[171]  = 16'h9104;   // 171  0.498 -0.867
// assign  wn_re[172]  = 16'h3F17;   assign  wn_im[172]  = 16'h90A0;   // 172  0.493 -0.870
// assign  wn_re[173]  = 16'h3E68;   assign  wn_im[173]  = 16'h903E;   // 173  0.488 -0.873
// assign  wn_re[174]  = 16'h3DB8;   assign  wn_im[174]  = 16'h8FDC;   // 174  0.482 -0.876
// assign  wn_re[175]  = 16'h3D07;   assign  wn_im[175]  = 16'h8F7C;   // 175  0.477 -0.879
// assign  wn_re[176]  = 16'h3C57;   assign  wn_im[176]  = 16'h8F1D;   // 176  0.471 -0.882
// assign  wn_re[177]  = 16'h3BA5;   assign  wn_im[177]  = 16'h8EBE;   // 177  0.466 -0.885
// assign  wn_re[178]  = 16'h3AF2;   assign  wn_im[178]  = 16'h8E61;   // 178  0.461 -0.888
// assign  wn_re[179]  = 16'h3A40;   assign  wn_im[179]  = 16'h8E05;   // 179  0.455 -0.890
// assign  wn_re[180]  = 16'h398C;   assign  wn_im[180]  = 16'h8DAA;   // 180  0.450 -0.893
// assign  wn_re[181]  = 16'h38D8;   assign  wn_im[181]  = 16'h8D50;   // 181  0.444 -0.896
// assign  wn_re[182]  = 16'h3824;   assign  wn_im[182]  = 16'h8CF8;   // 182  0.439 -0.899
// assign  wn_re[183]  = 16'h376F;   assign  wn_im[183]  = 16'h8CA0;   // 183  0.433 -0.901
// assign  wn_re[184]  = 16'h36BA;   assign  wn_im[184]  = 16'h8C4A;   // 184  0.428 -0.904
// assign  wn_re[185]  = 16'h3604;   assign  wn_im[185]  = 16'h8BF4;   // 185  0.422 -0.907
// assign  wn_re[186]  = 16'h354D;   assign  wn_im[186]  = 16'h8BA0;   // 186  0.416 -0.909
// assign  wn_re[187]  = 16'h3496;   assign  wn_im[187]  = 16'h8B4D;   // 187  0.411 -0.912
// assign  wn_re[188]  = 16'h33DE;   assign  wn_im[188]  = 16'h8AFB;   // 188  0.405 -0.914
// assign  wn_re[189]  = 16'h3326;   assign  wn_im[189]  = 16'h8AAA;   // 189  0.400 -0.917
// assign  wn_re[190]  = 16'h326E;   assign  wn_im[190]  = 16'h8A5A;   // 190  0.394 -0.919
// assign  wn_re[191]  = 16'h31B5;   assign  wn_im[191]  = 16'h8A0B;   // 191  0.388 -0.922
// assign  wn_re[192]  = 16'h30FC;   assign  wn_im[192]  = 16'h89BE;   // 192  0.383 -0.924
// assign  wn_re[193]  = 16'h3041;   assign  wn_im[193]  = 16'h8971;   // 193  0.377 -0.926
// assign  wn_re[194]  = 16'h2F87;   assign  wn_im[194]  = 16'h8926;   // 194  0.371 -0.929
// assign  wn_re[195]  = 16'h2ECC;   assign  wn_im[195]  = 16'h88DC;   // 195  0.366 -0.931
// assign  wn_re[196]  = 16'h2E11;   assign  wn_im[196]  = 16'h8893;   // 196  0.360 -0.933
// assign  wn_re[197]  = 16'h2D55;   assign  wn_im[197]  = 16'h884B;   // 197  0.354 -0.935
// assign  wn_re[198]  = 16'h2C98;   assign  wn_im[198]  = 16'h8805;   // 198  0.348 -0.937
// assign  wn_re[199]  = 16'h2BDC;   assign  wn_im[199]  = 16'h87BF;   // 199  0.343 -0.939
// assign  wn_re[200]  = 16'h2B1F;   assign  wn_im[200]  = 16'h877B;   // 200  0.337 -0.942
// assign  wn_re[201]  = 16'h2A61;   assign  wn_im[201]  = 16'h8738;   // 201  0.331 -0.944
// assign  wn_re[202]  = 16'h29A3;   assign  wn_im[202]  = 16'h86F6;   // 202  0.325 -0.946
// assign  wn_re[203]  = 16'h28E5;   assign  wn_im[203]  = 16'h86B5;   // 203  0.320 -0.948
// assign  wn_re[204]  = 16'h2826;   assign  wn_im[204]  = 16'h8675;   // 204  0.314 -0.950
// assign  wn_re[205]  = 16'h2767;   assign  wn_im[205]  = 16'h8637;   // 205  0.308 -0.951
// assign  wn_re[206]  = 16'h26A8;   assign  wn_im[206]  = 16'h85FA;   // 206  0.302 -0.953
// assign  wn_re[207]  = 16'h25E8;   assign  wn_im[207]  = 16'h85BD;   // 207  0.296 -0.955
// assign  wn_re[208]  = 16'h2528;   assign  wn_im[208]  = 16'h8583;   // 208  0.290 -0.957
// assign  wn_re[209]  = 16'h2467;   assign  wn_im[209]  = 16'h8549;   // 209  0.284 -0.959
// assign  wn_re[210]  = 16'h23A6;   assign  wn_im[210]  = 16'h8510;   // 210  0.279 -0.960
// assign  wn_re[211]  = 16'h22E5;   assign  wn_im[211]  = 16'h84D9;   // 211  0.273 -0.962
// assign  wn_re[212]  = 16'h2223;   assign  wn_im[212]  = 16'h84A2;   // 212  0.267 -0.964
// assign  wn_re[213]  = 16'h2161;   assign  wn_im[213]  = 16'h846D;   // 213  0.261 -0.965
// assign  wn_re[214]  = 16'h209F;   assign  wn_im[214]  = 16'h843A;   // 214  0.255 -0.967
// assign  wn_re[215]  = 16'h1FDC;   assign  wn_im[215]  = 16'h8407;   // 215  0.249 -0.969
// assign  wn_re[216]  = 16'h1F1A;   assign  wn_im[216]  = 16'h83D6;   // 216  0.243 -0.970
// assign  wn_re[217]  = 16'h1E56;   assign  wn_im[217]  = 16'h83A5;   // 217  0.237 -0.972
// assign  wn_re[218]  = 16'h1D93;   assign  wn_im[218]  = 16'h8376;   // 218  0.231 -0.973
// assign  wn_re[219]  = 16'h1CCF;   assign  wn_im[219]  = 16'h8348;   // 219  0.225 -0.974
// assign  wn_re[220]  = 16'h1C0B;   assign  wn_im[220]  = 16'h831C;   // 220  0.219 -0.976
// assign  wn_re[221]  = 16'h1B47;   assign  wn_im[221]  = 16'h82F0;   // 221  0.213 -0.977
// assign  wn_re[222]  = 16'h1A82;   assign  wn_im[222]  = 16'h82C6;   // 222  0.207 -0.978
// assign  wn_re[223]  = 16'h19BD;   assign  wn_im[223]  = 16'h829D;   // 223  0.201 -0.980
// assign  wn_re[224]  = 16'h18F9;   assign  wn_im[224]  = 16'h8276;   // 224  0.195 -0.981
// assign  wn_re[225]  = 16'h1833;   assign  wn_im[225]  = 16'h824F;   // 225  0.189 -0.982
// assign  wn_re[226]  = 16'h176D;   assign  wn_im[226]  = 16'h8229;   // 226  0.183 -0.983
// assign  wn_re[227]  = 16'h16A8;   assign  wn_im[227]  = 16'h8205;   // 227  0.177 -0.984
// assign  wn_re[228]  = 16'h15E2;   assign  wn_im[228]  = 16'h81E2;   // 228  0.171 -0.985
// assign  wn_re[229]  = 16'h151B;   assign  wn_im[229]  = 16'h81C0;   // 229  0.165 -0.986
// assign  wn_re[230]  = 16'h1455;   assign  wn_im[230]  = 16'h81A0;   // 230  0.159 -0.987
// assign  wn_re[231]  = 16'h138E;   assign  wn_im[231]  = 16'h8180;   // 231  0.153 -0.988
// assign  wn_re[232]  = 16'h12C8;   assign  wn_im[232]  = 16'h8163;   // 232  0.147 -0.989
// assign  wn_re[233]  = 16'h1201;   assign  wn_im[233]  = 16'h8145;   // 233  0.141 -0.990
// assign  wn_re[234]  = 16'h1139;   assign  wn_im[234]  = 16'h812A;   // 234  0.135 -0.991
// assign  wn_re[235]  = 16'h1072;   assign  wn_im[235]  = 16'h810F;   // 235  0.128 -0.992
// assign  wn_re[236]  = 16'h0FAB;   assign  wn_im[236]  = 16'h80F6;   // 236  0.122 -0.992
// assign  wn_re[237]  = 16'h0EE3;   assign  wn_im[237]  = 16'h80DE;   // 237  0.116 -0.993
// assign  wn_re[238]  = 16'h0E1B;   assign  wn_im[238]  = 16'h80C7;   // 238  0.110 -0.994
// assign  wn_re[239]  = 16'h0D53;   assign  wn_im[239]  = 16'h80B2;   // 239  0.104 -0.995
// assign  wn_re[240]  = 16'h0C8C;   assign  wn_im[240]  = 16'h809E;   // 240  0.098 -0.995
// assign  wn_re[241]  = 16'h0BC3;   assign  wn_im[241]  = 16'h808A;   // 241  0.092 -0.996
// assign  wn_re[242]  = 16'h0AFB;   assign  wn_im[242]  = 16'h8078;   // 242  0.086 -0.996
// assign  wn_re[243]  = 16'h0A33;   assign  wn_im[243]  = 16'h8068;   // 243  0.080 -0.997
// assign  wn_re[244]  = 16'h096A;   assign  wn_im[244]  = 16'h8058;   // 244  0.074 -0.997
// assign  wn_re[245]  = 16'h08A2;   assign  wn_im[245]  = 16'h804A;   // 245  0.067 -0.998
// assign  wn_re[246]  = 16'h07D9;   assign  wn_im[246]  = 16'h803D;   // 246  0.061 -0.998
// assign  wn_re[247]  = 16'h0710;   assign  wn_im[247]  = 16'h8031;   // 247  0.055 -0.998
// assign  wn_re[248]  = 16'h0648;   assign  wn_im[248]  = 16'h8027;   // 248  0.049 -0.999
// assign  wn_re[249]  = 16'h057F;   assign  wn_im[249]  = 16'h801E;   // 249  0.043 -0.999
// assign  wn_re[250]  = 16'h04B6;   assign  wn_im[250]  = 16'h8016;   // 250  0.037 -0.999
// assign  wn_re[251]  = 16'h03ED;   assign  wn_im[251]  = 16'h800F;   // 251  0.031 -1.000
// assign  wn_re[252]  = 16'h0324;   assign  wn_im[252]  = 16'h8009;   // 252  0.025 -1.000
// assign  wn_re[253]  = 16'h025B;   assign  wn_im[253]  = 16'h8005;   // 253  0.018 -1.000
// assign  wn_re[254]  = 16'h0192;   assign  wn_im[254]  = 16'h8002;   // 254  0.012 -1.000
// assign  wn_re[255]  = 16'h00C9;   assign  wn_im[255]  = 16'h8000;   // 255  0.006 -1.000
// assign  wn_re[256]  = 16'h0000;   assign  wn_im[256]  = 16'h8000;   // 256  0.000 -1.000
// assign  wn_re[257]  = 16'hxxxx;   assign  wn_im[257]  = 16'hxxxx;   // 257 -0.006 -1.000
// assign  wn_re[258]  = 16'hFE6D;   assign  wn_im[258]  = 16'h8002;   // 258 -0.012 -1.000
// assign  wn_re[259]  = 16'hxxxx;   assign  wn_im[259]  = 16'hxxxx;   // 259 -0.018 -1.000
// assign  wn_re[260]  = 16'hFCDB;   assign  wn_im[260]  = 16'h8009;   // 260 -0.025 -1.000
// assign  wn_re[261]  = 16'hFC12;   assign  wn_im[261]  = 16'h800F;   // 261 -0.031 -1.000
// assign  wn_re[262]  = 16'hFB49;   assign  wn_im[262]  = 16'h8016;   // 262 -0.037 -0.999
// assign  wn_re[263]  = 16'hxxxx;   assign  wn_im[263]  = 16'hxxxx;   // 263 -0.043 -0.999
// assign  wn_re[264]  = 16'hF9B8;   assign  wn_im[264]  = 16'h8027;   // 264 -0.049 -0.999
// assign  wn_re[265]  = 16'hxxxx;   assign  wn_im[265]  = 16'hxxxx;   // 265 -0.055 -0.998
// assign  wn_re[266]  = 16'hF826;   assign  wn_im[266]  = 16'h803D;   // 266 -0.061 -0.998
// assign  wn_re[267]  = 16'hF75D;   assign  wn_im[267]  = 16'h804A;   // 267 -0.067 -0.998
// assign  wn_re[268]  = 16'hF695;   assign  wn_im[268]  = 16'h8058;   // 268 -0.074 -0.997
// assign  wn_re[269]  = 16'hxxxx;   assign  wn_im[269]  = 16'hxxxx;   // 269 -0.080 -0.997
// assign  wn_re[270]  = 16'hF504;   assign  wn_im[270]  = 16'h8078;   // 270 -0.086 -0.996
// assign  wn_re[271]  = 16'hxxxx;   assign  wn_im[271]  = 16'hxxxx;   // 271 -0.092 -0.996
// assign  wn_re[272]  = 16'hF374;   assign  wn_im[272]  = 16'h809E;   // 272 -0.098 -0.995
// assign  wn_re[273]  = 16'hF2AC;   assign  wn_im[273]  = 16'h80B2;   // 273 -0.104 -0.995
// assign  wn_re[274]  = 16'hF1E4;   assign  wn_im[274]  = 16'h80C7;   // 274 -0.110 -0.994
// assign  wn_re[275]  = 16'hxxxx;   assign  wn_im[275]  = 16'hxxxx;   // 275 -0.116 -0.993
// assign  wn_re[276]  = 16'hF054;   assign  wn_im[276]  = 16'h80F6;   // 276 -0.122 -0.992
// assign  wn_re[277]  = 16'hxxxx;   assign  wn_im[277]  = 16'hxxxx;   // 277 -0.128 -0.992
// assign  wn_re[278]  = 16'hEEC6;   assign  wn_im[278]  = 16'h812A;   // 278 -0.135 -0.991
// assign  wn_re[279]  = 16'hEDFE;   assign  wn_im[279]  = 16'h8145;   // 279 -0.141 -0.990
// assign  wn_re[280]  = 16'hED37;   assign  wn_im[280]  = 16'h8162;   // 280 -0.147 -0.989
// assign  wn_re[281]  = 16'hxxxx;   assign  wn_im[281]  = 16'hxxxx;   // 281 -0.153 -0.988
// assign  wn_re[282]  = 16'hEBAA;   assign  wn_im[282]  = 16'h81A0;   // 282 -0.159 -0.987
// assign  wn_re[283]  = 16'hxxxx;   assign  wn_im[283]  = 16'hxxxx;   // 283 -0.165 -0.986
// assign  wn_re[284]  = 16'hEA1D;   assign  wn_im[284]  = 16'h81E2;   // 284 -0.171 -0.985
// assign  wn_re[285]  = 16'hE957;   assign  wn_im[285]  = 16'h8205;   // 285 -0.177 -0.984
// assign  wn_re[286]  = 16'hE892;   assign  wn_im[286]  = 16'h8229;   // 286 -0.183 -0.983
// assign  wn_re[287]  = 16'hxxxx;   assign  wn_im[287]  = 16'hxxxx;   // 287 -0.189 -0.982
// assign  wn_re[288]  = 16'hE707;   assign  wn_im[288]  = 16'h8276;   // 288 -0.195 -0.981
// assign  wn_re[289]  = 16'hxxxx;   assign  wn_im[289]  = 16'hxxxx;   // 289 -0.201 -0.980
// assign  wn_re[290]  = 16'hE57D;   assign  wn_im[290]  = 16'h82C6;   // 290 -0.207 -0.978
// assign  wn_re[291]  = 16'hE4B8;   assign  wn_im[291]  = 16'h82F0;   // 291 -0.213 -0.977
// assign  wn_re[292]  = 16'hE3F4;   assign  wn_im[292]  = 16'h831C;   // 292 -0.219 -0.976
// assign  wn_re[293]  = 16'hxxxx;   assign  wn_im[293]  = 16'hxxxx;   // 293 -0.225 -0.974
// assign  wn_re[294]  = 16'hE26C;   assign  wn_im[294]  = 16'h8376;   // 294 -0.231 -0.973
// assign  wn_re[295]  = 16'hxxxx;   assign  wn_im[295]  = 16'hxxxx;   // 295 -0.237 -0.972
// assign  wn_re[296]  = 16'hE0E6;   assign  wn_im[296]  = 16'h83D6;   // 296 -0.243 -0.970
// assign  wn_re[297]  = 16'hE023;   assign  wn_im[297]  = 16'h8407;   // 297 -0.249 -0.969
// assign  wn_re[298]  = 16'hDF60;   assign  wn_im[298]  = 16'h843A;   // 298 -0.255 -0.967
// assign  wn_re[299]  = 16'hxxxx;   assign  wn_im[299]  = 16'hxxxx;   // 299 -0.261 -0.965
// assign  wn_re[300]  = 16'hDDDC;   assign  wn_im[300]  = 16'h84A2;   // 300 -0.267 -0.964
// assign  wn_re[301]  = 16'hxxxx;   assign  wn_im[301]  = 16'hxxxx;   // 301 -0.273 -0.962
// assign  wn_re[302]  = 16'hDC59;   assign  wn_im[302]  = 16'h8510;   // 302 -0.279 -0.960
// assign  wn_re[303]  = 16'hDB98;   assign  wn_im[303]  = 16'h8549;   // 303 -0.284 -0.959
// assign  wn_re[304]  = 16'hDAD8;   assign  wn_im[304]  = 16'h8583;   // 304 -0.290 -0.957
// assign  wn_re[305]  = 16'hxxxx;   assign  wn_im[305]  = 16'hxxxx;   // 305 -0.296 -0.955
// assign  wn_re[306]  = 16'hD957;   assign  wn_im[306]  = 16'h85FA;   // 306 -0.302 -0.953
// assign  wn_re[307]  = 16'hxxxx;   assign  wn_im[307]  = 16'hxxxx;   // 307 -0.308 -0.951
// assign  wn_re[308]  = 16'hD7D9;   assign  wn_im[308]  = 16'h8675;   // 308 -0.314 -0.950
// assign  wn_re[309]  = 16'hD71A;   assign  wn_im[309]  = 16'h86B5;   // 309 -0.320 -0.948
// assign  wn_re[310]  = 16'hD65C;   assign  wn_im[310]  = 16'h86F6;   // 310 -0.325 -0.946
// assign  wn_re[311]  = 16'hxxxx;   assign  wn_im[311]  = 16'hxxxx;   // 311 -0.331 -0.944
// assign  wn_re[312]  = 16'hD4E1;   assign  wn_im[312]  = 16'h877B;   // 312 -0.337 -0.942
// assign  wn_re[313]  = 16'hxxxx;   assign  wn_im[313]  = 16'hxxxx;   // 313 -0.343 -0.939
// assign  wn_re[314]  = 16'hD367;   assign  wn_im[314]  = 16'h8805;   // 314 -0.348 -0.937
// assign  wn_re[315]  = 16'hD2AA;   assign  wn_im[315]  = 16'h884B;   // 315 -0.354 -0.935
// assign  wn_re[316]  = 16'hD1EE;   assign  wn_im[316]  = 16'h8893;   // 316 -0.360 -0.933
// assign  wn_re[317]  = 16'hxxxx;   assign  wn_im[317]  = 16'hxxxx;   // 317 -0.366 -0.931
// assign  wn_re[318]  = 16'hD078;   assign  wn_im[318]  = 16'h8926;   // 318 -0.371 -0.929
// assign  wn_re[319]  = 16'hxxxx;   assign  wn_im[319]  = 16'hxxxx;   // 319 -0.377 -0.926
// assign  wn_re[320]  = 16'hCF04;   assign  wn_im[320]  = 16'h89BE;   // 320 -0.383 -0.924
// assign  wn_re[321]  = 16'hCE4A;   assign  wn_im[321]  = 16'h8A0B;   // 321 -0.388 -0.922
// assign  wn_re[322]  = 16'hCD91;   assign  wn_im[322]  = 16'h8A5A;   // 322 -0.394 -0.919
// assign  wn_re[323]  = 16'hxxxx;   assign  wn_im[323]  = 16'hxxxx;   // 323 -0.400 -0.917
// assign  wn_re[324]  = 16'hCC21;   assign  wn_im[324]  = 16'h8AFB;   // 324 -0.405 -0.914
// assign  wn_re[325]  = 16'hxxxx;   assign  wn_im[325]  = 16'hxxxx;   // 325 -0.411 -0.912
// assign  wn_re[326]  = 16'hCAB2;   assign  wn_im[326]  = 16'h8BA0;   // 326 -0.416 -0.909
// assign  wn_re[327]  = 16'hC9FB;   assign  wn_im[327]  = 16'h8BF4;   // 327 -0.422 -0.907
// assign  wn_re[328]  = 16'hC945;   assign  wn_im[328]  = 16'h8C4A;   // 328 -0.428 -0.904
// assign  wn_re[329]  = 16'hxxxx;   assign  wn_im[329]  = 16'hxxxx;   // 329 -0.433 -0.901
// assign  wn_re[330]  = 16'hC7DB;   assign  wn_im[330]  = 16'h8CF8;   // 330 -0.439 -0.899
// assign  wn_re[331]  = 16'hxxxx;   assign  wn_im[331]  = 16'hxxxx;   // 331 -0.444 -0.896
// assign  wn_re[332]  = 16'hC673;   assign  wn_im[332]  = 16'h8DAA;   // 332 -0.450 -0.893
// assign  wn_re[333]  = 16'hC5BF;   assign  wn_im[333]  = 16'h8E05;   // 333 -0.455 -0.890
// assign  wn_re[334]  = 16'hC50D;   assign  wn_im[334]  = 16'h8E61;   // 334 -0.461 -0.888
// assign  wn_re[335]  = 16'hxxxx;   assign  wn_im[335]  = 16'hxxxx;   // 335 -0.466 -0.885
// assign  wn_re[336]  = 16'hC3A9;   assign  wn_im[336]  = 16'h8F1D;   // 336 -0.471 -0.882
// assign  wn_re[337]  = 16'hxxxx;   assign  wn_im[337]  = 16'hxxxx;   // 337 -0.477 -0.879
// assign  wn_re[338]  = 16'hC247;   assign  wn_im[338]  = 16'h8FDC;   // 338 -0.482 -0.876
// assign  wn_re[339]  = 16'hC197;   assign  wn_im[339]  = 16'h903E;   // 339 -0.488 -0.873
// assign  wn_re[340]  = 16'hC0E8;   assign  wn_im[340]  = 16'h90A0;   // 340 -0.493 -0.870
// assign  wn_re[341]  = 16'hxxxx;   assign  wn_im[341]  = 16'hxxxx;   // 341 -0.498 -0.867
// assign  wn_re[342]  = 16'hBF8C;   assign  wn_im[342]  = 16'h9169;   // 342 -0.504 -0.864
// assign  wn_re[343]  = 16'hxxxx;   assign  wn_im[343]  = 16'hxxxx;   // 343 -0.509 -0.861
// assign  wn_re[344]  = 16'hBE31;   assign  wn_im[344]  = 16'h9235;   // 344 -0.514 -0.858
// assign  wn_re[345]  = 16'hBD85;   assign  wn_im[345]  = 16'h929D;   // 345 -0.519 -0.855
// assign  wn_re[346]  = 16'hBCDA;   assign  wn_im[346]  = 16'h9306;   // 346 -0.525 -0.851
// assign  wn_re[347]  = 16'hxxxx;   assign  wn_im[347]  = 16'hxxxx;   // 347 -0.530 -0.848
// assign  wn_re[348]  = 16'hBB85;   assign  wn_im[348]  = 16'h93DB;   // 348 -0.535 -0.845
// assign  wn_re[349]  = 16'hxxxx;   assign  wn_im[349]  = 16'hxxxx;   // 349 -0.540 -0.842
// assign  wn_re[350]  = 16'hBA32;   assign  wn_im[350]  = 16'h94B5;   // 350 -0.545 -0.838
// assign  wn_re[351]  = 16'hB98A;   assign  wn_im[351]  = 16'h9523;   // 351 -0.550 -0.835
// assign  wn_re[352]  = 16'hB8E3;   assign  wn_im[352]  = 16'h9592;   // 352 -0.556 -0.831
// assign  wn_re[353]  = 16'hxxxx;   assign  wn_im[353]  = 16'hxxxx;   // 353 -0.561 -0.828
// assign  wn_re[354]  = 16'hB796;   assign  wn_im[354]  = 16'h9673;   // 354 -0.566 -0.825
// assign  wn_re[355]  = 16'hxxxx;   assign  wn_im[355]  = 16'hxxxx;   // 355 -0.571 -0.821
// assign  wn_re[356]  = 16'hB64B;   assign  wn_im[356]  = 16'h9759;   // 356 -0.576 -0.818
// assign  wn_re[357]  = 16'hB5A7;   assign  wn_im[357]  = 16'h97CD;   // 357 -0.581 -0.814
// assign  wn_re[358]  = 16'hB504;   assign  wn_im[358]  = 16'h9842;   // 358 -0.586 -0.810
// assign  wn_re[359]  = 16'hxxxx;   assign  wn_im[359]  = 16'hxxxx;   // 359 -0.591 -0.807
// assign  wn_re[360]  = 16'hB3C0;   assign  wn_im[360]  = 16'h9930;   // 360 -0.596 -0.803
// assign  wn_re[361]  = 16'hxxxx;   assign  wn_im[361]  = 16'hxxxx;   // 361 -0.601 -0.800
// assign  wn_re[362]  = 16'hB27E;   assign  wn_im[362]  = 16'h9A22;   // 362 -0.606 -0.796
// assign  wn_re[363]  = 16'hB1DE;   assign  wn_im[363]  = 16'h9A9C;   // 363 -0.610 -0.792
// assign  wn_re[364]  = 16'hB140;   assign  wn_im[364]  = 16'h9B17;   // 364 -0.615 -0.788
// assign  wn_re[365]  = 16'hxxxx;   assign  wn_im[365]  = 16'hxxxx;   // 365 -0.620 -0.785
// assign  wn_re[366]  = 16'hB004;   assign  wn_im[366]  = 16'h9C10;   // 366 -0.625 -0.781
// assign  wn_re[367]  = 16'hxxxx;   assign  wn_im[367]  = 16'hxxxx;   // 367 -0.630 -0.777
// assign  wn_re[368]  = 16'hAECC;   assign  wn_im[368]  = 16'h9D0D;   // 368 -0.634 -0.773
// assign  wn_re[369]  = 16'hAE31;   assign  wn_im[369]  = 16'h9D8E;   // 369 -0.639 -0.769
// assign  wn_re[370]  = 16'hAD96;   assign  wn_im[370]  = 16'h9E0E;   // 370 -0.644 -0.765
// assign  wn_re[371]  = 16'hxxxx;   assign  wn_im[371]  = 16'hxxxx;   // 371 -0.649 -0.761
// assign  wn_re[372]  = 16'hAC64;   assign  wn_im[372]  = 16'h9F13;   // 372 -0.653 -0.757
// assign  wn_re[373]  = 16'hxxxx;   assign  wn_im[373]  = 16'hxxxx;   // 373 -0.658 -0.753
// assign  wn_re[374]  = 16'hAB35;   assign  wn_im[374]  = 16'hA01C;   // 374 -0.662 -0.749
// assign  wn_re[375]  = 16'hAA9F;   assign  wn_im[375]  = 16'hA0A1;   // 375 -0.667 -0.745
// assign  wn_re[376]  = 16'hAA0A;   assign  wn_im[376]  = 16'hA128;   // 376 -0.672 -0.741
// assign  wn_re[377]  = 16'hxxxx;   assign  wn_im[377]  = 16'hxxxx;   // 377 -0.676 -0.737
// assign  wn_re[378]  = 16'hA8E2;   assign  wn_im[378]  = 16'hA238;   // 378 -0.681 -0.733
// assign  wn_re[379]  = 16'hxxxx;   assign  wn_im[379]  = 16'hxxxx;   // 379 -0.685 -0.728
// assign  wn_re[380]  = 16'hA7BD;   assign  wn_im[380]  = 16'hA34B;   // 380 -0.690 -0.724
// assign  wn_re[381]  = 16'hA72B;   assign  wn_im[381]  = 16'hA3D6;   // 381 -0.694 -0.720
// assign  wn_re[382]  = 16'hA69B;   assign  wn_im[382]  = 16'hA462;   // 382 -0.698 -0.716
// assign  wn_re[383]  = 16'hxxxx;   assign  wn_im[383]  = 16'hxxxx;   // 383 -0.703 -0.711
// assign  wn_re[384]  = 16'hA57E;   assign  wn_im[384]  = 16'hA57E;   // 384 -0.707 -0.707
// assign  wn_re[385]  = 16'hxxxx;   assign  wn_im[385]  = 16'hxxxx;   // 385 -0.711 -0.703
// assign  wn_re[386]  = 16'hA462;   assign  wn_im[386]  = 16'hA69B;   // 386 -0.716 -0.698
// assign  wn_re[387]  = 16'hA3D6;   assign  wn_im[387]  = 16'hA72B;   // 387 -0.720 -0.694
// assign  wn_re[388]  = 16'hA34B;   assign  wn_im[388]  = 16'hA7BD;   // 388 -0.724 -0.690
// assign  wn_re[389]  = 16'hxxxx;   assign  wn_im[389]  = 16'hxxxx;   // 389 -0.728 -0.685
// assign  wn_re[390]  = 16'hA238;   assign  wn_im[390]  = 16'hA8E2;   // 390 -0.733 -0.681
// assign  wn_re[391]  = 16'hxxxx;   assign  wn_im[391]  = 16'hxxxx;   // 391 -0.737 -0.676
// assign  wn_re[392]  = 16'hA128;   assign  wn_im[392]  = 16'hAA0A;   // 392 -0.741 -0.672
// assign  wn_re[393]  = 16'hA0A1;   assign  wn_im[393]  = 16'hAA9F;   // 393 -0.745 -0.667
// assign  wn_re[394]  = 16'hA01C;   assign  wn_im[394]  = 16'hAB35;   // 394 -0.749 -0.662
// assign  wn_re[395]  = 16'hxxxx;   assign  wn_im[395]  = 16'hxxxx;   // 395 -0.753 -0.658
// assign  wn_re[396]  = 16'h9F13;   assign  wn_im[396]  = 16'hAC64;   // 396 -0.757 -0.653
// assign  wn_re[397]  = 16'hxxxx;   assign  wn_im[397]  = 16'hxxxx;   // 397 -0.761 -0.649
// assign  wn_re[398]  = 16'h9E0E;   assign  wn_im[398]  = 16'hAD96;   // 398 -0.765 -0.644
// assign  wn_re[399]  = 16'h9D8E;   assign  wn_im[399]  = 16'hAE31;   // 399 -0.769 -0.639
// assign  wn_re[400]  = 16'h9D0E;   assign  wn_im[400]  = 16'hAECC;   // 400 -0.773 -0.634
// assign  wn_re[401]  = 16'hxxxx;   assign  wn_im[401]  = 16'hxxxx;   // 401 -0.777 -0.630
// assign  wn_re[402]  = 16'h9C10;   assign  wn_im[402]  = 16'hB004;   // 402 -0.781 -0.625
// assign  wn_re[403]  = 16'hxxxx;   assign  wn_im[403]  = 16'hxxxx;   // 403 -0.785 -0.620
// assign  wn_re[404]  = 16'h9B17;   assign  wn_im[404]  = 16'hB140;   // 404 -0.788 -0.615
// assign  wn_re[405]  = 16'h9A9C;   assign  wn_im[405]  = 16'hB1DE;   // 405 -0.792 -0.610
// assign  wn_re[406]  = 16'h9A22;   assign  wn_im[406]  = 16'hB27E;   // 406 -0.796 -0.606
// assign  wn_re[407]  = 16'hxxxx;   assign  wn_im[407]  = 16'hxxxx;   // 407 -0.800 -0.601
// assign  wn_re[408]  = 16'h9930;   assign  wn_im[408]  = 16'hB3C0;   // 408 -0.803 -0.596
// assign  wn_re[409]  = 16'hxxxx;   assign  wn_im[409]  = 16'hxxxx;   // 409 -0.807 -0.591
// assign  wn_re[410]  = 16'h9842;   assign  wn_im[410]  = 16'hB504;   // 410 -0.810 -0.586
// assign  wn_re[411]  = 16'h97CD;   assign  wn_im[411]  = 16'hB5A7;   // 411 -0.814 -0.581
// assign  wn_re[412]  = 16'h9759;   assign  wn_im[412]  = 16'hB64B;   // 412 -0.818 -0.576
// assign  wn_re[413]  = 16'hxxxx;   assign  wn_im[413]  = 16'hxxxx;   // 413 -0.821 -0.571
// assign  wn_re[414]  = 16'h9673;   assign  wn_im[414]  = 16'hB796;   // 414 -0.825 -0.566
// assign  wn_re[415]  = 16'hxxxx;   assign  wn_im[415]  = 16'hxxxx;   // 415 -0.828 -0.561
// assign  wn_re[416]  = 16'h9592;   assign  wn_im[416]  = 16'hB8E3;   // 416 -0.831 -0.556
// assign  wn_re[417]  = 16'h9523;   assign  wn_im[417]  = 16'hB98A;   // 417 -0.835 -0.550
// assign  wn_re[418]  = 16'h94B5;   assign  wn_im[418]  = 16'hBA32;   // 418 -0.838 -0.545
// assign  wn_re[419]  = 16'hxxxx;   assign  wn_im[419]  = 16'hxxxx;   // 419 -0.842 -0.540
// assign  wn_re[420]  = 16'h93DB;   assign  wn_im[420]  = 16'hBB85;   // 420 -0.845 -0.535
// assign  wn_re[421]  = 16'hxxxx;   assign  wn_im[421]  = 16'hxxxx;   // 421 -0.848 -0.530
// assign  wn_re[422]  = 16'h9306;   assign  wn_im[422]  = 16'hBCDA;   // 422 -0.851 -0.525
// assign  wn_re[423]  = 16'h929D;   assign  wn_im[423]  = 16'hBD85;   // 423 -0.855 -0.519
// assign  wn_re[424]  = 16'h9235;   assign  wn_im[424]  = 16'hBE31;   // 424 -0.858 -0.514
// assign  wn_re[425]  = 16'hxxxx;   assign  wn_im[425]  = 16'hxxxx;   // 425 -0.861 -0.509
// assign  wn_re[426]  = 16'h9169;   assign  wn_im[426]  = 16'hBF8C;   // 426 -0.864 -0.504
// assign  wn_re[427]  = 16'hxxxx;   assign  wn_im[427]  = 16'hxxxx;   // 427 -0.867 -0.498
// assign  wn_re[428]  = 16'h90A0;   assign  wn_im[428]  = 16'hC0E8;   // 428 -0.870 -0.493
// assign  wn_re[429]  = 16'h903E;   assign  wn_im[429]  = 16'hC197;   // 429 -0.873 -0.488
// assign  wn_re[430]  = 16'h8FDC;   assign  wn_im[430]  = 16'hC247;   // 430 -0.876 -0.482
// assign  wn_re[431]  = 16'hxxxx;   assign  wn_im[431]  = 16'hxxxx;   // 431 -0.879 -0.477
// assign  wn_re[432]  = 16'h8F1D;   assign  wn_im[432]  = 16'hC3A9;   // 432 -0.882 -0.471
// assign  wn_re[433]  = 16'hxxxx;   assign  wn_im[433]  = 16'hxxxx;   // 433 -0.885 -0.466
// assign  wn_re[434]  = 16'h8E61;   assign  wn_im[434]  = 16'hC50D;   // 434 -0.888 -0.461
// assign  wn_re[435]  = 16'h8E05;   assign  wn_im[435]  = 16'hC5BF;   // 435 -0.890 -0.455
// assign  wn_re[436]  = 16'h8DAA;   assign  wn_im[436]  = 16'hC673;   // 436 -0.893 -0.450
// assign  wn_re[437]  = 16'hxxxx;   assign  wn_im[437]  = 16'hxxxx;   // 437 -0.896 -0.444
// assign  wn_re[438]  = 16'h8CF8;   assign  wn_im[438]  = 16'hC7DB;   // 438 -0.899 -0.439
// assign  wn_re[439]  = 16'hxxxx;   assign  wn_im[439]  = 16'hxxxx;   // 439 -0.901 -0.433
// assign  wn_re[440]  = 16'h8C4A;   assign  wn_im[440]  = 16'hC945;   // 440 -0.904 -0.428
// assign  wn_re[441]  = 16'h8BF4;   assign  wn_im[441]  = 16'hC9FB;   // 441 -0.907 -0.422
// assign  wn_re[442]  = 16'h8BA0;   assign  wn_im[442]  = 16'hCAB2;   // 442 -0.909 -0.416
// assign  wn_re[443]  = 16'hxxxx;   assign  wn_im[443]  = 16'hxxxx;   // 443 -0.912 -0.411
// assign  wn_re[444]  = 16'h8AFB;   assign  wn_im[444]  = 16'hCC21;   // 444 -0.914 -0.405
// assign  wn_re[445]  = 16'hxxxx;   assign  wn_im[445]  = 16'hxxxx;   // 445 -0.917 -0.400
// assign  wn_re[446]  = 16'h8A5A;   assign  wn_im[446]  = 16'hCD91;   // 446 -0.919 -0.394
// assign  wn_re[447]  = 16'h8A0B;   assign  wn_im[447]  = 16'hCE4A;   // 447 -0.922 -0.388
// assign  wn_re[448]  = 16'h89BE;   assign  wn_im[448]  = 16'hCF04;   // 448 -0.924 -0.383
// assign  wn_re[449]  = 16'hxxxx;   assign  wn_im[449]  = 16'hxxxx;   // 449 -0.926 -0.377
// assign  wn_re[450]  = 16'h8926;   assign  wn_im[450]  = 16'hD078;   // 450 -0.929 -0.371
// assign  wn_re[451]  = 16'hxxxx;   assign  wn_im[451]  = 16'hxxxx;   // 451 -0.931 -0.366
// assign  wn_re[452]  = 16'h8893;   assign  wn_im[452]  = 16'hD1EE;   // 452 -0.933 -0.360
// assign  wn_re[453]  = 16'h884B;   assign  wn_im[453]  = 16'hD2AA;   // 453 -0.935 -0.354
// assign  wn_re[454]  = 16'h8805;   assign  wn_im[454]  = 16'hD367;   // 454 -0.937 -0.348
// assign  wn_re[455]  = 16'hxxxx;   assign  wn_im[455]  = 16'hxxxx;   // 455 -0.939 -0.343
// assign  wn_re[456]  = 16'h877B;   assign  wn_im[456]  = 16'hD4E1;   // 456 -0.942 -0.337
// assign  wn_re[457]  = 16'hxxxx;   assign  wn_im[457]  = 16'hxxxx;   // 457 -0.944 -0.331
// assign  wn_re[458]  = 16'h86F6;   assign  wn_im[458]  = 16'hD65C;   // 458 -0.946 -0.325
// assign  wn_re[459]  = 16'h86B5;   assign  wn_im[459]  = 16'hD71A;   // 459 -0.948 -0.320
// assign  wn_re[460]  = 16'h8675;   assign  wn_im[460]  = 16'hD7D9;   // 460 -0.950 -0.314
// assign  wn_re[461]  = 16'hxxxx;   assign  wn_im[461]  = 16'hxxxx;   // 461 -0.951 -0.308
// assign  wn_re[462]  = 16'h85FA;   assign  wn_im[462]  = 16'hD957;   // 462 -0.953 -0.302
// assign  wn_re[463]  = 16'hxxxx;   assign  wn_im[463]  = 16'hxxxx;   // 463 -0.955 -0.296
// assign  wn_re[464]  = 16'h8583;   assign  wn_im[464]  = 16'hDAD8;   // 464 -0.957 -0.290
// assign  wn_re[465]  = 16'h8549;   assign  wn_im[465]  = 16'hDB98;   // 465 -0.959 -0.284
// assign  wn_re[466]  = 16'h8510;   assign  wn_im[466]  = 16'hDC59;   // 466 -0.960 -0.279
// assign  wn_re[467]  = 16'hxxxx;   assign  wn_im[467]  = 16'hxxxx;   // 467 -0.962 -0.273
// assign  wn_re[468]  = 16'h84A2;   assign  wn_im[468]  = 16'hDDDC;   // 468 -0.964 -0.267
// assign  wn_re[469]  = 16'hxxxx;   assign  wn_im[469]  = 16'hxxxx;   // 469 -0.965 -0.261
// assign  wn_re[470]  = 16'h843A;   assign  wn_im[470]  = 16'hDF60;   // 470 -0.967 -0.255
// assign  wn_re[471]  = 16'h8407;   assign  wn_im[471]  = 16'hE023;   // 471 -0.969 -0.249
// assign  wn_re[472]  = 16'h83D6;   assign  wn_im[472]  = 16'hE0E6;   // 472 -0.970 -0.243
// assign  wn_re[473]  = 16'hxxxx;   assign  wn_im[473]  = 16'hxxxx;   // 473 -0.972 -0.237
// assign  wn_re[474]  = 16'h8376;   assign  wn_im[474]  = 16'hE26C;   // 474 -0.973 -0.231
// assign  wn_re[475]  = 16'hxxxx;   assign  wn_im[475]  = 16'hxxxx;   // 475 -0.974 -0.225
// assign  wn_re[476]  = 16'h831C;   assign  wn_im[476]  = 16'hE3F4;   // 476 -0.976 -0.219
// assign  wn_re[477]  = 16'h82F0;   assign  wn_im[477]  = 16'hE4B8;   // 477 -0.977 -0.213
// assign  wn_re[478]  = 16'h82C6;   assign  wn_im[478]  = 16'hE57D;   // 478 -0.978 -0.207
// assign  wn_re[479]  = 16'hxxxx;   assign  wn_im[479]  = 16'hxxxx;   // 479 -0.980 -0.201
// assign  wn_re[480]  = 16'h8276;   assign  wn_im[480]  = 16'hE707;   // 480 -0.981 -0.195
// assign  wn_re[481]  = 16'hxxxx;   assign  wn_im[481]  = 16'hxxxx;   // 481 -0.982 -0.189
// assign  wn_re[482]  = 16'h8229;   assign  wn_im[482]  = 16'hE892;   // 482 -0.983 -0.183
// assign  wn_re[483]  = 16'h8205;   assign  wn_im[483]  = 16'hE957;   // 483 -0.984 -0.177
// assign  wn_re[484]  = 16'h81E2;   assign  wn_im[484]  = 16'hEA1D;   // 484 -0.985 -0.171
// assign  wn_re[485]  = 16'hxxxx;   assign  wn_im[485]  = 16'hxxxx;   // 485 -0.986 -0.165
// assign  wn_re[486]  = 16'h81A0;   assign  wn_im[486]  = 16'hEBAA;   // 486 -0.987 -0.159
// assign  wn_re[487]  = 16'hxxxx;   assign  wn_im[487]  = 16'hxxxx;   // 487 -0.988 -0.153
// assign  wn_re[488]  = 16'h8162;   assign  wn_im[488]  = 16'hED37;   // 488 -0.989 -0.147
// assign  wn_re[489]  = 16'h8145;   assign  wn_im[489]  = 16'hEDFE;   // 489 -0.990 -0.141
// assign  wn_re[490]  = 16'h812A;   assign  wn_im[490]  = 16'hEEC6;   // 490 -0.991 -0.135
// assign  wn_re[491]  = 16'hxxxx;   assign  wn_im[491]  = 16'hxxxx;   // 491 -0.992 -0.128
// assign  wn_re[492]  = 16'h80F6;   assign  wn_im[492]  = 16'hF054;   // 492 -0.992 -0.122
// assign  wn_re[493]  = 16'hxxxx;   assign  wn_im[493]  = 16'hxxxx;   // 493 -0.993 -0.116
// assign  wn_re[494]  = 16'h80C7;   assign  wn_im[494]  = 16'hF1E4;   // 494 -0.994 -0.110
// assign  wn_re[495]  = 16'h80B2;   assign  wn_im[495]  = 16'hF2AC;   // 495 -0.995 -0.104
// assign  wn_re[496]  = 16'h809E;   assign  wn_im[496]  = 16'hF374;   // 496 -0.995 -0.098
// assign  wn_re[497]  = 16'hxxxx;   assign  wn_im[497]  = 16'hxxxx;   // 497 -0.996 -0.092
// assign  wn_re[498]  = 16'h8078;   assign  wn_im[498]  = 16'hF504;   // 498 -0.996 -0.086
// assign  wn_re[499]  = 16'hxxxx;   assign  wn_im[499]  = 16'hxxxx;   // 499 -0.997 -0.080
// assign  wn_re[500]  = 16'h8058;   assign  wn_im[500]  = 16'hF695;   // 500 -0.997 -0.074
// assign  wn_re[501]  = 16'h804A;   assign  wn_im[501]  = 16'hF75D;   // 501 -0.998 -0.067
// assign  wn_re[502]  = 16'h803D;   assign  wn_im[502]  = 16'hF826;   // 502 -0.998 -0.061
// assign  wn_re[503]  = 16'hxxxx;   assign  wn_im[503]  = 16'hxxxx;   // 503 -0.998 -0.055
// assign  wn_re[504]  = 16'h8027;   assign  wn_im[504]  = 16'hF9B8;   // 504 -0.999 -0.049
// assign  wn_re[505]  = 16'hxxxx;   assign  wn_im[505]  = 16'hxxxx;   // 505 -0.999 -0.043
// assign  wn_re[506]  = 16'h8016;   assign  wn_im[506]  = 16'hFB49;   // 506 -0.999 -0.037
// assign  wn_re[507]  = 16'h800F;   assign  wn_im[507]  = 16'hFC12;   // 507 -1.000 -0.031
// assign  wn_re[508]  = 16'h8009;   assign  wn_im[508]  = 16'hFCDB;   // 508 -1.000 -0.025
// assign  wn_re[509]  = 16'hxxxx;   assign  wn_im[509]  = 16'hxxxx;   // 509 -1.000 -0.018
// assign  wn_re[510]  = 16'h8002;   assign  wn_im[510]  = 16'hFE6D;   // 510 -1.000 -0.012
// assign  wn_re[511]  = 16'hxxxx;   assign  wn_im[511]  = 16'hxxxx;   // 511 -1.000 -0.006
// assign  wn_re[512]  = 16'hxxxx;   assign  wn_im[512]  = 16'hxxxx;   // 512 -1.000 -0.000
// assign  wn_re[513]  = 16'h8000;   assign  wn_im[513]  = 16'h00C9;   // 513 -1.000  0.006
// assign  wn_re[514]  = 16'hxxxx;   assign  wn_im[514]  = 16'hxxxx;   // 514 -1.000  0.012
// assign  wn_re[515]  = 16'hxxxx;   assign  wn_im[515]  = 16'hxxxx;   // 515 -1.000  0.018
// assign  wn_re[516]  = 16'h8009;   assign  wn_im[516]  = 16'h0324;   // 516 -1.000  0.025
// assign  wn_re[517]  = 16'hxxxx;   assign  wn_im[517]  = 16'hxxxx;   // 517 -1.000  0.031
// assign  wn_re[518]  = 16'hxxxx;   assign  wn_im[518]  = 16'hxxxx;   // 518 -0.999  0.037
// assign  wn_re[519]  = 16'h801E;   assign  wn_im[519]  = 16'h057F;   // 519 -0.999  0.043
// assign  wn_re[520]  = 16'hxxxx;   assign  wn_im[520]  = 16'hxxxx;   // 520 -0.999  0.049
// assign  wn_re[521]  = 16'hxxxx;   assign  wn_im[521]  = 16'hxxxx;   // 521 -0.998  0.055
// assign  wn_re[522]  = 16'h803D;   assign  wn_im[522]  = 16'h07D9;   // 522 -0.998  0.061
// assign  wn_re[523]  = 16'hxxxx;   assign  wn_im[523]  = 16'hxxxx;   // 523 -0.998  0.067
// assign  wn_re[524]  = 16'hxxxx;   assign  wn_im[524]  = 16'hxxxx;   // 524 -0.997  0.074
// assign  wn_re[525]  = 16'h8068;   assign  wn_im[525]  = 16'h0A33;   // 525 -0.997  0.080
// assign  wn_re[526]  = 16'hxxxx;   assign  wn_im[526]  = 16'hxxxx;   // 526 -0.996  0.086
// assign  wn_re[527]  = 16'hxxxx;   assign  wn_im[527]  = 16'hxxxx;   // 527 -0.996  0.092
// assign  wn_re[528]  = 16'h809E;   assign  wn_im[528]  = 16'h0C8B;   // 528 -0.995  0.098
// assign  wn_re[529]  = 16'hxxxx;   assign  wn_im[529]  = 16'hxxxx;   // 529 -0.995  0.104
// assign  wn_re[530]  = 16'hxxxx;   assign  wn_im[530]  = 16'hxxxx;   // 530 -0.994  0.110
// assign  wn_re[531]  = 16'h80DE;   assign  wn_im[531]  = 16'h0EE3;   // 531 -0.993  0.116
// assign  wn_re[532]  = 16'hxxxx;   assign  wn_im[532]  = 16'hxxxx;   // 532 -0.992  0.122
// assign  wn_re[533]  = 16'hxxxx;   assign  wn_im[533]  = 16'hxxxx;   // 533 -0.992  0.128
// assign  wn_re[534]  = 16'h812A;   assign  wn_im[534]  = 16'h1139;   // 534 -0.991  0.135
// assign  wn_re[535]  = 16'hxxxx;   assign  wn_im[535]  = 16'hxxxx;   // 535 -0.990  0.141
// assign  wn_re[536]  = 16'hxxxx;   assign  wn_im[536]  = 16'hxxxx;   // 536 -0.989  0.147
// assign  wn_re[537]  = 16'h8180;   assign  wn_im[537]  = 16'h138E;   // 537 -0.988  0.153
// assign  wn_re[538]  = 16'hxxxx;   assign  wn_im[538]  = 16'hxxxx;   // 538 -0.987  0.159
// assign  wn_re[539]  = 16'hxxxx;   assign  wn_im[539]  = 16'hxxxx;   // 539 -0.986  0.165
// assign  wn_re[540]  = 16'h81E2;   assign  wn_im[540]  = 16'h15E2;   // 540 -0.985  0.171
// assign  wn_re[541]  = 16'hxxxx;   assign  wn_im[541]  = 16'hxxxx;   // 541 -0.984  0.177
// assign  wn_re[542]  = 16'hxxxx;   assign  wn_im[542]  = 16'hxxxx;   // 542 -0.983  0.183
// assign  wn_re[543]  = 16'h824F;   assign  wn_im[543]  = 16'h1833;   // 543 -0.982  0.189
// assign  wn_re[544]  = 16'hxxxx;   assign  wn_im[544]  = 16'hxxxx;   // 544 -0.981  0.195
// assign  wn_re[545]  = 16'hxxxx;   assign  wn_im[545]  = 16'hxxxx;   // 545 -0.980  0.201
// assign  wn_re[546]  = 16'h82C6;   assign  wn_im[546]  = 16'h1A82;   // 546 -0.978  0.207
// assign  wn_re[547]  = 16'hxxxx;   assign  wn_im[547]  = 16'hxxxx;   // 547 -0.977  0.213
// assign  wn_re[548]  = 16'hxxxx;   assign  wn_im[548]  = 16'hxxxx;   // 548 -0.976  0.219
// assign  wn_re[549]  = 16'h8348;   assign  wn_im[549]  = 16'h1CCF;   // 549 -0.974  0.225
// assign  wn_re[550]  = 16'hxxxx;   assign  wn_im[550]  = 16'hxxxx;   // 550 -0.973  0.231
// assign  wn_re[551]  = 16'hxxxx;   assign  wn_im[551]  = 16'hxxxx;   // 551 -0.972  0.237
// assign  wn_re[552]  = 16'h83D6;   assign  wn_im[552]  = 16'h1F1A;   // 552 -0.970  0.243
// assign  wn_re[553]  = 16'hxxxx;   assign  wn_im[553]  = 16'hxxxx;   // 553 -0.969  0.249
// assign  wn_re[554]  = 16'hxxxx;   assign  wn_im[554]  = 16'hxxxx;   // 554 -0.967  0.255
// assign  wn_re[555]  = 16'h846D;   assign  wn_im[555]  = 16'h2161;   // 555 -0.965  0.261
// assign  wn_re[556]  = 16'hxxxx;   assign  wn_im[556]  = 16'hxxxx;   // 556 -0.964  0.267
// assign  wn_re[557]  = 16'hxxxx;   assign  wn_im[557]  = 16'hxxxx;   // 557 -0.962  0.273
// assign  wn_re[558]  = 16'h8510;   assign  wn_im[558]  = 16'h23A6;   // 558 -0.960  0.279
// assign  wn_re[559]  = 16'hxxxx;   assign  wn_im[559]  = 16'hxxxx;   // 559 -0.959  0.284
// assign  wn_re[560]  = 16'hxxxx;   assign  wn_im[560]  = 16'hxxxx;   // 560 -0.957  0.290
// assign  wn_re[561]  = 16'h85BD;   assign  wn_im[561]  = 16'h25E8;   // 561 -0.955  0.296
// assign  wn_re[562]  = 16'hxxxx;   assign  wn_im[562]  = 16'hxxxx;   // 562 -0.953  0.302
// assign  wn_re[563]  = 16'hxxxx;   assign  wn_im[563]  = 16'hxxxx;   // 563 -0.951  0.308
// assign  wn_re[564]  = 16'h8675;   assign  wn_im[564]  = 16'h2826;   // 564 -0.950  0.314
// assign  wn_re[565]  = 16'hxxxx;   assign  wn_im[565]  = 16'hxxxx;   // 565 -0.948  0.320
// assign  wn_re[566]  = 16'hxxxx;   assign  wn_im[566]  = 16'hxxxx;   // 566 -0.946  0.325
// assign  wn_re[567]  = 16'h8738;   assign  wn_im[567]  = 16'h2A61;   // 567 -0.944  0.331
// assign  wn_re[568]  = 16'hxxxx;   assign  wn_im[568]  = 16'hxxxx;   // 568 -0.942  0.337
// assign  wn_re[569]  = 16'hxxxx;   assign  wn_im[569]  = 16'hxxxx;   // 569 -0.939  0.343
// assign  wn_re[570]  = 16'h8805;   assign  wn_im[570]  = 16'h2C98;   // 570 -0.937  0.348
// assign  wn_re[571]  = 16'hxxxx;   assign  wn_im[571]  = 16'hxxxx;   // 571 -0.935  0.354
// assign  wn_re[572]  = 16'hxxxx;   assign  wn_im[572]  = 16'hxxxx;   // 572 -0.933  0.360
// assign  wn_re[573]  = 16'h88DC;   assign  wn_im[573]  = 16'h2ECC;   // 573 -0.931  0.366
// assign  wn_re[574]  = 16'hxxxx;   assign  wn_im[574]  = 16'hxxxx;   // 574 -0.929  0.371
// assign  wn_re[575]  = 16'hxxxx;   assign  wn_im[575]  = 16'hxxxx;   // 575 -0.926  0.377
// assign  wn_re[576]  = 16'h89BE;   assign  wn_im[576]  = 16'h30FC;   // 576 -0.924  0.383
// assign  wn_re[577]  = 16'hxxxx;   assign  wn_im[577]  = 16'hxxxx;   // 577 -0.922  0.388
// assign  wn_re[578]  = 16'hxxxx;   assign  wn_im[578]  = 16'hxxxx;   // 578 -0.919  0.394
// assign  wn_re[579]  = 16'h8AAA;   assign  wn_im[579]  = 16'h3326;   // 579 -0.917  0.400
// assign  wn_re[580]  = 16'hxxxx;   assign  wn_im[580]  = 16'hxxxx;   // 580 -0.914  0.405
// assign  wn_re[581]  = 16'hxxxx;   assign  wn_im[581]  = 16'hxxxx;   // 581 -0.912  0.411
// assign  wn_re[582]  = 16'h8BA0;   assign  wn_im[582]  = 16'h354D;   // 582 -0.909  0.416
// assign  wn_re[583]  = 16'hxxxx;   assign  wn_im[583]  = 16'hxxxx;   // 583 -0.907  0.422
// assign  wn_re[584]  = 16'hxxxx;   assign  wn_im[584]  = 16'hxxxx;   // 584 -0.904  0.428
// assign  wn_re[585]  = 16'h8CA0;   assign  wn_im[585]  = 16'h376F;   // 585 -0.901  0.433
// assign  wn_re[586]  = 16'hxxxx;   assign  wn_im[586]  = 16'hxxxx;   // 586 -0.899  0.439
// assign  wn_re[587]  = 16'hxxxx;   assign  wn_im[587]  = 16'hxxxx;   // 587 -0.896  0.444
// assign  wn_re[588]  = 16'h8DAA;   assign  wn_im[588]  = 16'h398C;   // 588 -0.893  0.450
// assign  wn_re[589]  = 16'hxxxx;   assign  wn_im[589]  = 16'hxxxx;   // 589 -0.890  0.455
// assign  wn_re[590]  = 16'hxxxx;   assign  wn_im[590]  = 16'hxxxx;   // 590 -0.888  0.461
// assign  wn_re[591]  = 16'h8EBE;   assign  wn_im[591]  = 16'h3BA5;   // 591 -0.885  0.466
// assign  wn_re[592]  = 16'hxxxx;   assign  wn_im[592]  = 16'hxxxx;   // 592 -0.882  0.471
// assign  wn_re[593]  = 16'hxxxx;   assign  wn_im[593]  = 16'hxxxx;   // 593 -0.879  0.477
// assign  wn_re[594]  = 16'h8FDC;   assign  wn_im[594]  = 16'h3DB8;   // 594 -0.876  0.482
// assign  wn_re[595]  = 16'hxxxx;   assign  wn_im[595]  = 16'hxxxx;   // 595 -0.873  0.488
// assign  wn_re[596]  = 16'hxxxx;   assign  wn_im[596]  = 16'hxxxx;   // 596 -0.870  0.493
// assign  wn_re[597]  = 16'h9104;   assign  wn_im[597]  = 16'h3FC5;   // 597 -0.867  0.498
// assign  wn_re[598]  = 16'hxxxx;   assign  wn_im[598]  = 16'hxxxx;   // 598 -0.864  0.504
// assign  wn_re[599]  = 16'hxxxx;   assign  wn_im[599]  = 16'hxxxx;   // 599 -0.861  0.509
// assign  wn_re[600]  = 16'h9236;   assign  wn_im[600]  = 16'h41CE;   // 600 -0.858  0.514
// assign  wn_re[601]  = 16'hxxxx;   assign  wn_im[601]  = 16'hxxxx;   // 601 -0.855  0.519
// assign  wn_re[602]  = 16'hxxxx;   assign  wn_im[602]  = 16'hxxxx;   // 602 -0.851  0.525
// assign  wn_re[603]  = 16'h9370;   assign  wn_im[603]  = 16'h43D0;   // 603 -0.848  0.530
// assign  wn_re[604]  = 16'hxxxx;   assign  wn_im[604]  = 16'hxxxx;   // 604 -0.845  0.535
// assign  wn_re[605]  = 16'hxxxx;   assign  wn_im[605]  = 16'hxxxx;   // 605 -0.842  0.540
// assign  wn_re[606]  = 16'h94B5;   assign  wn_im[606]  = 16'h45CD;   // 606 -0.838  0.545
// assign  wn_re[607]  = 16'hxxxx;   assign  wn_im[607]  = 16'hxxxx;   // 607 -0.835  0.550
// assign  wn_re[608]  = 16'hxxxx;   assign  wn_im[608]  = 16'hxxxx;   // 608 -0.831  0.556
// assign  wn_re[609]  = 16'h9602;   assign  wn_im[609]  = 16'h47C3;   // 609 -0.828  0.561
// assign  wn_re[610]  = 16'hxxxx;   assign  wn_im[610]  = 16'hxxxx;   // 610 -0.825  0.566
// assign  wn_re[611]  = 16'hxxxx;   assign  wn_im[611]  = 16'hxxxx;   // 611 -0.821  0.571
// assign  wn_re[612]  = 16'h9759;   assign  wn_im[612]  = 16'h49B4;   // 612 -0.818  0.576
// assign  wn_re[613]  = 16'hxxxx;   assign  wn_im[613]  = 16'hxxxx;   // 613 -0.814  0.581
// assign  wn_re[614]  = 16'hxxxx;   assign  wn_im[614]  = 16'hxxxx;   // 614 -0.810  0.586
// assign  wn_re[615]  = 16'h98B9;   assign  wn_im[615]  = 16'h4B9E;   // 615 -0.807  0.591
// assign  wn_re[616]  = 16'hxxxx;   assign  wn_im[616]  = 16'hxxxx;   // 616 -0.803  0.596
// assign  wn_re[617]  = 16'hxxxx;   assign  wn_im[617]  = 16'hxxxx;   // 617 -0.800  0.601
// assign  wn_re[618]  = 16'h9A22;   assign  wn_im[618]  = 16'h4D81;   // 618 -0.796  0.606
// assign  wn_re[619]  = 16'hxxxx;   assign  wn_im[619]  = 16'hxxxx;   // 619 -0.792  0.610
// assign  wn_re[620]  = 16'hxxxx;   assign  wn_im[620]  = 16'hxxxx;   // 620 -0.788  0.615
// assign  wn_re[621]  = 16'h9B93;   assign  wn_im[621]  = 16'h4F5E;   // 621 -0.785  0.620
// assign  wn_re[622]  = 16'hxxxx;   assign  wn_im[622]  = 16'hxxxx;   // 622 -0.781  0.625
// assign  wn_re[623]  = 16'hxxxx;   assign  wn_im[623]  = 16'hxxxx;   // 623 -0.777  0.630
// assign  wn_re[624]  = 16'h9D0E;   assign  wn_im[624]  = 16'h5134;   // 624 -0.773  0.634
// assign  wn_re[625]  = 16'hxxxx;   assign  wn_im[625]  = 16'hxxxx;   // 625 -0.769  0.639
// assign  wn_re[626]  = 16'hxxxx;   assign  wn_im[626]  = 16'hxxxx;   // 626 -0.765  0.644
// assign  wn_re[627]  = 16'h9E90;   assign  wn_im[627]  = 16'h5302;   // 627 -0.761  0.649
// assign  wn_re[628]  = 16'hxxxx;   assign  wn_im[628]  = 16'hxxxx;   // 628 -0.757  0.653
// assign  wn_re[629]  = 16'hxxxx;   assign  wn_im[629]  = 16'hxxxx;   // 629 -0.753  0.658
// assign  wn_re[630]  = 16'hA01C;   assign  wn_im[630]  = 16'h54CA;   // 630 -0.749  0.662
// assign  wn_re[631]  = 16'hxxxx;   assign  wn_im[631]  = 16'hxxxx;   // 631 -0.745  0.667
// assign  wn_re[632]  = 16'hxxxx;   assign  wn_im[632]  = 16'hxxxx;   // 632 -0.741  0.672
// assign  wn_re[633]  = 16'hA1AF;   assign  wn_im[633]  = 16'h568A;   // 633 -0.737  0.676
// assign  wn_re[634]  = 16'hxxxx;   assign  wn_im[634]  = 16'hxxxx;   // 634 -0.733  0.681
// assign  wn_re[635]  = 16'hxxxx;   assign  wn_im[635]  = 16'hxxxx;   // 635 -0.728  0.685
// assign  wn_re[636]  = 16'hA34B;   assign  wn_im[636]  = 16'h5842;   // 636 -0.724  0.690
// assign  wn_re[637]  = 16'hxxxx;   assign  wn_im[637]  = 16'hxxxx;   // 637 -0.720  0.694
// assign  wn_re[638]  = 16'hxxxx;   assign  wn_im[638]  = 16'hxxxx;   // 638 -0.716  0.698
// assign  wn_re[639]  = 16'hA4EF;   assign  wn_im[639]  = 16'h59F3;   // 639 -0.711  0.703
// assign  wn_re[640]  = 16'hxxxx;   assign  wn_im[640]  = 16'hxxxx;   // 640 -0.707  0.707
// assign  wn_re[641]  = 16'hxxxx;   assign  wn_im[641]  = 16'hxxxx;   // 641 -0.703  0.711
// assign  wn_re[642]  = 16'hA69B;   assign  wn_im[642]  = 16'h5B9D;   // 642 -0.698  0.716
// assign  wn_re[643]  = 16'hxxxx;   assign  wn_im[643]  = 16'hxxxx;   // 643 -0.694  0.720
// assign  wn_re[644]  = 16'hxxxx;   assign  wn_im[644]  = 16'hxxxx;   // 644 -0.690  0.724
// assign  wn_re[645]  = 16'hA84F;   assign  wn_im[645]  = 16'h5D3E;   // 645 -0.685  0.728
// assign  wn_re[646]  = 16'hxxxx;   assign  wn_im[646]  = 16'hxxxx;   // 646 -0.681  0.733
// assign  wn_re[647]  = 16'hxxxx;   assign  wn_im[647]  = 16'hxxxx;   // 647 -0.676  0.737
// assign  wn_re[648]  = 16'hAA0A;   assign  wn_im[648]  = 16'h5ED7;   // 648 -0.672  0.741
// assign  wn_re[649]  = 16'hxxxx;   assign  wn_im[649]  = 16'hxxxx;   // 649 -0.667  0.745
// assign  wn_re[650]  = 16'hxxxx;   assign  wn_im[650]  = 16'hxxxx;   // 650 -0.662  0.749
// assign  wn_re[651]  = 16'hABCC;   assign  wn_im[651]  = 16'h6068;   // 651 -0.658  0.753
// assign  wn_re[652]  = 16'hxxxx;   assign  wn_im[652]  = 16'hxxxx;   // 652 -0.653  0.757
// assign  wn_re[653]  = 16'hxxxx;   assign  wn_im[653]  = 16'hxxxx;   // 653 -0.649  0.761
// assign  wn_re[654]  = 16'hAD96;   assign  wn_im[654]  = 16'h61F1;   // 654 -0.644  0.765
// assign  wn_re[655]  = 16'hxxxx;   assign  wn_im[655]  = 16'hxxxx;   // 655 -0.639  0.769
// assign  wn_re[656]  = 16'hxxxx;   assign  wn_im[656]  = 16'hxxxx;   // 656 -0.634  0.773
// assign  wn_re[657]  = 16'hAF68;   assign  wn_im[657]  = 16'h6371;   // 657 -0.630  0.777
// assign  wn_re[658]  = 16'hxxxx;   assign  wn_im[658]  = 16'hxxxx;   // 658 -0.625  0.781
// assign  wn_re[659]  = 16'hxxxx;   assign  wn_im[659]  = 16'hxxxx;   // 659 -0.620  0.785
// assign  wn_re[660]  = 16'hB140;   assign  wn_im[660]  = 16'h64E8;   // 660 -0.615  0.788
// assign  wn_re[661]  = 16'hxxxx;   assign  wn_im[661]  = 16'hxxxx;   // 661 -0.610  0.792
// assign  wn_re[662]  = 16'hxxxx;   assign  wn_im[662]  = 16'hxxxx;   // 662 -0.606  0.796
// assign  wn_re[663]  = 16'hB31E;   assign  wn_im[663]  = 16'h6657;   // 663 -0.601  0.800
// assign  wn_re[664]  = 16'hxxxx;   assign  wn_im[664]  = 16'hxxxx;   // 664 -0.596  0.803
// assign  wn_re[665]  = 16'hxxxx;   assign  wn_im[665]  = 16'hxxxx;   // 665 -0.591  0.807
// assign  wn_re[666]  = 16'hB504;   assign  wn_im[666]  = 16'h67BD;   // 666 -0.586  0.810
// assign  wn_re[667]  = 16'hxxxx;   assign  wn_im[667]  = 16'hxxxx;   // 667 -0.581  0.814
// assign  wn_re[668]  = 16'hxxxx;   assign  wn_im[668]  = 16'hxxxx;   // 668 -0.576  0.818
// assign  wn_re[669]  = 16'hB6F0;   assign  wn_im[669]  = 16'h6919;   // 669 -0.571  0.821
// assign  wn_re[670]  = 16'hxxxx;   assign  wn_im[670]  = 16'hxxxx;   // 670 -0.566  0.825
// assign  wn_re[671]  = 16'hxxxx;   assign  wn_im[671]  = 16'hxxxx;   // 671 -0.561  0.828
// assign  wn_re[672]  = 16'hB8E3;   assign  wn_im[672]  = 16'h6A6E;   // 672 -0.556  0.831
// assign  wn_re[673]  = 16'hxxxx;   assign  wn_im[673]  = 16'hxxxx;   // 673 -0.550  0.835
// assign  wn_re[674]  = 16'hxxxx;   assign  wn_im[674]  = 16'hxxxx;   // 674 -0.545  0.838
// assign  wn_re[675]  = 16'hBADB;   assign  wn_im[675]  = 16'h6BB8;   // 675 -0.540  0.842
// assign  wn_re[676]  = 16'hxxxx;   assign  wn_im[676]  = 16'hxxxx;   // 676 -0.535  0.845
// assign  wn_re[677]  = 16'hxxxx;   assign  wn_im[677]  = 16'hxxxx;   // 677 -0.530  0.848
// assign  wn_re[678]  = 16'hBCDA;   assign  wn_im[678]  = 16'h6CF9;   // 678 -0.525  0.851
// assign  wn_re[679]  = 16'hxxxx;   assign  wn_im[679]  = 16'hxxxx;   // 679 -0.519  0.855
// assign  wn_re[680]  = 16'hxxxx;   assign  wn_im[680]  = 16'hxxxx;   // 680 -0.514  0.858
// assign  wn_re[681]  = 16'hBEDE;   assign  wn_im[681]  = 16'h6E30;   // 681 -0.509  0.861
// assign  wn_re[682]  = 16'hxxxx;   assign  wn_im[682]  = 16'hxxxx;   // 682 -0.504  0.864
// assign  wn_re[683]  = 16'hxxxx;   assign  wn_im[683]  = 16'hxxxx;   // 683 -0.498  0.867
// assign  wn_re[684]  = 16'hC0E8;   assign  wn_im[684]  = 16'h6F5F;   // 684 -0.493  0.870
// assign  wn_re[685]  = 16'hxxxx;   assign  wn_im[685]  = 16'hxxxx;   // 685 -0.488  0.873
// assign  wn_re[686]  = 16'hxxxx;   assign  wn_im[686]  = 16'hxxxx;   // 686 -0.482  0.876
// assign  wn_re[687]  = 16'hC2F8;   assign  wn_im[687]  = 16'h7083;   // 687 -0.477  0.879
// assign  wn_re[688]  = 16'hxxxx;   assign  wn_im[688]  = 16'hxxxx;   // 688 -0.471  0.882
// assign  wn_re[689]  = 16'hxxxx;   assign  wn_im[689]  = 16'hxxxx;   // 689 -0.466  0.885
// assign  wn_re[690]  = 16'hC50D;   assign  wn_im[690]  = 16'h719E;   // 690 -0.461  0.888
// assign  wn_re[691]  = 16'hxxxx;   assign  wn_im[691]  = 16'hxxxx;   // 691 -0.455  0.890
// assign  wn_re[692]  = 16'hxxxx;   assign  wn_im[692]  = 16'hxxxx;   // 692 -0.450  0.893
// assign  wn_re[693]  = 16'hC727;   assign  wn_im[693]  = 16'h72AF;   // 693 -0.444  0.896
// assign  wn_re[694]  = 16'hxxxx;   assign  wn_im[694]  = 16'hxxxx;   // 694 -0.439  0.899
// assign  wn_re[695]  = 16'hxxxx;   assign  wn_im[695]  = 16'hxxxx;   // 695 -0.433  0.901
// assign  wn_re[696]  = 16'hC946;   assign  wn_im[696]  = 16'h73B6;   // 696 -0.428  0.904
// assign  wn_re[697]  = 16'hxxxx;   assign  wn_im[697]  = 16'hxxxx;   // 697 -0.422  0.907
// assign  wn_re[698]  = 16'hxxxx;   assign  wn_im[698]  = 16'hxxxx;   // 698 -0.416  0.909
// assign  wn_re[699]  = 16'hCB69;   assign  wn_im[699]  = 16'h74B2;   // 699 -0.411  0.912
// assign  wn_re[700]  = 16'hxxxx;   assign  wn_im[700]  = 16'hxxxx;   // 700 -0.405  0.914
// assign  wn_re[701]  = 16'hxxxx;   assign  wn_im[701]  = 16'hxxxx;   // 701 -0.400  0.917
// assign  wn_re[702]  = 16'hCD91;   assign  wn_im[702]  = 16'h75A5;   // 702 -0.394  0.919
// assign  wn_re[703]  = 16'hxxxx;   assign  wn_im[703]  = 16'hxxxx;   // 703 -0.388  0.922
// assign  wn_re[704]  = 16'hxxxx;   assign  wn_im[704]  = 16'hxxxx;   // 704 -0.383  0.924
// assign  wn_re[705]  = 16'hCFBE;   assign  wn_im[705]  = 16'h768E;   // 705 -0.377  0.926
// assign  wn_re[706]  = 16'hxxxx;   assign  wn_im[706]  = 16'hxxxx;   // 706 -0.371  0.929
// assign  wn_re[707]  = 16'hxxxx;   assign  wn_im[707]  = 16'hxxxx;   // 707 -0.366  0.931
// assign  wn_re[708]  = 16'hD1EE;   assign  wn_im[708]  = 16'h776C;   // 708 -0.360  0.933
// assign  wn_re[709]  = 16'hxxxx;   assign  wn_im[709]  = 16'hxxxx;   // 709 -0.354  0.935
// assign  wn_re[710]  = 16'hxxxx;   assign  wn_im[710]  = 16'hxxxx;   // 710 -0.348  0.937
// assign  wn_re[711]  = 16'hD423;   assign  wn_im[711]  = 16'h7840;   // 711 -0.343  0.939
// assign  wn_re[712]  = 16'hxxxx;   assign  wn_im[712]  = 16'hxxxx;   // 712 -0.337  0.942
// assign  wn_re[713]  = 16'hxxxx;   assign  wn_im[713]  = 16'hxxxx;   // 713 -0.331  0.944
// assign  wn_re[714]  = 16'hD65C;   assign  wn_im[714]  = 16'h7909;   // 714 -0.325  0.946
// assign  wn_re[715]  = 16'hxxxx;   assign  wn_im[715]  = 16'hxxxx;   // 715 -0.320  0.948
// assign  wn_re[716]  = 16'hxxxx;   assign  wn_im[716]  = 16'hxxxx;   // 716 -0.314  0.950
// assign  wn_re[717]  = 16'hD898;   assign  wn_im[717]  = 16'h79C8;   // 717 -0.308  0.951
// assign  wn_re[718]  = 16'hxxxx;   assign  wn_im[718]  = 16'hxxxx;   // 718 -0.302  0.953
// assign  wn_re[719]  = 16'hxxxx;   assign  wn_im[719]  = 16'hxxxx;   // 719 -0.296  0.955
// assign  wn_re[720]  = 16'hDAD8;   assign  wn_im[720]  = 16'h7A7D;   // 720 -0.290  0.957
// assign  wn_re[721]  = 16'hxxxx;   assign  wn_im[721]  = 16'hxxxx;   // 721 -0.284  0.959
// assign  wn_re[722]  = 16'hxxxx;   assign  wn_im[722]  = 16'hxxxx;   // 722 -0.279  0.960
// assign  wn_re[723]  = 16'hDD1A;   assign  wn_im[723]  = 16'h7B26;   // 723 -0.273  0.962
// assign  wn_re[724]  = 16'hxxxx;   assign  wn_im[724]  = 16'hxxxx;   // 724 -0.267  0.964
// assign  wn_re[725]  = 16'hxxxx;   assign  wn_im[725]  = 16'hxxxx;   // 725 -0.261  0.965
// assign  wn_re[726]  = 16'hDF60;   assign  wn_im[726]  = 16'h7BC5;   // 726 -0.255  0.967
// assign  wn_re[727]  = 16'hxxxx;   assign  wn_im[727]  = 16'hxxxx;   // 727 -0.249  0.969
// assign  wn_re[728]  = 16'hxxxx;   assign  wn_im[728]  = 16'hxxxx;   // 728 -0.243  0.970
// assign  wn_re[729]  = 16'hE1A9;   assign  wn_im[729]  = 16'h7C5A;   // 729 -0.237  0.972
// assign  wn_re[730]  = 16'hxxxx;   assign  wn_im[730]  = 16'hxxxx;   // 730 -0.231  0.973
// assign  wn_re[731]  = 16'hxxxx;   assign  wn_im[731]  = 16'hxxxx;   // 731 -0.225  0.974
// assign  wn_re[732]  = 16'hE3F4;   assign  wn_im[732]  = 16'h7CE3;   // 732 -0.219  0.976
// assign  wn_re[733]  = 16'hxxxx;   assign  wn_im[733]  = 16'hxxxx;   // 733 -0.213  0.977
// assign  wn_re[734]  = 16'hxxxx;   assign  wn_im[734]  = 16'hxxxx;   // 734 -0.207  0.978
// assign  wn_re[735]  = 16'hE642;   assign  wn_im[735]  = 16'h7D62;   // 735 -0.201  0.980
// assign  wn_re[736]  = 16'hxxxx;   assign  wn_im[736]  = 16'hxxxx;   // 736 -0.195  0.981
// assign  wn_re[737]  = 16'hxxxx;   assign  wn_im[737]  = 16'hxxxx;   // 737 -0.189  0.982
// assign  wn_re[738]  = 16'hE892;   assign  wn_im[738]  = 16'h7DD6;   // 738 -0.183  0.983
// assign  wn_re[739]  = 16'hxxxx;   assign  wn_im[739]  = 16'hxxxx;   // 739 -0.177  0.984
// assign  wn_re[740]  = 16'hxxxx;   assign  wn_im[740]  = 16'hxxxx;   // 740 -0.171  0.985
// assign  wn_re[741]  = 16'hEAE4;   assign  wn_im[741]  = 16'h7E3F;   // 741 -0.165  0.986
// assign  wn_re[742]  = 16'hxxxx;   assign  wn_im[742]  = 16'hxxxx;   // 742 -0.159  0.987
// assign  wn_re[743]  = 16'hxxxx;   assign  wn_im[743]  = 16'hxxxx;   // 743 -0.153  0.988
// assign  wn_re[744]  = 16'hED38;   assign  wn_im[744]  = 16'h7E9D;   // 744 -0.147  0.989
// assign  wn_re[745]  = 16'hxxxx;   assign  wn_im[745]  = 16'hxxxx;   // 745 -0.141  0.990
// assign  wn_re[746]  = 16'hxxxx;   assign  wn_im[746]  = 16'hxxxx;   // 746 -0.135  0.991
// assign  wn_re[747]  = 16'hEF8D;   assign  wn_im[747]  = 16'h7EF0;   // 747 -0.128  0.992
// assign  wn_re[748]  = 16'hxxxx;   assign  wn_im[748]  = 16'hxxxx;   // 748 -0.122  0.992
// assign  wn_re[749]  = 16'hxxxx;   assign  wn_im[749]  = 16'hxxxx;   // 749 -0.116  0.993
// assign  wn_re[750]  = 16'hF1E4;   assign  wn_im[750]  = 16'h7F38;   // 750 -0.110  0.994
// assign  wn_re[751]  = 16'hxxxx;   assign  wn_im[751]  = 16'hxxxx;   // 751 -0.104  0.995
// assign  wn_re[752]  = 16'hxxxx;   assign  wn_im[752]  = 16'hxxxx;   // 752 -0.098  0.995
// assign  wn_re[753]  = 16'hF43C;   assign  wn_im[753]  = 16'h7F75;   // 753 -0.092  0.996
// assign  wn_re[754]  = 16'hxxxx;   assign  wn_im[754]  = 16'hxxxx;   // 754 -0.086  0.996
// assign  wn_re[755]  = 16'hxxxx;   assign  wn_im[755]  = 16'hxxxx;   // 755 -0.080  0.997
// assign  wn_re[756]  = 16'hF695;   assign  wn_im[756]  = 16'h7FA7;   // 756 -0.074  0.997
// assign  wn_re[757]  = 16'hxxxx;   assign  wn_im[757]  = 16'hxxxx;   // 757 -0.067  0.998
// assign  wn_re[758]  = 16'hxxxx;   assign  wn_im[758]  = 16'hxxxx;   // 758 -0.061  0.998
// assign  wn_re[759]  = 16'hF8EF;   assign  wn_im[759]  = 16'h7FCE;   // 759 -0.055  0.998
// assign  wn_re[760]  = 16'hxxxx;   assign  wn_im[760]  = 16'hxxxx;   // 760 -0.049  0.999
// assign  wn_re[761]  = 16'hxxxx;   assign  wn_im[761]  = 16'hxxxx;   // 761 -0.043  0.999
// assign  wn_re[762]  = 16'hFB49;   assign  wn_im[762]  = 16'h7FE9;   // 762 -0.037  0.999
// assign  wn_re[763]  = 16'hxxxx;   assign  wn_im[763]  = 16'hxxxx;   // 763 -0.031  1.000
// assign  wn_re[764]  = 16'hxxxx;   assign  wn_im[764]  = 16'hxxxx;   // 764 -0.025  1.000
// assign  wn_re[765]  = 16'hFDA4;   assign  wn_im[765]  = 16'h7FFA;   // 765 -0.018  1.000
// assign  wn_re[766]  = 16'hxxxx;   assign  wn_im[766]  = 16'hxxxx;   // 766 -0.012  1.000
// assign  wn_re[767]  = 16'hxxxx;   assign  wn_im[767]  = 16'hxxxx;   // 767 -0.006  1.000
// assign  wn_re[768]  = 16'hxxxx;   assign  wn_im[768]  = 16'hxxxx;   // 768 -0.000  1.000
// assign  wn_re[769]  = 16'hxxxx;   assign  wn_im[769]  = 16'hxxxx;   // 769  0.006  1.000
// assign  wn_re[770]  = 16'hxxxx;   assign  wn_im[770]  = 16'hxxxx;   // 770  0.012  1.000
// assign  wn_re[771]  = 16'hxxxx;   assign  wn_im[771]  = 16'hxxxx;   // 771  0.018  1.000
// assign  wn_re[772]  = 16'hxxxx;   assign  wn_im[772]  = 16'hxxxx;   // 772  0.025  1.000
// assign  wn_re[773]  = 16'hxxxx;   assign  wn_im[773]  = 16'hxxxx;   // 773  0.031  1.000
// assign  wn_re[774]  = 16'hxxxx;   assign  wn_im[774]  = 16'hxxxx;   // 774  0.037  0.999
// assign  wn_re[775]  = 16'hxxxx;   assign  wn_im[775]  = 16'hxxxx;   // 775  0.043  0.999
// assign  wn_re[776]  = 16'hxxxx;   assign  wn_im[776]  = 16'hxxxx;   // 776  0.049  0.999
// assign  wn_re[777]  = 16'hxxxx;   assign  wn_im[777]  = 16'hxxxx;   // 777  0.055  0.998
// assign  wn_re[778]  = 16'hxxxx;   assign  wn_im[778]  = 16'hxxxx;   // 778  0.061  0.998
// assign  wn_re[779]  = 16'hxxxx;   assign  wn_im[779]  = 16'hxxxx;   // 779  0.067  0.998
// assign  wn_re[780]  = 16'hxxxx;   assign  wn_im[780]  = 16'hxxxx;   // 780  0.074  0.997
// assign  wn_re[781]  = 16'hxxxx;   assign  wn_im[781]  = 16'hxxxx;   // 781  0.080  0.997
// assign  wn_re[782]  = 16'hxxxx;   assign  wn_im[782]  = 16'hxxxx;   // 782  0.086  0.996
// assign  wn_re[783]  = 16'hxxxx;   assign  wn_im[783]  = 16'hxxxx;   // 783  0.092  0.996
// assign  wn_re[784]  = 16'hxxxx;   assign  wn_im[784]  = 16'hxxxx;   // 784  0.098  0.995
// assign  wn_re[785]  = 16'hxxxx;   assign  wn_im[785]  = 16'hxxxx;   // 785  0.104  0.995
// assign  wn_re[786]  = 16'hxxxx;   assign  wn_im[786]  = 16'hxxxx;   // 786  0.110  0.994
// assign  wn_re[787]  = 16'hxxxx;   assign  wn_im[787]  = 16'hxxxx;   // 787  0.116  0.993
// assign  wn_re[788]  = 16'hxxxx;   assign  wn_im[788]  = 16'hxxxx;   // 788  0.122  0.992
// assign  wn_re[789]  = 16'hxxxx;   assign  wn_im[789]  = 16'hxxxx;   // 789  0.128  0.992
// assign  wn_re[790]  = 16'hxxxx;   assign  wn_im[790]  = 16'hxxxx;   // 790  0.135  0.991
// assign  wn_re[791]  = 16'hxxxx;   assign  wn_im[791]  = 16'hxxxx;   // 791  0.141  0.990
// assign  wn_re[792]  = 16'hxxxx;   assign  wn_im[792]  = 16'hxxxx;   // 792  0.147  0.989
// assign  wn_re[793]  = 16'hxxxx;   assign  wn_im[793]  = 16'hxxxx;   // 793  0.153  0.988
// assign  wn_re[794]  = 16'hxxxx;   assign  wn_im[794]  = 16'hxxxx;   // 794  0.159  0.987
// assign  wn_re[795]  = 16'hxxxx;   assign  wn_im[795]  = 16'hxxxx;   // 795  0.165  0.986
// assign  wn_re[796]  = 16'hxxxx;   assign  wn_im[796]  = 16'hxxxx;   // 796  0.171  0.985
// assign  wn_re[797]  = 16'hxxxx;   assign  wn_im[797]  = 16'hxxxx;   // 797  0.177  0.984
// assign  wn_re[798]  = 16'hxxxx;   assign  wn_im[798]  = 16'hxxxx;   // 798  0.183  0.983
// assign  wn_re[799]  = 16'hxxxx;   assign  wn_im[799]  = 16'hxxxx;   // 799  0.189  0.982
// assign  wn_re[800]  = 16'hxxxx;   assign  wn_im[800]  = 16'hxxxx;   // 800  0.195  0.981
// assign  wn_re[801]  = 16'hxxxx;   assign  wn_im[801]  = 16'hxxxx;   // 801  0.201  0.980
// assign  wn_re[802]  = 16'hxxxx;   assign  wn_im[802]  = 16'hxxxx;   // 802  0.207  0.978
// assign  wn_re[803]  = 16'hxxxx;   assign  wn_im[803]  = 16'hxxxx;   // 803  0.213  0.977
// assign  wn_re[804]  = 16'hxxxx;   assign  wn_im[804]  = 16'hxxxx;   // 804  0.219  0.976
// assign  wn_re[805]  = 16'hxxxx;   assign  wn_im[805]  = 16'hxxxx;   // 805  0.225  0.974
// assign  wn_re[806]  = 16'hxxxx;   assign  wn_im[806]  = 16'hxxxx;   // 806  0.231  0.973
// assign  wn_re[807]  = 16'hxxxx;   assign  wn_im[807]  = 16'hxxxx;   // 807  0.237  0.972
// assign  wn_re[808]  = 16'hxxxx;   assign  wn_im[808]  = 16'hxxxx;   // 808  0.243  0.970
// assign  wn_re[809]  = 16'hxxxx;   assign  wn_im[809]  = 16'hxxxx;   // 809  0.249  0.969
// assign  wn_re[810]  = 16'hxxxx;   assign  wn_im[810]  = 16'hxxxx;   // 810  0.255  0.967
// assign  wn_re[811]  = 16'hxxxx;   assign  wn_im[811]  = 16'hxxxx;   // 811  0.261  0.965
// assign  wn_re[812]  = 16'hxxxx;   assign  wn_im[812]  = 16'hxxxx;   // 812  0.267  0.964
// assign  wn_re[813]  = 16'hxxxx;   assign  wn_im[813]  = 16'hxxxx;   // 813  0.273  0.962
// assign  wn_re[814]  = 16'hxxxx;   assign  wn_im[814]  = 16'hxxxx;   // 814  0.279  0.960
// assign  wn_re[815]  = 16'hxxxx;   assign  wn_im[815]  = 16'hxxxx;   // 815  0.284  0.959
// assign  wn_re[816]  = 16'hxxxx;   assign  wn_im[816]  = 16'hxxxx;   // 816  0.290  0.957
// assign  wn_re[817]  = 16'hxxxx;   assign  wn_im[817]  = 16'hxxxx;   // 817  0.296  0.955
// assign  wn_re[818]  = 16'hxxxx;   assign  wn_im[818]  = 16'hxxxx;   // 818  0.302  0.953
// assign  wn_re[819]  = 16'hxxxx;   assign  wn_im[819]  = 16'hxxxx;   // 819  0.308  0.951
// assign  wn_re[820]  = 16'hxxxx;   assign  wn_im[820]  = 16'hxxxx;   // 820  0.314  0.950
// assign  wn_re[821]  = 16'hxxxx;   assign  wn_im[821]  = 16'hxxxx;   // 821  0.320  0.948
// assign  wn_re[822]  = 16'hxxxx;   assign  wn_im[822]  = 16'hxxxx;   // 822  0.325  0.946
// assign  wn_re[823]  = 16'hxxxx;   assign  wn_im[823]  = 16'hxxxx;   // 823  0.331  0.944
// assign  wn_re[824]  = 16'hxxxx;   assign  wn_im[824]  = 16'hxxxx;   // 824  0.337  0.942
// assign  wn_re[825]  = 16'hxxxx;   assign  wn_im[825]  = 16'hxxxx;   // 825  0.343  0.939
// assign  wn_re[826]  = 16'hxxxx;   assign  wn_im[826]  = 16'hxxxx;   // 826  0.348  0.937
// assign  wn_re[827]  = 16'hxxxx;   assign  wn_im[827]  = 16'hxxxx;   // 827  0.354  0.935
// assign  wn_re[828]  = 16'hxxxx;   assign  wn_im[828]  = 16'hxxxx;   // 828  0.360  0.933
// assign  wn_re[829]  = 16'hxxxx;   assign  wn_im[829]  = 16'hxxxx;   // 829  0.366  0.931
// assign  wn_re[830]  = 16'hxxxx;   assign  wn_im[830]  = 16'hxxxx;   // 830  0.371  0.929
// assign  wn_re[831]  = 16'hxxxx;   assign  wn_im[831]  = 16'hxxxx;   // 831  0.377  0.926
// assign  wn_re[832]  = 16'hxxxx;   assign  wn_im[832]  = 16'hxxxx;   // 832  0.383  0.924
// assign  wn_re[833]  = 16'hxxxx;   assign  wn_im[833]  = 16'hxxxx;   // 833  0.388  0.922
// assign  wn_re[834]  = 16'hxxxx;   assign  wn_im[834]  = 16'hxxxx;   // 834  0.394  0.919
// assign  wn_re[835]  = 16'hxxxx;   assign  wn_im[835]  = 16'hxxxx;   // 835  0.400  0.917
// assign  wn_re[836]  = 16'hxxxx;   assign  wn_im[836]  = 16'hxxxx;   // 836  0.405  0.914
// assign  wn_re[837]  = 16'hxxxx;   assign  wn_im[837]  = 16'hxxxx;   // 837  0.411  0.912
// assign  wn_re[838]  = 16'hxxxx;   assign  wn_im[838]  = 16'hxxxx;   // 838  0.416  0.909
// assign  wn_re[839]  = 16'hxxxx;   assign  wn_im[839]  = 16'hxxxx;   // 839  0.422  0.907
// assign  wn_re[840]  = 16'hxxxx;   assign  wn_im[840]  = 16'hxxxx;   // 840  0.428  0.904
// assign  wn_re[841]  = 16'hxxxx;   assign  wn_im[841]  = 16'hxxxx;   // 841  0.433  0.901
// assign  wn_re[842]  = 16'hxxxx;   assign  wn_im[842]  = 16'hxxxx;   // 842  0.439  0.899
// assign  wn_re[843]  = 16'hxxxx;   assign  wn_im[843]  = 16'hxxxx;   // 843  0.444  0.896
// assign  wn_re[844]  = 16'hxxxx;   assign  wn_im[844]  = 16'hxxxx;   // 844  0.450  0.893
// assign  wn_re[845]  = 16'hxxxx;   assign  wn_im[845]  = 16'hxxxx;   // 845  0.455  0.890
// assign  wn_re[846]  = 16'hxxxx;   assign  wn_im[846]  = 16'hxxxx;   // 846  0.461  0.888
// assign  wn_re[847]  = 16'hxxxx;   assign  wn_im[847]  = 16'hxxxx;   // 847  0.466  0.885
// assign  wn_re[848]  = 16'hxxxx;   assign  wn_im[848]  = 16'hxxxx;   // 848  0.471  0.882
// assign  wn_re[849]  = 16'hxxxx;   assign  wn_im[849]  = 16'hxxxx;   // 849  0.477  0.879
// assign  wn_re[850]  = 16'hxxxx;   assign  wn_im[850]  = 16'hxxxx;   // 850  0.482  0.876
// assign  wn_re[851]  = 16'hxxxx;   assign  wn_im[851]  = 16'hxxxx;   // 851  0.488  0.873
// assign  wn_re[852]  = 16'hxxxx;   assign  wn_im[852]  = 16'hxxxx;   // 852  0.493  0.870
// assign  wn_re[853]  = 16'hxxxx;   assign  wn_im[853]  = 16'hxxxx;   // 853  0.498  0.867
// assign  wn_re[854]  = 16'hxxxx;   assign  wn_im[854]  = 16'hxxxx;   // 854  0.504  0.864
// assign  wn_re[855]  = 16'hxxxx;   assign  wn_im[855]  = 16'hxxxx;   // 855  0.509  0.861
// assign  wn_re[856]  = 16'hxxxx;   assign  wn_im[856]  = 16'hxxxx;   // 856  0.514  0.858
// assign  wn_re[857]  = 16'hxxxx;   assign  wn_im[857]  = 16'hxxxx;   // 857  0.519  0.855
// assign  wn_re[858]  = 16'hxxxx;   assign  wn_im[858]  = 16'hxxxx;   // 858  0.525  0.851
// assign  wn_re[859]  = 16'hxxxx;   assign  wn_im[859]  = 16'hxxxx;   // 859  0.530  0.848
// assign  wn_re[860]  = 16'hxxxx;   assign  wn_im[860]  = 16'hxxxx;   // 860  0.535  0.845
// assign  wn_re[861]  = 16'hxxxx;   assign  wn_im[861]  = 16'hxxxx;   // 861  0.540  0.842
// assign  wn_re[862]  = 16'hxxxx;   assign  wn_im[862]  = 16'hxxxx;   // 862  0.545  0.838
// assign  wn_re[863]  = 16'hxxxx;   assign  wn_im[863]  = 16'hxxxx;   // 863  0.550  0.835
// assign  wn_re[864]  = 16'hxxxx;   assign  wn_im[864]  = 16'hxxxx;   // 864  0.556  0.831
// assign  wn_re[865]  = 16'hxxxx;   assign  wn_im[865]  = 16'hxxxx;   // 865  0.561  0.828
// assign  wn_re[866]  = 16'hxxxx;   assign  wn_im[866]  = 16'hxxxx;   // 866  0.566  0.825
// assign  wn_re[867]  = 16'hxxxx;   assign  wn_im[867]  = 16'hxxxx;   // 867  0.571  0.821
// assign  wn_re[868]  = 16'hxxxx;   assign  wn_im[868]  = 16'hxxxx;   // 868  0.576  0.818
// assign  wn_re[869]  = 16'hxxxx;   assign  wn_im[869]  = 16'hxxxx;   // 869  0.581  0.814
// assign  wn_re[870]  = 16'hxxxx;   assign  wn_im[870]  = 16'hxxxx;   // 870  0.586  0.810
// assign  wn_re[871]  = 16'hxxxx;   assign  wn_im[871]  = 16'hxxxx;   // 871  0.591  0.807
// assign  wn_re[872]  = 16'hxxxx;   assign  wn_im[872]  = 16'hxxxx;   // 872  0.596  0.803
// assign  wn_re[873]  = 16'hxxxx;   assign  wn_im[873]  = 16'hxxxx;   // 873  0.601  0.800
// assign  wn_re[874]  = 16'hxxxx;   assign  wn_im[874]  = 16'hxxxx;   // 874  0.606  0.796
// assign  wn_re[875]  = 16'hxxxx;   assign  wn_im[875]  = 16'hxxxx;   // 875  0.610  0.792
// assign  wn_re[876]  = 16'hxxxx;   assign  wn_im[876]  = 16'hxxxx;   // 876  0.615  0.788
// assign  wn_re[877]  = 16'hxxxx;   assign  wn_im[877]  = 16'hxxxx;   // 877  0.620  0.785
// assign  wn_re[878]  = 16'hxxxx;   assign  wn_im[878]  = 16'hxxxx;   // 878  0.625  0.781
// assign  wn_re[879]  = 16'hxxxx;   assign  wn_im[879]  = 16'hxxxx;   // 879  0.630  0.777
// assign  wn_re[880]  = 16'hxxxx;   assign  wn_im[880]  = 16'hxxxx;   // 880  0.634  0.773
// assign  wn_re[881]  = 16'hxxxx;   assign  wn_im[881]  = 16'hxxxx;   // 881  0.639  0.769
// assign  wn_re[882]  = 16'hxxxx;   assign  wn_im[882]  = 16'hxxxx;   // 882  0.644  0.765
// assign  wn_re[883]  = 16'hxxxx;   assign  wn_im[883]  = 16'hxxxx;   // 883  0.649  0.761
// assign  wn_re[884]  = 16'hxxxx;   assign  wn_im[884]  = 16'hxxxx;   // 884  0.653  0.757
// assign  wn_re[885]  = 16'hxxxx;   assign  wn_im[885]  = 16'hxxxx;   // 885  0.658  0.753
// assign  wn_re[886]  = 16'hxxxx;   assign  wn_im[886]  = 16'hxxxx;   // 886  0.662  0.749
// assign  wn_re[887]  = 16'hxxxx;   assign  wn_im[887]  = 16'hxxxx;   // 887  0.667  0.745
// assign  wn_re[888]  = 16'hxxxx;   assign  wn_im[888]  = 16'hxxxx;   // 888  0.672  0.741
// assign  wn_re[889]  = 16'hxxxx;   assign  wn_im[889]  = 16'hxxxx;   // 889  0.676  0.737
// assign  wn_re[890]  = 16'hxxxx;   assign  wn_im[890]  = 16'hxxxx;   // 890  0.681  0.733
// assign  wn_re[891]  = 16'hxxxx;   assign  wn_im[891]  = 16'hxxxx;   // 891  0.685  0.728
// assign  wn_re[892]  = 16'hxxxx;   assign  wn_im[892]  = 16'hxxxx;   // 892  0.690  0.724
// assign  wn_re[893]  = 16'hxxxx;   assign  wn_im[893]  = 16'hxxxx;   // 893  0.694  0.720
// assign  wn_re[894]  = 16'hxxxx;   assign  wn_im[894]  = 16'hxxxx;   // 894  0.698  0.716
// assign  wn_re[895]  = 16'hxxxx;   assign  wn_im[895]  = 16'hxxxx;   // 895  0.703  0.711
// assign  wn_re[896]  = 16'hxxxx;   assign  wn_im[896]  = 16'hxxxx;   // 896  0.707  0.707
// assign  wn_re[897]  = 16'hxxxx;   assign  wn_im[897]  = 16'hxxxx;   // 897  0.711  0.703
// assign  wn_re[898]  = 16'hxxxx;   assign  wn_im[898]  = 16'hxxxx;   // 898  0.716  0.698
// assign  wn_re[899]  = 16'hxxxx;   assign  wn_im[899]  = 16'hxxxx;   // 899  0.720  0.694
// assign  wn_re[900]  = 16'hxxxx;   assign  wn_im[900]  = 16'hxxxx;   // 900  0.724  0.690
// assign  wn_re[901]  = 16'hxxxx;   assign  wn_im[901]  = 16'hxxxx;   // 901  0.728  0.685
// assign  wn_re[902]  = 16'hxxxx;   assign  wn_im[902]  = 16'hxxxx;   // 902  0.733  0.681
// assign  wn_re[903]  = 16'hxxxx;   assign  wn_im[903]  = 16'hxxxx;   // 903  0.737  0.676
// assign  wn_re[904]  = 16'hxxxx;   assign  wn_im[904]  = 16'hxxxx;   // 904  0.741  0.672
// assign  wn_re[905]  = 16'hxxxx;   assign  wn_im[905]  = 16'hxxxx;   // 905  0.745  0.667
// assign  wn_re[906]  = 16'hxxxx;   assign  wn_im[906]  = 16'hxxxx;   // 906  0.749  0.662
// assign  wn_re[907]  = 16'hxxxx;   assign  wn_im[907]  = 16'hxxxx;   // 907  0.753  0.658
// assign  wn_re[908]  = 16'hxxxx;   assign  wn_im[908]  = 16'hxxxx;   // 908  0.757  0.653
// assign  wn_re[909]  = 16'hxxxx;   assign  wn_im[909]  = 16'hxxxx;   // 909  0.761  0.649
// assign  wn_re[910]  = 16'hxxxx;   assign  wn_im[910]  = 16'hxxxx;   // 910  0.765  0.644
// assign  wn_re[911]  = 16'hxxxx;   assign  wn_im[911]  = 16'hxxxx;   // 911  0.769  0.639
// assign  wn_re[912]  = 16'hxxxx;   assign  wn_im[912]  = 16'hxxxx;   // 912  0.773  0.634
// assign  wn_re[913]  = 16'hxxxx;   assign  wn_im[913]  = 16'hxxxx;   // 913  0.777  0.630
// assign  wn_re[914]  = 16'hxxxx;   assign  wn_im[914]  = 16'hxxxx;   // 914  0.781  0.625
// assign  wn_re[915]  = 16'hxxxx;   assign  wn_im[915]  = 16'hxxxx;   // 915  0.785  0.620
// assign  wn_re[916]  = 16'hxxxx;   assign  wn_im[916]  = 16'hxxxx;   // 916  0.788  0.615
// assign  wn_re[917]  = 16'hxxxx;   assign  wn_im[917]  = 16'hxxxx;   // 917  0.792  0.610
// assign  wn_re[918]  = 16'hxxxx;   assign  wn_im[918]  = 16'hxxxx;   // 918  0.796  0.606
// assign  wn_re[919]  = 16'hxxxx;   assign  wn_im[919]  = 16'hxxxx;   // 919  0.800  0.601
// assign  wn_re[920]  = 16'hxxxx;   assign  wn_im[920]  = 16'hxxxx;   // 920  0.803  0.596
// assign  wn_re[921]  = 16'hxxxx;   assign  wn_im[921]  = 16'hxxxx;   // 921  0.807  0.591
// assign  wn_re[922]  = 16'hxxxx;   assign  wn_im[922]  = 16'hxxxx;   // 922  0.810  0.586
// assign  wn_re[923]  = 16'hxxxx;   assign  wn_im[923]  = 16'hxxxx;   // 923  0.814  0.581
// assign  wn_re[924]  = 16'hxxxx;   assign  wn_im[924]  = 16'hxxxx;   // 924  0.818  0.576
// assign  wn_re[925]  = 16'hxxxx;   assign  wn_im[925]  = 16'hxxxx;   // 925  0.821  0.571
// assign  wn_re[926]  = 16'hxxxx;   assign  wn_im[926]  = 16'hxxxx;   // 926  0.825  0.566
// assign  wn_re[927]  = 16'hxxxx;   assign  wn_im[927]  = 16'hxxxx;   // 927  0.828  0.561
// assign  wn_re[928]  = 16'hxxxx;   assign  wn_im[928]  = 16'hxxxx;   // 928  0.831  0.556
// assign  wn_re[929]  = 16'hxxxx;   assign  wn_im[929]  = 16'hxxxx;   // 929  0.835  0.550
// assign  wn_re[930]  = 16'hxxxx;   assign  wn_im[930]  = 16'hxxxx;   // 930  0.838  0.545
// assign  wn_re[931]  = 16'hxxxx;   assign  wn_im[931]  = 16'hxxxx;   // 931  0.842  0.540
// assign  wn_re[932]  = 16'hxxxx;   assign  wn_im[932]  = 16'hxxxx;   // 932  0.845  0.535
// assign  wn_re[933]  = 16'hxxxx;   assign  wn_im[933]  = 16'hxxxx;   // 933  0.848  0.530
// assign  wn_re[934]  = 16'hxxxx;   assign  wn_im[934]  = 16'hxxxx;   // 934  0.851  0.525
// assign  wn_re[935]  = 16'hxxxx;   assign  wn_im[935]  = 16'hxxxx;   // 935  0.855  0.519
// assign  wn_re[936]  = 16'hxxxx;   assign  wn_im[936]  = 16'hxxxx;   // 936  0.858  0.514
// assign  wn_re[937]  = 16'hxxxx;   assign  wn_im[937]  = 16'hxxxx;   // 937  0.861  0.509
// assign  wn_re[938]  = 16'hxxxx;   assign  wn_im[938]  = 16'hxxxx;   // 938  0.864  0.504
// assign  wn_re[939]  = 16'hxxxx;   assign  wn_im[939]  = 16'hxxxx;   // 939  0.867  0.498
// assign  wn_re[940]  = 16'hxxxx;   assign  wn_im[940]  = 16'hxxxx;   // 940  0.870  0.493
// assign  wn_re[941]  = 16'hxxxx;   assign  wn_im[941]  = 16'hxxxx;   // 941  0.873  0.488
// assign  wn_re[942]  = 16'hxxxx;   assign  wn_im[942]  = 16'hxxxx;   // 942  0.876  0.482
// assign  wn_re[943]  = 16'hxxxx;   assign  wn_im[943]  = 16'hxxxx;   // 943  0.879  0.477
// assign  wn_re[944]  = 16'hxxxx;   assign  wn_im[944]  = 16'hxxxx;   // 944  0.882  0.471
// assign  wn_re[945]  = 16'hxxxx;   assign  wn_im[945]  = 16'hxxxx;   // 945  0.885  0.466
// assign  wn_re[946]  = 16'hxxxx;   assign  wn_im[946]  = 16'hxxxx;   // 946  0.888  0.461
// assign  wn_re[947]  = 16'hxxxx;   assign  wn_im[947]  = 16'hxxxx;   // 947  0.890  0.455
// assign  wn_re[948]  = 16'hxxxx;   assign  wn_im[948]  = 16'hxxxx;   // 948  0.893  0.450
// assign  wn_re[949]  = 16'hxxxx;   assign  wn_im[949]  = 16'hxxxx;   // 949  0.896  0.444
// assign  wn_re[950]  = 16'hxxxx;   assign  wn_im[950]  = 16'hxxxx;   // 950  0.899  0.439
// assign  wn_re[951]  = 16'hxxxx;   assign  wn_im[951]  = 16'hxxxx;   // 951  0.901  0.433
// assign  wn_re[952]  = 16'hxxxx;   assign  wn_im[952]  = 16'hxxxx;   // 952  0.904  0.428
// assign  wn_re[953]  = 16'hxxxx;   assign  wn_im[953]  = 16'hxxxx;   // 953  0.907  0.422
// assign  wn_re[954]  = 16'hxxxx;   assign  wn_im[954]  = 16'hxxxx;   // 954  0.909  0.416
// assign  wn_re[955]  = 16'hxxxx;   assign  wn_im[955]  = 16'hxxxx;   // 955  0.912  0.411
// assign  wn_re[956]  = 16'hxxxx;   assign  wn_im[956]  = 16'hxxxx;   // 956  0.914  0.405
// assign  wn_re[957]  = 16'hxxxx;   assign  wn_im[957]  = 16'hxxxx;   // 957  0.917  0.400
// assign  wn_re[958]  = 16'hxxxx;   assign  wn_im[958]  = 16'hxxxx;   // 958  0.919  0.394
// assign  wn_re[959]  = 16'hxxxx;   assign  wn_im[959]  = 16'hxxxx;   // 959  0.922  0.388
// assign  wn_re[960]  = 16'hxxxx;   assign  wn_im[960]  = 16'hxxxx;   // 960  0.924  0.383
// assign  wn_re[961]  = 16'hxxxx;   assign  wn_im[961]  = 16'hxxxx;   // 961  0.926  0.377
// assign  wn_re[962]  = 16'hxxxx;   assign  wn_im[962]  = 16'hxxxx;   // 962  0.929  0.371
// assign  wn_re[963]  = 16'hxxxx;   assign  wn_im[963]  = 16'hxxxx;   // 963  0.931  0.366
// assign  wn_re[964]  = 16'hxxxx;   assign  wn_im[964]  = 16'hxxxx;   // 964  0.933  0.360
// assign  wn_re[965]  = 16'hxxxx;   assign  wn_im[965]  = 16'hxxxx;   // 965  0.935  0.354
// assign  wn_re[966]  = 16'hxxxx;   assign  wn_im[966]  = 16'hxxxx;   // 966  0.937  0.348
// assign  wn_re[967]  = 16'hxxxx;   assign  wn_im[967]  = 16'hxxxx;   // 967  0.939  0.343
// assign  wn_re[968]  = 16'hxxxx;   assign  wn_im[968]  = 16'hxxxx;   // 968  0.942  0.337
// assign  wn_re[969]  = 16'hxxxx;   assign  wn_im[969]  = 16'hxxxx;   // 969  0.944  0.331
// assign  wn_re[970]  = 16'hxxxx;   assign  wn_im[970]  = 16'hxxxx;   // 970  0.946  0.325
// assign  wn_re[971]  = 16'hxxxx;   assign  wn_im[971]  = 16'hxxxx;   // 971  0.948  0.320
// assign  wn_re[972]  = 16'hxxxx;   assign  wn_im[972]  = 16'hxxxx;   // 972  0.950  0.314
// assign  wn_re[973]  = 16'hxxxx;   assign  wn_im[973]  = 16'hxxxx;   // 973  0.951  0.308
// assign  wn_re[974]  = 16'hxxxx;   assign  wn_im[974]  = 16'hxxxx;   // 974  0.953  0.302
// assign  wn_re[975]  = 16'hxxxx;   assign  wn_im[975]  = 16'hxxxx;   // 975  0.955  0.296
// assign  wn_re[976]  = 16'hxxxx;   assign  wn_im[976]  = 16'hxxxx;   // 976  0.957  0.290
// assign  wn_re[977]  = 16'hxxxx;   assign  wn_im[977]  = 16'hxxxx;   // 977  0.959  0.284
// assign  wn_re[978]  = 16'hxxxx;   assign  wn_im[978]  = 16'hxxxx;   // 978  0.960  0.279
// assign  wn_re[979]  = 16'hxxxx;   assign  wn_im[979]  = 16'hxxxx;   // 979  0.962  0.273
// assign  wn_re[980]  = 16'hxxxx;   assign  wn_im[980]  = 16'hxxxx;   // 980  0.964  0.267
// assign  wn_re[981]  = 16'hxxxx;   assign  wn_im[981]  = 16'hxxxx;   // 981  0.965  0.261
// assign  wn_re[982]  = 16'hxxxx;   assign  wn_im[982]  = 16'hxxxx;   // 982  0.967  0.255
// assign  wn_re[983]  = 16'hxxxx;   assign  wn_im[983]  = 16'hxxxx;   // 983  0.969  0.249
// assign  wn_re[984]  = 16'hxxxx;   assign  wn_im[984]  = 16'hxxxx;   // 984  0.970  0.243
// assign  wn_re[985]  = 16'hxxxx;   assign  wn_im[985]  = 16'hxxxx;   // 985  0.972  0.237
// assign  wn_re[986]  = 16'hxxxx;   assign  wn_im[986]  = 16'hxxxx;   // 986  0.973  0.231
// assign  wn_re[987]  = 16'hxxxx;   assign  wn_im[987]  = 16'hxxxx;   // 987  0.974  0.225
// assign  wn_re[988]  = 16'hxxxx;   assign  wn_im[988]  = 16'hxxxx;   // 988  0.976  0.219
// assign  wn_re[989]  = 16'hxxxx;   assign  wn_im[989]  = 16'hxxxx;   // 989  0.977  0.213
// assign  wn_re[990]  = 16'hxxxx;   assign  wn_im[990]  = 16'hxxxx;   // 990  0.978  0.207
// assign  wn_re[991]  = 16'hxxxx;   assign  wn_im[991]  = 16'hxxxx;   // 991  0.980  0.201
// assign  wn_re[992]  = 16'hxxxx;   assign  wn_im[992]  = 16'hxxxx;   // 992  0.981  0.195
// assign  wn_re[993]  = 16'hxxxx;   assign  wn_im[993]  = 16'hxxxx;   // 993  0.982  0.189
// assign  wn_re[994]  = 16'hxxxx;   assign  wn_im[994]  = 16'hxxxx;   // 994  0.983  0.183
// assign  wn_re[995]  = 16'hxxxx;   assign  wn_im[995]  = 16'hxxxx;   // 995  0.984  0.177
// assign  wn_re[996]  = 16'hxxxx;   assign  wn_im[996]  = 16'hxxxx;   // 996  0.985  0.171
// assign  wn_re[997]  = 16'hxxxx;   assign  wn_im[997]  = 16'hxxxx;   // 997  0.986  0.165
// assign  wn_re[998]  = 16'hxxxx;   assign  wn_im[998]  = 16'hxxxx;   // 998  0.987  0.159
// assign  wn_re[999]  = 16'hxxxx;   assign  wn_im[999]  = 16'hxxxx;   // 999  0.988  0.153
// assign  wn_re[1000] = 16'hxxxx;   assign  wn_im[1000] = 16'hxxxx;   // 1000  0.989  0.147
// assign  wn_re[1001] = 16'hxxxx;   assign  wn_im[1001] = 16'hxxxx;   // 1001  0.990  0.141
// assign  wn_re[1002] = 16'hxxxx;   assign  wn_im[1002] = 16'hxxxx;   // 1002  0.991  0.135
// assign  wn_re[1003] = 16'hxxxx;   assign  wn_im[1003] = 16'hxxxx;   // 1003  0.992  0.128
// assign  wn_re[1004] = 16'hxxxx;   assign  wn_im[1004] = 16'hxxxx;   // 1004  0.992  0.122
// assign  wn_re[1005] = 16'hxxxx;   assign  wn_im[1005] = 16'hxxxx;   // 1005  0.993  0.116
// assign  wn_re[1006] = 16'hxxxx;   assign  wn_im[1006] = 16'hxxxx;   // 1006  0.994  0.110
// assign  wn_re[1007] = 16'hxxxx;   assign  wn_im[1007] = 16'hxxxx;   // 1007  0.995  0.104
// assign  wn_re[1008] = 16'hxxxx;   assign  wn_im[1008] = 16'hxxxx;   // 1008  0.995  0.098
// assign  wn_re[1009] = 16'hxxxx;   assign  wn_im[1009] = 16'hxxxx;   // 1009  0.996  0.092
// assign  wn_re[1010] = 16'hxxxx;   assign  wn_im[1010] = 16'hxxxx;   // 1010  0.996  0.086
// assign  wn_re[1011] = 16'hxxxx;   assign  wn_im[1011] = 16'hxxxx;   // 1011  0.997  0.080
// assign  wn_re[1012] = 16'hxxxx;   assign  wn_im[1012] = 16'hxxxx;   // 1012  0.997  0.074
// assign  wn_re[1013] = 16'hxxxx;   assign  wn_im[1013] = 16'hxxxx;   // 1013  0.998  0.067
// assign  wn_re[1014] = 16'hxxxx;   assign  wn_im[1014] = 16'hxxxx;   // 1014  0.998  0.061
// assign  wn_re[1015] = 16'hxxxx;   assign  wn_im[1015] = 16'hxxxx;   // 1015  0.998  0.055
// assign  wn_re[1016] = 16'hxxxx;   assign  wn_im[1016] = 16'hxxxx;   // 1016  0.999  0.049
// assign  wn_re[1017] = 16'hxxxx;   assign  wn_im[1017] = 16'hxxxx;   // 1017  0.999  0.043
// assign  wn_re[1018] = 16'hxxxx;   assign  wn_im[1018] = 16'hxxxx;   // 1018  0.999  0.037
// assign  wn_re[1019] = 16'hxxxx;   assign  wn_im[1019] = 16'hxxxx;   // 1019  1.000  0.031
// assign  wn_re[1020] = 16'hxxxx;   assign  wn_im[1020] = 16'hxxxx;   // 1020  1.000  0.025
// assign  wn_re[1021] = 16'hxxxx;   assign  wn_im[1021] = 16'hxxxx;   // 1021  1.000  0.018
// assign  wn_re[1022] = 16'hxxxx;   assign  wn_im[1022] = 16'hxxxx;   // 1022  1.000  0.012
// assign  wn_re[1023] = 16'hxxxx;   assign  wn_im[1023] = 16'hxxxx;   // 1023  1.000  0.006

assign wn_re[0] =16'h0000 ; assign wn_im[0] =16'h0000 ; 
assign wn_re[1] =16'h7FF6 ; assign wn_im[1] =16'hFCDC ; 
assign wn_re[2] =16'h7FD9 ; assign wn_im[2] =16'hF9B8 ; 
assign wn_re[3] =16'h7FA7 ; assign wn_im[3] =16'hF695 ; 
assign wn_re[4] =16'h7F62 ; assign wn_im[4] =16'hF374 ; 
assign wn_re[5] =16'h7F0A ; assign wn_im[5] =16'hF055 ; 
assign wn_re[6] =16'h7E9D ; assign wn_im[6] =16'hED38 ; 
assign wn_re[7] =16'h7E1E ; assign wn_im[7] =16'hEA1E ; 
assign wn_re[8] =16'h7D8A ; assign wn_im[8] =16'hE707 ; 
assign wn_re[9] =16'h7CE4 ; assign wn_im[9] =16'hE3F4 ; 
assign wn_re[10] =16'h7C2A ; assign wn_im[10] =16'hE0E6 ; 
assign wn_re[11] =16'h7B5D ; assign wn_im[11] =16'hDDDC ; 
assign wn_re[12] =16'h7A7D ; assign wn_im[12] =16'hDAD8 ; 
assign wn_re[13] =16'h798A ; assign wn_im[13] =16'hD7D9 ; 
assign wn_re[14] =16'h7885 ; assign wn_im[14] =16'hD4E1 ; 
assign wn_re[15] =16'h776C ; assign wn_im[15] =16'hD1EF ; 
assign wn_re[16] =16'h7642 ; assign wn_im[16] =16'hCF04 ; 
assign wn_re[17] =16'h7505 ; assign wn_im[17] =16'hCC21 ; 
assign wn_re[18] =16'h73B6 ; assign wn_im[18] =16'hC946 ; 
assign wn_re[19] =16'h7255 ; assign wn_im[19] =16'hC673 ; 
assign wn_re[20] =16'h70E3 ; assign wn_im[20] =16'hC3A9 ; 
assign wn_re[21] =16'h6F5F ; assign wn_im[21] =16'hC0E9 ; 
assign wn_re[22] =16'h6DCA ; assign wn_im[22] =16'hBE32 ; 
assign wn_re[23] =16'h6C24 ; assign wn_im[23] =16'hBB85 ; 
assign wn_re[24] =16'h6A6E ; assign wn_im[24] =16'hB8E3 ; 
assign wn_re[25] =16'h68A7 ; assign wn_im[25] =16'hB64C ; 
assign wn_re[26] =16'h66D0 ; assign wn_im[26] =16'hB3C0 ; 
assign wn_re[27] =16'h64E9 ; assign wn_im[27] =16'hB140 ; 
assign wn_re[28] =16'h62F2 ; assign wn_im[28] =16'hAECC ; 
assign wn_re[29] =16'h60EC ; assign wn_im[29] =16'hAC65 ; 
assign wn_re[30] =16'h5ED7 ; assign wn_im[30] =16'hAA0A ; 
assign wn_re[31] =16'h5CB4 ; assign wn_im[31] =16'hA7BD ; 
assign wn_re[32] =16'h5A82 ; assign wn_im[32] =16'hA57E ; 
assign wn_re[33] =16'h5843 ; assign wn_im[33] =16'hA34C ; 
assign wn_re[34] =16'h55F6 ; assign wn_im[34] =16'hA129 ; 
assign wn_re[35] =16'h539B ; assign wn_im[35] =16'h9F14 ; 
assign wn_re[36] =16'h5134 ; assign wn_im[36] =16'h9D0E ; 
assign wn_re[37] =16'h4EC0 ; assign wn_im[37] =16'h9B17 ; 
assign wn_re[38] =16'h4C40 ; assign wn_im[38] =16'h9930 ; 
assign wn_re[39] =16'h49B4 ; assign wn_im[39] =16'h9759 ; 
assign wn_re[40] =16'h471D ; assign wn_im[40] =16'h9592 ; 
assign wn_re[41] =16'h447B ; assign wn_im[41] =16'h93DC ; 
assign wn_re[42] =16'h41CE ; assign wn_im[42] =16'h9236 ; 
assign wn_re[43] =16'h3F17 ; assign wn_im[43] =16'h90A1 ; 
assign wn_re[44] =16'h3C57 ; assign wn_im[44] =16'h8F1D ; 
assign wn_re[45] =16'h398D ; assign wn_im[45] =16'h8DAB ; 
assign wn_re[46] =16'h36BA ; assign wn_im[46] =16'h8C4A ; 
assign wn_re[47] =16'h33DF ; assign wn_im[47] =16'h8AFB ; 
assign wn_re[48] =16'h30FC ; assign wn_im[48] =16'h89BE ; 
assign wn_re[49] =16'h2E11 ; assign wn_im[49] =16'h8894 ; 
assign wn_re[50] =16'h2B1F ; assign wn_im[50] =16'h877B ; 
assign wn_re[51] =16'h2827 ; assign wn_im[51] =16'h8676 ; 
assign wn_re[52] =16'h2528 ; assign wn_im[52] =16'h8583 ; 
assign wn_re[53] =16'h2224 ; assign wn_im[53] =16'h84A3 ; 
assign wn_re[54] =16'h1F1A ; assign wn_im[54] =16'h83D6 ; 
assign wn_re[55] =16'h1C0C ; assign wn_im[55] =16'h831C ; 
assign wn_re[56] =16'h18F9 ; assign wn_im[56] =16'h8276 ; 
assign wn_re[57] =16'h15E2 ; assign wn_im[57] =16'h81E2 ; 
assign wn_re[58] =16'h12C8 ; assign wn_im[58] =16'h8163 ; 
assign wn_re[59] =16'h0FAB ; assign wn_im[59] =16'h80F6 ; 
assign wn_re[60] =16'h0C8C ; assign wn_im[60] =16'h809E ; 
assign wn_re[61] =16'h096B ; assign wn_im[61] =16'h8059 ; 
assign wn_re[62] =16'h0648 ; assign wn_im[62] =16'h8027 ; 
assign wn_re[63] =16'h0324 ; assign wn_im[63] =16'h800A ; 
assign wn_re[64] =16'h0000 ; assign wn_im[64] =16'h8000 ; 
assign wn_re[65] =16'hFCDC ; assign wn_im[65] =16'h800A ; 
assign wn_re[66] =16'hF9B8 ; assign wn_im[66] =16'h8027 ; 
assign wn_re[67] =16'hF695 ; assign wn_im[67] =16'h8059 ; 
assign wn_re[68] =16'hF374 ; assign wn_im[68] =16'h809E ; 
assign wn_re[69] =16'hF055 ; assign wn_im[69] =16'h80F6 ; 
assign wn_re[70] =16'hED38 ; assign wn_im[70] =16'h8163 ; 
assign wn_re[71] =16'hEA1E ; assign wn_im[71] =16'h81E2 ; 
assign wn_re[72] =16'hE707 ; assign wn_im[72] =16'h8276 ; 
assign wn_re[73] =16'hE3F4 ; assign wn_im[73] =16'h831C ; 
assign wn_re[74] =16'hE0E6 ; assign wn_im[74] =16'h83D6 ; 
assign wn_re[75] =16'hDDDC ; assign wn_im[75] =16'h84A3 ; 
assign wn_re[76] =16'hDAD8 ; assign wn_im[76] =16'h8583 ; 
assign wn_re[77] =16'hD7D9 ; assign wn_im[77] =16'h8676 ; 
assign wn_re[78] =16'hD4E1 ; assign wn_im[78] =16'h877B ; 
assign wn_re[79] =16'hD1EF ; assign wn_im[79] =16'h8894 ; 
assign wn_re[80] =16'hCF04 ; assign wn_im[80] =16'h89BE ; 
assign wn_re[81] =16'hCC21 ; assign wn_im[81] =16'h8AFB ; 
assign wn_re[82] =16'hC946 ; assign wn_im[82] =16'h8C4A ; 
assign wn_re[83] =16'hC673 ; assign wn_im[83] =16'h8DAB ; 
assign wn_re[84] =16'hC3A9 ; assign wn_im[84] =16'h8F1D ; 
assign wn_re[85] =16'hC0E9 ; assign wn_im[85] =16'h90A1 ; 
assign wn_re[86] =16'hBE32 ; assign wn_im[86] =16'h9236 ; 
assign wn_re[87] =16'hBB85 ; assign wn_im[87] =16'h93DC ; 
assign wn_re[88] =16'hB8E3 ; assign wn_im[88] =16'h9592 ; 
assign wn_re[89] =16'hB64C ; assign wn_im[89] =16'h9759 ; 
assign wn_re[90] =16'hB3C0 ; assign wn_im[90] =16'h9930 ; 
assign wn_re[91] =16'hB140 ; assign wn_im[91] =16'h9B17 ; 
assign wn_re[92] =16'hAECC ; assign wn_im[92] =16'h9D0E ; 
assign wn_re[93] =16'hAC65 ; assign wn_im[93] =16'h9F14 ; 
assign wn_re[94] =16'hAA0A ; assign wn_im[94] =16'hA129 ; 
assign wn_re[95] =16'hA7BD ; assign wn_im[95] =16'hA34C ; 
assign wn_re[96] =16'hA57E ; assign wn_im[96] =16'hA57E ; 
assign wn_re[97] =16'hA34C ; assign wn_im[97] =16'hA7BD ; 
assign wn_re[98] =16'hA129 ; assign wn_im[98] =16'hAA0A ; 
assign wn_re[99] =16'h9F14 ; assign wn_im[99] =16'hAC65 ; 
assign wn_re[100] =16'h9D0E ; assign wn_im[100] =16'hAECC ; 
assign wn_re[101] =16'h9B17 ; assign wn_im[101] =16'hB140 ; 
assign wn_re[102] =16'h9930 ; assign wn_im[102] =16'hB3C0 ; 
assign wn_re[103] =16'h9759 ; assign wn_im[103] =16'hB64C ; 
assign wn_re[104] =16'h9592 ; assign wn_im[104] =16'hB8E3 ; 
assign wn_re[105] =16'h93DC ; assign wn_im[105] =16'hBB85 ; 
assign wn_re[106] =16'h9236 ; assign wn_im[106] =16'hBE32 ; 
assign wn_re[107] =16'h90A1 ; assign wn_im[107] =16'hC0E9 ; 
assign wn_re[108] =16'h8F1D ; assign wn_im[108] =16'hC3A9 ; 
assign wn_re[109] =16'h8DAB ; assign wn_im[109] =16'hC673 ; 
assign wn_re[110] =16'h8C4A ; assign wn_im[110] =16'hC946 ; 
assign wn_re[111] =16'h8AFB ; assign wn_im[111] =16'hCC21 ; 
assign wn_re[112] =16'h89BE ; assign wn_im[112] =16'hCF04 ; 
assign wn_re[113] =16'h8894 ; assign wn_im[113] =16'hD1EF ; 
assign wn_re[114] =16'h877B ; assign wn_im[114] =16'hD4E1 ; 
assign wn_re[115] =16'h8676 ; assign wn_im[115] =16'hD7D9 ; 
assign wn_re[116] =16'h8583 ; assign wn_im[116] =16'hDAD8 ; 
assign wn_re[117] =16'h84A3 ; assign wn_im[117] =16'hDDDC ; 
assign wn_re[118] =16'h83D6 ; assign wn_im[118] =16'hE0E6 ; 
assign wn_re[119] =16'h831C ; assign wn_im[119] =16'hE3F4 ; 
assign wn_re[120] =16'h8276 ; assign wn_im[120] =16'hE707 ; 
assign wn_re[121] =16'h81E2 ; assign wn_im[121] =16'hEA1E ; 
assign wn_re[122] =16'h8163 ; assign wn_im[122] =16'hED38 ; 
assign wn_re[123] =16'h80F6 ; assign wn_im[123] =16'hF055 ; 
assign wn_re[124] =16'h809E ; assign wn_im[124] =16'hF374 ; 
assign wn_re[125] =16'h8059 ; assign wn_im[125] =16'hF695 ; 
assign wn_re[126] =16'h8027 ; assign wn_im[126] =16'hF9B8 ; 
assign wn_re[127] =16'h800A ; assign wn_im[127] =16'hFCDC ; 
assign wn_re[128] =16'h8000 ; assign wn_im[128] =16'h0000 ; 
assign wn_re[129] =16'h800A ; assign wn_im[129] =16'h0324 ; 
assign wn_re[130] =16'h8027 ; assign wn_im[130] =16'h0648 ; 
assign wn_re[131] =16'h8059 ; assign wn_im[131] =16'h096B ; 
assign wn_re[132] =16'h809E ; assign wn_im[132] =16'h0C8C ; 
assign wn_re[133] =16'h80F6 ; assign wn_im[133] =16'h0FAB ; 
assign wn_re[134] =16'h8163 ; assign wn_im[134] =16'h12C8 ; 
assign wn_re[135] =16'h81E2 ; assign wn_im[135] =16'h15E2 ; 
assign wn_re[136] =16'h8276 ; assign wn_im[136] =16'h18F9 ; 
assign wn_re[137] =16'h831C ; assign wn_im[137] =16'h1C0C ; 
assign wn_re[138] =16'h83D6 ; assign wn_im[138] =16'h1F1A ; 
assign wn_re[139] =16'h84A3 ; assign wn_im[139] =16'h2224 ; 
assign wn_re[140] =16'h8583 ; assign wn_im[140] =16'h2528 ; 
assign wn_re[141] =16'h8676 ; assign wn_im[141] =16'h2827 ; 
assign wn_re[142] =16'h877B ; assign wn_im[142] =16'h2B1F ; 
assign wn_re[143] =16'h8894 ; assign wn_im[143] =16'h2E11 ; 
assign wn_re[144] =16'h89BE ; assign wn_im[144] =16'h30FC ; 
assign wn_re[145] =16'h8AFB ; assign wn_im[145] =16'h33DF ; 
assign wn_re[146] =16'h8C4A ; assign wn_im[146] =16'h36BA ; 
assign wn_re[147] =16'h8DAB ; assign wn_im[147] =16'h398D ; 
assign wn_re[148] =16'h8F1D ; assign wn_im[148] =16'h3C57 ; 
assign wn_re[149] =16'h90A1 ; assign wn_im[149] =16'h3F17 ; 
assign wn_re[150] =16'h9236 ; assign wn_im[150] =16'h41CE ; 
assign wn_re[151] =16'h93DC ; assign wn_im[151] =16'h447B ; 
assign wn_re[152] =16'h9592 ; assign wn_im[152] =16'h471D ; 
assign wn_re[153] =16'h9759 ; assign wn_im[153] =16'h49B4 ; 
assign wn_re[154] =16'h9930 ; assign wn_im[154] =16'h4C40 ; 
assign wn_re[155] =16'h9B17 ; assign wn_im[155] =16'h4EC0 ; 
assign wn_re[156] =16'h9D0E ; assign wn_im[156] =16'h5134 ; 
assign wn_re[157] =16'h9F14 ; assign wn_im[157] =16'h539B ; 
assign wn_re[158] =16'hA129 ; assign wn_im[158] =16'h55F6 ; 
assign wn_re[159] =16'hA34C ; assign wn_im[159] =16'h5843 ; 
assign wn_re[160] =16'hA57E ; assign wn_im[160] =16'h5A82 ; 
assign wn_re[161] =16'hA7BD ; assign wn_im[161] =16'h5CB4 ; 
assign wn_re[162] =16'hAA0A ; assign wn_im[162] =16'h5ED7 ; 
assign wn_re[163] =16'hAC65 ; assign wn_im[163] =16'h60EC ; 
assign wn_re[164] =16'hAECC ; assign wn_im[164] =16'h62F2 ; 
assign wn_re[165] =16'hB140 ; assign wn_im[165] =16'h64E9 ; 
assign wn_re[166] =16'hB3C0 ; assign wn_im[166] =16'h66D0 ; 
assign wn_re[167] =16'hB64C ; assign wn_im[167] =16'h68A7 ; 
assign wn_re[168] =16'hB8E3 ; assign wn_im[168] =16'h6A6E ; 
assign wn_re[169] =16'hBB85 ; assign wn_im[169] =16'h6C24 ; 
assign wn_re[170] =16'hBE32 ; assign wn_im[170] =16'h6DCA ; 
assign wn_re[171] =16'hC0E9 ; assign wn_im[171] =16'h6F5F ; 
assign wn_re[172] =16'hC3A9 ; assign wn_im[172] =16'h70E3 ; 
assign wn_re[173] =16'hC673 ; assign wn_im[173] =16'h7255 ; 
assign wn_re[174] =16'hC946 ; assign wn_im[174] =16'h73B6 ; 
assign wn_re[175] =16'hCC21 ; assign wn_im[175] =16'h7505 ; 
assign wn_re[176] =16'hCF04 ; assign wn_im[176] =16'h7642 ; 
assign wn_re[177] =16'hD1EF ; assign wn_im[177] =16'h776C ; 
assign wn_re[178] =16'hD4E1 ; assign wn_im[178] =16'h7885 ; 
assign wn_re[179] =16'hD7D9 ; assign wn_im[179] =16'h798A ; 
assign wn_re[180] =16'hDAD8 ; assign wn_im[180] =16'h7A7D ; 
assign wn_re[181] =16'hDDDC ; assign wn_im[181] =16'h7B5D ; 
assign wn_re[182] =16'hE0E6 ; assign wn_im[182] =16'h7C2A ; 
assign wn_re[183] =16'hE3F4 ; assign wn_im[183] =16'h7CE4 ; 
assign wn_re[184] =16'hE707 ; assign wn_im[184] =16'h7D8A ; 
assign wn_re[185] =16'hEA1E ; assign wn_im[185] =16'h7E1E ; 
assign wn_re[186] =16'hED38 ; assign wn_im[186] =16'h7E9D ; 
assign wn_re[187] =16'hF055 ; assign wn_im[187] =16'h7F0A ; 
assign wn_re[188] =16'hF374 ; assign wn_im[188] =16'h7F62 ; 
assign wn_re[189] =16'hF695 ; assign wn_im[189] =16'h7FA7 ; 
assign wn_re[190] =16'hF9B8 ; assign wn_im[190] =16'h7FD9 ; 
assign wn_re[191] =16'hFCDC ; assign wn_im[191] =16'h7FF6 ; 
assign wn_re[192] =16'h0000 ; assign wn_im[192] =16'h7FFF ; 
assign wn_re[193] =16'h0324 ; assign wn_im[193] =16'h7FF6 ; 
assign wn_re[194] =16'h0648 ; assign wn_im[194] =16'h7FD9 ; 
assign wn_re[195] =16'h096B ; assign wn_im[195] =16'h7FA7 ; 
assign wn_re[196] =16'h0C8C ; assign wn_im[196] =16'h7F62 ; 
assign wn_re[197] =16'h0FAB ; assign wn_im[197] =16'h7F0A ; 
assign wn_re[198] =16'h12C8 ; assign wn_im[198] =16'h7E9D ; 
assign wn_re[199] =16'h15E2 ; assign wn_im[199] =16'h7E1E ; 
assign wn_re[200] =16'h18F9 ; assign wn_im[200] =16'h7D8A ; 
assign wn_re[201] =16'h1C0C ; assign wn_im[201] =16'h7CE4 ; 
assign wn_re[202] =16'h1F1A ; assign wn_im[202] =16'h7C2A ; 
assign wn_re[203] =16'h2224 ; assign wn_im[203] =16'h7B5D ; 
assign wn_re[204] =16'h2528 ; assign wn_im[204] =16'h7A7D ; 
assign wn_re[205] =16'h2827 ; assign wn_im[205] =16'h798A ; 
assign wn_re[206] =16'h2B1F ; assign wn_im[206] =16'h7885 ; 
assign wn_re[207] =16'h2E11 ; assign wn_im[207] =16'h776C ; 
assign wn_re[208] =16'h30FC ; assign wn_im[208] =16'h7642 ; 
assign wn_re[209] =16'h33DF ; assign wn_im[209] =16'h7505 ; 
assign wn_re[210] =16'h36BA ; assign wn_im[210] =16'h73B6 ; 
assign wn_re[211] =16'h398D ; assign wn_im[211] =16'h7255 ; 
assign wn_re[212] =16'h3C57 ; assign wn_im[212] =16'h70E3 ; 
assign wn_re[213] =16'h3F17 ; assign wn_im[213] =16'h6F5F ; 
assign wn_re[214] =16'h41CE ; assign wn_im[214] =16'h6DCA ; 
assign wn_re[215] =16'h447B ; assign wn_im[215] =16'h6C24 ; 
assign wn_re[216] =16'h471D ; assign wn_im[216] =16'h6A6E ; 
assign wn_re[217] =16'h49B4 ; assign wn_im[217] =16'h68A7 ; 
assign wn_re[218] =16'h4C40 ; assign wn_im[218] =16'h66D0 ; 
assign wn_re[219] =16'h4EC0 ; assign wn_im[219] =16'h64E9 ; 
assign wn_re[220] =16'h5134 ; assign wn_im[220] =16'h62F2 ; 
assign wn_re[221] =16'h539B ; assign wn_im[221] =16'h60EC ; 
assign wn_re[222] =16'h55F6 ; assign wn_im[222] =16'h5ED7 ; 
assign wn_re[223] =16'h5843 ; assign wn_im[223] =16'h5CB4 ; 
assign wn_re[224] =16'h5A82 ; assign wn_im[224] =16'h5A82 ; 
assign wn_re[225] =16'h5CB4 ; assign wn_im[225] =16'h5843 ; 
assign wn_re[226] =16'h5ED7 ; assign wn_im[226] =16'h55F6 ; 
assign wn_re[227] =16'h60EC ; assign wn_im[227] =16'h539B ; 
assign wn_re[228] =16'h62F2 ; assign wn_im[228] =16'h5134 ; 
assign wn_re[229] =16'h64E9 ; assign wn_im[229] =16'h4EC0 ; 
assign wn_re[230] =16'h66D0 ; assign wn_im[230] =16'h4C40 ; 
assign wn_re[231] =16'h68A7 ; assign wn_im[231] =16'h49B4 ; 
assign wn_re[232] =16'h6A6E ; assign wn_im[232] =16'h471D ; 
assign wn_re[233] =16'h6C24 ; assign wn_im[233] =16'h447B ; 
assign wn_re[234] =16'h6DCA ; assign wn_im[234] =16'h41CE ; 
assign wn_re[235] =16'h6F5F ; assign wn_im[235] =16'h3F17 ; 
assign wn_re[236] =16'h70E3 ; assign wn_im[236] =16'h3C57 ; 
assign wn_re[237] =16'h7255 ; assign wn_im[237] =16'h398D ; 
assign wn_re[238] =16'h73B6 ; assign wn_im[238] =16'h36BA ; 
assign wn_re[239] =16'h7505 ; assign wn_im[239] =16'h33DF ; 
assign wn_re[240] =16'h7642 ; assign wn_im[240] =16'h30FC ; 
assign wn_re[241] =16'h776C ; assign wn_im[241] =16'h2E11 ; 
assign wn_re[242] =16'h7885 ; assign wn_im[242] =16'h2B1F ; 
assign wn_re[243] =16'h798A ; assign wn_im[243] =16'h2827 ; 
assign wn_re[244] =16'h7A7D ; assign wn_im[244] =16'h2528 ; 
assign wn_re[245] =16'h7B5D ; assign wn_im[245] =16'h2224 ; 
assign wn_re[246] =16'h7C2A ; assign wn_im[246] =16'h1F1A ; 
assign wn_re[247] =16'h7CE4 ; assign wn_im[247] =16'h1C0C ; 
assign wn_re[248] =16'h7D8A ; assign wn_im[248] =16'h18F9 ; 
assign wn_re[249] =16'h7E1E ; assign wn_im[249] =16'h15E2 ; 
assign wn_re[250] =16'h7E9D ; assign wn_im[250] =16'h12C8 ; 
assign wn_re[251] =16'h7F0A ; assign wn_im[251] =16'h0FAB ; 
assign wn_re[252] =16'h7F62 ; assign wn_im[252] =16'h0C8C ; 
assign wn_re[253] =16'h7FA7 ; assign wn_im[253] =16'h096B ; 
assign wn_re[254] =16'h7FD9 ; assign wn_im[254] =16'h0648 ; 
assign wn_re[255] =16'h7FF6 ; assign wn_im[255] =16'h0324 ; 


endmodule
