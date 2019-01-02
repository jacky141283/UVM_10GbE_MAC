`ifndef TESTCASE__SV
`define TESTCASE__SV

program testcase();
	import uvm_pkg::*;
	`include "testclass.sv"
	`include "test_lib.svh"

	initial begin
		run_test();		
	end

endprogram

`endif
