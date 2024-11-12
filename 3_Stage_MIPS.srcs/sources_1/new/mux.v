`include "defines.v"

module mux #(parameter integer LENGTH = 8) (in1, in2, sel, out); // Default value for LENGTH
  input sel;
  input [LENGTH-1:0] in1, in2;
  output [LENGTH-1:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule // mux

module mux_3input #(parameter integer LENGTH = 8) (in1, in2, in3, sel, out); // Default value for LENGTH
  input [LENGTH-1:0] in1, in2, in3;
  input [1:0] sel;
  output [LENGTH-1:0] out;

  assign out = (sel == 2'd0) ? in1 :
               (sel == 2'd1) ? in2 : in3;
endmodule // mux_3input
