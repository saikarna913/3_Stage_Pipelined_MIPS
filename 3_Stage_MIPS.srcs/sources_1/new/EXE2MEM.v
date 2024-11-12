`include "defines.v"

module EXE2MEM (
    input clk,
    input rst,
    input WB_EN_IN,
    input MEM_R_EN_IN,
    input MEM_W_EN_IN,
    input [`WORD_LEN-1:0] ALUResIn,
    input [`WORD_LEN-1:0] STValIn,
    input [`REG_FILE_ADDR_LEN-1:0] destIn,
    output reg WB_EN,
    output reg MEM_R_EN,
    output reg MEM_W_EN,
    output reg [`WORD_LEN-1:0] ALURes,
    output reg [`WORD_LEN-1:0] STVal,
    output reg [`REG_FILE_ADDR_LEN-1:0] dest
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      WB_EN <= 0;
      MEM_R_EN <= 0;
      MEM_W_EN <= 0;
      ALURes <= 0;
      STVal <= 0;
      dest <= 0;
    end else begin
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      MEM_W_EN <= MEM_W_EN_IN;
      ALURes <= ALUResIn;
      STVal <= STValIn;
      dest <= destIn;
    end
  end
endmodule // EXE2MEM