`include "defines.v"

module hazard_detection(
    input [`REG_FILE_ADDR_LEN-1:0] src1_ID, src2_ID,
    input [`REG_FILE_ADDR_LEN-1:0] dest_EXE,
    input WB_EN_EXE, is_imm, ST_or_BNE,
    output hazard_detected
);
    
    wire src2_is_valid, exe_has_hazard;

    assign src2_is_valid = (~is_imm) || ST_or_BNE;

    // Hazard detection for the EX stage
    assign exe_has_hazard = WB_EN_EXE && 
                            (src1_ID == dest_EXE || (src2_is_valid && src2_ID == dest_EXE));
    
    assign hazard_detected = exe_has_hazard;

endmodule // hazard_detection