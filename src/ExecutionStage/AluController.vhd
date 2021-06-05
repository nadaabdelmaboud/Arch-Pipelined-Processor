LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY AluController IS
    PORT( 
	  Opcode : IN std_logic_vector(5 DOWNTO 0);
	  AluSignal: OUT std_logic_vector(4 DOWNTO 0)
        );
END AluController;

ARCHITECTURE AluController_Arch OF AluController IS
  BEGIN
	---Add-IADD---
	AluSignal <= "00000" WHEN Opcode = "000100" or Opcode = "010000" 
	---LDD-LDM---PERFORMS ADD DOESNOT CHANGE FLAGS
	ELSE "10010" WHEN Opcode = "010100" or Opcode = "010101"
	---SUB---
	ELSE "00001" WHEN Opcode = "000101"
	---NOT---
	ELSE "00010" WHEN Opcode = "001001"
	---NEG---
	ELSE "00011" WHEN Opcode = "001100"
	---CLRC---
	ELSE "00100" WHEN Opcode = "000010"
	---SETC---
	ELSE "00101" WHEN Opcode = "000001"
	---SHL---
	ELSE "00110" WHEN Opcode = "010001"
	---SHR---
	ELSE "00111" WHEN Opcode = "010010"
	---RLC---
	ELSE "01000" WHEN Opcode = "001101"
	---RRC---
	ELSE "01001" WHEN Opcode = "001110"
	---MOVA---
	ELSE "01010" WHEN Opcode = "000011" or Opcode = "011001"
	---MOVB---
	ELSE "01011" WHEN Opcode = "010011"
	---AND---
	ELSE "01100" WHEN Opcode = "000110"
	---OR---
	ELSE "01101" WHEN Opcode = "000111"
	---CLR---
	ELSE "01111" WHEN Opcode = "001000"
	---INC---
	ELSE "01111" WHEN Opcode = "001010"
	---DEC---
	ELSE "10000" WHEN Opcode = "001011"
	---NOP---
	Else "10001";

END AluController_Arch;
