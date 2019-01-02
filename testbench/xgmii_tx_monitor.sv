`ifndef XGMII_TX_MONITOR__SV
`define XGMII_TX_MONITOR__SV

`include "xgmii_packet.sv"


class xgmii_tx_monitor extends uvm_monitor;
	`uvm_component_utils(xgmii_tx_monitor);
	
	uvm_analysis_port#(xgmii_packet) ap;
	virtual xge_mac_interface tx_vi;
	int num_pkt_recv;
	xgmii_packet rcvpkt;	

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","tx_vi",tx_vi);
		if (tx_vi==null)
			`uvm_fatal("xgmii_tx_monitor config error","No monitor virtual interface set up");
		ap=new("ap",this); //We will use ap.write()
		num_pkt_recv=0;
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("xgmii_tx_monitor run phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		forever begin
			@(tx_vi.mon_cb)begin //no modport, and mon_cb happened at clk_156m25
				rcvpkt=xgmii_packet::type_id::create("rcvpkt",this);
				rcvpkt.control<=tx_vi.mon_cb.xgmii_txc;
				rcvpkt.data<=tx_vi.mon_cb.xgmii_txd;
				//`uvm_info("xgmii_tx_monitor run phase",$psprintf("xgmii rcvpkt:%s",rcvpkt.sprint()),UVM_HIGH);
				ap.write(rcvpkt);
				num_pkt_recv++;
			end
		end
	endtask	
	
	//We can add a report phase for monitor	
	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("xgmii_tx_monitor report phase",$sformatf("num_pkt_recv:%d",num_pkt_recv),UVM_HIGH);
	endfunction
endclass
`endif
