`ifndef PACKET_TX_DRIVER__SV
`define PACKET_TX_DRIVER__SV

`include "packet.sv"

class packet_tx_driver extends uvm_driver #(packet);
	`uvm_component_utils(packet_tx_driver);

	virtual xge_mac_interface tx_vi;
	
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","tx_vi",tx_vi);
		
		if (tx_vi==null)
			`uvm_fatal("pkt_tx_driver config error", "tx_vi for driver not set");
	endfunction

	virtual task run_phase(uvm_phase phase);
		int pkt_length_byte;
		int pkt_length_8byte;
		bit[63:0] pkt_buffer;		
		int init=0;		

		`uvm_info("Driver class",$sformatf("Hierarchy:%m"),UVM_HIGH);
	
		forever begin
			seq_item_port.get_next_item(req); //driver has built in port, then no need for analysis port
			`uvm_info("Driver run phase",req.sprint(),UVM_HIGH);
			pkt_length_byte=req.pkt_data_byte.size();
			pkt_length_8byte=pkt_length_byte%8 ? pkt_length_byte/8 + 1 : pkt_length_byte/8;
			
          	@tx_vi.drv_cb
			tx_vi.drv_cb.pkt_tx_val<=1'b1;
			for (int i=0;i<pkt_length_byte;i=i+8) begin
				tx_vi.drv_cb.pkt_tx_sop<=1'b0;
				tx_vi.drv_cb.pkt_tx_eop<=1'b0;
	            tx_vi.drv_cb.pkt_tx_mod<=3'b0;
	
				if (i==0) tx_vi.drv_cb.pkt_tx_sop<=1'b1;
 
				if (i+8 >= pkt_length_byte) begin
					tx_vi.drv_cb.pkt_tx_eop<=1'b1;
					tx_vi.drv_cb.pkt_tx_mod<=pkt_length_byte%8;	//mod only effect at last word with eop=1
				end

				tx_vi.drv_cb.pkt_tx_data[7:0]<=req.pkt_data_byte[i];
				tx_vi.drv_cb.pkt_tx_data[15:8]<=req.pkt_data_byte[i+1];
				tx_vi.drv_cb.pkt_tx_data[23:16]<=req.pkt_data_byte[i+2];
				tx_vi.drv_cb.pkt_tx_data[31:24]<=req.pkt_data_byte[i+3];
				tx_vi.drv_cb.pkt_tx_data[39:32]<=req.pkt_data_byte[i+4];
				tx_vi.drv_cb.pkt_tx_data[47:40]<=req.pkt_data_byte[i+5];
				tx_vi.drv_cb.pkt_tx_data[55:48]<=req.pkt_data_byte[i+6];
				tx_vi.drv_cb.pkt_tx_data[63:56]<=req.pkt_data_byte[i+7];

				@tx_vi.drv_cb; //wait one more cycle for eop=1 but valid=0
			end
			tx_vi.drv_cb.pkt_tx_val<=1'b0;	
			
			seq_item_port.item_done();
		end		
	endtask		
	


endclass

`endif

