`ifndef RESET_AGNET__SV
`define RESET_AGENT__SV

`include "reset_driver.sv"
`include "reset_item.sv"

typedef uvm_sequencer#(reset_item) reset_sequencer;

class reset_agent extends uvm_agent;
	`uvm_component_utils(reset_agent); //register with factory

	reset_sequencer rst_seqr;
	reset_driver rst_drv;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (is_active==UVM_ACTIVE) begin
			rst_drv=reset_driver::type_id::create("rst_drv",this);
			rst_seqr=reset_sequencer::type_id::create("rst_seqr",this);
		end
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if (is_active==UVM_ACTIVE) begin
			rst_drv.seq_item_port.connect(rst_seqr.seq_item_export); //remember seq_item_port/_export
		end
	endfunction
endclass


`endif
