`ifndef PACKET_OVERSIZE_TEST__SV
`define PACKET_OVERSIZE_TEST__SV

class packet_oversize_test extends virtual_sequence_test;
	`uvm_component_utils(packet_oversize_test)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		factory.set_type_override_by_type(packet::get_type(),packet_oversize::get_type());	
	endfunction
endclass
	
`endif
