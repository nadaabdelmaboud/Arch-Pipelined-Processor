LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram IS
    PORT (
        rst : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        MAR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ram;

ARCHITECTURE RAM_ARCHITECTURE OF ram IS
    TYPE ram_type IS ARRAY(0 TO 99999) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;
BEGIN

    DATAOUT <= ram(to_integer(unsigned(MAR))) & ram(to_integer(unsigned(MAR) + 1));
END RAM_ARCHITECTURE;