onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /prbfec_tb/uut/clk
add wave -noupdate /prbfec_tb/uut/clk1
add wave -noupdate /prbfec_tb/uut/reset_n
add wave -noupdate /prbfec_tb/uut/prbs_Ready_in
add wave -noupdate /prbfec_tb/uut/prbs_data_in
add wave -noupdate /prbfec_tb/uut/prbs_Valid_in
add wave -noupdate /prbfec_tb/uut/prbs_data_out
add wave -noupdate /prbfec_tb/uut/fec_ready_out
add wave -noupdate /prbfec_tb/uut/prbs_Ready_out
add wave -noupdate /prbfec_tb/uut/prbs_Valid_out
add wave -noupdate /prbfec_tb/uut/prbs_inst/data_in
add wave -noupdate /prbfec_tb/uut/prbs_inst/XOR_1out
add wave -noupdate /prbfec_tb/uut/load
add wave -noupdate /prbfec_tb/uut/prbs_inst/Ready_in
add wave -noupdate /prbfec_tb/uut/prbs_inst/data_out_reg
add wave -noupdate /prbfec_tb/uut/prbs_inst/data_out
add wave -noupdate /prbfec_tb/uut/fec_inst/fec_in
add wave -noupdate /prbfec_tb/uut/fec_inst/current_state
add wave -noupdate /prbfec_tb/uut/fec_inst/x
add wave -noupdate /prbfec_tb/uut/fec_inst/y
add wave -noupdate /prbfec_tb/uut/fec_inst/valid_out
add wave -noupdate /prbfec_tb/uut/fec_inst/toggle
add wave -noupdate /prbfec_tb/uut/fec_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2048076 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1929590 ps} {2174505 ps}
