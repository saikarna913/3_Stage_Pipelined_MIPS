`include "defines.v"
module IF_ID_Pipeline_Register (
    input clk,
    input rst,
    input freeze,
    input [`WORD_LEN-1:0] PC_in,
    input MEM_R_EN_in,
    input MEM_W_EN_in,
    input WB_EN_in,
    input is_imm_out_in,
    input ST_or_BNE_out_in,
    input [1:0] branch_comm_in,
    input [`WORD_LEN-1:0] immediate_in,
    input [`REG_FILE_ADDR_LEN-1:0] writeDest_in,
    input [`EXE_CMD_LEN-1:0] EXE_CMD_in,
    input [`WORD_LEN-1:0] reg1_in,reg2_in,
    input [4:0] src1_in,            // New 5-bit input for src1
    input [4:0] src2_in,            // New 5-bit input for src2

    output reg [`WORD_LEN-1:0] PC_out,
    output reg MEM_R_EN_out,
    output reg MEM_W_EN_out,
    output reg WB_EN_out,
    output reg is_imm_out_out,
    output reg ST_or_BNE_out_out,
    output reg [1:0] branch_comm_out,
    output reg [`WORD_LEN-1:0] immediate_out,
    output reg [`EXE_CMD_LEN-1:0] EXE_CMD_out,
    output reg [`REG_FILE_ADDR_LEN-1:0] writeDest_out,
    output reg [`WORD_LEN-1:0] reg1_out,reg2_out,
    output reg [4:0] src1_out,       // New 5-bit output for src1
    output reg [4:0] src2_out        // New 5-bit output for src2
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all outputs
            PC_out <= 0;
            MEM_R_EN_out <= 0;
            MEM_W_EN_out <= 0;
            WB_EN_out <= 0;
            is_imm_out_out <= 0;
            ST_or_BNE_out_out <= 0;
            branch_comm_out <= 0;
            immediate_out <= 0;
            writeDest_out <= 0;
            EXE_CMD_out <= 0;
            reg1_out <= 0;
            reg2_out <= 0;
            src1_out <= 0;          // Reset src1
            src2_out <= 0;          // Reset src2
        end else if (~freeze) begin
            // Capture inputs on clock edge
            PC_out <= PC_in;
            MEM_R_EN_out <= MEM_R_EN_in;
            MEM_W_EN_out <= MEM_W_EN_in;
            WB_EN_out <= WB_EN_in;
            is_imm_out_out <= is_imm_out_in;
            ST_or_BNE_out_out <= ST_or_BNE_out_in;
            branch_comm_out <= branch_comm_in;
            immediate_out <= immediate_in;
            writeDest_out <= writeDest_in;
            EXE_CMD_out <= EXE_CMD_in;
            reg1_out <= reg1_in;
            reg2_out <= reg2_in;
            src1_out <= src1_in;    // Pass src1 input to src1 output
            src2_out <= src2_in;    // Pass src2 input to src2 output
            
        end
    end

endmodule // IF_ID_Pipeline_Register
