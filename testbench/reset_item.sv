`ifndef RESET_ITEM__SV
`define RESET_ITEM__SV

class reset_item extends uvm_sequence_item; 
	typedef enum bit{LOW=0,HIGH=1} mode;

	rand mode rst_n;
	rand int cycles;

	`uvm_object_utils_begin(reset_item) //register with factory including members
		`uvm_field_enum(mode,rst_n,UVM_ALL_ON);
		`uvm_field_int(cycles,UVM_ALL_ON);
	`uvm_object_utils_end
		
	function new(string name="reset_item"); //There is no void for new()
		super.new(name); //must invoke base class's constructor
	endfunction

endclass

`endif



