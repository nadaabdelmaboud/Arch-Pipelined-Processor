vsim work.alu

add wave sim:/alu/*

force -freeze sim:/alu/Operand1 -32'd22 0
force -freeze sim:/alu/Operand2 'd10 0
run
force -freeze sim:/alu/Operand1 11111111111111111111111111100010 0
run

force -freeze sim:/alu/Operand2 00000000000000000000000000000010 0
run
force -freeze sim:/alu/Operand1 11111111111111111111111111100000 0
run
force -freeze sim:/alu/Operand1 10111111111111111111111111100000 0
run

