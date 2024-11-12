`timescale 1ns / 1ps
`include "C:\Users\pardh\OneDrive\Desktop\3_Stage_MIPS\5_Stage_MIPS.srcs\sources_1\new\defines.v" // Make sure this file is included for definitions

module TopLevel_tb;

    // Parameters
    reg clk;
    reg rst;
    reg freeze;

    // Outputs from the TopLevel
    wire [`WORD_LEN-1:0] PC_out;
    wire WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM;
    wire [`WORD_LEN-1:0] WB_res;

    // Instantiate the TopLevel module
    TopLevel uut (
        .clk(clk),
        .rst(rst),
        .freeze(freeze)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        rst = 1;
        freeze = 0;

        // Reset the system
        #10;
        rst = 0; // Release reset
        #10;

        // Test Case 1: Normal operation without hazards
        // Assume PC is initialized and we load some instructions
        // Example MIPS instructions:
        // LW $t0, 0($t1)   // Load word from address in $t1 into $t0
        // ADD $t2, $t0, $t3 // Add $t0 and $t3, store in $t2

        // Initialize instruction memory (assumed to be part of TopLevel)
        // For simplicity, we assume some mechanism to load instructions
        // Load first instruction: LW $t0, 0($t1)
        // Load second instruction: ADD $t2, $t0, $t3
        
        // Example sequence: Assuming instructions are loaded in a certain way
        // You may need to adapt this according to your architecture

        // Wait for a few clock cycles to observe behavior
        #100;

        // Test Case 2: Introduce a data hazard
        // Sequence: LW $t0, 0($t1)
        //           ADD $t1, $t0, $t2  // This should create a hazard
        //           SUB $t4, $t1, $t5  // Another instruction dependent on $t1

        // Load instructions that create a data hazard
        // Assuming we have a way to inject these instructions into the pipeline

        // Test Case 3: Introduce control hazards
        // Example sequence:
        // BEQ $t0, $t1, label  // Branch instruction
        // ADD $t2, $t0, $t3    // This should stall if the branch is taken
        // label: SUB $t4, $t1, $t5

        // Finish simulation
        #200; // Wait for additional clock cycles
        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %0t | PC_out: %h | WB_res: %h | WB_EN_MEM: %b | MEM_R_EN_MEM: %b | MEM_W_EN_MEM: %b", 
                 $time, PC_out, WB_res, WB_EN_MEM, MEM_R_EN_MEM, MEM_W_EN_MEM);
    end

endmodule