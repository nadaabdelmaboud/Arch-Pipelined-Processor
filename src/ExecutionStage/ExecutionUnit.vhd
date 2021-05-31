LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL; 
ENTITY ExecutionUnit IS
    PORT( 
	  clk : IN std_logic;
	  Signals : IN std_logic_vector(12 DOWNTO 0);
	  Opcode : IN std_logic_vector(5 DOWNTO 0);
	  RdstAddress: IN std_logic_vector(2 DOWNTO 0);
	  RsrcAddress: IN std_logic_vector(2 DOWNTO 0);
	  RdstData: IN std_logic_vector(31 DOWNTO 0);
	  RsrcData: IN std_logic_vector(31 DOWNTO 0);
	  InData : IN std_logic_vector(31 DOWNTO 0);
	  Immediate : IN std_logic_vector(31 DOWNTO 0);
	  ---From EX/MEM Buffer
	  AluDataForwarded : IN std_logic_vector(31 DOWNTO 0);
	  AluRdstAddress : IN std_logic_vector(2 DOWNTO 0);
	  RegWriteAlu,MemToRegAlu : IN std_logic;
	  ---From EX/MEM Buffer
	  MemDataForwarded : IN std_logic_vector(31 DOWNTO 0);
	  MemRdstAddress : IN std_logic_vector(2 DOWNTO 0);
	  RegWriteMem,MemToRegMem: IN std_logic;
	  Sp : IN std_logic_vector(31 DOWNTO 0);
	  
	  MemDataIn : OUT std_logic_vector(31 DOWNTO 0);
	  AluDataOut : OUT std_logic_vector(31 DOWNTO 0);
	  SpOut : OUT std_logic_vector(31 DOWNTO 0);
	  Flags : INOUT std_logic_vector(2 DOWNTO 0) :="000"
        );
END ExecutionUnit;

ARCHITECTURE ExecutionUnit_Arch OF ExecutionUnit IS
	COMPONENT Alu IS
        	PORT (
            		Operand1 : IN std_logic_vector(31 DOWNTO 0);
	  		Operand2 : IN std_logic_vector(31 DOWNTO 0);
	  		AluSignal: IN std_logic_vector(4 DOWNTO 0);
	  		CarryOld : IN std_logic;
	  		clk : IN std_logic;
	  		AluOut : OUT std_logic_vector(31 DOWNTO 0);
	  		Flags : OUT std_logic_vector(2 DOWNTO 0) :="000"
        	);
	END COMPONENT;
	COMPONENT AluController IS
        	PORT (
            		Opcode : IN std_logic_vector(5 DOWNTO 0);
	 		AluSignal: OUT std_logic_vector(4 DOWNTO 0)
        	);
	END COMPONENT;
	COMPONENT ForwardingUnit IS
        	PORT (
  			Rdst,Rsrc,RdstAlu,RdstMem : IN std_logic_vector(2 DOWNTO 0);
	  		RegWriteAlu,MemToRegAlu,RegWriteMem,MemToRegMem: IN std_logic;
	  		SrcSelector, DstSelector: OUT std_logic_vector(1 DOWNTO 0)
        	);
	END COMPONENT;

	SIGNAL AluSignal :std_logic_vector(4 DOWNTO 0);
	SIGNAL SrcSelector, DstSelector: std_logic_vector(1 DOWNTO 0);
	SIGNAL SrcMuxOut, DstMuxOut,AluData: std_logic_vector(31 DOWNTO 0);
	SIGNAL FlagsAlu: std_logic_vector(2 DOWNTO 0);
	SIGNAL CarryOld: std_logic;
	
	SIGNAL SrcData,DstData : std_logic_vector(31 DOWNTO 0);

  BEGIN
	-------------------PORTMAPS------------------------------
	Alu1 : Alu PORT MAP(SrcMuxOut,DstMuxOut,AluSignal,CarryOld,clk,AluData,FlagsAlu);

	AluController1 : AluController PORT MAP(OpCode,AluSignal);

	ForwardingUnit1 : ForwardingUnit PORT MAP(
		RdstAddress,RsrcAddress,AluRdstAddress,MemRdstAddress,
		RegWriteAlu,MemToRegAlu,RegWriteMem,MemToRegMem,
		SrcSelector, DstSelector);

	-------------------LOGIC------------------------------
	MemDataIn <= DstMuxOut;
	
	SrcData <= INDATA  WHEN Signals(7) = '1' --IN Signal
	ELSE RsrcData;

	DstData <= Immediate  WHEN Signals(6) = '1' --ALU Src Signal
	ELSE RdstData;

	SrcMuxOut <= SrcData WHEN SrcSelector = "00"
	ELSE AluDataForwarded WHEN SrcSelector = "01"
	ELSE MemDataForwarded WHEN SrcSelector = "10";

	DstMuxOut <= DstData WHEN DstSelector = "00"
	ELSE AluDataForwarded WHEN DstSelector = "01"
	ELSE MemDataForwarded WHEN DstSelector = "10";


	---SP if POP
	---Note: SP value should be handled in integeration
	---New value Should be written on falling edge
	PROCESS(clk)
      	BEGIN
 		IF(rising_edge(clk) and Opcode = "101011") THEN
       			SpOut <= std_logic_vector(signed(Sp) + 2) ;
      		END IF;
    	END PROCESS;

	---Flag Register Handling
	PROCESS(clk)
      	BEGIN
 		IF(falling_edge(clk)) THEN
       			CarryOld <= Flags(2);
      		END IF;
		IF(rising_edge(clk)) THEN
       			Flags <= FlagsAlu;
			AluDataOut <= AluData;
      		END IF;
    	END PROCESS;
	
END ExecutionUnit_Arch;




