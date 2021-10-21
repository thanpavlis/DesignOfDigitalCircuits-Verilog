//to T flip-flop
module T_FF (q, t, clk, reset);
	output q;
	input t, clk, reset;
	reg q;

	always @ (posedge reset or negedge clk)
	 if (reset)
	    #1 q <= 1'b0;
	 else if (t == 1) 
	    #2 q <= ~q;
endmodule

//4bit RippleCounter
module RippleCounter(q,clk,reset);
	output [3:0] q;
	input clk,reset;
	wire t_start,Q0,Q1,Q2,Q3;
	buf(t_start,1'b1);
	T_FF t_ff0(q[0],t_start,clk,reset);
	T_FF t_ff1(q[1],t_start,q[0],reset);
	T_FF t_ff2(q[2],t_start,q[1],reset);
	T_FF t_ff3(q[3],t_start,q[2],reset);
endmodule

//4bit RippleCounter - TestBench
module TestBenchRippleCounter;
	reg clk,reset;
	wire [3:0] q;
	RippleCounter rc0(q,clk,reset);
	initial begin
		clk<=1'b0;
		#19 reset<=1'b1;
		#20 reset<=~reset;
	end
	always
		#10 clk <= ~clk;
endmodule

//4bit Synchronous Counter
module SynchronousCounter(q,clk,reset);
	output [3:0] q;
	input clk,reset;
	wire t2,t3;
	T_FF t_ff0(q[0],1'b1,clk,reset);
	T_FF t_ff1(q[1],q[0],clk,reset);
	and(t2,q[0],q[1]);
	T_FF t_ff2(q[2],t2,clk,reset);
	and(t3,t2,q[2]);
	T_FF t_ff3(q[3],t3,clk,reset);
endmodule

//4bit SynchronousCounter - TestBench
module TestBenchSynchronousCounter;
	reg clk,reset;
	wire [3:0] q;
	SynchronousCounter sc0(q,clk,reset);
	initial begin
		clk<=1'b0;
		#19 reset<=1'b1;
		#20 reset<=~reset;
	end
	always
	    #10 clk<=~clk;
endmodule

















