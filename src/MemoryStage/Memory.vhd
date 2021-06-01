LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
	GENERIC(n: INTEGER := 16);
	PORT(
		clk : IN std_logic;
		MemoryWrite  : IN std_logic;
		MemoryRead  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(n-1 DOWNTO 0);
		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL ram : ram_type := (others => (others => '0'));
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF (MemoryWrite = '1') and (to_integer(unsigned(address)) < 2048) THEN
						ram(to_integer(unsigned(address))) <= datain;
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;


-- LIBRARY IEEE;
-- USE IEEE.std_logic_1164.all;
-- USE IEEE.numeric_bit.all;
-- use IEEE.Numeric_Std.all;
-- ENTITY Memory IS
-- Generic ( n : Integer:=16);
--     PORT( clk,enable,MemoryWrite,MemoryRead : IN std_logic;
-- 	    MemoryData,MemoryAddress: IN std_logic_vector(n-1 DOWNTO 0);
--       Data : OUT std_logic_vector(n-1 DOWNTO 0));
-- END Memory;
-- -- ask about the reset signal if needed ??
-- ARCHITECTURE Memo OF Memory IS
--     type RAMtype is array (0 to 255) of std_logic_vector(n-1 downto 0);
--     signal Ram : RAMtype := (others => (others => '0'));
--   BEGIN
--     PROCESS(clk)
--       BEGIN
--       if rising_edge(clk) then  -- Read from memory
--           if MemoryRead = '1' then
--               Data <= Ram(to_integer(unsigned(MemoryAddress)));
--           end if ;
--       end if ;
--       if falling_edge(clk) then -- Write to memory
--           if MemoryWrite ='1' then
--             Ram(to_integer(unsigned(MemoryAddress))) <= MemoryData;
--           end if ;
--       end if ;
      
--     END PROCESS;
-- END Memo;