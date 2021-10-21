module FAStruct(input a,b,cin,output sum,cout);
    wire an_1,an_2,an_3;
    and(an_1,a,b);
    and(an_3,a,cin);
    and(an_2,b,cin);
    or(cout,an_1,an_2,an_3);
    xor(sum,a,b,cin);
endmodule