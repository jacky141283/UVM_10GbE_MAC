`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV

class scoreboard extends uvm_scoreboard; 
	`uvm_component_utils(scoreboard);

	typedef uvm_in_order_class_comparator#(packet) packet_comparator;
	typedef uvm_in_order_class_comparator#(xgmii_packet) xgmii_comparator;

	uvm_analysis_export#(packet) from_pkt_tx_agt; 	
	uvm_analysis_export#(packet) from_pkt_rx_agt; 	
	uvm_analysis_export#(xgmii_packet) from_xgmii_tx_agt; 	
	uvm_analysis_export#(xgmii_packet) from_xgmii_rx_agt; 	
	packet_comparator pkt_comp;
	xgmii_comparator xgmii_comp;

	function new(string name, uvm_component parent); //There is no void for new()
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pkt_comp=packet_comparator::type_id::create("pkt_comp",this);
		from_pkt_tx_agt=new("from_pkt_tx_agt",this);
		from_pkt_rx_agt=new("from_pkt_rx_agt",this);
		xgmii_comp=xgmii_comparator::type_id::create("xgmii_comp",this);
		from_xgmii_tx_agt=new("from_xgmii_tx_agt",this);
		from_xgmii_rx_agt=new("from_xgmii_rx_agt",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		this.from_pkt_tx_agt.connect(pkt_comp.after_export);
		this.from_pkt_rx_agt.connect(pkt_comp.before_export);
		this.from_xgmii_tx_agt.connect(xgmii_comp.after_export);
		this.from_xgmii_rx_agt.connect(xgmii_comp.before_export);
	endfunction

	function void report_phase(uvm_phase phase);
		`uvm_info("SCOREBOARD report_phase()",$sformatf("Hierarchy:%m"),UVM_HIGH);
		`uvm_info("SCOREBOARD report_phase()",$sformatf("Number of pkt matched=%0d,\nNumber of pkt mismatches=%0d",pkt_comp.m_matches,pkt_comp.m_mismatches),UVM_HIGH);
		`uvm_info("SCOREBOARD report_phase()",$sformatf("Hierarchy:%m"),UVM_HIGH);
		`uvm_info("SCOREBOARD report_phase()",$sformatf("Number of xgmii_pkt matched=%0d,\nNumber of xgmii_pkt mismatches=%0d",xgmii_comp.m_matches,xgmii_comp.m_mismatches),UVM_HIGH);
	endfunction

endclass

`endif



