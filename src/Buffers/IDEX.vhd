LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IDEX IS
    PORT (
        enable : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        SIGNALS_IN : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        OPCODE_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rsrc_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IN_PORT_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMMEDIATE_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNALS : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        OPCODE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rsrc_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IN_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMMEDIATE_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END IDEX;

ARCHITECTURE arch OF IDEX IS

BEGIN

    PROCESS (clk) IS

        IF (enable = '1' AND falling_edge(clk)) THEN
            SIGNALS <= SIGNALS_IN;
            OPCODE <= OPCODE_IN;
            Rdst_Address <= Rdst_Address_IN;
            Rsrc_Address <= Rsrc_Address_IN;
            PC <= PC_IN;
            Rsrc_DATA <= Rsrc_DATA_IN;
            Rdst_DATA <= Rdst_DATA_IN;
            IN_PORT_DATA <= IN_PORT_DATA_IN;
            IMMEDIATE_DATA <= IMMEDIATE_DATA_IN;
        END IF;

    END PROCESS

END ARCHITECTURE;