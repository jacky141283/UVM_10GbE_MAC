`ifndef PACKET__SV
`define PACKET__SV


class packet extends uvm_sequence_item; 

	rand bit[7:0] pkt_data_byte[];

	`uvm_object_utils_begin(packet) //register with factory including packet members
		`uvm_field_array_int(pkt_data_byte,UVM_ALL_ON)
	`uvm_object_utils_end

	constraint pkt_data_byte_size{
		pkt_data_byte.size() inside {[46:1500]};
	}
		
	function new(string name="packet"); //There is no void for new()
		super.new(name); //must invoke base class's constructor
	endfunction

endclass

class packet_oversize extends packet;
	`uvm_object_utils(packet_oversize);
	
	constraint pkt_data_byte_size {
		pkt_data_byte.size() inside {[1501:2000]};
	}

	function new(string name="packet_oversize");
		super.new(name);
	endfunction
endclass

`endif
