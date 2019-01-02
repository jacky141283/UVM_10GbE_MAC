help:
	@echo "======================================================================";
	@echo "Usage:";
	@echo "  > make regress          - run all tests;
	@echo "  > make test_index       - run individual test [see list below]";
	@echo "  > make clean            - run CLEAN script";
	@echo "";
	@echo "    -----------------------------------------";
	@echo "    test_index      test_name";
	@echo "    -----------------------------------------";
	@echo "    t1              loopback_test";
	@echo "    t2              packet_oversize_test";
	@echo "======================================================================";


# Makefile variables
#####################
VCS_CMD_RAND	= vcs -full64 -R -sverilog -ntb_opts uvm-1.1 -debug_pp +ntb_random_seed_automatic -override_timescale=1ps/1ps
DESIGN_FILES	= ../rtl/verilog/*.v +incdir+../rtl/include/
TESTBENCH_FILES = +incdir+../testbench/ ../testbench/testcase.sv ../testbench/xge_test_top.sv ../testbench/xge_mac_interface.sv +incdir+../testcases


# Makefile targets
#####################
regress: all_tests

all_tests: t1 t2

# Bogus targets -> map to real testnames
t1: loopback_test
t2: packet_oversize_test

loopback_test:
	${VCS_CMD_RAND} ${DESIGN_FILES} ${TESTBENCH_FILES} +UVM_TESTNAME=$@ +UVM_VERBOSITY=HIGH -l ../sim/sv/$@_vcs.log

packet_oversize_test:
	${VCS_CMD_RAND} ${DESIGN_FILES} ${TESTBENCH_FILES} +UVM_TESTNAME=$@ +UVM_VERBOSITY=HIGH -l ../sim/sv/$@_vcs.log


clean:
	rm -rf ../sim/*_vcs.log \
	csrc \
	simv* \
	summary.log \
	ucli.key \
	vcdplus.vpd \
	*DVE* \
	*INCA* \
	transcript \
	work \
	vc_hdrs.h
