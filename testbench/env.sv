`ifndef ENV__SV
`define ENV__SV

`include "packet_tx_agent.sv"
`include "packet_rx_agent.sv"
`include "xgmii_tx_agent.sv"
`include "xgmii_rx_agent.sv"
`include "wishbone_agent.sv"
`include "reset_agent.sv"
`include "scoreboard.sv"
//`include "coverage.sv"

class env extends uvm_env;
	`uvm_component_utils(env); //register with factory

	packet_tx_agent pkt_tx_agent;
	packet_rx_agent pkt_rx_agent;
	xgmii_tx_agent xgmii_tx_agt;
	xgmii_rx_agent xgmii_rx_agt;
	wishbone_agent wb_agent;
	reset_agent rst_agent;
	scoreboard sb;
	//coverage cov;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pkt_tx_agent=packet_tx_agent::type_id::create("pkt_tx_agent",this);
		pkt_rx_agent=packet_rx_agent::type_id::create("pkt_rx_agent",this);
		rst_agent=reset_agent::type_id::create("rst_agent",this);
		wb_agent=wishbone_agent::type_id::create("wb_agent",this);
		sb=scoreboard::type_id::create("sb",this);
		//cov=coverage::type_id::create("cov",this);
		xgmii_tx_agt=xgmii_tx_agent::type_id::create("xgmii_tx_agt",this);
		xgmii_rx_agt=xgmii_rx_agent::type_id::create("xgmii_rx_agt",this);
	endfunction

	virtual function void connect_phase(uvm_phase phase); //still need uvm_phase phase
		super.connect_phase(phase);
		pkt_tx_agent.ap.connect(sb.from_pkt_tx_agt);
		pkt_rx_agent.ap.connect(sb.from_pkt_rx_agt);
		xgmii_tx_agt.ap.connect(sb.from_xgmii_tx_agt);
		xgmii_rx_agt.ap.connect(sb.from_xgmii_rx_agt);
		//pkt_rx_agent.ap.connect(cov.analysis_export);
	endfunction

endclass


`endif
