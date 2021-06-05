LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Alu IS
	PORT (
		Operand1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Operand2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		AluSignal : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		CarryOld : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		AluOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000"
	);
END Alu;

ARCHITECTURE Alu_Arch OF Alu IS

	SIGNAL addRes : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL subRes : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL notRes : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL negRes : STD_LOGIC_VECTOR(32 DOWNTO 0);

	SIGNAL shlRes : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL shrRes : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL rrcRes : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL rlcRes : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL andRes : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL orRes : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL incRes : STD_LOGIC_VECTOR(32 DOWNTO 0);
	SIGNAL decRes : STD_LOGIC_VECTOR(32 DOWNTO 0);

	SIGNAL shiftAmount : INTEGER := 1;
	SIGNAL shiftAmountLeft : INTEGER := 0;
	SIGNAL shlCarry : STD_LOGIC;
	SIGNAL shrCarry : STD_LOGIC;

	SIGNAL CarryIn : STD_LOGIC;

	SIGNAL OutTemp : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ones : STD_LOGIC_VECTOR(31 DOWNTO 0):="11111111111111111111111111111111";
	SIGNAL subcarry :  std_logic;

BEGIN
	addRes <= STD_LOGIC_VECTOR(unsigned('0' & Operand1) + unsigned('0' & Operand2)); --addition
	subRes <= STD_LOGIC_VECTOR(unsigned('0' & Operand1) - unsigned('0' & Operand2)); --subtraction Rsrc - Rdst
	notRes <= NOT Operand1;

	negRes <= Operand1(31) & Operand1 WHEN Operand1 = "00000000000000000000000000000000"
		ELSE
		STD_LOGIC_VECTOR(signed(notRes(31) & notRes) + 1);

	shlRes <= STD_LOGIC_VECTOR(shift_left(unsigned(Operand1), shiftAmount));
	shrRes <= STD_LOGIC_VECTOR(shift_right(unsigned(Operand1), shiftAmount));

	shiftAmount <= to_integer(unsigned(Operand2(4 DOWNTO 0)));
	shrCarry <= Operand1(shiftAmount - 1) WHEN shiftAmount /= 0;
	shiftAmountLeft <= 32 - shiftAmount;
	shlCarry <= Operand1(shiftAmountLeft) WHEN shiftAmountLeft /= 32;

	rrcRes <= CarryIn & Operand1(31 DOWNTO 1);
	rlcRes <= Operand1(30 DOWNTO 0) & CarryIn;

	andRes <= Operand1 AND Operand2; --addition
	orRes <= Operand2 OR Operand1; --subtraction Rsrc - Rdst
	incRes <= STD_LOGIC_VECTOR(unsigned('0' & Operand1) + 1); --INC
	decRes <= STD_LOGIC_VECTOR(unsigned('0' & Operand1) - 1); --DEC

	OutTemp <= addRes(31 DOWNTO 0) WHEN AluSignal = "00000"
		ELSE
		subRes(31 DOWNTO 0) WHEN AluSignal = "00001"
		ELSE
		notRes WHEN AluSignal = "00010"
		ELSE
		negRes(31 DOWNTO 0) WHEN AluSignal = "00011"
		ELSE
		shlRes WHEN AluSignal = "00110"
		ELSE
		shrRes WHEN AluSignal = "00111"
		ELSE
		rlcRes WHEN AluSignal = "01000"
		ELSE
		rrcRes WHEN AluSignal = "01001"
		ELSE
		Operand1 WHEN AluSignal = "01010"
		ELSE
		Operand2 WHEN AluSignal = "01011"
		ELSE
		andRes WHEN AluSignal = "01100"
		ELSE
		orRes WHEN AluSignal = "01101"
		ELSE
		"00000000000000000000000000000000" WHEN AluSignal = "01110"
		ELSE
		incRes(31 DOWNTO 0) WHEN AluSignal = "01111"
		ELSE
		decRes(31 DOWNTO 0) WHEN AluSignal = "10000"
		ELSE
		"00000000000000000000000000000000";

	AluOut <= OutTemp;

	---Flags handling
	---Zero Flag
	Flags(0) <= '1' WHEN
	OutTemp = 
	"00000000000000000000000000000000" 
--MovA
	AND AluSignal /= "01010" 
--MovB
	AND AluSignal /= "01011" 
--NOP
	AND AluSignal /= "10001"
--CLRC
--SETC
--LD/ST
	ELSE '0';
	---Negative Flag
	Flags(1) <= OutTemp(31) WHEN AluSignal /= "01011" AND AluSignal /= "10001";

	---Carry Flag with Shift operations
	Flags(2) <= '0' WHEN AluSignal = "00100"
ELSE
	'1' WHEN AluSignal = "00101"
ELSE
	shlCarry WHEN AluSignal = "00110"
ELSE
	shrCarry WHEN AluSignal = "00111"
ELSE
	Operand1(31) WHEN AluSignal = "01000"
ELSE
	Operand1(0) WHEN AluSignal = "01001"
ELSE
	addRes(32) WHEN AluSignal = "00000"
ELSE
	subRes(32) WHEN AluSignal = "00001"
ELSE
	incRes(32) WHEN AluSignal = "01111"
ELSE
	decRes(32) WHEN AluSignal = "10000";
	CarryIn <= CarryOld;

END Alu_Arch;