LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Execution IS
	PORT (
		clk : IN STD_LOGIC;
		Signals : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		Opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		RdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RsrcAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RdstData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RsrcData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		InData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		---From EX/MEM Buffer
		AluDataForwarded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		AluRdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RegWriteAlu, MemToRegAlu : IN STD_LOGIC;
		---From EX/MEM Buffer
		MemDataForwarded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemRdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		MemToRegMem : IN STD_LOGIC;
		Sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

		MemDataIn : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		AluDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		SpOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Flags : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"
	);
END Execution;

ARCHITECTURE ExecutionUnit_Arch OF Execution IS
	COMPONENT Alu IS
		PORT (
			Operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			Operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			AluSignal : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			CarryOld : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			AluOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"
		);
	END COMPONENT;
	COMPONENT AluController IS
		PORT (
			Opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			AluSignal : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT ForwardingUnit IS
		PORT (
			Rdst, Rsrc, RdstAlu, RdstMem : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			RegWriteAlu, MemToRegAlu, MemToRegMem : IN STD_LOGIC;
			SrcSelector, DstSelector : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL AluSignal : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL SrcSelector, DstSelector : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL SrcMuxOut, DstMuxOut, AluData : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL FlagsAlu : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL CarryOld : STD_LOGIC;

	SIGNAL SrcData, DstData : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
	-------------------PORTMAPS------------------------------
	Alu1 : Alu PORT MAP(SrcMuxOut, DstMuxOut, AluSignal, CarryOld, clk, AluData, FlagsAlu);

	AluController1 : AluController PORT MAP(OpCode, AluSignal);

	ForwardingUnit1 : ForwardingUnit PORT MAP(
		RdstAddress, RsrcAddress, AluRdstAddress, MemRdstAddress,
		RegWriteAlu, MemToRegAlu, MemToRegMem,
		SrcSelector, DstSelector);

	-------------------LOGIC------------------------------

	SrcData <= INDATA WHEN Signals(6) = '1' --IN Signal
		ELSE
		RsrcData;

	DstData <= Immediate WHEN Signals(7) = '1' --ALU Src Signal
		ELSE
		RdstData;

	SrcMuxOut <= SrcData WHEN SrcSelector = "00"
		ELSE
		AluDataForwarded WHEN SrcSelector = "01"
		ELSE
		MemDataForwarded WHEN SrcSelector = "10";

	DstMuxOut <= DstData WHEN DstSelector = "00"
		ELSE
		AluDataForwarded WHEN DstSelector = "01"
		ELSE
		MemDataForwarded WHEN DstSelector = "10";

	MemDataIn <= RdstData WHEN DstSelector = "00"
		ELSE
		AluDataForwarded WHEN DstSelector = "01"
		ELSE
		MemDataForwarded WHEN DstSelector = "10";
	---SP if POP
	---Note: SP value should be handled in integeration
	---New value Should be written on falling edge
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk) AND Opcode = "101011") THEN
			SpOut <= STD_LOGIC_VECTOR(signed(Sp) + 2);
		END IF;
	END PROCESS;

	---Flag Register Handling
	PROCESS (clk)
	BEGIN
		IF (falling_edge(clk)) THEN
			CarryOld <= Flags(2);
		END IF;
		IF (rising_edge(clk)) THEN
			Flags <= FlagsAlu;
			AluDataOut <= AluData;
		END IF;
	END PROCESS;

END ExecutionUnit_Arch;