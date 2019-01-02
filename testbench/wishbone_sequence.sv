`ifndef WISHBONE_SEQUENCE__SV
`define WISHBONE_SEQUENCE__SV

`include "wishbone_item.sv"

class wishbone_sequence_begin extends uvm_sequence#(wishbone_item);
	`uvm_object_utils(wishbone_sequence_begin)

	function new(string name="wishbone_sequence_begin");	
		super.new(name);
		`uvm_info("wb_seq_begin",$sformatf("Hierarchy:%m"),UVM_HIGH);
	endfunction

	task body();
		//write to the configuration reg to enable the transmission.
		`uvm_do_with(req,{wb_m==wt; wb_addr==8'h00; wb_data==32'h1; })
		//write to the interrupt mark reg to enable interupts.
		`uvm_do_with(req,{wb_m==wt; wb_addr==8'h10; wb_data==32'hFFFF_FFFF; })
	endtask

	task pre_start();
		if(starting_phase!=null)
			starting_phase.raise_objection(this);
	endtask

	task post_start();
		if(starting_phase!=null)
			starting_phase.drop_objection(this);
	endtask

endclass


class wishbone_sequence_end extends uvm_sequence#(wishbone_item);
	`uvm_object_utils(wishbone_sequence_end)

	function new(string name="wishbone_sequence_end");	
		super.new(name);
		`uvm_info("wb_seq_end",$sformatf("Hierarchy:%m"),UVM_HIGH);
	endfunction

	task body();
		//read the configuration reg.
		`uvm_do_with(req,{wb_m==rd; wb_addr==8'h00;})
		//read the interrupt pending reg.
		`uvm_do_with(req,{wb_m==rd; wb_addr==8'h08;})
		//read the interrupt status reg.
		`uvm_do_with(req,{wb_m==rd; wb_addr==8'h0C;})
		//read the interrupt mark reg.
		`uvm_do_with(req,{wb_m==rd; wb_addr==8'h10;})
	endtask

	task pre_start();
		if(starting_phase!=null)
			starting_phase.raise_objection(this);
	endtask

	task post_start();
		if(starting_phase!=null)
			starting_phase.drop_objection(this);
	endtask

endclass


`endif
