vsim work.executionunit

add wave sim:/executionunit/*

force -freeze sim:/executionunit/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/executionunit/Signals 'd0 0
force -freeze sim:/executionunit/RdstAddress 000 0
force -freeze sim:/executionunit/RsrcAddress 000 0
force -freeze sim:/executionunit/RsrcData 'd0 0
force -freeze sim:/executionunit/RdstData 'd0 0
force -freeze sim:/executionunit/RegWriteAlu 0 0
force -freeze sim:/executionunit/MemToRegAlu 0 0
force -freeze sim:/executionunit/RegWriteMem 0 0
force -freeze sim:/executionunit/MemToRegMem 0 0
force -freeze sim:/executionunit/Opcode 000001 0
run
force -freeze sim:/executionunit/Opcode 001101 0
run

