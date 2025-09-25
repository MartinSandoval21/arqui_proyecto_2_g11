module test;
    reg clk = 0;
    computer Comp(.clk(clk), .reset(1'b0));  // Reset opcional

    initial begin
        $dumpfile("out/dump.vcd");
        $dumpvars(0, test);

        // Cargar programa en memoria de instrucciones
        $readmemb("im.dat", Comp.InstructionMemory.mem);

        // Mostrar contenido de memoria
        $display("=== CONTENIDO DE MEMORIA ===");
        $display("mem[0] = %b", Comp.InstructionMemory.mem[0]);
        $display("mem[1] = %b", Comp.InstructionMemory.mem[1]);
        $display("mem[2] = %b", Comp.InstructionMemory.mem[2]);
        $display("mem[3] = %b", Comp.InstructionMemory.mem[3]);

        // Monitor de señales principales
        $monitor("Tiempo %t: PC=0x%h, Opcode=%b, Literal=0x%h, RegA=0x%h, RegB=0x%h, ALU=0x%h",
                 $time, 
                 Comp.pc_addr, 
                 Comp.opcode,
                 Comp.literal,
                 Comp.regA_out,
                 Comp.regB_out,
                 Comp.alu_out);

        // Esperar a que PC llegue a 4 o timeout
        #200;
        $display("=== SIMULACIÓN COMPLETADA ===");
        $finish;
    end

    always #5 clk = ~clk;  // Reloj más lento para ver mejor
endmodule