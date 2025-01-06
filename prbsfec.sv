`timescale 1ns / 1ps

module prbsfec(
    input logic        clk, 
    input logic        clk1,
    input logic        reset_n,
    input logic        load,
    input logic [15:1] seed,
    input logic        prbs_data_in,
    input logic        prbs_Valid_in,
    output logic       pr_val,
    output logic       pr_out,
    output logic       fec_out,
    output logic       fec_ready_out,
    output logic       fec_valid_out
);

wire prbs_Ready_out, prbs_Valid_out, prbs_data_out;
assign pr_val = prbs_Valid_out;
assign pr_out = prbs_data_out;


prbs prbs_inst(
    .clk(clk), 
    .reset_n(reset_n),         // Connected to active-low reset
    .load(load),
    .Ready_in(fec_ready_out),       
    .seed(seed), 
    .data_in(prbs_data_in),
    .Valid_in(1),
    .data_out(prbs_data_out), 
    .Ready_out(prbs_Ready_out), 
    .Valid_out(prbs_Valid_out) 
);


fec fec_inst(
    .clk(clk),
    .clk1(clk1),
    .reset(reset_n),
    .valid_in(prbs_Valid_out),
    .ready_in(prbs_Ready_out),
    .fec_in(prbs_data_out),
    .fec_out(fec_out),
    .ready_out(fec_ready_out),
    .valid_out(fec_valid_out)
);

endmodule
