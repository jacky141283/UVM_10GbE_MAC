`ifndef VIRTUAL_SEQUENCER__SV
`define VIRTUAL_SEQUENCER__SV

class virtual_sequencer extends uvm_sequencer;
	`uvm_component_utils(virtual_sequencer)

	//for virtual sequncer we have different nameing way.
	reset_sequencer seqr_rst;
	packet_tx_sequencer seqr_pkt_tx;
	wishbone_sequencer seqr_wb;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction 
endclass
`endif
