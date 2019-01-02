`ifndef XGE_MAC_INTERFACE__SV
`define XGE_MAC_INTERFACE__SV

//no need to put pass reset because reset should be handled by my reset sequence
interface xge_mac_interface(	
	input logic clk_156m25,
	input logic clk_xgmii_rx,
	input logic clk_xgmii_tx,
	input logic wb_clk_i
);
	logic 		pkt_rx_avail;
	logic [63:0] 	pkt_rx_data;
	logic 		pkt_rx_eop;
	logic	 	pkt_rx_err;
	logic [2:0]	pkt_rx_mod;
	logic 		pkt_rx_sop;
	logic 		pkt_rx_val;
	logic 		pkt_tx_full;
	logic 		wb_ack_o;
	logic [31:0] 	wb_dat_o;
	logic 		wb_int_o;
	logic [7:0] 	xgmii_txc;
	logic [63:0] 	xgmii_txd;
	logic 		pkt_rx_ren;
	logic [63:0] 	pkt_tx_data;
	logic 		pkt_tx_eop;
	logic [2:0]  	pkt_tx_mod;
	logic 		pkt_tx_sop;
	logic 		pkt_tx_val;
	logic 		reset_156m25_n;
	logic 		reset_xgmii_rx_n;
	logic 		reset_xgmii_tx_n;
	logic [7:0]	wb_adr_i;
   	logic           wb_cyc_i;
   	logic [31:0]    wb_dat_i;
   	logic           wb_rst_i;
   	logic           wb_stb_i;
   	logic           wb_we_i;
   	logic [7:0]     xgmii_rxc;
   	logic [63:0]    xgmii_rxd;
	
	parameter IN_SKEW=1;
	parameter OUT_SKEW=1;
	
	//signals we drive into RTL are output, signals come out from RTL are
	//input
	clocking drv_cb @(posedge clk_156m25);
	    default input  #IN_SKEW;
	    default output #OUT_SKEW;
	    input 		pkt_rx_avail;
	    input 		pkt_rx_data;
	    input 		pkt_rx_eop;
	    input 		pkt_rx_err;
	    input 		pkt_rx_mod;
	    input 		pkt_rx_sop;
	    input 		pkt_rx_val;
	    input 		pkt_tx_full;
	    input 		wb_ack_o;
	    input 		wb_dat_o;
	    input 		wb_int_o;
	    input 		xgmii_txc;
	    input 		xgmii_txd;
	    output 		pkt_rx_ren;
	    output 		pkt_tx_data;
	    output 		pkt_tx_eop;
	    output 		pkt_tx_mod;
	    output 		pkt_tx_sop;
	    output 		pkt_tx_val;
	    output 		reset_156m25_n;
	    output 		reset_xgmii_rx_n;
	    output 		reset_xgmii_tx_n;
	    output 		wb_adr_i;
	    output 		wb_cyc_i;
	    output 		wb_dat_i;
	    output 		wb_rst_i;
	    output 		wb_stb_i;
	    output 		wb_we_i;
	    output 		xgmii_rxc;
	    output 		xgmii_rxd;
	endclocking

	modport drv_mod (clocking drv_cb); //clk_156m25 is input of drv_cb, so not listed in arguments
	
	//even signals we drive into RTL, we still monitor them. So we only
	//send signal pkt_rx_en into RTL

	clocking mon_cb @(posedge clk_156m25);
	    default input  #IN_SKEW;
	    default output #OUT_SKEW;

	    input 		pkt_rx_avail;
	    input 		pkt_rx_data;
	    input 		pkt_rx_eop;
	    input 		pkt_rx_err;
	    input 		pkt_rx_mod;
	    input 		pkt_rx_sop;
	    input 		pkt_rx_val;
	    input 		pkt_tx_full;
	    input 		wb_ack_o;
	    input 		wb_dat_o;
	    input 		wb_int_o;
	    input 		xgmii_txc;
	    input 		xgmii_txd;
	    output 		pkt_rx_ren; //Becareful it is output
	    input 		pkt_tx_data;
	    input 		pkt_tx_eop;
	    input 		pkt_tx_mod;
	    input 		pkt_tx_sop;
	    input 		pkt_tx_val;
	    input 		reset_156m25_n;
	    input 		reset_xgmii_rx_n;
	    input 		reset_xgmii_tx_n;
	    input 		wb_adr_i;
	    input 		wb_cyc_i;
	    input 		wb_dat_i;
	    input 		wb_rst_i;
	    input 		wb_stb_i;
	    input 		wb_we_i;
	    input 		xgmii_rxc;
	    input 		xgmii_rxd;
	endclocking

	modport mon_mod (clocking mon_cb); //

	//it is loop back
	initial begin
		assign xgmii_rxc = xgmii_txc;
		assign xgmii_rxd = xgmii_txd;
	end	
endinterface

`endif
