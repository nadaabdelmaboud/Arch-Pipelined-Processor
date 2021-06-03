LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY ForwardingUnit IS
	PORT (
		-------Alu data is taken from Ex/Mem buffer
		-------Mem data is taken from Mem/Wb buffer
		-------Adresses
		Rdst, Rsrc, RdstAlu, RdstMem : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		-------Signals
		RegWriteAlu, MemToRegAlu, MemToRegMem : IN STD_LOGIC;
		SrcSelector, DstSelector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ForwardingUnit;

ARCHITECTURE ForwardingUnit_Arch OF ForwardingUnit IS
	SIGNAL WbAlu, WbMem : STD_LOGIC;
	SIGNAL isRsrcAlu, isRdstAlu : STD_LOGIC;
	SIGNAL isRsrcMem, isRdstMem : STD_LOGIC;
BEGIN
	WbAlu <= RegWriteAlu AND NOT MemToRegAlu;
	WbMem <= MemToRegMem;

	isRsrcAlu <= '1' WHEN Rsrc = RdstAlu
		ELSE
		'0';

	isRdstAlu <= '1' WHEN Rdst = RdstAlu
		ELSE
		'0';

	isRsrcMem <= '1' WHEN Rsrc = RdstMem
		ELSE
		'0';

	isRdstMem <= '1' WHEN Rsrc = RdstMem
		ELSE
		'0';

	----Alu forwarded => higher priority
	SrcSelector <= "01" WHEN isRsrcAlu = '1' AND WbAlu = '1'
		----Mem forwarded
		ELSE
		"10" WHEN isRsrcMem = '1' AND WbMem = '1'
		ELSE
		"00";

	----Alu forwarded => higher priority
	DstSelector <= "01" WHEN isRdstAlu = '1' AND WbAlu = '1'
		----Mem forwarded
		ELSE
		"10" WHEN isRdstMem = '1' AND WbMem = '1'
		ELSE
		"00";

END ForwardingUnit_Arch;