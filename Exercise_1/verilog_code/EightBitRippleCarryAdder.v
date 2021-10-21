module EightBitRippleCarryAdder(a,b,cstart,s);
   output [8:0] s;
   input [7:0] a,b;
   input cstart;
   wire [9:0] c;
   FourBitRippleCarryAdder fbrca1(a[3:0],b[3:0],cstart,c[4:0]);
   FourBitRippleCarryAdder fbrca2(a[7:4],b[7:4],c[4],c[9:5]);  
   assign s[3:0]=c[3:0];
   assign s[8:4]=c[9:5];
endmodule