LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Reg IS
  GENERIC (n : INTEGER := 16);
  PORT (
    rst, enable : IN STD_LOGIC;
    d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END Reg;

ARCHITECTURE a_Reg OF Reg IS
BEGIN
  PROCESS (enable, rst)
  BEGIN
    IF (enable = '0') THEN
      NULL;
    ELSIF (rst = '1') THEN
      q <= (OTHERS => '0');
    ELSE 
      q <= d;
    END IF;
  END PROCESS;
END a_Reg;