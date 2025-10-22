# Archivos del proyecto
VERILOG_FILES = alu.v computer.v control_unit.v data_memory.v instruction_memory.v muxA.v muxB.v muxData.v pc.v regA.v regB.v status.v
TESTBENCH_FILE = testbench.v
TESTBENCH_ADVANCED_FILE = testbench_advanced.v
YOSYS_SCRIPT = yosys.tcl

# Rutas de salida
OUT_DIR = out
OUT_FILE = computer
OUT_FILE_ADVANCED = computer_advanced
WAVEFORM_FILE = $(OUT_DIR)/dump.vcd
WAVEFORM_FILE_ADVANCED = $(OUT_DIR)/dump_advanced.vcd

# Target por defecto
all: build run

# Target para crear el directorio de salida
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Target para construir el ejecutable de simulación básico
build: $(OUT_DIR)
	@echo "Construyendo ejecutable de simulación básico..."
	iverilog -o $(OUT_DIR)/$(OUT_FILE) $(VERILOG_FILES) $(TESTBENCH_FILE)
	@echo "Construcción exitosa. Ejecutable creado en $(OUT_DIR)/$(OUT_FILE)"

# Target para construir el ejecutable de simulación avanzado
build-advanced: $(OUT_DIR)
	@echo "Construyendo ejecutable de simulación avanzado..."
	iverilog -o $(OUT_DIR)/$(OUT_FILE_ADVANCED) $(VERILOG_FILES) $(TESTBENCH_ADVANCED_FILE)
	@echo "Construcción exitosa. Ejecutable avanzado creado en $(OUT_DIR)/$(OUT_FILE_ADVANCED)"

# Target para ejecutar la simulación básica
run:
	@echo "Ejecutando simulación básica..."
	vvp $(OUT_DIR)/$(OUT_FILE)

# Target para ejecutar la simulación avanzada
run-advanced: build-advanced
	@echo "Ejecutando simulación avanzada..."
	vvp $(OUT_DIR)/$(OUT_FILE_ADVANCED)

# Target para ver las formas de onda básicas
wave:
	@echo "Abriendo formas de onda básicas con GTKWave..."
	gtkwave $(WAVEFORM_FILE)

# Target para ver las formas de onda avanzadas
wave-advanced:
	@echo "Abriendo formas de onda avanzadas con GTKWave..."
	gtkwave $(WAVEFORM_FILE_ADVANCED)

# Target para síntesis
synth: $(OUT_DIR)
	@echo "Iniciando síntesis lógica con Yosys..."
	yosys -c $(YOSYS_SCRIPT)
	@echo "Síntesis completa."

# Target para limpiar los archivos generados
clean:
	@echo "Limpiando archivos generados..."
	@rm -rf $(OUT_DIR)
	@rm -f yosys.log
	@echo "Limpieza completa."

.PHONY: all build build-advanced run run-advanced wave wave-advanced synth clean
