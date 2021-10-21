module TestBenchFourBitRippleCarryAdder;
   reg [3:0] a,b;
   wire [4:0] S;
   FourBitRippleCarryAdder fbrca(a,b,1'b0,S);
   initial begin
     a = 4'b0000;
     b = 4'b0000;
   end
   always
     #160 a <= a + 1;
   always
     #10 b <= b + 1;
endmodule