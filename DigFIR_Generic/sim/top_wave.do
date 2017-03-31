onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/UUT_Top/CLK
add wave -noupdate /top_tb/UUT_Top/RESET
add wave -noupdate /top_tb/UUT_Top/ftw
add wave -noupdate /top_tb/UUT_Top/init_phase
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32767.0 -radix sfixed /top_tb/UUT_Top/ampl_out
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32736.0 -radix sfixed /top_tb/UUT_Top/phase_out
add wave -noupdate -format Analog-Step -height 74 -max 32766.999999999993 -min -32768.0 -radix sfixed /top_tb/UUT_Top/fir_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3620690 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {112370690 ps}
