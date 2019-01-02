`ifndef PACKET_SEQUENCE__SV
`define PACKET_SEQUENCE__SV

`include "packet.sv"

class packet_sequence extends uvm_sequence#(packet); //remember parameterized packet

	`uvm_object_utils(packet_sequence);
	
	int num_pkts=3;

	function new(string name="packet_sequence"); 
		super.new(name); //must invoke base class's constructor
		`uvm_info("PACKET_SEQ",$sformatf("Hierarchy:%m"),UVM_HIGH);
	endfunction

	virtual task pre_start(); //it is call pre_task so must invoke base class's constructor
		if (starting_phase != null) 
			starting_phase.raise_objection(this);
		uvm_config_db #(int)::get(null,get_full_name(),"num_pkts",num_pkts);
		`uvm_info("PACKET_SEQ",$sformatf("num_pkts:%0d",num_pkts),UVM_HIGH);
	endtask	

	virtual task body(); //remember to raise objection
		repeat(num_pkts) begin
			`uvm_do(req);
		end
	endtask

	virtual task post_start();
		if (starting_phase != null) 
			starting_phase.drop_objection(this);
	endtask

endclass

`endif
