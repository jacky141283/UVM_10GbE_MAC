`ifndef XGMII_TX_AGNET__SV
`define XGMII_TX_AGENT__SV

`include "xgmii_tx_monitor.sv"

class xgmii_tx_agent extends uvm_agent;
	`uvm_component_utils(xgmii_tx_agent); //register with factory

	xgmii_tx_monitor xgmii_tx_mon;
	uvm_analysis_port#(xgmii_packet) ap;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction 

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		xgmii_tx_mon=xgmii_tx_monitor::type_id::create("xgmii_tx_mon",this);
		ap=new("ap",this);//initialize analysis_port
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		xgmii_tx_mon.ap.connect(this.ap);//If we use assign to connect analysis port, then we don't have to initialize ap
	endfunction
endclass


`endif
