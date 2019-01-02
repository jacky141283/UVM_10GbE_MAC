`ifndef TESTCLASS__SV
`define TESTCLASS__SV

`include "env.sv"
`include "packet_sequence.sv"
`include "reset_sequence.sv"
`include "wishbone_sequence.sv"
`include "virtual_sequence.sv"
`include "virtual_sequencer.sv"
`include "xgmii_packet.sv"


class test_base extends uvm_test;
	`uvm_component_utils(test_base); //register with factory

	env m_env;
	packet_sequence pkt_seq;
	reset_sequence rst_seq;
	virtual_sequence v_seq;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_env=env::type_id::create("m_env",this);

		//Setting default sequence
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.pkt_tx_agent.pkt_tx_seqr.main_phase","default_sequence",packet_sequence::get_type());
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.rst_agent.rst_seqr.reset_phase","default_sequence",reset_sequence::get_type());	
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.wb_agent.wb_seqr.config_phase","default_sequence",wishbone_sequence_begin::get_type());	

		//setting virtual interface
		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.pkt_tx_agent.pkt_tx_drv","tx_vi",xge_test_top.xge_mac_intf);
		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.pkt_tx_agent.pkt_tx_mon","tx_vi",xge_test_top.xge_mac_intf);	
		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.pkt_rx_agent.pkt_rx_mon","rx_vi",xge_test_top.xge_mac_intf);	

		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.xgmii_tx_agt.xgmii_tx_mon","tx_vi",xge_test_top.xge_mac_intf);	
		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.xgmii_rx_agt.xgmii_rx_mon","rx_vi",xge_test_top.xge_mac_intf);	

		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.rst_agent.rst_drv","rst_vi",xge_test_top.xge_mac_intf);	

		uvm_config_db#(virtual xge_mac_interface)::set(this,"m_env.wb_agent.wb_drv","wb_vi",xge_test_top.xge_mac_intf);	

		//setting number of packet
		//uvm_config_db#(int)::set(this,"m_env.pkt_tx_agent.pkt_tx_seqr.packet_sequence","num_pkts",10);

	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
		factory.print();		
	endfunction

	virtual task run_phase(uvm_phase phase); //still need uvm_phase phase
		`uvm_info("test_base run phase",$sformatf("%m"),UVM_HIGH);	
		//pkt_seq=packet_sequence::type_id::create(pkt_seq,this);		
		//rst_seq=rst_sequence::type_id::create(rst_seq,this);		
	endtask

	virtual task main_phase( input uvm_phase phase);
  	  	uvm_objection   objection;
   		super.main_phase(phase);
	    objection = phase.get_objection();
   		objection.set_drain_time(this, 1us);
    endtask 

endclass

class virtual_sequence_test extends test_base;
	`uvm_component_utils(virtual_sequence_test);	
	
	virtual_sequencer v_seqr;

	function new(string name,uvm_component parent);
		super.new(name,parent);
    endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		v_seqr=virtual_sequencer::type_id::create("v_seqr",this);
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.rst_agent.rst_seqr.reset_phase","default_sequence",null);	
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.pkt_tx_agent.pkt_tx_seqr.main_phase","default_sequence",null);
		uvm_config_db#(uvm_object_wrapper)::set(this,"m_env.wb_agent.wb_seqr.config_phase","default_sequence",null);

		uvm_config_db#(uvm_object_wrapper)::set(this,"v_seqr.reset_phase","default_sequence",virtual_sequence::get_type());

 		uvm_config_db#(int)::set(this,"v_seqr.virtual_sequence.seq_pkt","num_pkts",6);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		v_seqr.seqr_rst=m_env.rst_agent.rst_seqr;
		v_seqr.seqr_pkt_tx=m_env.pkt_tx_agent.pkt_tx_seqr;
		v_seqr.seqr_wb=m_env.wb_agent.wb_seqr;
	endfunction
endclass
/*
class loopback_test extends virtual_sequence_test;
	`uvm_component_utils(loopback_test)

	function new(string name="loopback_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("loopback_test build_phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		//factory.set_type_override_by_type(packet::get_type(), packet_oversize::get_type());
	endfunction

endclass

class packet_oversize_test extends virtual_sequence_test;
	`uvm_component_utils(packet_oversize_test)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		factory.set_type_override_by_type(packet::get_type(),packet_oversize::get_type());	
	endfunction
endclass
*/
`endif
