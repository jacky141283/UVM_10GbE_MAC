`ifndef XGMII_RX_MONITOR__SV
`define XGMII_RX_MONITOR__SV

`include "xgmii_packet.sv"

class xgmii_rx_monitor extends uvm_monitor;
	`uvm_component_utils(xgmii_rx_monitor)

	virtual xge_mac_interface rx_vi;
	uvm_analysis_port#(xgmii_packet) ap;
	int num_pkt_recv;
	xgmii_packet rcvpkt;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","rx_vi",rx_vi);
		if (rx_vi==null)
			`uvm_fatal("xgmii_rx_monitor config error","rx virtual interface not set");
		ap=new("ap",this);	
	endfunction 

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction	

	virtual task run_phase(uvm_phase phase);
		`uvm_info("xgmii_rx_monitor run_phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		forever begin
			@(rx_vi.mon_cb)begin
				rcvpkt=xgmii_packet::type_id::create("rcvpkt",this);
				rcvpkt.control<=rx_vi.mon_cb.xgmii_rxc;
				rcvpkt.data<=rx_vi.mon_cb.xgmii_rxd;
				//`uvm_info("xgmii_rx_monitor run_phase",$sformatf("rcvpkt:%s",rcvpkt.sprint()),UVM_HIGH);
				num_pkt_recv++;
				ap.write(rcvpkt);	
			end		
		end	
	endtask

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);	
		`uvm_info("xgmii_rx_monitor report_phase",$sformatf("num_pkt_recv:%0d",num_pkt_recv),UVM_HIGH);
	endfunction

endclass

`endif
