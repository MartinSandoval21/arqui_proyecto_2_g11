module alu (
    input [7:0] A,          // Entrada Mux A
    input [7:0] B,          // Entrada Mux B
    input [3:0] ALU_Sel,     // Selector de operacion
    output reg [7:0] Result,
    output reg Z, N, C, V    // Flags: Zero, Negative, Carry, Overflow
);

    always @(*) begin
        // Valores por defecto
        Result = 8'b0;
        Z = 0; N = 0; C = 0; V = 0;

        case(ALU_Sel)
            4'b0000: {C, Result} = A + B;           // ADD
            4'b0001: {C, Result} = A - B;           // SUB
            4'b0010: Result = A & B;                // AND
            4'b0011: Result = A | B;                // OR
            4'b0100: Result = A ^ B;                // XOR
            4'b0101: Result = ~A;                   // NOT A
            4'b0110: {C, Result} = {A[6:0], 1'b0};  // SHL
            4'b0111: {Result, C} = {1'b0, A[7:1]};  // SHR
            4'b1000: {C, Result} = A + 8'b1;        // INC
            4'b1001: {C, Result} = A - B;           // CMP (solo flags)
            default: Result = 8'b0;
        endcase

        // Flags comunes
        Z = (Result == 8'b0);
        N = Result[7];

        // Overflow solo para operaciones aritméticas
        if (ALU_Sel == 4'b0000) begin          // ADD
            V = (A[7] == B[7]) && (Result[7] != A[7]);
        end else if (ALU_Sel == 4'b0001) begin // SUB
            V = (A[7] != B[7]) && (Result[7] != A[7]);
        end
    end

endmodule