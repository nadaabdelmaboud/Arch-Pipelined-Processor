LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY ControlUnit IS
    PORT( IR : IN std_logic_vector(15 DOWNTO 0);
      ControlSignals : OUT std_logic_vector(13 DOWNTO 0));
END ControlUnit;

ARCHITECTURE a_ControlUnit OF ControlUnit IS
  BEGIN
  
    PROCESS(IR)

      BEGIN

      -------------------------------2-operand ----------------------------------
     
      IF (IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "000") THEN 
        ControlSignals <=  "00000000000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "00000100000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "010") THEN
        ControlSignals <=  "00000100000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "011") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "100") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "101") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "110") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "000" and IR(12 DOWNTO 10) = "111") THEN
        ControlSignals <=  "00000101000000";

     --------------------------------1-operand -------------------------------------
    
      ELSIF (IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "000") THEN 
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "010") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "011") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "100") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "101") THEN
        ControlSignals <=  "00000101000000";
      ELSIF(IR(15 DOWNTO 13) = "001" and IR(12 DOWNTO 10) = "110") THEN
        ControlSignals <=  "00000101000000";

       --------------------------------Immediate -------------------------------------
     
      ELSIF (IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "000") THEN 
        ControlSignals <=  "00000111000001";
      ELSIF(IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "00000111000001";
      ELSIF(IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "010") THEN
        ControlSignals <=  "00000111000001";
      ELSIF(IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "011") THEN
        ControlSignals <=  "00000111000001";
      ELSIF(IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "100") THEN
        ControlSignals <=  "00110111000001";
      ELSIF(IR(15 DOWNTO 13) = "010" and IR(12 DOWNTO 10) = "101") THEN
        ControlSignals <=  "00000111000001";

      --------------------------------INOUT-------------------------------------
   
      ELSIF (IR(15 DOWNTO 13) = "011" and IR(12 DOWNTO 10) = "000") THEN 
        ControlSignals <=  "00000000010000";
      ELSIF(IR(15 DOWNTO 13) = "011" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "00000101100000";

       --------------------------------Jump -------------------------------------
     
      ELSIF (IR(15 DOWNTO 13) = "100" and IR(12 DOWNTO 10) = "000") THEN 
        ControlSignals <=  "01000000000000";
      ELSIF(IR(15 DOWNTO 13) = "100" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "01000000000000";
      ELSIF(IR(15 DOWNTO 13) = "100" and IR(12 DOWNTO 10) = "010") THEN
        ControlSignals <=  "01000000000000";
      ELSIF(IR(15 DOWNTO 13) = "100" and IR(12 DOWNTO 10) = "011") THEN
        ControlSignals <=  "10000000000000";


      --------------------------------stack -------------------------------------
      
      ELSIF(IR(15 DOWNTO 13) = "101" and IR(12 DOWNTO 10) = "000") THEN
        ControlSignals <=  "10001001001000";
      ELSIF(IR(15 DOWNTO 13) = "101" and IR(12 DOWNTO 10) = "001") THEN
        ControlSignals <=  "00110101000110";
      ELSIF(IR(15 DOWNTO 13) = "101" and IR(12 DOWNTO 10) = "010") THEN
        ControlSignals <=  "00001000001000";
      ELSIF(IR(15 DOWNTO 13) = "101" and IR(12 DOWNTO 10) = "011") THEN
        ControlSignals <=  "00110001000100";
    

      END IF;
    END PROCESS;
END a_ControlUnit;
