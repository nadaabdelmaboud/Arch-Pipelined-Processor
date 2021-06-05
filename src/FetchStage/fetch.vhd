LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY Fetch IS
    PORT (
        RST : IN STD_LOGIC := '1';
        CLK : IN STD_LOGIC;
        JUMP : IN STD_LOGIC := '0';
        BRANCH : IN STD_LOGIC := '0';
        BRANCH_CONDITION : IN STD_LOGIC := '0';
        RET : IN STD_LOGIC := '0';
        IR_SIZE : IN STD_LOGIC := '0';
        CONTROL_HAZARD : IN STD_LOGIC := '0';
        DATA_HAZARD : IN STD_LOGIC := '0';
        HLT : IN STD_LOGIC := '0';
        RDST_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        MEM_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Fetch;

ARCHITECTURE Fetch_ARCHITECTURE OF Fetch IS
    COMPONENT instructions_ram IS
        PORT (
            rst : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            MAR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	    MEM_ZERO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );

    END COMPONENT;
    SIGNAL RAM_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PC_ZERO : STD_LOGIC;
    SIGNAL COMPARE_ZERO : STD_LOGIC;
    SIGNAL PC_SELECTOR : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL JUMP_BRANCH : STD_LOGIC;
    SIGNAL HAZARD : STD_LOGIC;
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL NOP : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MEM_DATA_IN : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL READ_MEM : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
    SIGNAL MEM_ZERO :  STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    IR <= NOP WHEN PC_ZERO = '1' OR CONTROL_HAZARD = '1' OR HLT = '1' OR RET = '1' OR RST='1'
        ELSE
        RAM_OUT;

    COMPARE_ZERO <= '1' WHEN PC = "00000000000000000000000000000000"
        ELSE
        '0';
    PC_OUT <= PC;
    PC_ZERO <= COMPARE_ZERO OR RST;
    HAZARD <= CONTROL_HAZARD OR DATA_HAZARD OR HLT;
    JUMP_BRANCH <= JUMP OR (BRANCH AND BRANCH_CONDITION);

    PC_SELECTOR <= "000" WHEN PC_ZERO = '0' AND JUMP_BRANCH = '0' AND HAZARD = '0' AND RET = '0' --16-BIT INSTRUCTION PC=PC+1-
        ELSE
        "001" WHEN PC_ZERO = '0' AND JUMP_BRANCH = '0' AND HAZARD = '0' AND RET = '0' AND IR_SIZE = '1' --32-BIT INSTRUCTION PC=PC+2-
        ELSE
        "010" WHEN PC_ZERO = '0' AND JUMP_BRANCH = '1' AND HAZARD = '0' AND RET = '0' --DATA OF RDST BRANCH INSTRUCTION-
        ELSE
        "011" WHEN PC_ZERO = '0' AND HAZARD = '1' AND RET = '0' --PC_PREV NO_CHANGE-
        ELSE
        "100" WHEN PC_ZERO = '0' AND RET = '1' --MEM DATA --
        ELSE
        "101" WHEN PC_ZERO = '1'; --MEM[0]--


    PC <= STD_LOGIC_VECTOR((unsigned(PC)) + 1) WHEN PC_SELECTOR = "000"
    ELSE STD_LOGIC_VECTOR((unsigned(PC)) + 2) WHEN PC_SELECTOR = "001"
    ELSE RDST_DATA WHEN PC_SELECTOR = "010"
    ELSE MEM_DATA WHEN PC_SELECTOR = "100"
    ELSE "0000000000000000" & MEM_ZERO WHEN PC_SELECTOR = "101";

 
    ram_component : instructions_ram PORT MAP(rst, clk, PC, RAM_OUT,MEM_ZERO);
END Fetch_ARCHITECTURE;