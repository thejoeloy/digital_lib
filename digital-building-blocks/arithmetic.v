module HalfAdder(a, b, cout, out);
   input wire a, b;
   output wire cout, out;
   
   assign out = a ^ b;
   assign cout = a & b;
   

endmodule // HalfAdder

module FullAdder(a, b, cin, cout, out);
   parameter n = 8;
   
   input wire [n-1:0] a, b;
   input wire	 cin;
   output wire	 cout;
   output wire [n-1:0] out;
   
   assign {cout, out} = a + b + cin;
   
endmodule // FullAdder


module AddSub1(a, b, sub, ovf, out);
   parameter n = 8;

   input wire [n-1:0] a, b;
   input wire	 sub;
   output wire [n-1:0] out;
   output wire	  ovf;
   wire		  c1, c2;
   assign ovf = c1 ^ c2;

   FullAdder #(n-1) fa1(a[n-2:0], b[n-2:0] ^ {n-1{sub}}, sub, c1, out[n-2:0]);
   FullAdder #(1) fa2(a[n-1], b[n-1] ^ sub, c1, c2, out[n-1]);
   
endmodule // AddSub1

module AddSub2(a, b, sub, ovf, out);
   parameter n = 8;

   input [n-1:0] a, b;
   input	 sub;
   output [n-1:0] out;
   output	  ovf;
   wire		  c1, c2;
   wire		  ovf = c1 ^ c2;

   assign {c1, out[n-2:0]} = a[n-2:0] + (b[n-2:0] ^ {n-1{sub}}) + sub;
   assign {c2, out[n-1]} = a[n-1] + (b[n-1] ^ sub) + c1;
   
   
endmodule // AddSub2

module Mul4(a, b, p);
   input wire [3:0] a, b;
   output wire [7:0]	p;

   wire [3:0] pp0 = a & {4{b[0]}} ;
   wire [3:0] pp1 = a & {4{b[1]}} ;
   wire [3:0] pp2 = a & {4{b[2]}} ;
   wire [3:0] pp3 = a & {4{b[3]}} ;

   wire	      cout1, cout2, cout3 ;

   wire [3:0] s1, s2, s3;
   FullAdder #(4) a1(pp1, {1'b0, pp0[3:1]}, 1'b0, cout1, s1);
   FullAdder #(4) a2(pp2, {cout1, s1[3:1]}, 1'b0, cout2, s2);
   FullAdder #(4) a3(pp3, {cout2, s2[3:1]}, 1'b0, cout3, s3);

   assign p = {cout3, s3, s2[0], s1[0], pp0[0]};
   
endmodule // Mul4


