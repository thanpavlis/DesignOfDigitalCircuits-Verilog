module decoder4to16(in,d);
   input [3:0] in;
   output [15:0] d;
   wire notx,noty,notz,notw;
   not(notx,in[3]);
   not(noty,in[2]);
   not(notz,in[1]);
   not(notw,in[0]);
   and(d[15],notx,noty,notz,notw);
   and(d[14],notx,noty,notz,in[0]);
   and(d[13],notx,noty,in[1],notw);
   and(d[12],notx,noty,in[1],in[0]);
   and(d[11],notx,in[2],notz,notw);
   and(d[10],notx,in[2],notz,in[0]);
   and(d[9],notx,in[2],in[1],notw);
   and(d[8],notx,in[2],in[1],in[0]);
   and(d[7],in[3],noty,notz,notw);
   and(d[6],in[3],noty,notz,in[0]);
   and(d[5],in[3],noty,in[1],notw);
   and(d[4],in[3],noty,in[1],in[0]);
   and(d[3],in[3],in[2],notz,notw);
   and(d[2],in[3],in[2],notz,in[0]);
   and(d[1],in[3],in[2],in[1],notw);
   and(d[0],in[3],in[2],in[1],in[0]);
endmodule

module testbenchDecoder4to16;
   reg [3:0] x;
   wire [15:0] d;
   decoder4to16 dec0(x,d);
   initial
      x=1'b0;
   always
      #10 x<=x+1;
endmodule

module sqr(in,d);
   input [3:0] in;
   output [7:0] d;
   wire notx,noty,notz,notw,v1,v2,v3,v4,v5,v6,v7,v8;
   not(notx,in[3]);
   not(noty,in[2]);
   not(notz,in[1]);
   not(notw,in[0]);
   //ipologismos tou d[7]
   and(d[7],in[3],in[2]);
   //ipologismos tou d[6]
   or(v1,noty,in[1]);
   and(d[6],in[3],v1);
   //ipologismos tou d[5]
   and(v2,notx,in[2],in[1]);
   and(v3,in[3],in[2],in[0]);
   and(v4,in[3],noty,in[1]);
   or(d[5],v2,v3,v4);
   //ipologismos tou d[4]
   and(v5,notx,in[2],in[0]);
   and(v6,in[2],notz,notw);
   and(v7,in[3],noty,in[0]);
   or(d[4],v5,v6,v7);
   //ipologismos tou d[3]
   xor(v8,in[1],in[2]);
   and(d[3],in[0],v8);
   //ipologismos tou d[2]
   and(d[2],notw,in[1]);
   //ipologismos tou d[1]
   buf(d[1],1'b0);
   //ipologismos tou d[0]
   buf(d[0],in[0]);
endmodule

module testbenchSqr;
   reg [3:0] x;
   wire [7:0] d;
   sqr sqr0(x,d);
   initial 
      x=4'b0;
   always
      #10 x<=x+1;
endmodule