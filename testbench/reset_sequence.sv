`ifndef RESET_SEQUENCE__SV
`define RESET_SEQUENCE__SV

`include "reset_item.sv"

class reset_sequence extends uvm_sequence#(reset_item); //remember parameterized packet

	`uvm_object_utils(reset_sequence);
	
	function new(string name="reset_sequence"); 
		super.new(name); //must invoke base class's constructor
		`uvm_info("RESET_SEQUENCE",$sformatf("Hierarchy:%m"),UVM_HIGH);		
	endfunction

	virtual task pre_start(); //it is call pre_task so must invoke base class's constructor
		if (starting_phase != null) 
			starting_phase.raise_objection(this);
	endtask	

	virtual task body(); //remember to raise objection
		`uvm_do_with(req,{rst_n==LOW; cycles==1;});
		`uvm_do_with(req,{rst_n==HIGH; cycles==1;});
		`uvm_info("generate reset_n",req.sprint(),UVM_HIGH);		
	endtask

	virtual task post_start();
		if (starting_phase != null) 
			starting_phase.drop_objection(this);
	endtask

endclass

`endif
