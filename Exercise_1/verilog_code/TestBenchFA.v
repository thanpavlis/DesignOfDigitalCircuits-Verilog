module TestBenchFA;
   reg [2:0] in;
   wire S_struct, Cout_struct;
   wire S_behav, Cout_behav;
   FAStruct fa0(in[2], in[1], in[0], S_struct, Cout_struct);
   FABehav fa1(in[2], in[1], in[0], S_behav, Cout_behav);
   initial
     in = 3'b000;
   always
     #10 in = in + 1;
endmodule