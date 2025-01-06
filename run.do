quit -sim
vlib work
vmap altera_mf "C:/intelFPGA_lite/20.1/modelsim_ae/altera/verilog/altera_mf"
vmap cyclonev "C:/intelFPGA_lite/20.1/modelsim_ae/altera/verilog/cyclonev"
vmap altera_lnsim "C:/intelFPGA_lite/20.1/modelsim_ae/altera/verilog/altera_lnsim"
#vmap altera_pll "C:/intelFPGA_lite/20.1/ip/altera/altera_pll"


vlog constants_pkg.sv
vlog fec.sv
vlog prbs.sv
vlog prbsfec.sv
vlog prbfec_tb.sv
vlog RAM2P.v
vlog DPR.v
vlog interleaver.sv
vlog Modulator.sv
vlog Top.sv
vlog Top_tb.sv
vlog WiMax.sv
vlog WiMax_Tb.sv
vlog PLL.v
vlog PLL_0002.v
#vlog altera_pll.sv




vsim -voptargs=+acc -L altera_mf -L altera_lnsim work.WiMax_tb
add wave -position insertpoint sim:/WiMax_tb/*

run -all