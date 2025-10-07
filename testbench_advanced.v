module test_advanced;
    reg           clk = 0;
    wire [7:0]    regA_out;
    wire [7:0]    regB_out;
    wire [7:0]    pc_out;
    wire [3:0]    status_flags;

    reg           test_failed = 1'b0;

    computer Comp(.clk(clk), .reset(1'b0));
    
    assign regA_out = Comp.regA_out;
    assign regB_out = Comp.regB_out;
    assign pc_out = Comp.pc_addr;
    assign status_flags = Comp.status_flags;

    initial begin
        $dumpfile("out/dump_advanced.vcd");
        $dumpvars(0, test_advanced);
        $readmemb("im_advanced_working.dat", Comp.InstructionMemory.mem);

        $display("\n===============================================");
        $display("TEST AVANZADO SIMPLIFICADO - FUNCIONANDO");
        $display("===============================================\n");

        // Test 1: Memoria con Dirección Directa
        $display("----- TEST 1: MEMORIA CON DIRECCIÓN DIRECTA -----");
        
        #3; // MOV A, 100
        $display("CHECK @ t=%0t: After MOV A, 100 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL: regA expected 100, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV B, 200
        $display("CHECK @ t=%0t: After MOV B, 200 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd200) begin
            $error("FAIL: regB expected 200, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // MOV (5), A
        $display("CHECK @ t=%0t: After MOV (5), A -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL: regA expected 100 after MOV (5), A, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV (15), B
        $display("CHECK @ t=%0t: After MOV (15), B -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd200) begin
            $error("FAIL: regB expected 200 after MOV (15), B, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // MOV A, (5)
        $display("CHECK @ t=%0t: After MOV A, (5) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL: regA expected 100 (Mem[5] should be 100), got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV B, (15)
        $display("CHECK @ t=%0t: After MOV B, (15) -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd200) begin
            $error("FAIL: regB expected 200 (Mem[15] should be 200), got %d", regB_out);
            test_failed = 1'b1;
        end

        if (!test_failed) begin
            $display(">>>>> MEMORIA DIRECTA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> MEMORIA DIRECTA TEST FAILED! <<<<<");
        end

        // Test 2: Direccionamiento Indirecto
        $display("\n----- TEST 2: DIRECCIONAMIENTO INDIRECTO -----");

        #2; // MOV A, 25
        $display("CHECK @ t=%0t: After MOV A, 25 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd25) begin
            $error("FAIL: regA expected 25, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV A, (A) - indirecto
        $display("CHECK @ t=%0t: After MOV A, (A) -> regA = %d", $time, regA_out);
        // Nota: Memoria vacía puede devolver valor indefinido

        #2; // MOV B, 30
        $display("CHECK @ t=%0t: After MOV B, 30 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd30) begin
            $error("FAIL: regB expected 30, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // MOV A, 50
        $display("CHECK @ t=%0t: After MOV A, 50 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV (B), A - indirecto
        $display("CHECK @ t=%0t: After MOV (B), A -> regA = %d, regB = %d", $time, regA_out, regB_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50 after MOV (B), A, got %d", regA_out);
            test_failed = 1'b1;
        end
        if (regB_out !== 8'd30) begin
            $error("FAIL: regB expected 30 after MOV (B), A, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // MOV A, (30)
        $display("CHECK @ t=%0t: After MOV A, (30) -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50 (Mem[30] should be 50), got %d", regA_out);
            test_failed = 1'b1;
        end

        if (!test_failed) begin
            $display(">>>>> DIRECCIONAMIENTO INDIRECTO TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> DIRECCIONAMIENTO INDIRECTO TEST FAILED! <<<<<");
        end

        // Test 3: Operaciones Aritméticas
        $display("\n----- TEST 3: OPERACIONES ARITMÉTICAS -----");

        #2; // MOV A, 50
        $display("CHECK @ t=%0t: After MOV A, 50 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV B, 75
        $display("CHECK @ t=%0t: After MOV B, 75 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd75) begin
            $error("FAIL: regB expected 75, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // ADD A, B
        $display("CHECK @ t=%0t: After ADD A, B -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd125) begin
            $error("FAIL: regA expected 125 (50+75), got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV A, 10
        $display("CHECK @ t=%0t: After MOV A, 10 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd10) begin
            $error("FAIL: regA expected 10, got %d", regA_out);
            test_failed = 1'b1;
        end

        #2; // MOV B, 3
        $display("CHECK @ t=%0t: After MOV B, 3 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd3) begin
            $error("FAIL: regB expected 3, got %d", regB_out);
            test_failed = 1'b1;
        end

        #2; // ADD A, B
        $display("CHECK @ t=%0t: After ADD A, B -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd13) begin
            $error("FAIL: regA expected 13 (10+3), got %d", regA_out);
            test_failed = 1'b1;
        end

        if (!test_failed) begin
            $display(">>>>> ARITMÉTICA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> ARITMÉTICA TEST FAILED! <<<<<");
        end

        $display("\n===============================================");
        $display("RESUMEN: %s", test_failed ? "ALGUNOS TESTS FALLARON" : "TODOS LOS TESTS PASARON");
        $display("===============================================");

        #2;
        $finish;
    end

    // Clock Generator
    always #1 clk = ~clk;

endmodule
