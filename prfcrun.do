quit -sim
vlib asic
vmap altera_mf "C:/intelFPGA_lite/22.1std/questa_fse/intel/verilog/altera_mf"
vlog fec.sv
vlog prbs.sv
vlog prbsfec.sv
vlog prbfec_tb.sv
vlog RAM2P.v

do wave.do

vsim -voptargs=+acc -L altera_mf work.prbfec_tb
run -all