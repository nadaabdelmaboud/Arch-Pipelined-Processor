LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY MuxSignals IS
    PORT( ControlSignals : IN std_logic_vector(13 DOWNTO 0);
          HazardDetected : IN std_logic;
          Signals : OUT std_logic_vector(13 DOWNTO 0));
END MuxSignals;

ARCHITECTURE a_MuxSignals OF MuxSignals IS
  BEGIN
  
    PROCESS(ControlSignals,HazardDetected)

      BEGIN

       IF HazardDetected = '0'  THEN
       Signals(13 DOWNTO 0) <= ControlSignals(13 DOWNTO 0);
      ELSE 
       Signals(13 DOWNTO 0) <= (others => '0');
      END IF;
 
    END PROCESS;
END a_MuxSignals;
