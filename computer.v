module computer(
    input clk,
    input reset
);

    // =============================================
    // SEÑALES PRINCIPALES
    // =============================================
    
    // Instruction Memory
    wire [7:0] pc_addr;
    wire [14:0] instruction;
    wire [6:0] opcode = instruction[14:8];
    wire [7:0] literal = instruction[7:0];
    
    // Control Unit
    wire ctrl_L_PC, ctrl_D_W;
    wire [1:0] ctrl_S_D, ctrl_S_A, ctrl_S_B;
    wire ctrl_L_A, ctrl_L_B;
    wire [3:0] ctrl_ALU_Sel;
    
    // ALU
    wire [7:0] alu_out;
    wire alu_Z, alu_N, alu_C, alu_V;
    
    // Status Register
    wire [3:0] status_flags;
    
    // Registros
    wire [7:0] regA_out, regB_out;
    
    // Memorias y Muxes
    wire [7:0] muxA_out, muxB_out, muxData_out;
    wire [7:0] data_mem_out;
    
    // Señales constantes
    wire [7:0] zero = 8'b00000000;
    wire [7:0] one = 8'b00000001;

    // =============================================
    // MÓDULOS
    // =============================================

    // 1. PROGRAM COUNTER
    pc ProgramCounter(
        .clk(clk),
        .reset(reset),
        .new_addr(literal),
        .load(ctrl_L_PC),
        .addr(pc_addr)
    );

    // 2. INSTRUCTION MEMORY
    instruction_memory InstructionMemory(
        .address(pc_addr),
        .out(instruction)
    );

    // 3. CONTROL UNIT
    control_unit ControlUnit(
        .opcode(opcode),
        .status_flags(status_flags),
        .L_PC(ctrl_L_PC),
        .D_W(ctrl_D_W),
        .S_D(ctrl_S_D),
        .L_A(ctrl_L_A),
        .L_B(ctrl_L_B),
        .S_A(ctrl_S_A),
        .S_B(ctrl_S_B),
        .ALU_Sel(ctrl_ALU_Sel)
    );

    // 4. DATA MEMORY
    data_memory DataMemory(
        .clk(clk),
        .reset(reset),
        .data_in(alu_out),
        .address(muxData_out),
        .write_enable(ctrl_D_W),
        .data_out(data_mem_out)
    );

    // 5. MUX DATA
    muxData MuxData(
        .lit(literal),
        .regB(regB_out),
        .sel(ctrl_S_D[0]),
        .out(muxData_out)
    );

    // 6. regA
    regA regA(
        .clk(clk),
        .reset(reset),
        .data_in(alu_out),
        .load(ctrl_L_A),
        .out(regA_out)
    );
    // 7. regB
    regB regB(
        .clk(clk),
        .reset(reset),
        .data_in(alu_out),
        .load(ctrl_L_B),
        .out(regB_out)
    );

    // 8. MUX A
    muxA MuxA(
        .regA(regA_out),
        .regB(regB_out),
        .zero(zero),
        .one(one),
        .sel(ctrl_S_A),
        .out(muxA_out)
    );

    // 9. MUX B
    muxB MuxB(
        .regB(regB_out),
        .datam(data_mem_out),
        .lit(literal),
        .zero(zero),
        .sel(ctrl_S_B),
        .out(muxB_out)
    );

    // 10. ALU
    alu ALU(
        .A(muxA_out),
        .B(muxB_out),
        .ALU_Sel(ctrl_ALU_Sel),
        .Result(alu_out),
        .Z(alu_Z),
        .N(alu_N),
        .C(alu_C),
        .V(alu_V)
    );

    // 11. STATUS
    status Status(
        .clk(clk),
        .reset(reset),
        .flags_in({alu_Z, alu_N, alu_C, alu_V}),
        .flags_out(status_flags)
    );

endmodule