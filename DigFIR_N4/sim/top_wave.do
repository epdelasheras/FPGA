onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/DEBUG
add wave -noupdate /top_tb/CLK_T
add wave -noupdate /top_tb/CLK_WAVE_T
add wave -noupdate /top_tb/CLK
add wave -noupdate /top_tb/CLK_WAVE
add wave -noupdate /top_tb/RESET
add wave -noupdate -divider WaveGenerator
add wave -noupdate /top_tb/UUT_WaveGenerator/RST
add wave -noupdate /top_tb/UUT_WaveGenerator/WAVE_GEN
add wave -noupdate /top_tb/UUT_WaveGenerator/table_index
add wave -noupdate /top_tb/UUT_WaveGenerator/table_index_down
add wave -noupdate -divider {FIR FILTER}
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/CLK
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/RST
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/B
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/X
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/Y
add wave -noupdate -expand /top_tb/UUT_Top/UUT_FIR_FILTER/MUL
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/TAP_CNT
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/Z1
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/Z2
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/Z3
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/ADD1
add wave -noupdate /top_tb/UUT_Top/UUT_FIR_FILTER/ADD2
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -format Analog-Step -height 74 -max 16375.0 -min -16383.0 -radix sfixed /top_tb/UUT_Top/UUT_FIR_FILTER/FILTER_IN
add wave -noupdate -format Analog-Step -height 74 -max 2259750.0 -min -2260854.0 -radix sfixed /top_tb/UUT_Top/UUT_FIR_FILTER/ADD3
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -format Analog-Step -height 74 -max 32732.0 -min -32732.0 -radix sfixed /top_tb/UUT_Top/UUT_FIR_FILTER/FILTER_OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {259677419 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 303
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
WaveRestoreZoom {0 ps} {1050 us}
