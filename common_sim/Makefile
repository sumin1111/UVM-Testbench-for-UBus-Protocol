# ============================
# User Configurable Variables
# ============================

TEST_NAME ?= ubus_virtual_sequence_test
N_REPEAT ?= 4
SEED ?= 

UVM_VER = uvm-1.2

SRC_PATH = ../common_vip
TOP      = $(SRC_PATH)/my3_testbench_top.sv
IF       = $(SRC_PATH)/ubus_if/ubus_m_if.sv $(SRC_PATH)/ubus_if/ubus_s_if.sv

DUT = $(SRC_PATH)/dummy_dut.sv

LOG = simv.log | tee simv.log

# ============================
# Compile options
# ============================

VCS_FLAGS = -full64 -sverilog -lca -debug_access+all+reverse \
            -kdb -l comp.log -ntb_opts $(UVM_VER) \
			-cm line+cond+fsm+tgl+branch+assert

# ============================
# Default Target
# ============================

all: simv run

# ============================
# Compile
# ============================

simv:
	vcs $(VCS_FLAGS) $(IF) $(TOP) $(DUT) -o simv

# ============================
# Run Simulation
# ============================

run: simv
	./simv +UVM_TESTNAME=$(TEST_NAME) +N_REPEAT=$(N_REPEAT) \
		   +ntb_random_seed_verbose \
	       +UVM_TR_RECORD +UVM_LOG_RECORD +UVM_VERDI_TRACE \
		   -cm_dir ubus_cov.vdb \
	       -l $(LOG) 

	/tools/synopsys/vcs/V-2023.12-SP2-8/bin/urg -dir ubus_cov.vdb \
	    -report urg_report_dir \
	    -format text \
	    -metric group \
	    -group expand_bins \
	    -show brief group \
	    > ubus_coverage_report.txt 2>&1

# ============================
# Random seed run
# ============================



ifeq ($(SEED),)
RANDOM_OPT = +ntb_random_seed_automatic
else
RANDOM_OPT = +ntb_random_seed=$(SEED)
endif

random: simv
	./simv +UVM_TESTNAME=$(TEST_NAME) +N_REPEAT=$(N_REPEAT) \
	       $(RANDOM_OPT) +ntb_random_seed_verbose \
	       +UVM_TR_RECORD +UVM_LOG_RECORD +UVM_VERDI_TRACE \
		   -cm_dir ubus_cov.vdb \
	       -l $(LOG)

	/tools/synopsys/vcs/V-2023.12-SP2-8/bin/urg -dir ubus_cov.vdb \
	    -report urg_report_dir \
	    -format text \
	    -metric group \
	    -group expand_bins \
	    -show brief group \
	    > ubus_coverage_report.txt 2>&1
#           ^^^^^^^^^^^^^^^^^^^^^^^ 이 부분이 핵심입니다. 
#           > ubus_coverage_report.txt: STDOUT을 파일로
#           2>&1: STDERR(2)을 STDOUT(1)으로 리다이렉션합니다.

clean:
	rm -rf simv simv.daidir csrc *.log *.vpd *.key DVE* verdi* *.fsdb *.hvp .vcs* vc* novas* fsdbData.db *.vdb *dir *txt

verdi:
	verdi -ssf wave.fsdb -simv simv
