module regB(
    input clk,             // Señal de reloj  
    input reset,           // Reset síncrono
    input [7:0] data_in,   // Dato de entrada (Desde ALU)
    input load,            // Señal de carga (L_B desde Control Unit)
    output reg [7:0] out   // Salida del registro
);

    // Estado inicial
    initial begin
        out = 8'b00000000;
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000000;   // Reinicia a 0
        end else if (load) begin
            out <= data_in;       // Cargar nuevo valor
        end
        // Si reset=0 y load=0 → mantiene el valor actual
    end
endmodule
