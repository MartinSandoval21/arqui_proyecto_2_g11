module regA(
    input clk,             // Señal de reloj
    input reset,           // Reset
    input [7:0] data_in,   // Dato de entrada (desde ALU)
    input load,            // Señal de carga (L_A desde Control Unit)
    output reg [7:0] out   // Salida del registro
);

    // Estado inicial
    initial begin
        out = 8'b00000000;
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000000;   // Reinicia el registro a 0
        end else if (load) begin
            out <= data_in;       // Cargar nuevo valor
        end
        // Si reset=0 y load=0 → mantiene valor actual
    end
endmodule
