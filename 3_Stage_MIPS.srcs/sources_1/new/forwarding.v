`include "defines.v"

module forwarding_EXE (
    input [`REG_FILE_ADDR_LEN-1:0] src1, src2,
    input [`REG_FILE_ADDR_LEN-1:0] ST_src_ID, // Source ID for store instruction
    input [`REG_FILE_ADDR_LEN-1:0] dest_ID,   // Destination ID of the last write-back
    input WB_EN,                               // Write Back Enable
    output reg val1_sel,                       // Forwarding for ALU input 1
    output reg val2_sel,                       // Forwarding for ALU input 2
    output reg ST_val_sel                       // Forwarding for store value
);

    always @(*) begin
        // Initialize selection signals to 0
        val1_sel = 0;
        val2_sel = 0;
        ST_val_sel = 0;

        // Determine forwarding control signals for ALU inputs
        if (WB_EN) begin
            if (src1 == dest_ID) val1_sel = 1; // Forward src1 from EX stage
            if (src2 == dest_ID) val2_sel = 1; // Forward src2 from EX stage
        end

        // Determine forwarding control signal for store value
        if (WB_EN && ST_src_ID == dest_ID) begin
            ST_val_sel = 1; // Forward the value for store operation
        end
    end

endmodule // forwarding_EXE