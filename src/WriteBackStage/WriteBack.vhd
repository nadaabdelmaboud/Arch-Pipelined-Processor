LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteStage IS
    PORT (
        ALU_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_DATA_OUT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_TO_REG : IN STD_LOGIC;
        WriteBackData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END WriteStage;

ARCHITECTURE arch OF WriteStage IS

BEGIN

    WriteBackData <= MEM_DATA_OUT WHEN MEM_TO_REG = '1'
        ELSE
        ALU_DATA;

END ARCHITECTURE;