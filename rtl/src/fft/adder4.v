module adder4
(
input    wire          cin ,//来自低位的进位输入
input    wire [3:0]    p   ,//p=a|b 进位传递因子
input    wire [3:0]    g   ,//g=a&b 进位生成因子
output   wire          G   ,//下一级的进位生成因子
output   wire          P   ,//下一级的进位传递因子
output   wire [2:0]    cout //每个bit对应的进位输出
);

assign P=&p;
assign G=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);
assign cout[0]=g[0]|(p[0]&cin);
assign cout[1]=g[1]|(p[1]&g[0])|(p[1]&p[0]&cin);
assign cout[2]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin);
endmodule