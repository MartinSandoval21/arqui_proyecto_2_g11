module control_unit(
    input [6:0] opcode,        // 7 bits de opcode desde instruction_memory[14:8]
    input [3:0] status_flags,   // {Z, N, C, V} desde Status
    output reg L_PC,           // Load Program Counter
    output reg D_W,            // Data Write (escritura en memoria)
    output reg [1:0] S_D,     // Selector Mux Data
    output reg L_A,            // Load Register A r
    output reg L_B,            // Load Register B r
    output reg [1:0] S_A,      // Selector Mux A r
    output reg [1:0] S_B,      // Selector Mux B r
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
        S_D = 2'b00;
        L_A = 1'b0;
        L_B = 1'b0;
        S_A = 2'b00;
        S_B = 2'b00;
        ALU_Sel = 4'b0000;

        case(opcode)
            // === INSTRUCCIONES BÁSICAS ===
            // === INSTRUCCIONES CON DIRECCIONAMIENTO ===
            // === INSTRUCCIONES DE SALTO ===
            

        endcase
    end

endmodule