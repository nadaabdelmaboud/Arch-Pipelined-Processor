LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY ControlUnit IS
  PORT (
    IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ControlSignals : OUT STD_LOGIC_VECTOR(13 DOWNTO 0));
END ControlUnit;

ARCHITECTURE a_ControlUnit OF ControlUnit IS
BEGIN

  PROCESS (IR)

  BEGIN

    -------------------------------2-operand ----------------------------------

    IF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "00000000000000";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "00000100000000";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "010") THEN
      ControlSignals <= "00000100000000";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "011") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "100") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "101") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "110") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "000" AND IR(12 DOWNTO 10) = "111") THEN
      ControlSignals <= "00000100000100";

      --------------------------------1-operand -------------------------------------

    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "010") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "011") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "100") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "101") THEN
      ControlSignals <= "00000100000100";
    ELSIF (IR(15 DOWNTO 13) = "001" AND IR(12 DOWNTO 10) = "110") THEN
      ControlSignals <= "00000100000100";

      --------------------------------Immediate -------------------------------------

    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "00000110000101";
    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "00000110000101";
    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "010") THEN
      ControlSignals <= "00000110000101";
    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "011") THEN
      ControlSignals <= "00000110000101";
    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "100") THEN
      ControlSignals <= "00110110000101";
    ELSIF (IR(15 DOWNTO 13) = "010" AND IR(12 DOWNTO 10) = "101") THEN
      ControlSignals <= "00000110000101";

      --------------------------------INOUT-------------------------------------

    ELSIF (IR(15 DOWNTO 13) = "011" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "00000000100000";
    ELSIF (IR(15 DOWNTO 13) = "011" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "00000101000100";

      --------------------------------Jump -------------------------------------

    ELSIF (IR(15 DOWNTO 13) = "100" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "01000000000000";
    ELSIF (IR(15 DOWNTO 13) = "100" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "01000000000000";
    ELSIF (IR(15 DOWNTO 13) = "100" AND IR(12 DOWNTO 10) = "010") THEN
      ControlSignals <= "01000000000000";
    ELSIF (IR(15 DOWNTO 13) = "100" AND IR(12 DOWNTO 10) = "011") THEN
      ControlSignals <= "10000000000000";
      --------------------------------stack -------------------------------------

    ELSIF (IR(15 DOWNTO 13) = "101" AND IR(12 DOWNTO 10) = "000") THEN
      ControlSignals <= "10001000010100";
    ELSIF (IR(15 DOWNTO 13) = "101" AND IR(12 DOWNTO 10) = "001") THEN
      ControlSignals <= "00110100001110";
    ELSIF (IR(15 DOWNTO 13) = "101" AND IR(12 DOWNTO 10) = "010") THEN
      ControlSignals <= "00001000010000";
    ELSIF (IR(15 DOWNTO 13) = "101" AND IR(12 DOWNTO 10) = "011") THEN
      ControlSignals <= "00110000001100";
    END IF;
  END PROCESS;
END a_ControlUnit;