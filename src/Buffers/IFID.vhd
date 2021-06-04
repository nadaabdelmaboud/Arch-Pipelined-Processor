LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IFID IS
    PORT (
        RST : IN STD_LOGIC;
        enable : IN STD_LOGIC := '1';
        clk : IN STD_LOGIC;
        IR_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IN_PORT_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        IN_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END IFID;

ARCHITECTURE arch OF IFID IS

BEGIN

    PROCESS (clk) IS
    BEGIN
        IF (falling_edge(clk) AND RST = '1') THEN
            IR <= (OTHERS => '0');
            PC <= (OTHERS => '0');
            IN_PORT_DATA <= (OTHERS => '0');
        END IF;
        IF (enable = '1' AND falling_edge(clk) AND RST = '0') THEN
            IR <= IR_IN;
            PC <= PC_IN;
            IN_PORT_DATA <= IN_PORT_DATA_IN;
        END IF;

    END PROCESS;

END ARCHITECTURE;