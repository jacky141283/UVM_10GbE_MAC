`ifndef PACKET_TX_MONITOR__SV
`define PACKET_TX_MONITOR__SV

`include "packet.sv"

class packet_tx_monitor extends uvm_monitor;
	`uvm_component_utils(packet_tx_monitor);
	
	uvm_analysis_port#(packet) ap;
	virtual xge_mac_interface tx_vi;
	int num_pkt_recv;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","tx_vi",tx_vi);
		if (tx_vi==null)
			`uvm_fatal("pkt_tx_monitor config error","No monitor virtual interface set up");
		ap=new("ap",this); //We will use ap.write()
		num_pkt_recv=0;
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		packet tx_mon_pkt;
		int byte_num=0;
		int proceeding=0;

		`uvm_info("PACKET_TX_MONITOR run phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		forever begin
			@tx_vi.mon_cb;
			if (tx_vi.mon_cb.pkt_tx_val) begin
				if(tx_vi.mon_cb.pkt_tx_sop) begin
					tx_mon_pkt=packet::type_id::create("tx_mon_pkt",this);
					proceeding=1;	
					byte_num=0;
				end
			
				if(proceeding) begin
					for(int j=0; j<8 ;j++)
						tx_mon_pkt.pkt_data_byte[byte_num*8+j]<=tx_vi.mon_cb.pkt_tx_data[j*8+:7];
					byte_num=+1;
				end

				if (tx_vi.mon_cb.pkt_tx_eop) begin
					ap.write(tx_mon_pkt); 
					num_pkt_recv++;
					proceeding=0;	
				end
			end
		end
	endtask	
	
	//We can add a report phase for monitor	
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("packet_tx_monitor report phase",$sformatf("num_pkt_recv:%d",num_pkt_recv),UVM_HIGH);
	endfunction
endclass
`endif
