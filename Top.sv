module Top(
    // input declerations
    input logic rst_n,
    input logic clk,
    input logic Valid_top,
    input logic datain,
    input logic ready_mod,
    // output declerations 
    output logic inter_out,
    output logic inter_valid, 
    output logic [15:0] I_top,
    output logic [15:0] Q_top,
    output logic Valid_out_top
);

logic Valid_int_mod, dataintmod, ready_modint, ready_intmod;
   
    assign inter_out = dataintmod;
    assign inter_valid = Valid_int_mod;

interleaver I1(
    .clk(clk),
    .rstn(rst_n),
    .Ready_in(ready_modint),
    .Valid_in(Valid_top),
    .Data_in(datain),
    ////
    .Ready_out(ready_intmod),
    .Data_out(dataintmod),
    .Valid_out (Valid_int_mod)
);



// instantiations
    Modulator M1 (
     .clk (clk),
    .rstn(rst_n), 
    .Valid_in (Valid_int_mod),
    .Data_in(dataintmod),
    .Ready_out(ready_mod),
    

    // out puts 
    .Ready_in(ready_modint),
    .Valid_out(Valid_out_top),
    .I(I_top),
    .Q(Q_top)
);

endmodule