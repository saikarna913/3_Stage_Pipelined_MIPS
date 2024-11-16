# 3 stage pipelined MIPS processor
Developed in the Computer Architecture course, this project implements a 3 stage pipelined MIPS processor featuring hazard detection and forwarding.   
![Untitled Diagram drawio (8)](https://github.com/user-attachments/assets/d351df12-bafd-40cb-b76a-7141539cec03)


**Getting Started**

To run it, compile the Verilog files and run testbench.v in a Verilog simulation environment such as vivado.

**Instruction format**

Instructions should be provided to the instruction memory in reset time. The instruction memory cells are 32 bits long, whereas each instruction is 32 bits long. Therefore, each instruction takes up one memory cell, as shown bellow.

For example, an add instruction: `10000000001000000000000000001010` or `Addi r1,r0,10` will need to be given as

```
   mem[0]  = 32'b00000001001010100100000000100000;
```

**Forwarding:**

An instance of the top-level circuit is taken in `testbench.v`. The inputs of the  `MIPS_Processor`  include `clk`, `rst`. 

**Under the hood**

There are Three pipeline stages:

1. Instruction Fetch
2. Execution
3. Write Back

**Modular design**

For the best understanding of the code check this repo: https://github.com/saikarna913/3_STAGE_PIPELINE_MIPS

All modules are organized within the `modules` directory. The main description of the design is located in the `topLevelCircuit.v` file. This file outlines a modular processor design, integrating all three pipeline stages and two pipeline registers. The details of the pipeline stages and registers are provided in the `modules/pipeStages` and `modules/pipeRegisters` directories, respectively. Additionally, the `topLevelCircuit.v` file instantiates the register file, hazard detection unit, and forwarding unit. Each pipeline stage is constructed from and encapsulates various supporting modules.

**Constants**

`defines.v` contains project-wide constants for **opcodes**, **execution**, and **branch condition commands**. It also contains constants for wire widths and memory specifications.

**Wire naming convention**

To maintain understanbility, most wire names follow the format {wire description}_{wire stage/wire property}, where the second part describes the stage where the wire is located. For example, `MEM_W_EN` is the memory write enable signal.
