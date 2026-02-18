# Define folders
SOFT_DIR := soft
ACC_DIR := acc
INCLUDE_DIR := include
OUTPUT_DIR := output
BIN_DIR   := bin_files
GRAPH_DIR := graph
# Default configuration
CONFIG = rv32-standard
PYTHON = python3
include config/$(CONFIG).conf
LLVM_OPT := $(LLVM)/bin/opt
LLVM_LLC := $(LLVM)/bin/llc
#Disassembly flags
LLVM_DFLAGS += $(LLVMCC)
LLVM_DFLAGS += -S $(OUTPUT_DIR)/main.ll -o $(OUTPUT_DIR)/main.asm
LLVM_DFLAGS += -S $(OUTPUT_DIR)/optimized_main.ll -o $(OUTPUT_DIR)/optimized_main.asm

# Compiler flags
LLVM_CFLAGS += --target=riscv32-unknown-elf -Wall
LLVM_CFLAGS += -I/$(RISCV_ARCH)/include
LLVM_CFLAGS += -march=rv32gczkne -mabi=ilp32
LLVM_CFLAGS += -I./share
LLVM_CFLAGS += -msmall-data-limit=8  -std=gnu11 -nostartfiles -ffunction-sections -fdata-sections -g3
LLVM_CFLAGS += --sysroot=$(RISCV_GCC)/$(RISCV_ARCH)

GCC_WARNS  = -Wall -Wextra -Wshadow -Wundef -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings

# Define common files
MAIN_SRC := main_hw_aes.c 
MAIN_ASM := crt0.riscv.S

# Define source files
SOFT_SRC := $(wildcard $(SOFT_DIR)/*.c)
ACC_SRC := $(wildcard $(ACC_DIR)/*.S)
INCLUDE_SRC := $(wildcard $(INCLUDE_DIR)/*.c)

PYTHON_FLAGS_CODE = -b 0x8000 -s 0x8000 -f
PYTHON_FLAGS_DATA = -b 0x100000 -s 0x8000 -f

# Define object files
SOFT_OBJS := $(patsubst %.c,%.o,$(SOFT_SRC)) $(patsubst %.c,%.o,$(INCLUDE_SRC)) $(OUTPUT_DIR)/main_hw_aes.o
ACC_OBJS  := $(patsubst %.S,%.o,$(ACC_SRC)) $(patsubst %.c,%.o,$(INCLUDE_SRC)) $(patsubst %.c,%.o,$(MAIN_SRC)) 
SREC_OBJS := $(OUTPUT_DIR)/soft.srec $(OUTPUT_DIR)/acc.srec
ELF_OBJS := $(OUTPUT_DIR)/soft.elf $(OUTPUT_DIR)/acc.elf

LINKER_SCRIPT := link.common.ld
LLVM_LDFLAGS := -Wl,--build-id=none -Wl,-Map=aes.map -T $(LINKER_SCRIPT) -lc -nostdlib
OPT_LL := $(OUTPUT_DIR)/main_hw_opt.ll
GRAPH_LL_NOPT := $(GRAPH_DIR)/main_no_opt.png
GRAPH_LL_OPT := $(GRAPH_DIR)/main_opt.png

# CHANGE PASSES HERE
PASSES := -passes='mem2reg,loop-unroll,simplifycfg' -debug-pass-manager 
# ------------------


# Create output directory
$(shell mkdir -p $(OUTPUT_DIR))

# Compilation rules
all: soft
.PHONY: all soft clean

.PHONY: clean_ir ir

# IR & ASM section -------------------------
clean_ir:
	rm -f $(OUTPUT_DIR)/main_hw_aes.ll $(OPT_LL) $(OUTPUT_DIR)/main_hw_aes.s 
	rm -f $(GRAPH_DIR)/main_no_opt_call.png
	rm -f $(GRAPH_DIR)/main_no_opt.png
	rm -f $(GRAPH_DIR)/main_opt.png
	rm -f $(GRAPH_DIR)/main_opt_call.png


$(OUTPUT_DIR)/main_hw_aes.ll: $(MAIN_SRC)
	$(LLVMCC) \
		-I/$(RISCV_GCC)/$(RISCV_ARCH)/include \
		--target=riscv32-unknown-elf  \
		-march=rv32gczkne -O0 -Xclang -disable-O0-optnone \
		-S -emit-llvm $< -o $(OUTPUT_DIR)/main_hw_aes.ll
		
$(OPT_LL): $(OUTPUT_DIR)/main_hw_aes.ll
	$(LLVM_OPT) $< \
	  	$(PASSES) \
		-S -o $(OUTPUT_DIR)/main_hw_opt.ll

$(GRAPH_LL_NOPT) : $(OPT_LL)
	$(LLVM_OPT) -passes='dot-callgraph,dot-cfg' -disable-output \
		$(OUTPUT_DIR)/main_hw_aes.ll
	dot -Tpng -o $(GRAPH_LL_NOPT) .main.dot
	dot -Tpng -o $(GRAPH_DIR)/main_no_opt_call.png $(OUTPUT_DIR)/main_hw_aes.ll.callgraph.dot

$(GRAPH_LL_OPT) : $(GRAPH_LL_NOPT)
	$(LLVM_OPT) -passes='dot-callgraph,dot-cfg' -disable-output \
		$(OUTPUT_DIR)/main_hw_opt.ll 
	dot -Tpng -o $(GRAPH_LL_OPT) .main.dot
	dot -Tpng -o $(GRAPH_DIR)/main_opt_call.png $(OUTPUT_DIR)/main_hw_opt.ll.callgraph.dot

$(OUTPUT_DIR)/main_hw_aes.s: $(GRAPH_LL_OPT)
	$(LLVM_LLC) $(OUTPUT_DIR)/main_hw_opt.ll -o $(OUTPUT_DIR)/main_hw_aes.s

ir: clean_ir $(OUTPUT_DIR)/main_hw_aes.s
# End of IR section --------------------

# Compile crt0 startup file
crt0.riscv.o: crt0.riscv.S
	$(LLVMCC) $(LLVM_CFLAGS) -c -x assembler-with-cpp -o $@ $<

$(OUTPUT_DIR)/main_hw_aes.o: $(OUTPUT_DIR)/main_hw_aes.s
	$(LLVMCC) $(LLVM_CFLAGS) -c -o $@ $<


# Compile object files
%.o: %.c
	$(LLVMCC) $(LLVM_CFLAGS) -c -o $@ $<

soft: ir $(SOFT_OBJS) crt0.riscv.o
	$(LLVMCC) $(LLVM_CFLAGS) $(LLVM_LDFLAGS) -msmall-data-limit=8 -o $(OUTPUT_DIR)/soft.elf  $(SOFT_OBJS) crt0.riscv.o
	$(OBJCOPY) -O srec $(OUTPUT_DIR)/soft.elf $(OUTPUT_DIR)/soft.srec
	$(PYTHON) python_script/srec_to_coe.py   $(OUTPUT_DIR)/soft.srec $(PYTHON_FLAGS_CODE) -o $(BIN_DIR)/code.coe
	$(PYTHON) python_script/srec_to_coe.py   $(OUTPUT_DIR)/soft.srec $(PYTHON_FLAGS_DATA) -o $(BIN_DIR)/data.coe

# Clean rule
clean:
	rm -f -r crt0.riscv.o aes.map $(SOFT_OBJS) $(ACC_OBJS) $(OUTPUT_DIR)
