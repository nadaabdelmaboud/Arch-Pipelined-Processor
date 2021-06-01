LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY MuxSignals IS
    PORT( ControlSignals : IN std_logic_vector(13 DOWNTO 0);
          CONTROL_HAZARD : IN STD_LOGIC ;
          DATA_HAZARD : IN STD_LOGIC ;
          OutSignals : OUT std_logic_vector(13 DOWNTO 0));
END MuxSignals;

        

ARCHITECTURE a_MuxSignals OF MuxSignals IS
  BEGIN

      OutSignals(13 DOWNTO 0) <= (others => '0')  WHEN CONTROL_HAZARD = '1' or DATA_HAZARD = '1'
	ELSE ControlSignals(13 DOWNTO 0);
 
END a_MuxSignals;
