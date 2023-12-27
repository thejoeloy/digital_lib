`include "defines.v"
`timescale 1ns / 1ps

// Page 351 of pdf (270 in actual textbook)

module alu (
	input r,
	input [3:0] alu_op,
	input [31:0] alu_in1,
	input [31:0] alu_in2,
	output wire zero,
	output reg [31:0] alu_result
);
	
	localparam ADD = 4'b0010;
	localparam SUB = 4'b0110;
	localparam AND = 4'b0000;
	localparam OR = 4'b0001;
	
	wire signed [31:0] alu_in1_signed = alu_in1;
	wire signed [31:0] alu_in2_signed = alu_in2;
	
	assign zero = (alu_in1_signed - alu_in2_signed == 0) ? 1'b1 : 1'b0;
	
	always @(*) begin
		if (r) begin
            alu_result = 0;	
		end
		else begin
		  case(alu_op)
			ADD : alu_result = alu_in1_signed + alu_in2_signed; // add
			SUB : alu_result = alu_in1_signed - alu_in2_signed; // sub					
			OR : alu_result = alu_in1_signed | alu_in2_signed; // or
			AND : alu_result = alu_in1_signed & alu_in2_signed; // and 			
			default : alu_result = 0;
		  endcase
		end
	end
	
endmodule