LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY HAZARD IS
    PORT (
        RSRC_IFID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RDST_IFID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RDST_IDEX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM_READ_IDEX : IN STD_LOGIC := '0';
        BRANCH_CONDITION : IN STD_LOGIC := '0';
        BRANCH : IN STD_LOGIC := '0';
        JUMP : IN STD_LOGIC := '0';
        CONTROL_HAZARD : OUT STD_LOGIC := '0';
        DATA_HAZARD : OUT STD_LOGIC := '0'

    );
END HAZARD;

ARCHITECTURE HAZARD_ARCHITECTURE OF HAZARD IS

    SIGNAL CMP1 : STD_LOGIC;
    SIGNAL CMP2 : STD_LOGIC;

BEGIN

    CMP1 <= '1' WHEN RSRC_IFID = RDST_IDEX
        ELSE
        '0';
    CMP2 <= '1' WHEN RDST_IFID = RDST_IDEX
        ELSE
        '0';

    DATA_HAZARD <= '1' WHEN MEM_READ_IDEX = '1' AND (CMP1 = '1' OR CMP2 = '1')
        ELSE
        '0';

    CONTROL_HAZARD <= '1' WHEN JUMP = '1' OR (BRANCH = '1' AND BRANCH_CONDITION = '1')
        ELSE
        '0';

END HAZARD_ARCHITECTURE;