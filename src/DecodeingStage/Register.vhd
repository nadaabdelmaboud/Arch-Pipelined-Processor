LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY Reg IS
Generic ( n : Integer:=32);
    PORT( clk,rst,enable : IN std_logic;
	    d: IN std_logic_vector(n-1 DOWNTO 0);
      q : OUT std_logic_vector(n-1 DOWNTO 0));
END Reg;

ARCHITECTURE a_Reg OF Reg IS
 SIGNAL storevalue : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
  BEGIN
    PROCESS(clk,rst,enable)
      BEGIN
      IF(rst = '1') THEN
        q <= (others => '0');
        storevalue<=(others => '0');
       ElSE 

          IF(enable = '1') THEN
          q <= d;
          storevalue<=d;
          ELSE
            q <= storevalue;
          END IF;
          
       END IF;

    END PROCESS;
END a_Reg;