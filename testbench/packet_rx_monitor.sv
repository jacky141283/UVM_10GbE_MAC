`ifndef PACKET_RX_MONITOR__SV
`define PACKET_RX_MONITOR__SV

class packet_rx_monitor extends uvm_monitor;
	`uvm_component_utils(packet_rx_monitor)

	virtual xge_mac_interface rx_vi;
	uvm_analysis_port#(packet) ap;
	int num_pkt_recv;

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual xge_mac_interface)::get(this,"","rx_vi",rx_vi);
		if (rx_vi==null)
			`uvm_fatal("rx_monitor config error","rx virtual interface not set");
		ap=new("ap",this);	
		num_pkt_recv=0;
	endfunction 

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction	

	virtual task run_phase(uvm_phase phase);
		packet rx_mon_pkt;
		int i=0;
		int proceeding=0;
 	    int byte_num=0;
 
		`uvm_info("PACKET_RX_MONITOR run_phase",$sformatf("Hierarchy:%m"),UVM_HIGH);
		forever begin
			@rx_vi.mon_cb;
        	if(rx_vi.mon_cb.pkt_rx_avail) begin	             
				rx_vi.mon_cb.pkt_rx_ren<=1'b1;
          	end  
          	if(rx_vi.mon_cb.pkt_rx_val) begin
            	if (rx_vi.mon_cb.pkt_rx_sop) begin                	
					rx_mon_pkt=packet::type_id::create("rx_mon_pkt",this);
                  	proceeding=1;
                end
                if (proceeding) begin
 	            	for(int j=0; j<8 ;j++)
                      rx_mon_pkt.pkt_data_byte[byte_num*8+j]<=rx_vi.mon_cb.pkt_rx_data[j*8+:7];
    	            byte_num=+1;                  
              	end 
              	if (rx_vi.mon_cb.pkt_rx_eop && proceeding) begin                					
					proceeding=0;
					ap.write(rx_mon_pkt);
					num_pkt_recv++;
				end
			end
		end	
	endtask

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("packet_rx_monitor report phase",$sformatf("num_pkt_recv:%d",num_pkt_recv),UVM_HIGH);
	endfunction

endclass

`endif



