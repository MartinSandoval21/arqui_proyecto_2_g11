module control_unit(
    input [6:0] opcode,        // 7 bits de opcode desde instruction_memory[14:8]
    input [3:0] status_flags,   // {Z, N, C, V} desde Status
    output reg L_PC,           // Load Program Counter
    output reg D_W,            // Data Write (escritura en memoria)
    output reg [0:0] S_D,     // Selector Mux Data
    output reg L_A,            // Load Register A 
    output reg L_B,            // Load Register B 
    output reg [1:0] S_A,      // Selector Mux A 
    output reg [1:0] S_B,      // Selector Mux B 
    output reg [2:0] ALU_Sel   // Operación ALU (3 bits)
);
    wire Z = status_flags[3];
    wire N = status_flags[2];
    wire C = status_flags[1]; 
    wire V = status_flags[0];

    always @(*) begin
        // Valores por defecto
        L_PC = 1'b0;
        D_W = 1'b0;
        S_D = 1'b0;
        L_A = 1'b0;
        L_B = 1'b0;
        S_A = 2'b00;
        S_B = 2'b00;
        ALU_Sel = 3'b000;

        case(opcode)
            // === INSTRUCCIONES BÁSICAS ===
            // MOV (A,B) A=B
            7'b0000000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b10;
                S_B = 2'b00;
                ALU_Sel = 3'b000;
            end
            
            // MOV (B,A) B=A
            7'b0000001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b11; // Z (zero) 
                ALU_Sel = 3'b000; //+
            end

            // MOV (A,Lit) A=Lit
            7'b0000010: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b10; // Z (zero) 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b000; //+
            end

            // MOV (B,Lit) B=Lit
            7'b0000011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b10; // Z (zero) 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b000; //+
            end

            // ADD (A,B) A=A+B
            7'b0000100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b000; //+
            end

            // ADD (B,A) B=A+B
            7'b0000101: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b000; //+
            end

            // ADD (A,Lit) A=A+Lit
            7'b0000110: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b000; //+
            end

            // ADD (B,Lit) B=B+Lit
            7'b0000111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b000; //+
            end

            // SUB (A,B) A=A-B
            7'b0001000: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b001; //-
            end

            // SUB (B,A) B=A-B
            7'b0001001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b001; //-
            end

            // SUB (A,Lit) A=A-Lit
            7'b0001010: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b001; //-
            end

            // SUB (B,Lit) B=B-Lit
            7'b0001011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b001; //-
            end

            // AND (A,B) A=A and B
            7'b0001100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b010; // &
            end

            // AND (B,A) B=A and B
            7'b0001101: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b010; // &
            end

            // AND (A,Lit) A=A and Lit
            7'b0001110: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b010; // &
            end

            // AND (B,Lit) B=B and Lit
            7'b0001111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b010; // &
            end

            // OR (A,B) A=A or B
            7'b0010000: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b011; // or
            end

            // OR (B,A) B=A or B
            7'b0010001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b011; // or
            end

            // OR (A,Lit) A=A or Lit
            7'b0010010: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b011; // or
            end

            // OR (B,Lit) B=B or Lit
            7'b0010011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b011; // or
            end

            // NOT (A,A) A=-A
            7'b0010100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B (CUALQUIER VALOR)
                ALU_Sel = 3'b101; // NOT
            end

            // NOT (A,B) A=-B
            7'b0010101: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b01; // B 
                S_B = 2'b00; // B (CUALQUIER VALOR)
                ALU_Sel = 3'b101; // NOT
            end

            // NOT (B,A) B=-A
            7'b0010110: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit (CUALQUIER VALOR)
                ALU_Sel = 3'b101; // NOT
            end

            // NOT (B,B) B=-B
            7'b0010111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit (CUALQUIER VALOR)
                ALU_Sel = 3'b101; // NOT
            end

            // XOR (A,B) A=A Xor B
            7'b0011000: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b100; // xor
            end

            // XOR (B,A) B=A xor B
            7'b0011001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b00; // B 
                ALU_Sel = 3'b100; // xor
            end

            // XOR (A,Lit) A=A xor Lit
            7'b0011010: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b100; // xor
            end

            // XOR (B,Lit) B=B xor Lit
            7'b0011011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b10; // Lit 
                ALU_Sel = 3'b100; // xor
            end

            // SHL (A,A) A=shift left A
            7'b0011100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b110; // SHL
            end

            // SHL (A,B) A=shift left B
            7'b0011101: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b01; // B 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b110; // SHL
            end

            // SHL (B,A) B=shift left A
            7'b0011110: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b110; // SHL
            end

            // SHL (B,B) B=shift left B
            7'b0011111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b110; // SHL
            end

            // SHR (A,A) A=shift right A
            7'b0100000: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b00; // A 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b111; // SHR
            end

            // SHL (A,B) A=shift right B
            7'b0100001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b1;  // 1  
                L_B = 1'b0;  // 0
                S_A = 2'b01; // B 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b111; // SHR
            end

            // SHL (B,A) B=shift right A
            7'b0100010: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b00; // A 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b111; // SHR
            end

            // SHL (B,B) B=shift right B
            7'b0100011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b01; // B 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b111; // SHR
            end

            // INC (B) B=B+1
            7'b0100100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0;  // 0
                S_D = 1'b0;  // 0 (cualquier valor)
                L_A = 1'b0;  // 0  
                L_B = 1'b1;  // 1
                S_A = 2'b11; // U 
                S_B = 2'b00; // B (cualquier valor)
                ALU_Sel = 3'b000; // +
            end

            
            // === INSTRUCCIONES CON DIRECCIONAMIENTO ===
            // MOV A,(Dir) A=Mem[Lit]
            7'b0100101: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // MOV B,(Dir) B=Mem[Lit]
            7'b0100110: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b10; // Z
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // MOV (Dir),A Mem[Lit]=A
            7'b0100111: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b000; // +
            end
            
            // MOV (Dir),B Mem[Lit]=B
            7'b0101000: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b00; // B
                ALU_Sel = 3'b000; // +
            end
            
            // MOV A,(B) A=Mem[B]
            7'b0101001: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // MOV B,(B) B=Mem[B]
            7'b0101010: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b10; // Z
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // MOV (B),A Mem[B]=A
            7'b0101011: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b000; // +
            end
            
            // ADD (A,Dir) A=A+Mem[Lit]
            7'b0101100: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 3'b000;
            end
            
            // ADD (B,Dir) B=B+Mem[Lit]
            7'b0101101: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // ADD (A,B) A=A+Mem[B]
            7'b0101110: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // ADD (Dir) Mem[Lit]=A+B
            7'b0101111: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b000; // +
            end
            
            // SUB (A,Dir) A=A-Mem[Lit]
            7'b0110000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 3'b001;
            end
            
            // SUB (B,Dir) B=B-Mem[Lit]
            7'b0110001: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b001; // -
            end
            
            // SUB (A,B) A=A-Mem[B]
            7'b0110010: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b001; // -
            end
            
            // SUB (Dir) Mem[Lit]=A-B
            7'b0110011: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b001; // -
            end

            // AND (A,Dir) A=A and Mem[Lit]
            7'b0110100: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 3'b010;
            end
            
            // AND (B,Dir) B=B and Mem[Lit]
            7'b0110101: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b010; // &
            end
            
            // AND (A,B) A=A and Mem[B]
            7'b0110110: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b010; // &
            end
            
            // AND (Dir) Mem[Lit]=A and B
            7'b0110111: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b010; // &
            end

            // OR (A,Dir) A=A or Mem[Lit]
            7'b0111000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00;
                S_B = 2'b01;
                ALU_Sel = 3'b011; // OR
            end
            
            // OR (B,Dir) B=B or Mem[Lit]
            7'b0111001: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0;
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b011; // OR
            end
            
            // OR (A,B) A=A or Mem[B]
            7'b0111010: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b011; // OR
            end
            
            // OR (Dir) Mem[Lit]=A or B
            7'b0111011: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b011; // OR
            end

            // NOT (Dir,A) Mem[Lit] = -A
            7'b0111100: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b11; // cualquier valor (zero)
                ALU_Sel = 3'b101; // NOT
            end
            
            // NOT (Dir,B) Mem[Lit] = -B
            7'b0111101: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b00; // B
                ALU_Sel = 3'b101; // NOT
            end
            
            // NOT (B) Mem[B] = -A
            7'b0111110: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b101; // NOT
            end

            // XOR (A,Dir) A = A xor Mem[Lit]
            7'b0111111: begin
                L_PC = 1'b0; // 0
                D_W = 1'b0; // 0
                S_D = 1'b0; // Lit
                L_A = 1'b1; // 1
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b100; // XOR
            end
            
            // XOR (B,Dir) B = B xor Mem[Lit]
            7'b1000000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b1;
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b100; // XOR
            end
            
            // XOR (A,B) A = A xor Mem[B]
            7'b1000001: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b1;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b100; // XOR
            end
            
            // XOR (Dir) Mem[Lit] = A xor B
            7'b1000010: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b100; // XOR
            end

            // SHL (Dir,A) Mem[Lit]= shift left A
            7'b1000011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b00; // A
                S_B = 2'b11; // cualquier valor (zero)
                ALU_Sel = 3'b110; // SHL
            end
            
            // SHL (Dir,B) Mem[Lit]= shift left B
            7'b1000100: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b00; // B
                ALU_Sel = 3'b110; // SHL
            end
            
            // SHL (B) Mem[B]= shift left A
            7'b1000101: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b110; // SHL
            end

            // SHR (Dir,A) Mem[Lit]= shift right A
            7'b1000110: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b111; // SHR
            end
            
            // SHR (Dir,B) Mem[Lit]= shift right B
            7'b1000111: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b0; // Lit
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b10; // Z
                S_B = 2'b00; // B
                ALU_Sel = 3'b111; // SHR
            end
            
            // SHR (B) Mem[B]= shift right A
            7'b1001000: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b00; // A
                S_B = 2'b11; // Z
                ALU_Sel = 3'b111; // SHR
            end
            
            // INC (Dir) Mem[Lit]= Mem[Lit] + 1
            7'b1001001: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b11; // U
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end

            // INC (B) Mem[B]= Mem[B] + 1
            7'b1001010: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // U
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b000; // +
            end
            
            // RST (Dir) Mem[Lit]= 0
            7'b1001011: begin
                L_PC = 1'b0; // 0
                D_W = 1'b1; // 1
                S_D = 1'b0; // Lit
                L_A = 1'b0; // 0
                L_B = 1'b0; // 0
                S_A = 2'b10; // ZERO
                S_B = 2'b11; // ZERO
                ALU_Sel = 3'b000; // +
            end
            
            // RST (B) Mem[B]= 0
            7'b1001100: begin
                L_PC = 1'b0;
                D_W = 1'b1;
                S_D = 1'b1; // B
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b10; // ZERO
                S_B = 2'b11; // ZERO
                ALU_Sel = 3'b000; // +
            end

            // === INSTRUCCIONES DE SALTO ===
            // CMP A,B A-B (solo establece flags)
            7'b1001101: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b00; // A
                S_B = 2'b00; // B
                ALU_Sel = 3'b001; // -
            end

            // CMP A,Lit A-Lit (solo establece flags)
            7'b1001110: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b00; // A
                S_B = 2'b10; // Lit
                ALU_Sel = 3'b001; // -
            end

            // CMP B,Lit B-Lit (solo establece flags)
            7'b1001111: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b01; // B
                S_B = 2'b10; // Lit
                ALU_Sel = 3'b001; // -
            end

            // CMP A,(Dir) A-Mem[Lit] (solo establece flags)
            7'b1010000: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Lit
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b001; // -
            end

            // CMP B,(Dir) B-Mem[Lit] (solo establece flags)
            7'b1010001: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b0; // Lit
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b01; // B
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b001; // -
            end

            // CMP A,(B) A-Mem[B] (solo establece flags)
            7'b1010010: begin
                L_PC = 1'b0;
                D_W = 1'b0;
                S_D = 1'b1; // B
                L_A = 1'b0; // No carga en A
                L_B = 1'b0; // No carga en B
                S_A = 2'b00; // A
                S_B = 2'b01; // Mem
                ALU_Sel = 3'b001; // -
            end

            // JMP Dir PC = Lit
            7'b1010011: begin
                L_PC = 1'b1; // Carga PC
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JEQ Dir PC = Lit (si Z=1)
            7'b1010100: begin
                L_PC = Z; // Carga PC solo si Z=1
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JNE Dir PC = Lit (si Z=0)
            7'b1010101: begin
                L_PC = ~Z; // Carga PC solo si Z=0
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JGT Dir PC = Lit (si N=0 y Z=0)
            7'b1010110: begin
                L_PC = (~N & ~Z); // Carga PC solo si N=0 y Z=0
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JLT Dir PC = Lit (si N=1)
            7'b1010111: begin
                L_PC = N; // Carga PC solo si N=1
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JGE Dir PC = Lit (si N=0)
            7'b1011000: begin
                L_PC = ~N; // Carga PC solo si N=0
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JLE Dir PC = Lit (si N=1 o Z=1)
            7'b1011001: begin
                L_PC = (N | Z); // Carga PC solo si N=1 o Z=1
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JCR Dir PC = Lit (si C=1)
            7'b1011010: begin
                L_PC = C; // Carga PC solo si C=1
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

            // JOV Dir PC = Lit (si V=1)
            7'b1011011: begin
                L_PC = V; // Carga PC solo si V=1
                D_W = 1'b0;
                S_D = 1'b0; // Don't care
                L_A = 1'b0;
                L_B = 1'b0;
                S_A = 2'b11; // Don't care
                S_B = 2'b11; // Don't care
                ALU_Sel = 3'b111; // Don't care
            end

        endcase
    end

endmodule