`include "defines.v"

module instructionMem (
  input rst,
  input [`WORD_LEN-1:0] addr,
  output reg [`WORD_LEN-1:0] instruction
);

  // Define instruction memory (32-bit instructions)
  reg [`WORD_LEN-1:0] mem [0:31];  // 32 entries for instruction memory
  
  initial begin
    mem[0]  = 32'b000000_01001_01010_01000_00000_100000; // add $t0, $t1, $t2
    mem[1]  = 32'b000000_01000_01100_01011_00000_100010; // sub $t3, $t0, $t4
    mem[2]  = 32'b000100_01000_01001_00000_00000_000100; // beq $t0, $t1, target
    mem[3]  = 32'b100011_01000_01101_00000_00000_000000; // lw $t5, 0($t0)
    mem[4]  = 32'b101011_01101_01110_00000_00000_000001; // sw $t6, 4($t5)
    mem[5]  = 32'b001000_01000_01111_00000_00000_000010; // addi $t7, $t0, 10
    mem[6]  = 32'b000010_00000000000000000000000000;     // j target
  end

  // Fetch instruction based on address
  always @(addr or rst) begin
    if (rst)
      instruction = 32'b0; // Reset: return 0
    else
      instruction = mem[addr >> 2]; // Fetch instruction, assuming 4-byte word alignment
  end

endmodule // instructionMem
