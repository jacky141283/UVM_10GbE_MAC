`ifndef RESET_DRIVER__SV
`define RESET_DRIVER__SV

`include "reset_item.sv"

class reset_driver extends uvm_driver #(reset_item);
	`uvm_component_utils(reset_driver);

	virtual xge_mac_interface rst_vi;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","rst_vi",rst_vi);
		
		if (rst_vi==null)
			`uvm_fatal("reset_driver config error", "rst_vi for driver not set");
	endfunction

	virtual task run_phase(uvm_phase phase);
		`uvm_info("Reset driver class",$sformatf("Hierarchy:%m"),UVM_HIGH);
		forever begin
			seq_item_port.get_next_item(req); //driver has built in port, then no need for analysis port
			`uvm_info("Reset driver run phase",req.sprint(),UVM_HIGH);
			@ rst_vi.drv_cb;
			rst_vi.drv_cb.reset_156m25_n<=req.rst_n;
			rst_vi.drv_cb.reset_xgmii_rx_n<=req.rst_n;
			rst_vi.drv_cb.reset_xgmii_tx_n<=req.rst_n;
			rst_vi.drv_cb.wb_rst_i<=!req.rst_n;	
			repeat (req.cycles)
				@ rst_vi.drv_cb;
			seq_item_port.item_done();
		end		
			
	endtask		
	


endclass

`endif
