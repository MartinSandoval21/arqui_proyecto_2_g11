module control_unit(
    input [6:0] opcode,        // 7 bits de opcode desde instruction_memory[14:8]
    input [3:0] status_flags,   // {Z, N, C, V} desde Status
    output reg L_PC,           // Load Program Counter
    output reg D_W,            // Data Write (escritura en memoria)
    output reg [0:0] S_D,     // Selector Mux Data
    output reg L_A,            // Load Register A 
    output reg L_B,            // Load Register B 
    output reg [1:0] S_A,      // Selector Mux A 
    output reg [1:0] S_B,      // Selector Mux B 
    output reg [3:0] ALU_Sel   // Operación ALU (4 bits) REVISAR
);
    wire Z = status_flags[3];
    wire N = status_flags[2];
    wire C = status_flags[1]; 
    wire V = status_flags[0];

    always @(*) begin
        // Valores por defecto
        L_PC = 1'b0;
        D_W = 1'b0;
        S_D = 1'b00;
        L_A = 1'b0;
        L_B = 1'b0;
        S_A = 2'b00;
        S_B = 2'b00;
        ALU_Sel = 4'b0000;

        case(opcode)
            // === INSTRUCCIONES BÁSICAS ===
            // MOV (A,B) A=B
            7'b0000000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b00;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b10;
                S_B = 2'b00;
                ALU_Sel = 4'b0000;
            end

            // ADD (A,Dir) A=A+Mem[Lit]
            7'b0101100: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 4'b0000;
            end
            
            // SUB (A,Dir) A=A-Mem[Lit]
            7'b0110000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 4'b0001;
            end

            // AND (A,Dir) A=A and Mem[Lit]
            7'b0110100: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 4'b0010;
            end

            // OR (A,Dir) A=A or Mem[Lit]
            7'b0111000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 4'b0011; // NOT
            end

            // NOT (Dir,A) Mem[Lit] = -A
            7'b0111100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b11; // cualquier valor (zero)
                ALU_Sel = 4'b0101; // NOT
            end

            // XOR (A,Dir) A = A xor Mem[Lit]
            7'b0111111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0; // 0
                S_D = 1'b0; // Lit
                L_A = 1'b1; // 1
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 4'b0100; // XOR
            end

            // SHL (Dir,A) Mem[Lit]= shift left A
            7'b1000011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b11; // cualquier valor (zero)
                ALU_Sel = 4'b0110; // SHL
            end

            // INC (Dir) Mem[Lit]= Mem[Lit] + 1
            7'b1001001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b11; // U
                S_B = 2'b01; // Mem
                ALU_Sel = 4'b0000; // +
            end

            // RST (Dir) Mem[Lit]= 0
            7'b1001011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b10; // ZERO
                S_B = 2'b11; // ZERO
                ALU_Sel = 4'b0000; // +
            end

            
            // === INSTRUCCIONES CON DIRECCIONAMIENTO ===
            // === INSTRUCCIONES DE SALTO ===
            

        endcase
    end

endmodule