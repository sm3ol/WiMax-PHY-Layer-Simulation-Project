quit -sim
vlib asic
vmap altera_mf "C:/intelFPGA_lite/20.1/modelsim_ae/altera/verilog/altera_mf"

vlog prbs.sv
vlog prbs_tb.sv

vsim -voptargs=+acc -L altera_mf work.prbs_tb

add wave -position insertpoint sim:/prbs_tb/*
run -all