# Target executable
TARGET = simv

# Source files
SRC = $(wildcard *.sv) $(wildcard *.v)

# Set the number of threads to use for parallel compilation (2 * cores)
CORES = $(shell getconf _NPROCESSORS_ONLN)
THREADS = $(shell echo $$((2 * $(CORES))))

# Vlogan flags
VLOGANFLAGS = -full64 -sverilog -debug_all +lint=all,noVCDE +warn=all \
					 -timescale=1ns/1ps +v2k
VCSUUMFLAGS = -full64 -sverilog -debug_all +lint=all,noVCDE +warn=all \
					 -timescale=1ns/1ps

# VCS flags
VCSFLAGS = -full64 -sverilog -debug_all +lint=all,noVCDE +warn=all -j$(THREADS) \
					 -timescale=1ns/1ps +v2k
COMMON_FLAGS +=

# Simulator
SIM = vcs

# Altera FPGA library files (for simulation)
INC_V = /afs/ece/support/altera/release/16.1.2/quartus/eda/sim_lib/altera_primitives.v \
				/afs/ece/support/altera/release/16.1.2/quartus/eda/sim_lib/220model.v \
				/afs/ece/support/altera/release/16.1.2/quartus/eda/sim_lib/sgate.v \
				/afs/ece/support/altera/release/16.1.2/quartus/eda/sim_lib/altera_mf.v \
				/afs/ece/support/altera/release/16.1.2/quartus/eda/sim_lib/cyclonev_atoms.v
INC_V_FLAGS = $(addprefix -v , $(INC_V))
INC_SV =
INC_SV_FLAGS = $(addprefix -v , $(INC_SV))

# Copy common flags
VCSFLAGS += $(COMMON_FLAGS)

default : $(SRC)
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

mat1 : $(SRC) .cp_mat1
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

mat2 : $(SRC) .cp_mat2
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

mat_gen : $(SRC) .cp_mat_gen
	$(SIM) $(VCSFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) -o $(TARGET) $(SRC)

.cp_mat1 :
	cp matA_1.mif matA.mif
	cp matB_1.mif matB.mif
	cp matC_1.mif matC.mif

.cp_mat2 :
	cp matA_2.mif matA.mif
	cp matB_2.mif matB.mif
	cp matC_2.mif matC.mif

.cp_mat_gen :
	python generate_matrix.py matA_gen.mif matB_gen.mif matC_gen.mif
	cp matA_gen.mif matA.mif
	cp matB_gen.mif matB.mif
	cp matC_gen.mif matC.mif

clean :
	-rm -r csrc
	-rm -r DVEfiles
	-rm $(TARGET)
	-rm -r $(TARGET).daidir
	-rm ucli.key
	-rm matA.mif
	-rm matB.mif
	-rm matC.mif

MODULE?=TB

test_one : .vlogan
	$(SIM) $(VCSUUMFLAGS) -nc $(MODULE)

.vlogan :
	vlogan $(VLOGANFLAGS) $(INC_V_FLAGS) $(INC_SV_FLAGS) $(SRC)

.PHONY : mat1 mat2 mat_gen .cp_mat1 .cp_mat2 .cp_mat_gen clean .vlogan test_one
