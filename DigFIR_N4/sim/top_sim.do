# --------------------------------------------------------
#  Copyright   : 
#  Contact     : 
#  Project     : 
#  Description : MODELSIM script for 
#  Author      : 
#  Date        : 
# --------------------------------------------------------


vlib work


vcom ../src/WaveGenerator.vhd
vcom ../src/MUL16x16.vhd
vcom ../src/FIR_FILTER.vhd
vcom ../src/top.vhd
vcom ../sim/top_tb.vhd

vsim -voptargs="+acc" -t 1ps  -lib work work.top_tb \

do top_wave.do

run 100 us
#run 1 ms