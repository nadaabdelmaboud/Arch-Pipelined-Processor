LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MEMWB IS
    PORT (
	RST : IN STD_LOGIC;
        enable : IN STD_LOGIC:='1';
        clk : IN STD_LOGIC;
        SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEMORY_DATAOUT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_DATAOUT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SP_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0):=(OTHERS=>'0');
        Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'0');
        MEMORY_DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        ALU_DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0')

    );
END MEMWB;

ARCHITECTURE arch OF MEMWB IS

BEGIN

    PROCESS (clk) IS
	BEGIN
   	IF(falling_edge(clk) AND RST='1') THEN
  	    
            SIGNALS <=  (OTHERS=>'0');
            Rdst_Address <=  (OTHERS=>'0');
            MEMORY_DATAOUT <= (OTHERS=>'0');
            ALU_DATAOUT <=  (OTHERS=>'0');
            SP <= (OTHERS=>'0');
	END IF;
        IF (enable = '1' AND falling_edge(clk) AND RST='0') THEN
            SIGNALS <= SIGNALS_IN;
            Rdst_Address <= Rdst_Address_IN;
            MEMORY_DATAOUT <= MEMORY_DATAOUT_IN;
            ALU_DATAOUT <= ALU_DATAOUT_IN;
            SP <= SP_IN;
        END IF;

    END PROCESS;

END ARCHITECTURE;