LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL; 
ENTITY Alu IS
    PORT( 
	  Operand1 : IN std_logic_vector(31 DOWNTO 0);
	  Operand2 : IN std_logic_vector(31 DOWNTO 0);
	  AluSignal: IN std_logic_vector(4 DOWNTO 0);
	  CarryOld : IN std_logic;
	  clk : IN std_logic;
	  AluOut : OUT std_logic_vector(31 DOWNTO 0);
	  Flags : OUT std_logic_vector(2 DOWNTO 0)
        );
END Alu;

ARCHITECTURE Alu_Arch OF Alu IS

SIGNAL addRes :  std_logic_vector(32 DOWNTO 0);
SIGNAL subRes :  std_logic_vector(32 DOWNTO 0);
SIGNAL notRes :  std_logic_vector(31 DOWNTO 0);
SIGNAL negRes :  std_logic_vector(32 DOWNTO 0);

SIGNAL shlRes : std_logic_vector(31 DOWNTO 0);
SIGNAL shrRes : std_logic_vector(31 DOWNTO 0);

SIGNAL rrcRes : std_logic_vector(31 DOWNTO 0);
SIGNAL rlcRes : std_logic_vector(31 DOWNTO 0);

SIGNAL andRes : std_logic_vector(31 DOWNTO 0);
SIGNAL orRes : std_logic_vector(31 DOWNTO 0);
SIGNAL incRes : std_logic_vector(32 DOWNTO 0);
SIGNAL decRes : std_logic_vector(32 DOWNTO 0);

SIGNAL shiftAmount : INTEGER := 1;
SIGNAL shiftAmountLeft : INTEGER := 0;
SIGNAL shlCarry :  std_logic;
SIGNAL shrCarry :  std_logic;

SIGNAL CarryIn :  std_logic;
--SIGNAL subcarry :  std_logic;

  BEGIN
	addRes <= std_logic_vector(signed(Operand1(31) & Operand1) + signed(Operand2(31) & Operand2)); --addition
        subRes <= std_logic_vector(signed(Operand2(31) & Operand2) - signed(Operand1(31) & Operand1)); --subtraction Rsrc - Rdst
	notRes <= not Operand1;

	negRes <= Operand1(31) & Operand1 WHEN Operand1 = "00000000000000000000000000000000"
	ELSE std_logic_vector(signed(notRes(31) & notRes) + 1 );

	shlRes <= STD_LOGIC_VECTOR(shift_left(unsigned(Operand1), shiftAmount));
	shrRes <= STD_LOGIC_VECTOR(shift_right(unsigned(Operand1), shiftAmount));

	shiftAmount <= to_integer(unsigned(Operand2(4 DOWNTO 0)));
	shrCarry <= Operand1(shiftAmount - 1);
	shiftAmountLeft <= 32 - shiftAmount;
	shlCarry <= Operand1(shiftAmountLeft);

	rrcRes <= CarryIn & Operand1(31 DOWNTO 1);
	rlcRes <= Operand1(30 DOWNTO 0) & CarryIn;

	andRes <= Operand1 and Operand2; --addition
        orRes <= Operand2 or Operand1; --subtraction Rsrc - Rdst
	incRes <= std_logic_vector(signed(Operand1(31) & Operand1) + 1); --addition
        decRes <= std_logic_vector(signed(Operand1(31) & Operand1) - 1 ); --subtraction

	AluOut <= addRes(31 DOWNTO 0) WHEN AluSignal = "00000"
	ELSE subRes(31 DOWNTO 0) WHEN AluSignal = "00001"
	ELSE notRes WHEN AluSignal = "00010"
	ELSE negRes(31 DOWNTO 0) WHEN AluSignal = "00011"
	ELSE shlRes WHEN AluSignal = "00110"
	ELSE shrRes WHEN AluSignal = "00111"
	ELSE rlcRes WHEN AluSignal = "01000"
	ELSE rrcRes WHEN AluSignal = "01001"
	ELSE Operand1 WHEN AluSignal = "01010"
	ELSE Operand2 WHEN AluSignal = "01011"
	ELSE andRes WHEN AluSignal = "01100"
	ELSE orRes WHEN AluSignal = "01101"
	ELSE "00000000000000000000000000000000" WHEN AluSignal = "01110"
	ELSE incRes(31 DOWNTO 0) WHEN AluSignal = "01111"
	ELSE decRes(31 DOWNTO 0) WHEN AluSignal = "10000"
	ELSE "00000000000000000000000000000000";


 	PROCESS(clk)
      	BEGIN
 		IF(rising_edge(clk)) THEN
       			CarryIn <= CarryOld;
      		END IF;
    	END PROCESS;

END Alu_Arch;




