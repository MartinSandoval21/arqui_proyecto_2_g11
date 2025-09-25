module muxB(
    input [7:0] regB,      // Valor del registro B
    input [7:0] datam,      // Valor del Data Memory
    input [7:0] lit,      // Valor del Literal
    input [7:0] zero,      // Señal Z (8 bits de 0)
    input [1:0] sel,       // Selector S_B
    output reg [7:0] out   // Salida al puerto B de la ALU
);

    always @(*) begin
        case(sel)
            2'b00: out = regB;      // Pasar registro B
            2'b01: out = datam;      // Pasar Data Memory
            2'b10: out = lit;      // Pasar Literal
            2'b11: out = zero;       // Pasar cero (Z)
            default: out = zero;     // Por defecto cero
        endcase
    end
endmodule