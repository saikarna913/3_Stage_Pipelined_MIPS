module TopLevel (
    input clk,
    input rst,
    input freeze
);

    // IF Stage Instantiation
    wire [`WORD_LEN-1:0] PC, PC_out;
    wire MEM_R_EN;
    wire MEM_W_EN;
    wire WB_EN;
    wire is_imm_out;
    wire ST_or_BNE_out;
    wire [1:0] branch_comm;
    wire [`WORD_LEN-1:0] immediate;
    wire [`WORD_LEN-1:0] instruction;
    wire [`REG_FILE_ADDR_LEN-1:0] writeDest;
    wire [`EXE_CMD_LEN-1:0] EXE_CMD;
    wire [`WORD_LEN-1:0] reg1,reg2,reg2_out,reg1_out,immediate_out,ALURes;
    wire hazard_detected_in;
    wire [`WORD_LEN-1:0] WB_res;
    wire MEM_W_EN_out;
    wire MEM_R_EN_out;
    wire is_imm,WB_EN_out,ST_or_BNE;
    wire [1:0]branch_comm_out;
    wire [3:0] EXE_CMD_out;
    wire [`WORD_LEN-1:0] ALUResult, ST_value_out;
    wire val1_sel, val2_sel, ST_val_sel;
    wire WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM;
    wire [`WORD_LEN-1:0] STVal;
    wire [`REG_FILE_ADDR_LEN-1:0] destIn,writeDest_out;
    wire src2_ID;
    wire  [4:0] src1, src2,writeDest_reg,src1_out, src2_out;
    
    IFStage if_stage (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .hazard_detected_in(hazard_detected_in),
        .PC(PC),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .WB_EN(WB_EN),
        .is_imm_out(is_imm_out),
        .ST_or_BNE_out(ST_or_BNE_out),
        .branch_comm(branch_comm),
        .immediate(immediate),
        .writeDest(writeDest),
        .EXE_CMD(EXE_CMD),
        .reg1(reg1),
        .writeVal(WB_res),
        .writeEn(WB_EN_MEM),
        .src1(src1),
        .src2(src2),
        .reg2(reg2),
        .writeDest_reg(destIn)
    );

    // IF_ID Pipeline Register Instantiation
    IF_ID_Pipeline_Register if_id_reg (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .PC_in(PC),
        .MEM_R_EN_in(MEM_R_EN),
        .MEM_W_EN_in(MEM_W_EN),
        .WB_EN_in(WB_EN),
        .is_imm_out_in(is_imm_out),
        .ST_or_BNE_out_in(ST_or_BNE_out),
        .branch_comm_in(branch_comm),
        .reg2_in(reg2),
        .src1_in(src1),
        .src2_in(src2),        
        .immediate_in(immediate),
        .writeDest_in(writeDest),
        .EXE_CMD_in(EXE_CMD),
        .reg1_in(reg1),

        // Outputs
        .PC_out(PC_out),
        .MEM_R_EN_out(MEM_R_EN_out),
        .MEM_W_EN_out(MEM_W_EN_out),
        .WB_EN_out(WB_EN_out),
        .is_imm_out_out(is_imm),
        .ST_or_BNE_out_out(ST_or_BNE),
        .branch_comm_out(branch_comm_out),
        .immediate_out(immediate_out),
        .writeDest_out(writeDest_out),
        .EXE_CMD_out(EXE_CMD_out),
        .reg1_out(reg1_out),
        .src1_out(src1_out),
        .src2_out(src2_out),
        .reg2_out(reg2_out)
        
    );
        // EXE Stage Instantiation

    EXEStage exe_stage (
        .clk(clk),
        .val1_sel(val1_sel),
        .val2_sel(val2_sel),
        .ST_val_sel(ST_val_sel),
        .EXE_CMD(EXE_CMD_out),
        .reg1(reg1_out),
        .immediate(immediate_out),
        .ALU_res_MEM(ALURes),  // Connect to next stage's ALU result
        .reg2(reg2_out),
        .ALUResult(ALUResult),
        .ST_value_out(ST_value_out)
    );

    // EXE2MEM Stage Instantiation



    EXE2MEM exe2mem (
        .clk(clk),
        .rst(rst),
        .WB_EN_IN(WB_EN_out),
        .MEM_R_EN_IN(MEM_R_EN_out),
        .MEM_W_EN_IN(MEM_W_EN_out),
        .ALUResIn(ALUResult),
        .STValIn(ST_value_out),
        .destIn(writeDest_out),
        .WB_EN(WB_EN_MEM),
        .MEM_R_EN(MEM_R_EN_MEM),
        .MEM_W_EN(MEM_W_EN_MEM),
        .ALURes(ALURes),
        .STVal(STVal),
        .dest(destIn)
    );

    // MEM_WB Stage Instantiation

    MEM_WB_Stage mem_wb_stage (
        .clk(clk),
        .rst(rst),
        .MEM_R_EN(MEM_R_EN_MEM),
        .MEM_W_EN(MEM_W_EN_MEM),
        .ALU_res(ALURes),
        .ST_value(STVal),
        .WB_res(WB_res) // Final result for write-back
    );
    
    // Hazard Detection Instantiation
    hazard_detection hazard_det (
        .is_imm(is_imm),
        .ST_or_BNE(ST_or_BNE),
        .src1_ID(src1_out),
        .src2_ID(src2_out),
        .dest_EXE(destIn),
        .WB_EN_EXE(WB_EN_MEM),
        .hazard_detected(hazard_detected_in)
    );

    // Forwarding Control Instantiation
    forwarding_EXE forwarding_unit (
        .src1(src1_out),
        .src2(src2_out),
        .ST_src_ID(src2_out),
        .dest_ID(destIn),
        .WB_EN(WB_EN_MEM),
        .val1_sel(val1_sel),
        .val2_sel(val2_sel),
        .ST_val_sel(ST_val_sel)
        );

endmodule // TopLevel