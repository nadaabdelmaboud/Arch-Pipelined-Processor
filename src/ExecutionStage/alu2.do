vsim work.alu

add wave -position insertpoint  \
sim:/alu/Operand1 \
sim:/alu/Operand2 \
sim:/alu/AluSignal \
sim:/alu/CarryOld \
sim:/alu/clk \
sim:/alu/AluOut \
sim:/alu/Flags
force -freeze sim:/alu/clk 0 0, 1 {50 ps} -r 100

force -freeze sim:/alu/Operand1 'd90 0
force -freeze sim:/alu/Operand2 'd40 0
force -freeze sim:/alu/CarryOld 0 0
#add
force -freeze sim:/alu/AluSignal 00000 0
run
#sub
force -freeze sim:/alu/AluSignal 00001 0
run

force -freeze sim:/alu/Operand1 'd40 0

run

force -freeze sim:/alu/AluSignal 00100 0
run
force -freeze sim:/alu/AluSignal 00101 0
run
force -freeze sim:/alu/AluSignal 00100 0
run
force -freeze sim:/alu/AluSignal 00101 0
run
force -freeze sim:/alu/AluSignal 01000 0
run
force -freeze sim:/alu/CarryOld 1 0
run
force -freeze sim:/alu/AluSignal 01001 0
run
force -freeze sim:/alu/AluSignal 01110 0
run
force -freeze sim:/alu/Operand1 'd0 0
force -freeze sim:/alu/AluSignal 01111 0
restart
run
force -freeze sim:/alu/AluSignal 10000 0
run


