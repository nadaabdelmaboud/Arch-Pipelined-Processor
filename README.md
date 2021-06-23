# Pipelined Processor

32-bit **5-stage pipelined processor**  has a **RISC-like** instruction set and **Harvard** Archeticure with features as:
	
  - Forwarding Unit (Data-Hazard)
		 - ALU Forwarding
		 - Memory Forwarding
- Hazard Detection Unit (For Stalling)
		- Data Hazard Load-Use Case
		- Control Hazards
- Static Branch Prediction

# Stages
| Fetch |Decode  |Execute  |Memory  |Write Back |
|--|--|--|--|--|

# Design
![Design](https://i.ibb.co/P6vYkcg/Schematic.png)



## Registers

<table>
  <tr>
    <td>General Purpose Registers</td>
    <td>R0</td>
    <td>R1</td>
    <td>R2</td>
    <td>R3</td>
    <td>R4</td>
    <td>R5</td>
    <td>R6</td>
     <td>R7</td>
  </tr>
  <tr>
  <td>
  Program Counter
  </td>
    <td>
  PC
  </td>
  </tr>
   <tr>
  <td>
  Stack Pointer
  </td>
    <td>
   SP
  </td>
  </tr>
</table>

## Control Signals
<table>
  <tr>
    <td>Jump</td>
    <td>Branch</td>
    <td>MemRead</td>
    <td>MemToReg</td>
    <td>MemWrite</td>
    <td>AluOp</td>
    <td>AluSrc</td>
     <td>In</td>
     <td>Out</td>
     <td>SP</td>
     <td>RegisterWrite</td>
     <td>Ret</td>
      <td>IRSize</td>
  </tr>
 </table>
 
## Operations Types
<table>
  <tr>
    <td>2-Operand</td>
    <td>1-Operand</td>
    <td>Immediate</td>
    <td>InOut</td>
    <td>Jump</td>
    <td>Stack</td>

  </tr>
 </table>


## 2-Operand

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rsrc [22:20]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td>Operation</td>
    <td>Function</td>
  </tr>
   <tr>
    <td>NOP</td>
    <td>No operation -zeros control signals-</td>
  </tr>
   <tr>
    <td>SETC</td>
    <td>Set Carry Flag - Carry=1 -</td>
  </tr>
    <tr>
    <td>CLRC</td>
    <td>Clear Carry Flag - Carry=0 -</td>
  </tr>
    <tr>
    <td>MOV Rsrc , Rdst </td>
    <td>Move value from register Rsrc to register Rdst</td>
  </tr>
    <tr>
    <td>ADD Rsrc , Rdst</td>
    <td>Add the values stored in registers Rsrc, Rdst  
and store the result in Rdst and updates carry</td>
  </tr>
    <tr>
    <td>SUB Rsrc, Rdst</td>
    <td>Subtract the values stored in registers Rsrc, Rdst  
and store the result in Rdst and updates carry</td>
  </tr>
    <tr>
    <td>AND Rsrc, Rdst</td>
    <td>AND the values stored in registers Rsrc, Rdst  
and store the result in Rdst</td>
  </tr>
    <tr>
    <td>OR Rsrc, Rdst</td>
    <td>OR the values stored in registers Rsrc, Rdst  
and store the result in Rdst</td>
  </tr>
 </table>
 
## 1-Operand

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rdst [22:20]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td> Operation </td>
    <td>Function</td>
  </tr>
   <tr>
    <td>CLR Rdst</td>
    <td>Sets Rdst to zeros</td>
  </tr>
   <tr>
    <td>NOT Rdst</td>
    <td>NOT value stored in register Rdst</td>
  </tr>
    <tr>
    <td>INC Rdst</td>
    <td>Increment value stored in Rdst</td>
  </tr>
    <tr>
    <td>DEC Rdst</td>
    <td>Decrement value stored in Rdst</td>
  </tr>
    <tr>
    <td>NEG Rdst</td>
    <td>Negate the value stored in register Rdst</td>
  </tr>
    <tr>
    <td>RLC Rdst</td>
    <td>Rotate left Rdst ; Carry ←R[ Rdst ]<31>;  
R[ Rdst ] ← R[ Rdst ]<30:0>&Carry</td>
  </tr>
    <tr>
    <td>RRC Rdst</td>
    <td>Rotate right Rdst ; Carry ←R[ Rdst ]<0>;  
R[ Rdst ] ←Carry&R[ Rdst ]<31:1></td>
  </tr>

 </table>

## INOUT

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rdst [22:20]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td> Operation </td>
    <td>Function</td>
  </tr>
   <tr>
    <td>OUT Rdst</td>
    <td>OUT.PORT ← Rdst</td>
  </tr>
     <tr>
    <td>IN Rdst</td>
    <td>Rdst  ←IN.PORT</td>
  </tr>
  </table>


## Immediate

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rsrc [22:20]</td>
    <td>Immediate/Offset [15:0]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td> Operation </td>
    <td>Function</td>
  </tr>
   <tr>
    <td>IADD Rdst,Imm</td>
    <td>Add the values stored in registers Rdst to Immediate Value  
and store the result in Rdst and updates carry</td>
  </tr>
     <tr>
    <td>SHL Rdst, Imm</td>
    <td>Shift left Rdst by #Imm bits and store result in same register</td>
  </tr>
      <tr>
    <td>SHR Rdst, Imm</td>
    <td>Shift right Rdst by #Imm bits and store result in same register</td>
  </tr>
      <tr>
    <td>LDM Rdst, Imm</td>
    <td>Load immediate value (16 bit) to register Rdst</td>
  </tr>
      <tr>
    <td>LDD Rdst, offset(Rsrc)</td>
    <td>Load value from memory address Rsrc + offset to register Rdst</td>
  </tr>
       <tr>
    <td>STD Rdst, offset(Rsrc)</td>
    <td>Store value that is in register Rdst to memory location Rsrc + offset</td>
  </tr>
  </table>


## Jump

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rdst [22:20]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td> Operation </td>
    <td>Function</td>
  </tr>
   <tr>
    <td>JZ Rdst</td>
    <td>Jump if zero :  PC ← Rdst; (Z=0)</td>
  </tr>
     <tr>
    <td>JMP Rdst</td>
    <td>Jump ; PC ← Rdst</td>
  </tr>
  </table>


## Stack

### IR
<table>
  <tr>
    <td>Operations Type [31:29]</td>
    <td>Function Opcode [28:26]</td>
    <td>Rdst [25:23]</td>
    <td>Rdst [22:20]</td>
  </tr>
 </table>

### Operations
<table>
  <tr>
    <td> Operation </td>
    <td>Function</td>
  </tr>
   <tr>
    <td>PUSH Rdst</td>
    <td>MEM[SP] ← Rdst ; SP-=2</td>
  </tr>
     <tr>
    <td>POP Rdst</td>
    <td>SP+=2; Rdst ← MEM[SP]</td>
  </tr>
  </table>



## RUN
-   Create new project in modelsim.
-   Add all the .vhd files in  [src](https://github.com/nadaabdelmaboud/Arch-Pipelined-Processor/tree/main/src)  to the project.
-   start your simulation by running .do file as in  [do_1.do](https://github.com/nadaabdelmaboud/Arch-Pipelined-Processor/blob/main/do%20files/do_1.do)  after changing the directory of the [memory1.mem](https://github.com/nadaabdelmaboud/Arch-Pipelined-Processor/blob/main/memoryFiles/memory1.mem) to your directory


## Contributors
<table>
  <tr>
    <td align="center">
    <a href="https://github.com/nadaabdelmaboud" target="_black">
    <b>Nada Abdelmaboud</b></a>
    </td>    
    <td align="center">
    <a href="https://github.com/MENNA123MAHMOUD" target="_black">
    <b>Menna Mahmoud</b></a>
    </td>   
        <td align="center">
    <a href="https://github.com/Bassantt" target="_black">
    <b>Bassant Mohamed</b></a>
    </td>   
        <td align="center">
    <a href="https://github.com/abdallahabusedo" target="_black">
    <b>Abdullah Zaher</b></a>
    </td>   
        <td align="center">
    <a href="https://github.com/davidraafat" target="_black">
    <b>David Raafat</b></a>
    </td>   
  </tr>
 </table>

## License

> This software is licensed under MIT License, See [License](https://github.com/nadaabdelmaboud/Arch-Pipelined-Processor/blob/main/LICENSE)
