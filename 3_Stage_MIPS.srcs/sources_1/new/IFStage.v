`include "C:\Users\pardh\OneDrive\Desktop\3_Stage_MIPS\5_Stage_MIPS.srcs\sources_1\new\defines.v"

module IFStage (
    input clk,
    input rst,
    input freeze,
    input hazard_detected_in,
    output reg is_imm,
    output reg [`WORD_LEN-1:0] PC,
    output reg MEM_R_EN,
    output reg MEM_W_EN,
    output reg WB_EN,
    output reg is_imm_out,
    output reg ST_or_BNE_out,
    output reg [1:0] branch_comm,
    output reg [`WORD_LEN-1:0] immediate,
    output reg [`REG_FILE_ADDR_LEN-1:0] src1, src2,
    output reg [`REG_FILE_ADDR_LEN-1:0] writeDest,
    output reg [`EXE_CMD_LEN-1:0] EXE_CMD,
    output reg [`WORD_LEN-1:0] reg1, reg2,
    input [`WORD_LEN-1:0] writeVal,
    input writeEn,
    input [`REG_FILE_ADDR_LEN-1:0] writeDest_reg
);
    wire CU2and, Cond2and;
    wire [1:0] CU2Cond;
    wire Is_Imm, ST_or_BNE;
    wire [`WORD_LEN-1:0] signExt2Mux;
    wire brTaken;
    wire [`WORD_LEN-1:0] adderIn1, adderOut, instruction;

    // Register File Instance
    wire [`WORD_LEN-1:0] reg2_in;

    // MUX for adder input
    mux #(.LENGTH(`WORD_LEN)) adderInput (
        .in1(32'd4),
        .in2(signExt2Mux),
        .sel(brTaken),
        .out(adderIn1)
    );

    // Adder for PC calculation
    adder add4 (
        .in1(adderIn1),
        .in2(PC),
        .out(adderOut)
    );

    // Instruction Memory
    instructionMem instructions (
        .rst(rst),
        .addr(PC),
        .instruction(instruction)
    );

    // Decode Unit
    controller controller (
        .opCode(instruction[31:26]),
        .func(instruction[5:0]),  
        .branchEn(CU2and),
        .EXE_CMD(EXE_CMD),
        .Branch_command(CU2Cond),
        .Is_Imm(Is_Imm),
        .ST_or_BNE(ST_or_BNE),
        .WB_EN(WB_EN),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .hazard_detected(hazard_detected_in)
    );

    // Register File
    regFile reg_file (
        .clk(clk),
        .rst(rst),
        .src1(instruction[25:21]),
        .src2(instruction[20:16]),
        .dest(writeDest_reg),
        .writeVal(writeVal),
        .writeEn(writeEn),
        .reg1(reg1),
        .reg2(reg2_in)
    );

    // Condition Checker
    conditionChecker conditionChecker (
        .reg1(reg1),
        .reg2(reg2),
        .cuBranchComm(CU2Cond),
        .brCond(Cond2and)
    );

    // MUX for write destination
    mux #(.LENGTH(`REG_FILE_ADDR_LEN)) mux_writeDest (
        .in1(instruction[15:11]),    // R-type instruction (rd)
        .in2(instruction[20:16]),    // I-type instruction (rt)
        .sel(ST_or_BNE),             // Select based on store or branch
        .out(writeDest)              // Write destination register
    );

    // MUX for immediate value selection
    mux #(.LENGTH(`WORD_LEN)) mux_val2 (
        .in1(reg2_in),
        .in2(signExt2Mux),
        .sel(Is_Imm),
        .out(immediate)
    );

    // Sign Extension
    signExtend signExtend(
        .in(instruction[15:0]),
        .out(signExt2Mux)
    );

    // MUX for src2
    mux #(.LENGTH(`REG_FILE_ADDR_LEN)) mux_src2 (
        .in1(5'b00000),                       // First input: zero
        .in2(instruction[20:16]),             // Second input: original src2_ID
        .sel(is_imm),                         // Selection signal: is_imm
        .out(src2)                            // Output of the MUX
    );

    assign brTaken = CU2and && Cond2and;

    // Combinatorial Logic Block
    always @* begin
        is_imm_out = Is_Imm;
        ST_or_BNE_out = ST_or_BNE;
        branch_comm = CU2Cond;
        immediate = signExt2Mux; 
        reg2 = reg2_in;
        src1 = instruction[25:21];
        // Ensure no other registers are assigned here
    end

    // Sequential Logic Block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 0;          // Reset PC
            MEM_R_EN <= 0;    // Reset memory read enable
            MEM_W_EN <= 0;    // Reset memory write enable
            WB_EN <= 0;       // Reset write back enable
            reg1 <= 0;        // Reset reg1
            writeDest <= 0;   // Reset write destination
            immediate <= 0;   // Reset immediate
            src2 <= 0;        // Reset src2
        end else if (!freeze) begin
            PC <= adderOut;   // Update PC with adder output
            // Update other control signals as necessary
        end
    end

endmodule // IFStage