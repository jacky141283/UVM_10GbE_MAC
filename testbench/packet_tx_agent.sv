`ifndef PACKET_TX_AGNET__SV
`define PACKET_TX_AGENT__SV

`include "packet_tx_driver.sv"
`include "packet_tx_monitor.sv"

typedef uvm_sequencer#(packet) packet_tx_sequencer;

class packet_tx_agent extends uvm_agent;
	`uvm_component_utils(packet_tx_agent); //register with factory

	packet_tx_sequencer pkt_tx_seqr;
	packet_tx_driver pkt_tx_drv;
	packet_tx_monitor pkt_tx_mon;
	uvm_analysis_port#(packet) ap;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pkt_tx_seqr=packet_tx_sequencer::type_id::create("pkt_tx_seqr",this);
		pkt_tx_drv=packet_tx_driver::type_id::create("pkt_tx_drv",this);
		pkt_tx_mon=packet_tx_monitor::type_id::create("pkt_tx_mon",this);
		ap=new("ap",this);//initialize analysis_port
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		pkt_tx_drv.seq_item_port.connect(pkt_tx_seqr.seq_item_export); //remember seq_item_port/_export
		pkt_tx_mon.ap.connect(this.ap);//If we use assign to connect analysis port, then we don't have to initialize ap
	endfunction
endclass


`endif
