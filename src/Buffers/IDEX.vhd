LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IDEX IS
    PORT (
	RST :IN STD_LOGIC;
        enable : IN STD_LOGIC:='1';
        clk : IN STD_LOGIC;
        SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        OPCODE_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        CONTROL_HAZARD_D : IN STD_LOGIC;
        DATA_HAZARD_D : IN STD_LOGIC;
        HAZARD_D : IN STD_LOGIC;
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rsrc_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IN_PORT_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMMEDIATE_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0):=(OTHERS=>'0');
        OPCODE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0):=(OTHERS=>'0');
        Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'0');
        Rsrc_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS=>'0');
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        Rsrc_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        Rdst_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        IN_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) :=(OTHERS=>'0');
        IMMEDIATE_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS=>'0');
        CONTROL_HAZARD_IDEX : OUT STD_LOGIC := '0';
        DATA_HAZARD_IDEX : OUT STD_LOGIC := '0';
        HAZARD_IDEX : OUT STD_LOGIC := '0'

    );
END IDEX;

ARCHITECTURE arch OF IDEX IS

BEGIN

    PROCESS (clk) IS
	BEGIN
	IF(falling_edge(clk) AND RST='1') THEN
  	    
            SIGNALS <=  (OTHERS=>'0');
            OPCODE <=  (OTHERS=>'0');
            Rdst_Address <= (OTHERS=>'0');
            Rsrc_Address <= (OTHERS=>'0');
            PC <= (OTHERS=>'0');
            Rsrc_DATA <= (OTHERS=>'0');
            Rdst_DATA <= (OTHERS=>'0');
            IN_PORT_DATA <= (OTHERS=>'0');
            IMMEDIATE_DATA <= (OTHERS=>'0');
            CONTROL_HAZARD_IDEX <= '0';
            DATA_HAZARD_IDEX <= '0';
            HAZARD_IDEX <= '0';
	END IF;
        IF (enable = '1' AND falling_edge(clk) AND RST='0') THEN
            SIGNALS <= SIGNALS_IN;
            OPCODE <= OPCODE_IN;
            Rdst_Address <= Rdst_Address_IN;
            Rsrc_Address <= Rsrc_Address_IN;
            PC <= PC_IN;
            Rsrc_DATA <= Rsrc_DATA_IN;
            Rdst_DATA <= Rdst_DATA_IN;
            IN_PORT_DATA <= IN_PORT_DATA_IN;
            IMMEDIATE_DATA <= IMMEDIATE_DATA_IN;
            CONTROL_HAZARD_IDEX <= CONTROL_HAZARD_D;
            DATA_HAZARD_IDEX <= DATA_HAZARD_D;
            HAZARD_IDEX <= HAZARD_D;
        END IF;

    END PROCESS;

END ARCHITECTURE;