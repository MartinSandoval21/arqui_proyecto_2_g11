module pc(
    input clk,
    input reset,           // Reset
    input [7:0] new_addr,  // Literal
    input load,            // L_PC desde Control Unit
    output reg [7:0] addr  // Dirección actual
);

    // Estado inicial para simulación
    initial begin
        addr = 8'b00000000;
    end

    always @(posedge clk) begin
        if (reset) begin
            addr <= 8'b00000000;      // Reinicia PC a 0
        end else if (load) begin
            addr <= new_addr;         // Salto
        end else begin
            addr <= addr + 8'b1;      // Siguiente instrucción
        end
    end

endmodule
