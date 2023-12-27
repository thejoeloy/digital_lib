`timescale 1ns / 1ps

// Page 352 of pdf (271 in actual textbook)

module alu_control(
    input wire r,
    input wire [1:0] alu_op,
    input wire [9:0] func_code, //{f7, f3}
    output reg [3:0] operation
);

    always @(*) begin
        if (r) begin
            operation = 4'b0000;
        end
        else begin
            casex({alu_op, func_code})
                {2'b00, 10'bxxxxxxxxxx} : operation = 4'b0010;
                {2'bx1, 10'bxxxxxxxxxx} : operation = 4'b0110;
                {2'b1x, 10'b0000000000} : operation = 4'b0010;
                {2'b1x, 10'b0100000000} : operation = 4'b0110;
                {2'b1x, 10'b0000000111} : operation = 4'b0000;
                {2'b1x, 10'b0000000110} : operation = 4'b0001;
                default : operation = 4'b0000;
            endcase
        end
    end


endmodule
