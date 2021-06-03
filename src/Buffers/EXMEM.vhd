LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EXMEM IS
    PORT (
	RST : IN STD_LOGIC;
        enable : IN STD_LOGIC:='1';
        clk : IN STD_LOGIC;
        SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        OPCODE_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEMORY_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SP_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Flags_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0):=(OTHERS=>'0');
        OPCODE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0):=(OTHERS=>'0');
        Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'0');
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        MEMORY_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        ALU_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) :=(OTHERS=>'0');
        Flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) :=(OTHERS=>'0')
    );
END EXMEM;

ARCHITECTURE arch OF EXMEM IS

BEGIN

    PROCESS (clk) IS
	BEGIN
   	IF(falling_edge(clk) AND RST='1') THEN
  	    
            SIGNALS <=  (OTHERS=>'0');
            OPCODE <=  (OTHERS=>'0');
            Rdst_Address <=  (OTHERS=>'0');
            PC <=  (OTHERS=>'0');
            MEMORY_DATA <=  (OTHERS=>'0');
            ALU_DATA <=  (OTHERS=>'0');
            SP <=  (OTHERS=>'0');
            Flags <=  (OTHERS=>'0');
       
	END IF;
        IF (enable = '1' AND falling_edge(clk) AND RST='0') THEN
            SIGNALS <= SIGNALS_IN;
            OPCODE <= OPCODE_IN;
            Rdst_Address <= Rdst_Address_IN;
            PC <= PC_IN;
            MEMORY_DATA <= MEMORY_DATA_IN;
            ALU_DATA <= ALU_DATA_IN;
            SP <= SP_IN;
            Flags <= Flags_IN;
        END IF;

    END PROCESS;

END ARCHITECTURE;