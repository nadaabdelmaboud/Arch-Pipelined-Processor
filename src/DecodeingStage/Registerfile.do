add wave -position insertpoint  \
sim:/registerfile/Writeenable \
sim:/registerfile/WriteData \
sim:/registerfile/Rest \
sim:/registerfile/RegisterWrite \
sim:/registerfile/Register2Data \
sim:/registerfile/Register1Data \
sim:/registerfile/RdstAddress \
sim:/registerfile/R7_Data \
sim:/registerfile/R6_Data \
sim:/registerfile/R5_Data \
sim:/registerfile/R4_Data \
sim:/registerfile/R3_Data \
sim:/registerfile/R2_Data \
sim:/registerfile/R1_Data \
sim:/registerfile/R0_Data \
sim:/registerfile/IR \
sim:/registerfile/Clk \
sim:/registerfile/CanRead
force -freeze sim:/registerfile/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/registerfile/Rest 1 0
run
force -freeze sim:/registerfile/Rest 0 0
run
force -freeze sim:/registerfile/IR 0000000000100000 0
force -freeze sim:/registerfile/WriteData 00000000001000000000000000100000 0
force -freeze sim:/registerfile/RegisterWrite 1 0
force -freeze sim:/registerfile/RdstAddress 111 0
run
force -freeze sim:/registerfile/IR 0000001110100000 0
force -freeze sim:/registerfile/WriteData 00000000001000000000000000100000 0
force -freeze sim:/registerfile/RegisterWrite 0 0
force -freeze sim:/registerfile/RdstAddress 111 0
run
