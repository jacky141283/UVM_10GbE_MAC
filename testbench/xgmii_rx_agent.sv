`ifndef XGMII_RX_AGNET__SV
`define XGMII_RX_AGENT__SV

`include "xgmii_rx_monitor.sv"


class xgmii_rx_agent extends uvm_agent;
	`uvm_component_utils(xgmii_rx_agent) //register with factory

	xgmii_rx_monitor xgmii_rx_mon;
	uvm_analysis_port#(xgmii_packet) ap;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		xgmii_rx_mon=xgmii_rx_monitor::type_id::create("xgmii_rx_mon",this);
		ap=new("ap",this);//initialize analysis_port
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		xgmii_rx_mon.ap.connect(this.ap);//If we use assign to connect analysis port, then we don't have to initialize ap
	endfunction
endclass


`endif
