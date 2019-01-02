`ifndef WISHBONE_DRIVER__SV
`define WISHBONE_DRIVER__SV

`include "wishbone_item.sv"

class wishbone_driver extends uvm_driver #(wishbone_item);
	`uvm_component_utils(wishbone_driver)

	virtual xge_mac_interface wb_vi;
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","wb_vi",wb_vi);
		if(wb_vi==null)
			`uvm_fatal("wb_driver config error","wb_vi not set"); 
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			if (req==null) begin
				@ wb_vi.drv_cb
				wb_vi.drv_cb.wb_adr_i<=$urandom_range(255,0); /////unsigned int in range(255,0)
				wb_vi.drv_cb.wb_cyc_i<=0;
				wb_vi.drv_cb.wb_stb_i<=0;
				wb_vi.drv_cb.wb_dat_i<=$urandom; //32bit unsigned int
				wb_vi.drv_cb.wb_we_i<=0;
			end
			else begin
				`uvm_info("wb_driver",$sformatf("wb driver transaction:%s",req.sprint()),UVM_HIGH); 
				@ wb_vi.drv_cb;
				wb_vi.drv_cb.wb_adr_i<=req.wb_addr;
				wb_vi.drv_cb.wb_cyc_i<=1;
				wb_vi.drv_cb.wb_stb_i<=1;
				wb_vi.drv_cb.wb_dat_i<=req.wb_data;
				wb_vi.drv_cb.wb_we_i<=req.wb_m;
				repeat (2) @ wb_vi.drv_cb; //last for 2 cycles
				repeat (2) begin
					wb_vi.drv_cb.wb_adr_i<=$urandom_range(255,0); /////unsigned int in range(255,0)
					wb_vi.drv_cb.wb_cyc_i<=0;
					wb_vi.drv_cb.wb_stb_i<=0;
					wb_vi.drv_cb.wb_dat_i<=$urandom; //32bit unsigned int
					wb_vi.drv_cb.wb_we_i<=0;
					@(wb_vi.drv_cb);
				end
			end
			seq_item_port.item_done();
		end
	endtask
endclass

`endif
