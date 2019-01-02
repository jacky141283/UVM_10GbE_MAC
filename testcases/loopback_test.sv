`ifndef LOOPBACK_TEST__SV
`define LOOPBACK_TEST__SV

//just inherite from virtual_sequence_test without overriding any transaction.

class loopback_test extends virtual_sequence_test;
	`uvm_component_utils(loopback_test)

	function new(string name="loopback_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("loopback_test build_phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		//factory.set_type_override_by_type(packet::get_type(), packet_oversize::get_type());
	endfunction

endclass

`endif
