module status(
    input clk,              // Reloj
    input reset,            // Reset
    input [3:0] flags_in,   // Flags desde la ALU: {Z, N, C, V}
    output reg [3:0] flags_out // Flags hacia Control Unit: {Z, N, C, V}
);

    // Estado inicial
    initial begin
        flags_out = 4'b0000;
    end

    always @(posedge clk) begin
        if (reset) begin
            flags_out <= 4'b0000;  // Reinicia todas las banderas
        end else begin
            flags_out <= flags_in; // Actualiza banderas desde ALU
        end
    end

endmodule
