`ifndef  WISHBONE_AGENT__SV
`define  WISHBONE_AGENT__SV

`include "wishbone_driver.sv"
`include "wishbone_item.sv"

typedef uvm_sequencer#(wishbone_item) wishbone_sequencer;

class wishbone_agent extends uvm_agent;
	`uvm_component_utils(wishbone_agent)
	
	wishbone_driver wb_drv;
	wishbone_sequencer wb_seqr;

	uvm_analysis_port#(wishbone_item) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wb_drv=wishbone_driver::type_id::create("wb_drv",this);
		wb_seqr=wishbone_sequencer::type_id::create("wb_seqr",this);
		ap=new("ap",this);
	endfunction
		
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		wb_drv.seq_item_port.connect(wb_seqr.seq_item_export);
	endfunction

endclass
`endif
