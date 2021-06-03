LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram IS
	PORT (
		clk : IN STD_LOGIC;
		MemoryWrite : IN STD_LOGIC;
		MemoryRead : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 1048575) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));

BEGIN
	PROCESS (clk) IS
	BEGIN
		IF rising_edge(clk) THEN
			IF (MemoryWrite = '1') AND (to_integer(unsigned(address)) < 1048576) THEN
				ram(to_integer(unsigned(address))) <= datain(15 DOWNTO 0);
				ram(to_integer(unsigned(address)) + 1) <= datain(31 DOWNTO 16);
			END IF;
		END IF;
	END PROCESS;
	dataout <= ram(to_integer(unsigned(address)) + 1) & ram(to_integer(unsigned(address)));
END syncrama;