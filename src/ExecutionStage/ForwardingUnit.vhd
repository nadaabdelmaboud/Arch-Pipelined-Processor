LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY ForwardingUnit IS
    PORT( 
	-------Alu data is taken from Ex/Mem buffer
	-------Mem data is taken from Mem/Wb buffer
	-------Adresses
	  Rdst,Rsrc,RdstAlu,RdstMem : IN std_logic_vector(2 DOWNTO 0);
	-------Signals
	  RegWriteAlu,MemToRegAlu,RegWriteMem,MemToRegMem: IN std_logic;
	  SrcSelector, DstSelector: OUT std_logic_vector(1 DOWNTO 0)
        );
END ForwardingUnit;

ARCHITECTURE ForwardingUnit_Arch OF ForwardingUnit IS
  SIGNAL WbAlu, WbMem : std_logic;
  SIGNAL isRsrcAlu, isRdstAlu : std_logic;
  SIGNAL isRsrcMem, isRdstMem : std_logic;
  BEGIN
	WbAlu <= RegWriteAlu and not MemToRegAlu;
	WbMem <= RegWriteMem and not MemToRegMem;

	isRsrcAlu <= '1' WHEN Rsrc = RdstAlu
 	ELSE '0';

	isRdstAlu <= '1' WHEN Rdst = RdstAlu
 	ELSE '0';

	isRsrcMem <= '1' WHEN Rsrc = RdstMem
 	ELSE '0';

	isRdstMem <= '1' WHEN Rsrc = RdstMem
 	ELSE '0';
	
	----Alu forwarded => higher priority
	SrcSelector <= "01" WHEN isRsrcAlu = '1' and WbAlu = '1'
	----Mem forwarded
	ELSE "10" WHEN isRsrcMem = '1' and WbMem = '1'
	Else "00";

	----Alu forwarded => higher priority
	DstSelector <= "01" WHEN isRdstAlu = '1' and WbAlu = '1'
	----Mem forwarded
	ELSE "10" WHEN isRdstMem = '1' and WbMem = '1'
	Else "00";

END ForwardingUnit_Arch;
