LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY IFID IS
    PORT (
        enable : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        IR_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );
END IFID;

ARCHITECTURE arch OF IFID IS

BEGIN

    PROCESS (clk) IS

        IF (enable = '1' AND falling_edge(clk)) THEN
            IR <= IR_IN;
            PC <= PC_IN;
        END IF;

    END PROCESS

END ARCHITECTURE;