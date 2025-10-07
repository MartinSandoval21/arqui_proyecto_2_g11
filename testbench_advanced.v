module test_advanced;
    reg           clk = 0;
    wire [7:0]    regA_out;
    wire [7:0]    regB_out;
    wire [7:0]    pc_out;
    wire [3:0]    status_flags;

    reg           memory_test_failed = 1'b0;
    reg           addressing_test_failed = 1'b0;
    reg           arithmetic_memory_test_failed = 1'b0;
    reg           logical_memory_test_failed = 1'b0;
    reg           shift_memory_test_failed = 1'b0;
    reg           inc_rst_test_failed = 1'b0;
    reg           compare_test_failed = 1'b0;
    reg           jump_test_failed = 1'b0;
    reg           conditional_jump_test_failed = 1'b0;
    reg           complex_sequence_test_failed = 1'b0;

    // ------------------------------------------------------------
    // IMPORTANTE!! Editar con el modulo de su computador
    // ------------------------------------------------------------
    computer Comp(.clk(clk), .reset(1'b0));
    // ------------------------------------------------------------

    // ------------------------------------------------------------
    // IMPORTANTE!! Editar para que la variable apunte a la salida
    // de los registros de su computador.
    // ------------------------------------------------------------
    assign regA_out = Comp.regA_out;
    assign regB_out = Comp.regB_out;
    assign pc_out = Comp.pc_addr;
    assign status_flags = Comp.status_flags;
    // ------------------------------------------------------------

    initial begin
        $dumpfile("out/dump_advanced.vcd");
        $dumpvars(0, test_advanced);
        $readmemb("im_advanced.dat", Comp.InstructionMemory.mem);

        $display("\n===============================================");
        $display("INICIANDO PRUEBAS DE INSTRUCCIONES AVANZADAS");
        $display("===============================================\n");

        // --- Test 1: Instrucciones de Memoria con Dirección Directa ---
        $display("----- TEST 1: MEMORIA CON DIRECCIÓN DIRECTA -----");
        
        #3; // MOV A, 100
        $display("CHECK @ t=%0t: After MOV A, 100 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL: regA expected 100, got %d", regA_out);
            memory_test_failed = 1'b1;
        end

        #2; // MOV B, 200
        $display("CHECK @ t=%0t: After MOV B, 200 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd200) begin
            $error("FAIL: regB expected 200, got %d", regB_out);
            memory_test_failed = 1'b1;
        end

        #2; // MOV A, (10) - A = Mem[10]
        $display("CHECK @ t=%0t: After MOV A, (10) -> regA = %d", $time, regA_out);
        // Nota: El valor en Mem[10] depende de la inicialización de la memoria

        #2; // MOV B, (20) - B = Mem[20]
        $display("CHECK @ t=%0t: After MOV B, (20) -> regB = %d", $time, regB_out);

        #2; // MOV (5), A - Mem[5] = A
        $display("CHECK @ t=%0t: After MOV (5), A -> regA = %d", $time, regA_out);

        #2; // MOV (15), B - Mem[15] = B
        $display("CHECK @ t=%0t: After MOV (15), B -> regB = %d", $time, regB_out);

        if (!memory_test_failed) begin
            $display(">>>>> MEMORIA DIRECTA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> MEMORIA DIRECTA TEST FAILED! <<<<<");
        end

        // --- Test 2: Direccionamiento Indirecto ---
        $display("\n----- TEST 2: DIRECCIONAMIENTO INDIRECTO -----");

        #2; // MOV A, 25
        $display("CHECK @ t=%0t: After MOV A, 25 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd25) begin
            $error("FAIL: regA expected 25, got %d", regA_out);
            addressing_test_failed = 1'b1;
        end

        #2; // MOV A, (A) - A = Mem[A] = Mem[25]
        $display("CHECK @ t=%0t: After MOV A, (A) -> regA = %d", $time, regA_out);

        #2; // MOV B, 30
        $display("CHECK @ t=%0t: After MOV B, 30 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd30) begin
            $error("FAIL: regB expected 30, got %d", regB_out);
            addressing_test_failed = 1'b1;
        end

        #2; // MOV (B), A - Mem[B] = Mem[30] = A
        $display("CHECK @ t=%0t: After MOV (B), A -> regA = %d, regB = %d", $time, regA_out, regB_out);

        if (!addressing_test_failed) begin
            $display(">>>>> DIRECCIONAMIENTO INDIRECTO TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> DIRECCIONAMIENTO INDIRECTO TEST FAILED! <<<<<");
        end

        // --- Test 3: Operaciones Aritméticas con Memoria ---
        $display("\n----- TEST 3: OPERACIONES ARITMÉTICAS CON MEMORIA -----");

        #2; // MOV A, 50
        $display("CHECK @ t=%0t: After MOV A, 50 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50, got %d", regA_out);
            arithmetic_memory_test_failed = 1'b1;
        end

        #2; // MOV B, 75
        $display("CHECK @ t=%0t: After MOV B, 75 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd75) begin
            $error("FAIL: regB expected 75, got %d", regB_out);
            arithmetic_memory_test_failed = 1'b1;
        end

        #2; // ADD (A, Dir) - A = A + Mem[40]
        $display("CHECK @ t=%0t: After ADD (A, Dir) -> regA = %d", $time, regA_out);

        #2; // ADD (B, Dir) - B = B + Mem[50]
        $display("CHECK @ t=%0t: After ADD (B, Dir) -> regB = %d", $time, regB_out);

        #2; // ADD (A, B) - A = A + Mem[B]
        $display("CHECK @ t=%0t: After ADD (A, B) -> regA = %d", $time, regA_out);

        #2; // ADD (Dir) - Mem[60] = A + B
        $display("CHECK @ t=%0t: After ADD (Dir) -> regA = %d, regB = %d", $time, regA_out, regB_out);

        if (!arithmetic_memory_test_failed) begin
            $display(">>>>> ARITMÉTICA CON MEMORIA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> ARITMÉTICA CON MEMORIA TEST FAILED! <<<<<");
        end

        // --- Test 4: Operaciones Lógicas con Memoria ---
        $display("\n----- TEST 4: OPERACIONES LÓGICAS CON MEMORIA -----");

        #2; // MOV A, 170 (10101010)
        $display("CHECK @ t=%0t: After MOV A, 170 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd170) begin
            $error("FAIL: regA expected 170, got %d", regA_out);
            logical_memory_test_failed = 1'b1;
        end

        #2; // MOV B, 85 (01010101)
        $display("CHECK @ t=%0t: After MOV B, 85 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd85) begin
            $error("FAIL: regB expected 85, got %d", regB_out);
            logical_memory_test_failed = 1'b1;
        end

        #2; // AND (A, Dir) - A = A & Mem[70]
        $display("CHECK @ t=%0t: After AND (A, Dir) -> regA = %d", $time, regA_out);

        #2; // OR (B, Dir) - B = B | Mem[80]
        $display("CHECK @ t=%0t: After OR (B, Dir) -> regB = %d", $time, regB_out);

        #2; // XOR (A, B) - A = A ^ Mem[B]
        $display("CHECK @ t=%0t: After XOR (A, B) -> regA = %d", $time, regA_out);

        if (!logical_memory_test_failed) begin
            $display(">>>>> LÓGICAS CON MEMORIA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> LÓGICAS CON MEMORIA TEST FAILED! <<<<<");
        end

        // --- Test 5: Instrucciones de Desplazamiento con Memoria ---
        $display("\n----- TEST 5: DESPLAZAMIENTO CON MEMORIA -----");

        #2; // MOV A, 8 (00001000)
        $display("CHECK @ t=%0t: After MOV A, 8 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd8) begin
            $error("FAIL: regA expected 8, got %d", regA_out);
            shift_memory_test_failed = 1'b1;
        end

        #2; // SHL (Dir, A) - Mem[90] = A << 1
        $display("CHECK @ t=%0t: After SHL (Dir, A) -> regA = %d", $time, regA_out);

        #2; // MOV B, 16 (00010000)
        $display("CHECK @ t=%0t: After MOV B, 16 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd16) begin
            $error("FAIL: regB expected 16, got %d", regB_out);
            shift_memory_test_failed = 1'b1;
        end

        #2; // SHR (Dir, B) - Mem[100] = B >> 1
        $display("CHECK @ t=%0t: After SHR (Dir, B) -> regB = %d", $time, regB_out);

        if (!shift_memory_test_failed) begin
            $display(">>>>> DESPLAZAMIENTO CON MEMORIA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> DESPLAZAMIENTO CON MEMORIA TEST FAILED! <<<<<");
        end

        // --- Test 6: Instrucciones de Incremento y Reset ---
        $display("\n----- TEST 6: INCREMENTO Y RESET -----");

        #2; // INC (Dir) - Mem[110] = Mem[110] + 1
        $display("CHECK @ t=%0t: After INC (Dir) -> regA = %d, regB = %d", $time, regA_out, regB_out);

        #2; // INC (B) - Mem[B] = Mem[B] + 1
        $display("CHECK @ t=%0t: After INC (B) -> regA = %d, regB = %d", $time, regA_out, regB_out);

        #2; // RST (Dir) - Mem[120] = 0
        $display("CHECK @ t=%0t: After RST (Dir) -> regA = %d, regB = %d", $time, regA_out, regB_out);

        #2; // RST (B) - Mem[B] = 0
        $display("CHECK @ t=%0t: After RST (B) -> regA = %d, regB = %d", $time, regA_out, regB_out);

        if (!inc_rst_test_failed) begin
            $display(">>>>> INCREMENTO Y RESET TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> INCREMENTO Y RESET TEST FAILED! <<<<<");
        end

        // --- Test 7: Instrucciones de Comparación ---
        $display("\n----- TEST 7: INSTRUCCIONES DE COMPARACIÓN -----");

        #2; // MOV A, 100
        $display("CHECK @ t=%0t: After MOV A, 100 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd100) begin
            $error("FAIL: regA expected 100, got %d", regA_out);
            compare_test_failed = 1'b1;
        end

        #2; // MOV B, 100
        $display("CHECK @ t=%0t: After MOV B, 100 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd100) begin
            $error("FAIL: regB expected 100, got %d", regB_out);
            compare_test_failed = 1'b1;
        end

        #2; // CMP A, B - Comparar A con B (debería establecer Z=1)
        $display("CHECK @ t=%0t: After CMP A, B -> regA = %d, regB = %d, Status = %b", $time, regA_out, regB_out, status_flags);
        if (status_flags[3] !== 1'b1) begin // Z flag
            $error("FAIL: Z flag expected 1 after CMP A, B, got %b", status_flags[3]);
            compare_test_failed = 1'b1;
        end

        #2; // MOV A, 50
        $display("CHECK @ t=%0t: After MOV A, 50 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd50) begin
            $error("FAIL: regA expected 50, got %d", regA_out);
            compare_test_failed = 1'b1;
        end

        #2; // CMP A, 50 - Comparar A con literal 50 (debería establecer Z=1)
        $display("CHECK @ t=%0t: After CMP A, 50 -> regA = %d, Status = %b", $time, regA_out, status_flags);
        if (status_flags[3] !== 1'b1) begin // Z flag
            $error("FAIL: Z flag expected 1 after CMP A, 50, got %b", status_flags[3]);
            compare_test_failed = 1'b1;
        end

        #2; // MOV B, 75
        $display("CHECK @ t=%0t: After MOV B, 75 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd75) begin
            $error("FAIL: regB expected 75, got %d", regB_out);
            compare_test_failed = 1'b1;
        end

        #2; // CMP B, 100 - Comparar B con literal 100 (debería establecer N=1)
        $display("CHECK @ t=%0t: After CMP B, 100 -> regB = %d, Status = %b", $time, regB_out, status_flags);
        if (status_flags[2] !== 1'b1) begin // N flag
            $error("FAIL: N flag expected 1 after CMP B, 100, got %b", status_flags[2]);
            compare_test_failed = 1'b1;
        end

        if (!compare_test_failed) begin
            $display(">>>>> COMPARACIÓN TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> COMPARACIÓN TEST FAILED! <<<<<");
        end

        // --- Test 8: Instrucciones de Salto Incondicional ---
        $display("\n----- TEST 8: SALTO INCONDICIONAL -----");

        #2; // JMP 200 - Saltar a la dirección 200
        $display("CHECK @ t=%0t: After JMP 200 -> PC = %d", $time, pc_out);
        // Nota: Verificar que el PC cambió a 200

        #2; // NOP (instrucción dummy en caso de que no salte)
        $display("CHECK @ t=%0t: After NOP -> PC = %d", $time, pc_out);

        if (!jump_test_failed) begin
            $display(">>>>> SALTO INCONDICIONAL TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> SALTO INCONDICIONAL TEST FAILED! <<<<<");
        end

        // --- Test 9: Instrucciones de Salto Condicional ---
        $display("\n----- TEST 9: SALTO CONDICIONAL -----");

        #2; // MOV A, 10
        $display("CHECK @ t=%0t: After MOV A, 10 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd10) begin
            $error("FAIL: regA expected 10, got %d", regA_out);
            conditional_jump_test_failed = 1'b1;
        end

        #2; // MOV B, 10
        $display("CHECK @ t=%0t: After MOV B, 10 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd10) begin
            $error("FAIL: regB expected 10, got %d", regB_out);
            conditional_jump_test_failed = 1'b1;
        end

        #2; // CMP A, B - Establecer Z=1
        $display("CHECK @ t=%0t: After CMP A, B -> Status = %b", $time, status_flags);

        #2; // JEQ 250 - Saltar si Z=1 (debería saltar)
        $display("CHECK @ t=%0t: After JEQ 250 -> PC = %d", $time, pc_out);

        #2; // NOP (no debería ejecutarse)
        $display("CHECK @ t=%0t: After NOP -> PC = %d", $time, pc_out);

        #2; // MOV A, 5
        $display("CHECK @ t=%0t: After MOV A, 5 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd5) begin
            $error("FAIL: regA expected 5, got %d", regA_out);
            conditional_jump_test_failed = 1'b1;
        end

        #2; // CMP A, 10 - Establecer Z=0, N=1
        $display("CHECK @ t=%0t: After CMP A, 10 -> Status = %b", $time, status_flags);

        #2; // JNE 260 - Saltar si Z=0 (debería saltar)
        $display("CHECK @ t=%0t: After JNE 260 -> PC = %d", $time, pc_out);

        #2; // NOP (no debería ejecutarse)
        $display("CHECK @ t=%0t: After NOP -> PC = %d", $time, pc_out);

        if (!conditional_jump_test_failed) begin
            $display(">>>>> SALTO CONDICIONAL TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> SALTO CONDICIONAL TEST FAILED! <<<<<");
        end

        // --- Test 10: Prueba Final - Secuencia Compleja ---
        $display("\n----- TEST 10: SECUENCIA COMPLEJA -----");

        #2; // MOV A, 42
        $display("CHECK @ t=%0t: After MOV A, 42 -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd42) begin
            $error("FAIL: regA expected 42, got %d", regA_out);
            complex_sequence_test_failed = 1'b1;
        end

        #2; // MOV B, 24
        $display("CHECK @ t=%0t: After MOV B, 24 -> regB = %d", $time, regB_out);
        if (regB_out !== 8'd24) begin
            $error("FAIL: regB expected 24, got %d", regB_out);
            complex_sequence_test_failed = 1'b1;
        end

        #2; // ADD A, B - A = 42 + 24 = 66
        $display("CHECK @ t=%0t: After ADD A, B -> regA = %d", $time, regA_out);
        if (regA_out !== 8'd66) begin
            $error("FAIL: regA expected 66 (42+24), got %d", regA_out);
            complex_sequence_test_failed = 1'b1;
        end

        #2; // MOV (190), A - Mem[190] = 66
        $display("CHECK @ t=%0t: After MOV (190), A -> regA = %d", $time, regA_out);

        #2; // CMP A, 66 - Verificar que A = 66
        $display("CHECK @ t=%0t: After CMP A, 66 -> Status = %b", $time, status_flags);
        if (status_flags[3] !== 1'b1) begin // Z flag
            $error("FAIL: Z flag expected 1 after CMP A, 66, got %b", status_flags[3]);
            complex_sequence_test_failed = 1'b1;
        end

        #2; // JEQ 400 - Saltar si A = 66
        $display("CHECK @ t=%0t: After JEQ 400 -> PC = %d", $time, pc_out);

        #2; // NOP (no debería ejecutarse)
        $display("CHECK @ t=%0t: After NOP -> PC = %d", $time, pc_out);

        if (!complex_sequence_test_failed) begin
            $display(">>>>> SECUENCIA COMPLEJA TEST PASSED! <<<<<");
        end else begin
            $display(">>>>> SECUENCIA COMPLEJA TEST FAILED! <<<<<");
        end

        // --- Resumen Final ---
        $display("\n===============================================");
        $display("RESUMEN DE PRUEBAS:");
        $display("===============================================");
        if (!memory_test_failed) $display("✓ Memoria con Dirección Directa: PASSED");
        else $display("✗ Memoria con Dirección Directa: FAILED");
        
        if (!addressing_test_failed) $display("✓ Direccionamiento Indirecto: PASSED");
        else $display("✗ Direccionamiento Indirecto: FAILED");
        
        if (!arithmetic_memory_test_failed) $display("✓ Aritmética con Memoria: PASSED");
        else $display("✗ Aritmética con Memoria: FAILED");
        
        if (!logical_memory_test_failed) $display("✓ Lógicas con Memoria: PASSED");
        else $display("✗ Lógicas con Memoria: FAILED");
        
        if (!shift_memory_test_failed) $display("✓ Desplazamiento con Memoria: PASSED");
        else $display("✗ Desplazamiento con Memoria: FAILED");
        
        if (!inc_rst_test_failed) $display("✓ Incremento y Reset: PASSED");
        else $display("✗ Incremento y Reset: FAILED");
        
        if (!compare_test_failed) $display("✓ Comparación: PASSED");
        else $display("✗ Comparación: FAILED");
        
        if (!jump_test_failed) $display("✓ Salto Incondicional: PASSED");
        else $display("✗ Salto Incondicional: FAILED");
        
        if (!conditional_jump_test_failed) $display("✓ Salto Condicional: PASSED");
        else $display("✗ Salto Condicional: FAILED");
        
        if (!complex_sequence_test_failed) $display("✓ Secuencia Compleja: PASSED");
        else $display("✗ Secuencia Compleja: FAILED");

        $display("===============================================");

        #2;
        $finish;
    end

    // Clock Generator
    always #1 clk = ~clk;

endmodule