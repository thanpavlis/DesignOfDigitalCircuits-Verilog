//to T flip-flop
module T_FF (q, t, clk, reset, enable);
	output q;
	input t, clk, reset, enable;
	reg q;
	always @ (posedge reset or negedge clk)
	 if (reset)
	    #1 q <= 1'b0;
	 else if (t == 1 && enable) 
	    #2 q <= ~q;
endmodule

//4bit Synchronous Counter
module SynchronousCounter(q,clk,reset);
	output [3:0] q;
	input clk,reset;
	wire t2,t3,enable;
	reg [24:0] delay_counter;
	
	assign enable = (delay_counter == 25'd24999999) ? 1'b1 : 1'b0;	
	T_FF t_ff0(q[0],1'b1,clk,reset,enable);
	T_FF t_ff1(q[1],q[0],clk,reset,enable);
	and(t2,q[0],q[1]);
	T_FF t_ff2(q[2],t2,clk,reset,enable);
	and(t3,t2,q[2]);
	T_FF t_ff3(q[3],t3,clk,reset,enable);
	always @ (negedge clk or posedge reset) 
		if (reset)
		   delay_counter <= 25'd0; 
		else if (enable) 
		   delay_counter <= 25'd0; 
		else 
		   delay_counter <= delay_counter + 1'b1;
endmodule
