//Fibonacci module - behavioral
module Fibonacci(reg1,clk,reset);
	output reg [7:0] reg1;
	input clk,reset;
	reg [7:0] reg2;
	wire [7:0] q;
	assign q=reg1+reg2;
	always @(posedge clk or posedge reset)
	    if(reset) 
           begin
			 reg1<=8'd0;
			 reg2<=8'd1;
           end
	    else
           begin
			   if(reg1===8'd233) 
				   begin
					  reg1<=8'd0;
			          reg2<=8'd1;
				   end
			   else 
				   begin 
					 reg1<=reg2;
					 reg2<=q;
				   end
           end 
endmodule

//TestBenchFibonacci
module TestBenchFobinacci;
    wire [7:0] q;
    reg clk,reset;
	Fibonacci f(q,clk,reset);
	initial 
		begin 
		   clk<=1'b0;
		   #10 reset<=1'b1;
		   #3 reset<=~reset;
		end
	always 
	   #10 clk<=~clk;
endmodule
//---------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------
//Full Adder behavioral module
module FABehav(input a,b,cin,output sum,cout);
   assign {cout,sum} = a + b + cin;
endmodule

//FourBitRippleCarryAdder module
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

//EightBitRippleCarryAdder module
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

//Fibonacci module - ripple carry adder
module RipleCarryAdderFibonacci(reg1,clk,reset);
	output reg [7:0] reg1;
	input clk,reset;
	reg [7:0] reg2;
	wire [7:0] q;
	EightBitRippleCarryAdder ebrca0(reg1,reg2,1'b0,q);
	always @(posedge clk or posedge reset)
	    if(reset) 
           begin
			 reg1<=8'd0;
			 reg2<=8'd1;
           end
	    else
           begin
			   if(reg1===8'd233) 
				   begin
					  reg1<=8'd0;
			          reg2<=8'd1;
				   end
			   else 
				   begin 
					 reg1<=reg2;
					 reg2<=q;
				   end
           end 
endmodule

//TestBenchRipleCarryAdderFibonacci
module TestBenchRipleCarryAdderFibonacci;
    wire [7:0] q;
    reg clk,reset;
	RipleCarryAdderFibonacci rcaf0(q,clk,reset);
	initial 
		begin 
		   clk<=1'b0;
		   #10 reset<=1'b1;
		   #3 reset<=~reset;
		end
	always 
	   #10 clk<=~clk;
endmodule