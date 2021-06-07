vsim -gui work.pipeline
add wave -position insertpoint  \
add wave  /pipeline/CLK \
add wave  /pipeline/RST \
add wave  /pipeline/IN_PORT_DATA \
add wave  /pipeline/OUT_PORT_DATA \
add wave  /pipeline/IR_FETCH \
add wave  /pipeline/PC_FETCH \
add wave  /pipeline/IR \
add wave  /pipeline/PC \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R0 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R1 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R2 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R3 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R4 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R5 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R6 \
add wave  /pipeline/Decoding_Stage/Registerfile_COMPONENT/R7 \
add wave  /pipeline/Execution_Stage/SP_SIGNAL \
add wave  /pipeline/Execution_Stage/Alu1/Flags 

force -freeze sim:/pipeline/CLK 0 0, 1 {50 ps} -r 100
mem load -i {/home/menna/Arch-Pipelined-Processor/memoryFiles/memory3.mem} -format hex /pipeline/Fetch_Stage/ram_component/ram
mem load -i {/home/menna/Arch-Pipelined-Processor/memoryFiles/memory3.mem} -format hex /pipeline/Memory_Stage/ram_component/ram
force -freeze sim:/pipeline/RST 1 0
force -freeze sim:/pipeline/IN_PORT_DATA 'h30 0
run

force -freeze sim:/pipeline/RST 0 0
force -freeze sim:/pipeline/IN_PORT_DATA 'h50 0
run
force -freeze sim:/pipeline/IN_PORT_DATA 'h100 0
run
force -freeze sim:/pipeline/IN_PORT_DATA 'h300 0
run
force -freeze sim:/pipeline/IN_PORT_DATA 'h200 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
