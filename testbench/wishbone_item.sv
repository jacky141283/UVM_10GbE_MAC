`ifndef WISHBONE_ITEM__SV
`define WISHBONE_ITEM__SV

class wishbone_item extends uvm_sequence_item; 
	typedef enum bit{rd=0,wt=1} wb_mode;

	rand wb_mode wb_m;
	rand bit[7:0] wb_addr;
	rand bit[63:0] wb_data;

	`uvm_object_utils_begin(wishbone_item) //register with factory including members
		`uvm_field_enum(wb_mode,wb_m,UVM_ALL_ON);
		`uvm_field_int(wb_addr,UVM_ALL_ON);
		`uvm_field_int(wb_data,UVM_ALL_ON);
	`uvm_object_utils_end
		
	 // Constraints 
	constraint wb_addr_cons {
    	wb_addr == 8'h00 ||   // Configuration register 0   : Address 0x00
	    wb_addr == 8'h08 ||   // Interrupt Pending Register : Address 0x08
	    wb_addr == 8'h0C ||   // Interrupt Status Register  : Address 0x0C
	    wb_addr == 8'h10;     // Interrupt Mask Register    : Address 0x010
  	}

	function new(string name="wishbone_item"); //There is no void for new()
		super.new(name); //must invoke base class's constructor
	endfunction

endclass

`endif



