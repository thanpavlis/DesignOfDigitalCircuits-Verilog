module FourBitRippleCarryAdder(a,b,cstart,s);
   output [4:0] s ;
   input [3:0] a,b;
   input cstart;
   wire fa1_Cout,fa2_Cout,fa3_Cout;
   FABehav fa1(a[0], b[0], cstart, s[0], fa1_Cout);
   FABehav fa2(a[1], b[1], fa1_Cout, s[1], fa2_Cout);
   FABehav fa3(a[2], b[2], fa2_Cout, s[2], fa3_Cout);
   FABehav fa4(a[3], b[3], fa3_Cout, s[3], s[4]);
endmodule