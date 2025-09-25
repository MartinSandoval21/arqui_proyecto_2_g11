module data_memory(
    input clk,
    input reset,
    input [7:0] data_in,
    input [7:0] address,
    input write_enable,
    output reg [7:0] data_out
);

    reg [7:0] mem [0:255];

    initial begin
        $readmemb("mem.dat", mem);
    end

    // Lectura
    always @(*) begin
        data_out = mem[address];  // Siempre leer, reset no afecta lectura
    end

    // Escritura
    always @(posedge clk) begin
        if (reset) begin
            mem[address] <= 8'b00000000;  // Reset solo posición actual
        end else if (write_enable) begin
            mem[address] <= data_in;
        end
    end

endmodule