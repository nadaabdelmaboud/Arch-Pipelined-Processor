LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY SignExtend IS
    PORT( IR : IN std_logic_vector(15 DOWNTO 0);
          ImmediateData : OUT std_logic_vector(31 DOWNTO 0)
         );
END SignExtend;

ARCHITECTURE a_SignExtend OF SignExtend IS
  BEGIN
  
    PROCESS(IR)

      BEGIN
      
      ImmediateData(15 DOWNTO 0) <= IR(15 DOWNTO 0);

      IF IR(15) = '0'  THEN
       ImmediateData(31 DOWNTO 16) <= (others => '0');
      ELSE 
       ImmediateData(31 DOWNTO 16) <= (others => '1');
      END IF;
      
    END PROCESS;
END a_SignExtend;
