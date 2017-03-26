# --------------------------------------------------------
#  Copyright   : 
#  Contact     : 
#  Project     : 
#  Description : MODELSIM script for 
#  Author      : 
#  Date        : 
# --------------------------------------------------------


vlib work

#compile only the sinus lut with the desired resolution.
vcom ../src/dds_synthesizer/sine_lut/sine_lut_16_x_16.vhd
#
vcom ../src/dds_synthesizer/dds_synthesizer.vhd
vcom ../src/top.vhd
vcom ../sim/top_tb.vhd

vsim -voptargs="+acc" -t 1ps  -lib work work.top_tb \

do top_wave.do

run 100 us
#run 1 ms