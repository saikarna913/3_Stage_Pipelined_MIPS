// Wire widths
`define WORD_LEN 32
`define REG_FILE_ADDR_LEN 5
`define EXE_CMD_LEN 4
`define FORW_SEL_LEN 2
`define OP_CODE_LEN 6

// Memory constants
`define DATA_MEM_SIZE 1024
`define INSTR_MEM_SIZE 1024
`define REG_FILE_SIZE 32
`define MEM_CELL_SIZE 8

// Opcode and func field definitions for instruction decoding
`define OP_CODE_LEN 6
`define FUNC_LEN 6

// Opcode Definitions
`define OP_R_TYPE 6'b000000   // R-type instructions
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_LD 6'b100000
`define OP_ST 6'b100001
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGTZ 6'b000111
`define OP_BLTZ 6'b000001
`define OP_JMP 6'b000010

// R-type func field Definitions
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_NOR 6'b100111
`define FUNC_XOR 6'b100110
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011

// ALU command definitions for different operations
`define EXE_ADD 4'b0000
`define EXE_SUB 4'b0010
`define EXE_AND 4'b0100
`define EXE_OR 4'b0101
`define EXE_NOR 4'b0110
`define EXE_XOR 4'b0111
`define EXE_SLL 4'b1000
`define EXE_SRL 4'b1010
`define EXE_SRA 4'b1001
`define EXE_NO_OPERATION 4'b1111

// Condition codes for branch operations
`define COND_JUMP 2'b10
`define COND_BEQ 2'b00
`define COND_BNE 2'b01
`define COND_BEZ 2'b11
`define COND_BGTZ 2'b01   // Condition for BGTZ// may remove later after checking 
`define COND_BLTZ 2'b10   // Condition for BLTZ// may remove

