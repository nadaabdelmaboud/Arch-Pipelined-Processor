LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY RegisterFile IS
    PORT( IR : IN std_logic_vector(15 DOWNTO 0);
          RegisterWrite : IN std_logic;
          Register1Data : OUT std_logic_vector(15 DOWNTO 0);
          Register2Data : OUT std_logic_vector(15 DOWNTO 0));
END RegisterFile;

ARCHITECTURE a_RegisterFile OF RegisterFile IS
  BEGIN
  
    PROCESS(IR,RegisterWrite)

      BEGIN

 
    END PROCESS;
END a_RegisterFile;