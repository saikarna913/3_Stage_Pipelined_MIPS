`include "defines.v"

module MEM_WB_Stage (
  input clk,
  input rst,
  input MEM_R_EN,
  input MEM_W_EN,
  input [`WORD_LEN-1:0] ALU_res,     // ALU result
  input [`WORD_LEN-1:0] ST_value,    // Store value for memory write
  output [`WORD_LEN-1:0] WB_res      // Final result for write-back
);

  // Intermediate wire for data read from memory
  wire [`WORD_LEN-1:0] dataMem_out;

  // Instantiation of the data memory module for memory access
  dataMem dataMem (
    .clk(clk),
    .rst(rst),
    .writeEn(MEM_W_EN),
    .readEn(MEM_R_EN),
    .address(ALU_res),
    .dataIn(ST_value),
    .dataOut(dataMem_out)
  );

  // Select the appropriate data for write-back (from memory or ALU)
  assign WB_res = (MEM_R_EN) ? dataMem_out : ALU_res;

endmodule // MEM_WB_Stage
