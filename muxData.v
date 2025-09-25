module muxData(
    input [7:0] lit,      // Valor del Literal
    input [7:0] regB,      // Valor del registro B
    input [0:0] sel,       // Selector S_D
    output reg [7:0] out   // Salida al puerto Adress Data Memory
);

    always @(*) begin
        case(sel)
            1'b0: out = lit;      // Pasar Literal
            1'b1: out = regB;      // Pasar registro B
            default: out = regB;     // Por defecto registro B
        endcase
    end
endmodule