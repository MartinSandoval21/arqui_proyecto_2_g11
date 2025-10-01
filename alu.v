module alu (
    input [7:0] A,          // Entrada Mux A
    input [7:0] B,          // Entrada Mux B
    input [2:0] ALU_Sel,     // Selector de operacion
    output reg [7:0] Result,
    output reg Z, N, C, V    // Flags: Zero, Negative, Carry, Overflow
);

    always @(*) begin
        // Valores por defecto
        Result = 8'b0;
        Z = 0; N = 0; C = 0; V = 0;

        case(ALU_Sel)
            3'b000: {C, Result} = A + B;           // ADD
            3'b001: {C, Result} = A - B;           // SUB
            3'b010: Result = A & B;                // AND
            3'b011: Result = A | B;                // OR
            3'b100: Result = A ^ B;                // XOR
            3'b101: Result = ~A;                   // NOT A
            3'b110: {C, Result} = {A[6:0], 1'b0};  // SHL
            3'b111: {Result, C} = {1'b0, A[6:0]};  // SHR
            default: Result = 8'b0;
        endcase

        // Flags comunes
        Z = (Result == 8'b0);
        N = Result[7];

        // Overflow solo para operaciones aritméticas
        if (ALU_Sel == 3'b000) begin          // ADD
            V = (A[7] == B[7]) && (Result[7] != A[7]);
        end else if (ALU_Sel == 3'b001) begin // SUB
            V = (A[7] != B[7]) && (Result[7] != A[7]);
        end
    end

endmodule