`ifndef VIRTUAL_SEQUENCE__SV
`define VIRTUAL_SEQUENCE__SV

`include "virtual_sequencer.sv"

class virtual_sequence extends uvm_sequence;
	`uvm_object_utils(virtual_sequence)
	`uvm_declare_p_sequencer(virtual_sequencer) //setting parent sequencer for virtual sequence

	packet_sequence seq_pkt;
	reset_sequence seq_rst;		
	wishbone_sequence_begin seq_wb_begin; //one sequencer for two sequences		
	wishbone_sequence_end seq_wb_end;	

	function new(string name="virtual_sequence");
		super.new(name);
		`uvm_info("virtual_sequence",$sformatf("Hierarchy:%m"),UVM_HIGH);		
	endfunction 
	
	virtual task body();
		`uvm_do_on(seq_rst,p_sequencer.seqr_rst);  //seq_rst will be asserted then deasserted
		`uvm_do_on(seq_wb_begin,p_sequencer.seqr_wb); //After seqr_rst
		`uvm_do_on(seq_pkt,p_sequencer.seqr_pkt_tx);
		#992000;
		`uvm_do_on(seq_wb_end,p_sequencer.seqr_wb); //After seqr_pkt
	endtask	

	virtual task pre_start();
		super.pre_start();
		`uvm_info("virtual_sequence pre_start()",$sformatf("Hierarchy:%m"),UVM_HIGH);		
		if((starting_phase!=null) && (get_parent_sequence==null))
			starting_phase.raise_objection(this);
	endtask

	virtual task post_start();
		super.post_start();
		`uvm_info("virtual_sequence post_start()",$sformatf("Hierarchy:%m"),UVM_HIGH);		
		if((starting_phase!=null) && (get_parent_sequence==null))
			starting_phase.drop_objection(this);
	endtask

endclass
`endif
