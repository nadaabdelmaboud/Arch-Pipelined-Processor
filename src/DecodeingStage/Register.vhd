LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Regggg IS
  GENERIC (n : INTEGER := 32);
  PORT (
    clk, rst, enable : IN STD_LOGIC;
    d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    storevalue : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0'));
END Regggg;

ARCHITECTURE a_Reg OF Regggg IS

BEGIN

  storevalue <= d WHEN enable = '1';
END a_Reg;