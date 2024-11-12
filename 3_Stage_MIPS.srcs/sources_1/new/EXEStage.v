`include "defines.v"

 module EXEStage (
    input clk,
    input val1_sel,
    input val2_sel,
    input ST_val_sel,
    input [`EXE_CMD_LEN-1:0] EXE_CMD,
    input [`WORD_LEN-1:0] reg1,
    input [`WORD_LEN-1:0] immediate,
    input [`WORD_LEN-1:0] ALU_res_MEM,
    input [`WORD_LEN-1:0] reg2,
    output reg [`WORD_LEN-1:0] ALUResult,
    output reg [`WORD_LEN-1:0] ST_value_out
);

    wire [`WORD_LEN-1:0] ALU_val1, ALU_val2;

    // MUX to select the first ALU input
    mux #(.LENGTH(`WORD_LEN)) mux_val1 (
        .in1(reg1),
        .in2(ALU_res_MEM),
        .sel(val1_sel),
        .out(ALU_val1)
    );

    // MUX to select the second ALU input
    mux #(.LENGTH(`WORD_LEN)) mux_val2 (
        .in1(immediate),
        .in2(ALU_res_MEM),
        .sel(val2_sel),
        .out(ALU_val2)
    );

    // MUX to select the store value
    mux #(.LENGTH(`WORD_LEN)) mux_ST_value (
        .in1(reg2),
        .in2(ALU_res_MEM),
        .sel(ST_val_sel),
        .out(ST_value_out)
    );

    // ALU instantiation
    ALU ALU (
        .val1(ALU_val1),
        .val2(ALU_val2),
        .EXE_CMD(EXE_CMD),
        .aluOut(ALUResult)
    );

endmodule // EXEStage