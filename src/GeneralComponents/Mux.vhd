LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Mux IS
Generic ( n : Integer:=16);
    PORT( clk,enable,sel : IN std_logic;
	    input1,input2: IN std_logic_vector(n-1 DOWNTO 0);
      result : OUT std_logic_vector(n-1 DOWNTO 0));
END Mux;
-- ask about the reset signal if needed ??
ARCHITECTURE Multiplixer OF Mux IS
  BEGIN
    PROCESS(clk)
      BEGIN
      IF (enable = '0') THEN null;
      ELSIF(sel = '0') THEN
        result <= input1;
      ELSIF(sel = '1')THEN
        result <= input2;
      END IF;
    END PROCESS;
END Multiplixer;