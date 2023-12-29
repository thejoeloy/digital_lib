`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2021 08:30:32 PM
// Design Name: 
// Module Name: sequential
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
module combinational(

    );
endmodule
*/

module  Dec(a, b) ;
    parameter n = 2 ;
    parameter m = 4 ;
    
    input [n-1:0] a ;
    output [m-1:0] b ; 
    
    wire [m-1:0] b = 1<<a ;
endmodule

module Mux3(a2, a1, a0, s, b) ;
    parameter k = 1 ;
    input[k-1:0] a0, a1, a2 ; // inputs
    input[2:0] s ; // one hot select
    output[k-1:0] b;
    
    wire [k-1:0] b =  ({k{s[0]}} & a0) |
                      ({k{s[1]}} & a1) |
                      ({k{s[2]}} & a2) ; 
endmodule

module Muxb3(a2, a1, a0, sb, b) ;
    parameter k = 1 ;
    input[k-1:0] a0, a1, a2 ; // inputs
    input[1:0] sb ; // binary select
    output[k-1:0] b;
    wire [3:0] s ;
    
    Dec #(2, 3) d(sb, s) ;
    Mux3 #(k) m(a2, a1, a0, s, b) ;
endmodule

module Mux6a(a5, a4, a3, a2, a1, a0, s, b) ;
    parameter k = 1 ;
    input [k-1:0] a0, a1, a2, a3, a4, a5  ; // inputs
    input [5:0] s ; // one hot select
    output [k-1:0] b;
    wire [k-1:0] ba, bb ;
    wire [k-1:0] b = ba | bb ;
    
    Mux3 #(k) ma(a2, a1, a0, s[2:0], ba) ;
    Mux3 #(k) mb(a5, a4, a3, s[5:3], bb) ;
endmodule

module Enc42(a, b) ;
    input [3:0] a ;    
    output [1:0] b ;
    wire [1:0] b = {a[3] | a[2], a[3] | a[1]} ;
endmodule

module Enc42a(a, b, c) ;
    input [3:0] a ;
    output [1:0] b ;
    output c ;
    wire [1:0] b = {a[3] | a[2], a[3] | a[1]} ;
    wire c = |a ;
endmodule

module Enc164(a, b) ;
    input [15:0] a ;
    output [3:0] b ;
    wire [3:0] b ;
    wire [7:0] c ; 
    wire [3:0] d ; 
    
    Enc42a e0(a[3:0], c[1:0], d[0]) ;
    Enc42a e1(a[7:4], c[3:2], d[1]) ;
    Enc42a e2(a[11:8], c[5:4], d[2]) ;
    Enc42a e3(a[15:12], c[7:6], d[3]) ;
    
    Enc42 e4(d[3:0], b[3:2]) ;
    
    assign b[1] = c[1] | c[3] | c[5] | c[7] ;
    assign b[0] = c[0] | c[2] | c[4] | c[6] ;
    
endmodule

module Arb(r, g) ; 
    parameter n = 8 ;
    input [n-1:0] r ;
    output [n-1:0] g ;
    wire [n-1:0] c = {(~r[n-2:0] & c[n-2:0]), 1'b1} ;
    wire [n-1:0] g = r & c ; 
endmodule

module RArb(r, g) ;
    parameter n = 8 ;
    input [n-1:0] r ;
    output [n-1:0] g ;
    wire [n-1:0] c = {1'b1, (~r[n-1:1] & c[n-1:1])} ;
    wire [n-1:0] g = r & c ;
endmodule 

/*
module PriorityEncoder83(r, b) ; 
    input [7:0] r ;
    output [2:0] b ;
    wire [7:0] g ;
    Arb #(8) a(r, g) ; 
    Enc83 e(g, b) ;
endmodule
*/

module EqComp(a, b, eq) ;
    parameter k = 8 ;
    input [k-1:0] a, b ;
    output eq ;
    wire eq = (a == b) ;
endmodule

module MagComp(a, b, gt) ;
    parameter k = 8 ;
    input [k-1:0] a, b; 
    output gt ;
    wire [k-1:0] eqi = a ~^ b ;
    wire [k-1:0] gti = a & ~b ; 
    wire [k:0] gtb = {((eqi[k-1:0] & gtb[k-1:0]) | gti[k-1:0]), 1'b0} ;
    wire gt = gtb[k] ;
endmodule


