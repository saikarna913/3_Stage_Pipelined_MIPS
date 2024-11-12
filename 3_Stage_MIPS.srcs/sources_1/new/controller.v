`include "defines.v"

module controller (
  input hazard_detected,
  input [`OP_CODE_LEN-1:0] opCode,      // The opcode field
  input [5:0] func,                      // The func field (for R-type instructions)
  output reg branchEn,
  output reg [`EXE_CMD_LEN-1:0] EXE_CMD,
  output reg [1:0] Branch_command,
  output reg Is_Imm, 
  output reg ST_or_BNE, 
  output reg WB_EN, 
  output reg MEM_R_EN, 
  output reg MEM_W_EN
);

  always @ (*) begin
    // Reset outputs when no hazard is detected
    branchEn = 0;
EXE_CMD = 0;
    if (hazard_detected == 0) begin
      {branchEn, EXE_CMD, Branch_command, Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN} <= 0;
      
      // Instruction type detection
      case (opCode)
        // R-type operations (use func field to determine EXE_CMD)
        `OP_R_TYPE: begin
          case (func)
            `FUNC_ADD:    EXE_CMD <= `EXE_ADD;
            `FUNC_ADDU:   EXE_CMD <= `EXE_ADD;
            `FUNC_SUB:    EXE_CMD <= `EXE_SUB;
            `FUNC_SUBU:   EXE_CMD <= `EXE_SUB;
            `FUNC_AND:    EXE_CMD <= `EXE_AND;
            `FUNC_OR:     EXE_CMD <= `EXE_OR;
            `FUNC_NOR:    EXE_CMD <= `EXE_NOR;
            `FUNC_XOR:    EXE_CMD <= `EXE_XOR;
            `FUNC_SLT:    EXE_CMD <= `EXE_SUB;  // SLT can be treated as SUB for comparison
            `FUNC_SLTU:   EXE_CMD <= `EXE_SUB;  // SLTU treated as SUB
            `FUNC_SLL:    EXE_CMD <= `EXE_SLL;
            `FUNC_SRL:    EXE_CMD <= `EXE_SRL;
            `FUNC_SRA:    EXE_CMD <= `EXE_SRA;
            default:      EXE_CMD <= `EXE_NO_OPERATION; // Invalid func field
          endcase
          WB_EN <= 1; // Enable writing to the register file for R-type instructions
        end
        
        // Immediate operations (I-type)
        `OP_ADDI, `OP_ADDIU: begin
          EXE_CMD <= `EXE_ADD;
          WB_EN <= 1;
          Is_Imm <= 1;
        end
        
        // Memory operations
        `OP_LD: begin
          EXE_CMD <= `EXE_ADD;
          WB_EN <= 1;
          Is_Imm <= 1;
          MEM_R_EN <= 1;
          ST_or_BNE <= 1;
        end
        `OP_ST: begin
          EXE_CMD <= `EXE_ADD;
          Is_Imm <= 1;
          MEM_W_EN <= 1;
          ST_or_BNE <= 1;
        end
        
        // Branch operations
        `OP_BEQ: begin
          EXE_CMD <= `EXE_NO_OPERATION;
          Is_Imm <= 1;
          Branch_command <= `COND_BEQ;
          branchEn <= 1;
        end
        `OP_BNE: begin
          EXE_CMD <= `EXE_NO_OPERATION;
          Is_Imm <= 1;
          Branch_command <= `COND_BNE;
          branchEn <= 1;
          ST_or_BNE <= 1;
        end
        `OP_BGTZ: begin
          EXE_CMD <= `EXE_NO_OPERATION;
          Is_Imm <= 1;
          Branch_command <= `COND_BGTZ;
          branchEn <= 1;
        end
        `OP_BLTZ: begin
          EXE_CMD <= `EXE_NO_OPERATION;
          Is_Imm <= 1;
          Branch_command <= `COND_BLTZ;
          branchEn <= 1;
        end
        `OP_JMP: begin
          EXE_CMD <= `EXE_NO_OPERATION;
          Is_Imm <= 1;
          Branch_command <= `COND_JUMP;
          branchEn <= 1;
        end
        
        // Default case: no operation
        default: begin
          {branchEn, EXE_CMD, Branch_command, Is_Imm, ST_or_BNE, WB_EN, MEM_R_EN, MEM_W_EN} <= 0;
        end
      endcase
    end

    // If a hazard is detected, prevent any writes
    else if (hazard_detected == 1) begin
      {EXE_CMD, WB_EN, MEM_W_EN} <= 0;
    end
  end
endmodule
