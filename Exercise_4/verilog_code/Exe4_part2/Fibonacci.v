//Fibonacci module - behavioral
module Fibonacci(HEX0,HEX1,HEX2,clk,reset);
	output reg [6:0] HEX0,HEX1,HEX2;
	input wire clk,reset;
	reg [7:0] reg2,reg1;
	wire [7:0] q;
	wire enable;
	reg [24:0] delay_counter;	
	assign q=reg1+reg2;
	assign enable = (delay_counter == 25'd24999999) ? 1'b1 : 1'b0;	
	always @(posedge clk or posedge reset)
	begin
	    if(reset) 
           begin
			  reg1<=7'd0;
			  reg2<=7'd1;
			  delay_counter<=25'd0;
           end 
		else if(enable)
           begin
			   reg1<=reg2;
			   reg2<=q;
			   delay_counter<=25'd0; 
           end
	    else
		   delay_counter<=delay_counter+1'b1;
	end
		   
	always @(reg1)
		begin
		   case (reg1)
				8'd0:begin//periptwsh apeikonishs tou 0 		        
						HEX2<=7'b1111111; 
						HEX1<=7'b1111111; 
						HEX0<=7'b1000000;
					 end
				8'd1:begin//periptwsh apeikonishs tou 1		        
						HEX2<=7'b1111111; 						
						HEX1<=7'b1111111; 
						HEX0<=7'b1111001; 
					 end
				8'd2:begin//periptwsh apeikonishs tou 2 		        
						HEX2<=7'b1111111; 			
						HEX1<=7'b1111111; 
						HEX0<=7'b0100100;
					 end
				8'd3:begin//periptwsh apeikonishs tou 3		        
						HEX2<=7'b1111111; 
						HEX1<=7'b1111111; 
						HEX0<=7'b0110000; 
					 end
				8'd5:begin//periptwsh apeikonishs tou 5		        
						HEX2<=7'b1111111; 
						HEX1<=7'b1111111; 				
						HEX0<=7'b0010010;
					 end
				8'd8:begin//periptwsh apeikonishs tou 8 		        
						HEX2<=7'b1111111; 
                        HEX1<=7'b1111111; 
						HEX0<=7'b0000000; 
					 end
				8'd13:begin//periptwsh apeikonishs tou 13 		        
						HEX2<=7'b1111111; 
						HEX1<=7'b1111001; 	
						HEX0<=7'b0110000; 
					 end
				8'd21:begin//periptwsh apeikonishs tou 21 		        
						HEX2<=7'b1111111; 
						HEX1<=7'b0100100; 
						HEX0<=7'b1111001; 
					 end
				8'd34:begin//periptwsh apeikonishs tou 34 		        
						HEX2<=7'b1111111; 					
						HEX1<=7'b0110000; 
						HEX0<=7'b0011001; 
					 end
				8'd55:begin//periptwsh apeikonishs tou 55 		        
						HEX2<=7'b1111111;
						HEX1<=7'b0010010; 
						HEX0<=7'b0010010; 
					 end
				8'd89:begin//periptwsh apeikonishs tou 89 		        
						HEX2<=7'b1111111; 		
						HEX1<=7'b0000000; 
						HEX0<=7'b0010000; 
					 end
				8'd144:begin//periptwsh apeikonishs tou 144		        
						HEX2<=7'b1111001; 
						HEX1<=7'b0011001; 				
						HEX0<=7'b0011001; 
					 end
				8'd233:begin//periptwsh apeikonishs tou 233 		        
						HEX2<=7'b0100100; 
						HEX1<=7'b0110000; 
						HEX0<=7'b0110000; 
					 end
				default:begin//mh enammenomenh timh emfanizoume to EEE		        
						HEX2<=7'b0000110; 	
						HEX1<=7'b0000110; 			
						HEX0<=7'b0000110; 
					 end
		   endcase
	 end
endmodule
