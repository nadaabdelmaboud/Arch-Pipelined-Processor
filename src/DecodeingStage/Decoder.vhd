library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity decoder is
port(
	selection: in std_logic_vector(2 downto 0);
	Write : in STD_LOGIC;
	Read : in STD_LOGIC;
	outEnable_decoder : out STD_LOGIC_VECTOR(7 downto 0);
	inEnable_decoder : out STD_LOGIC_VECTOR(7 downto 0)
	);
end decoder;

architecture adecoder of decoder is
begin

	outEnable_decoder <= "10000000" when selection ="000" and Read ='1'
	else "01000000" when selection ="001" and Read ='1'
	else "00100000" when selection = "010" and Read ='1'
	else "00010000" when selection = "011" and Read ='1'
	else "00001000" when selection = "100" and Read ='1'
	else "00000100" when selection = "101" and Read ='1'
	else "00000010" when selection = "110" and Read ='1'
	else "00000001" when selection = "111" and Read ='1'
	else "00000000";

	inEnable_decoder <= "10000000" when selection ="000" and Write ='1'
	else "01000000" when selection ="001" and Write ='1'
	else "00100000" when selection = "010" and Write ='1'
	else "00010000" when selection = "011" and Write ='1'
	else "00001000" when selection = "100" and Write ='1'
	else "00000100" when selection = "101" and Write ='1'
	else "00000010" when selection = "110" and Write ='1'
	else "00000001" when selection = "111" and Write ='1'
	else "00000000";
end adecoder;
