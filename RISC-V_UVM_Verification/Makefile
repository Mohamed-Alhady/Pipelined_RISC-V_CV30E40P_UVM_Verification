# Define variables to hold names of files
RTL_DIR = rtl
interfaces = intf.sv interr_intf.sv mul_intf.sv debug_intf.sv ALU_intf.sv config_intf.sv CV32E40P_Data_Mem_intf.sv reg_intf.sv
latch = rtl/cv32e40p_register_file_latch.sv
RTL_FILES = $(wildcard $(RTL_DIR)/*.sv)
pkg_files = rtl/cv32e40p_pkg.sv rtl/cv32e40p_fpu_pkg.sv rtl/cv32e40p_apu_core_pkg.sv
RTL_tb = $(filter-out $(pkg_files) $(latch), $(RTL_FILES))
Package_File = pack.sv
Tb_File = top.sv

# List of UVM tests (each must match folder and test name)
TESTS = base_test R_instr_test S_instr_test L_instr_test J_instr_test MUL_instr_test B_instr_test U_instr_test rand_test zero_ones_min_max_j_test zero_ones_min_max_auipc_test zero_ones_min_max_lui_test zero_ones_l_test zero_ones_jalr_test zero_ones_i_test sub_sra_test slli_srai_srli_i_test

# Define Flags
VCS_Flags = -sverilog -debug_access+all -cm line+cond+tgl+branch+fsm+assert +ntb_random_seed=321 -ntb_opts uvm-1.2 -cm_dir Vdb_Files/compile_cov -l Log_Files/comp.log
DVE_Flags = +fsdb+define+FSDB +fsdb+all=mapped+packed -cm line+cond+tgl+branch+fsm+assert
URG_Flags = -dir Vdb_Files/* -dbname Merged_db -report Merged_Cov_Report -format both -elfile ex.el 
 
# Default target
All: Clean Compile Run Gen_Reports Open_Reports

# Clean
Clean:
	@echo "******************* Clean old Files ********************"
	rm -rf csrc *.vcd *.vpd *.log *.key *.txt *.vdb simv DVEfiles simv.daidir urgReport *.tar.gz Log_Files Vdb_Files Merged_Cov_Report Merged_db.vdb

# Compile
Compile:
	@echo "******************** Compile with VCS ********************"
	mkdir -p Log_Files Vdb_Files
	vcs $(VCS_Flags) $(pkg_files) $(RTL_tb) $(interfaces) $(Package_File) $(Tb_File) -o simv

# Run simulation for all tests
Run:
	@echo "********************** Run Simulation for All Tests **********************"
	@for test in $(TESTS); do \
		echo "======== Running $$test ========"; \
		mkdir -p Vdb_Files/$$test Log_Files; \
		./simv $(DVE_Flags) +vpdpluson +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=$$test +UVM_TIMEOUT=90000 -cm_dir Vdb_Files/$$test -l Log_Files/$$test.log; \
	done
 
run_gui:
	@for test in $(TESTS); do \
	./simv -gui  +UVM_TESTNAME=$$test +UVM_VERBOSITY=UVM_HIGH -cm line+tgl+branch+cond -cm_dir Vdb_Files/$$test -l Log_Files/$$test.log;\
	done
 
 

# Merge coverage
Gen_Reports:
	@echo "******************** Generate Coverage Reports ********************"
	urg $(URG_Flags) &

# View coverage (optional)
Coverage:
	@echo "********************** Open Merged Coverage in DVE *************************"
	dve -cov -dir Merged_db.vdb &

Open_Reports:
	@echo "******************** Open URG HTML Dashboard ***********************"
	gedit Merged_Cov_Report/dashboard.txt &
	# firefox Merged_Cov_Report/dashboard.html

