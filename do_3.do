vsim -gui work.pipeline
add wave -r /*
force -freeze sim:/pipeline/CLK 0 0, 1 {50 ps} -r 100
mem load -i {D:/CMP 3rd Year/Second Sem/Arch/repo/Arch-Pipelined-Processor/assmbler/memory.mem} -format hex /pipeline/Fetch_Stage/ram_component/ram
mem load -i {D:/CMP 3rd Year/Second Sem/Arch/repo/Arch-Pipelined-Processor/assmbler/memory.mem} -format hex /pipeline/Memory_Stage/ram_component/ram
force -freeze sim:/pipeline/RST 1 0
force -freeze sim:/pipeline/IN_PORT_DATA 'h30 0
run
force -freeze sim:/pipeline/RST 0 0
force -freeze sim:/pipeline/IN_PORT_DATA 'h50 0
run
force -freeze sim:/pipeline/IN_PORT_DATA 'h100 0
run
force -freeze sim:/pipeline/IN_PORT_DATA 'h300 0