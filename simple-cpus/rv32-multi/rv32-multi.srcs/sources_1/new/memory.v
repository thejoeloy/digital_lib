`timescale 1ns / 1ps

module memory(
    input wire r,
    input wire [31:0] address,
    input wire [31:0] write_data,
    input wire mem_read,
    input wire mem_write,
    output reg [31:0] mem_data
);
    
    localparam MEM_SIZE = 2048;
    reg [31:0] memory [0:MEM_SIZE - 1];
    
    always @(*) begin
        if (r) begin
            mem_data = 0;        
        end
        else begin
            if (mem_read) begin
                mem_data <= memory[address]; 
            end
            else if (mem_write) begin
                memory[address] <= write_data;
            end
        end
    end
    
    integer i;
    initial begin
        // Initialize memory with zeros or predefined values
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            if (i == 0) begin
                memory[i] = 32'b0000000_00010_00001_000_00011_0110011; // add x3, x1, x2
            end
            else if (i == 1) begin
                memory[i] = 32'b0100000_00001_00010_000_00100_0110011; // sub x4, x2, x1
            end
            else if (i == 2) begin
                memory[i] = 32'b0000000_00010_00001_111_00101_0110011; // and x5, x1, x2
            end
            else if (i == 3) begin
                memory[i] = 32'b0000000_00010_00100_110_00110_0110011; // or x6, x4, x2
            end
            else if (i == 4) begin
                memory[i] = 32'b000001000000_00000_010_00111_0000011; // lw x7, 64(x0)
            end
            else if (i == 5) begin
                memory[i] = 32'b0000000_01000_00000_010_00001_0100011; // sw x8, 1(x0)
            end
            else if (i == 6) begin
                memory[i] = 32'b0000000_00110_00010_000_01010_1100011; // beq x2, x6, offset
            end
            else if (i == 7) begin
                memory[i] = 32'b0; // jalr
            end
            else if (i == 64) begin
                memory[i] = 68;
            end
            else begin
                memory[i] = 32'b0;
            end
        end
    end
    
endmodule