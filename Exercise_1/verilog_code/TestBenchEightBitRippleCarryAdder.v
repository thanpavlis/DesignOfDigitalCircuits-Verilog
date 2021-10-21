module TestBenchEightBitRippleCarryAdder;
   reg [7:0] a,b;
   wire [8:0] S;
   EightBitRippleCarryAdder ebrca(a,b,1'b0,S);
   initial begin
     a = 8'b00000000;
     b = 8'b00001111;
   end
   always
     #20 a <= a + 1;
   always
     #10 b <= b + 1;
endmodule