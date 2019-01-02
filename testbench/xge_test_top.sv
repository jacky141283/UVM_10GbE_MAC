`ifndef TB_XGE_MAC__SV
`define TB_XGE_MAC__SV

`include "timescale.v"
`include "defines.v"

module xge_test_top();

	logic clk_156m25;
	logic clk_xgmii_rx;
	logic clk_xgmii_tx;
	logic wb_clk_i;
	
	xge_mac_interface xge_mac_intf(
		.clk_156m25(clk_156m25),
		.clk_xgmii_rx(clk_xgmii_rx),
		.clk_xgmii_tx(clk_xgmii_tx),
		.wb_clk_i(wb_clk_i)
	);


	xge_mac dut(
         // Outputs
	.pkt_rx_avail               (xge_mac_intf.pkt_rx_avail),
	.pkt_rx_data                (xge_mac_intf.pkt_rx_data[63:0]),
        .pkt_rx_eop                 (xge_mac_intf.pkt_rx_eop),
        .pkt_rx_err                 (xge_mac_intf.pkt_rx_err),
        .pkt_rx_mod                 (xge_mac_intf.pkt_rx_mod[2:0]),
        .pkt_rx_sop                 (xge_mac_intf.pkt_rx_sop),
        .pkt_rx_val                 (xge_mac_intf.pkt_rx_val),
        .pkt_tx_full                (xge_mac_intf.pkt_tx_full),
        .wb_ack_o                   (xge_mac_intf.wb_ack_o),
        .wb_dat_o                   (xge_mac_intf.wb_dat_o[31:0]),
        .wb_int_o                   (xge_mac_intf.wb_int_o),
        .xgmii_txc                  (xge_mac_intf.xgmii_txc[7:0]),
        .xgmii_txd                  (xge_mac_intf.xgmii_txd[63:0]),

        // Inputs
        .clk_156m25                 (clk_156m25),
        .clk_xgmii_rx               (clk_xgmii_rx),
        .clk_xgmii_tx               (clk_xgmii_tx),
        .pkt_rx_ren                 (xge_mac_intf.pkt_rx_ren),
        .pkt_tx_data                (xge_mac_intf.pkt_tx_data[63:0]),
        .pkt_tx_eop                 (xge_mac_intf.pkt_tx_eop),
        .pkt_tx_mod                 (xge_mac_intf.pkt_tx_mod[2:0]),
        .pkt_tx_sop                 (xge_mac_intf.pkt_tx_sop),
        .pkt_tx_val                 (xge_mac_intf.pkt_tx_val),
        .reset_156m25_n             (xge_mac_intf.reset_156m25_n),
        .reset_xgmii_rx_n           (xge_mac_intf.reset_xgmii_rx_n),
        .reset_xgmii_tx_n           (xge_mac_intf.reset_xgmii_tx_n),
        .wb_adr_i                   (xge_mac_intf.wb_adr_i[7:0]),
        .wb_cyc_i                   (xge_mac_intf.wb_cyc_i),
        .wb_dat_i                   (xge_mac_intf.wb_dat_i[31:0]),
        .wb_rst_i                   (xge_mac_intf.wb_rst_i),
        .wb_stb_i                   (xge_mac_intf.wb_stb_i),
        .wb_we_i                    (xge_mac_intf.wb_we_i),
        .xgmii_rxc                  (xge_mac_intf.xgmii_rxc[7:0]),
        .xgmii_rxd                  (xge_mac_intf.xgmii_rxd[63:0]));

// Clock generation

initial begin
    clk_156m25 = 1'b0;
    clk_xgmii_rx = 1'b0;
    clk_xgmii_tx = 1'b0;
	wb_clk_i=1'b0;
    forever begin
        #3200;
        clk_156m25 = ~clk_156m25;
        clk_xgmii_rx = ~clk_xgmii_rx;
        clk_xgmii_tx = ~clk_xgmii_tx;
        wb_clk_i= ~wb_clk_i;
    end
end

endmodule

`endif
