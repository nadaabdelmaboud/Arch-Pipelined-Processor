LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY instructions_ram IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        MAR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_ZERO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );

END instructions_ram;

ARCHITECTURE RAM_ARCHITECTURE OF instructions_ram IS
    TYPE ram_type IS ARRAY(0 TO 3000) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));
BEGIN

    DATAOUT <= ram(to_integer(unsigned(MAR))) & ram(to_integer(unsigned(MAR) + 1)) WHEN (to_integer(unsigned(MAR)) < 3000);
    MEM_ZERO <= ram(0);
END RAM_ARCHITECTURE;