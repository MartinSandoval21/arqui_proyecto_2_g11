module muxA(
    input [7:0] regA,      // Valor del registro A
    input [7:0] regB,      // Valor del registro B
    input [7:0] zero,      // Señal Z (8 bits de 0)
    input [7:0] one,       // Señal U (8 bits de 1)
    input [1:0] sel,       // Selector S_A
    output reg [7:0] out   // Salida al puerto A de la ALU
);

    always @(*) begin
        case(sel)
            2'b00: out = regA;      // Pasar registro A
            2'b01: out = regB;      // Pasar registro B
            2'b10: out = zero;      // Pasar cero (Z)
            2'b11: out = one;       // Pasar uno (U)
            default: out = zero;     // Por defecto cero
        endcase
    end
endmodule