`ifndef XGMII_PACKET__SV
`define XGMII_PACKET__SV


class xgmii_packet extends uvm_sequence_item; 

	rand bit[7:0] control;
	rand bit[63:0] data;

	`uvm_object_utils_begin(xgmii_packet) //register with factory including packet members
		`uvm_field_int(control,UVM_ALL_ON);
		`uvm_field_int(data,UVM_ALL_ON);
	`uvm_object_utils_end
		
	function new(string name="xgmii_packet"); //There is no void for new()
		super.new(name); //must invoke base class's constructor
	endfunction

endclass

`endif
