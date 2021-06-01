LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY RegisterFile IS
    PORT( IR : IN std_logic_vector(15 DOWNTO 0);
          Clk : IN std_logic;
          Rest : IN std_logic;
          RegisterWrite : IN std_logic;
          RdstAddress : IN std_logic_vector(2 DOWNTO 0);
          WriteData : IN std_logic_vector(31 DOWNTO 0);
          Register1Data : OUT std_logic_vector(31 DOWNTO 0);
          Register2Data : OUT std_logic_vector(31 DOWNTO 0));
END RegisterFile;

ARCHITECTURE a_RegisterFile OF RegisterFile IS

COMPONENT Reg IS
Generic ( n : Integer:=32);
    PORT( clk,rst,enable : IN std_logic;
	    d: IN std_logic_vector(n-1 DOWNTO 0);
          q : OUT std_logic_vector(n-1 DOWNTO 0)
         );
END COMPONENT;

        Signal R0_Data : std_logic_vector(31 DOWNTO 0);
	Signal R1_Data : std_logic_vector(31 DOWNTO 0);
	Signal R2_Data : std_logic_vector(31 DOWNTO 0);
	Signal R3_Data : std_logic_vector(31 DOWNTO 0);
	Signal R4_Data : std_logic_vector(31 DOWNTO 0);
	Signal R5_Data : std_logic_vector(31 DOWNTO 0);
	Signal R6_Data : std_logic_vector(31 DOWNTO 0);
	Signal R7_Data : std_logic_vector(31 DOWNTO 0);
        SIGNAL Writeenable:std_logic_vector(7 DOWNTO 0);
        SIGNAL CanRead:std_logic:='0';

  BEGIN

Register0:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(0),WriteData,R0_Data);
Register1:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(1),WriteData,R1_Data);
Register2:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(2),WriteData,R2_Data);
Register3:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(3),WriteData,R3_Data);
Register4:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(4),WriteData,R4_Data);
Register5:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(5),WriteData,R5_Data);
Register6:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(6),WriteData,R6_Data);
Register7:Reg GENERIC MAP (32) PORT MAP(Clk,Rest,Writeenable(7),WriteData,R7_Data);
---------------------------------------------------------------------------------
PROCESS(Clk) IS  
      BEGIN
    	IF rising_edge(Clk) THEN  
	    CanRead<='0';	
         ELSIF falling_edge(Clk) THEN
            CanRead<='1';
    	END IF;
END PROCESS;

-----------------------------------------------------------------------------------
         ---Read Rsrc Data---> Register1Data----
       Register1Data <= R0_Data WHEN IR(6 DOWNTO 4) = "000" and CanRead='1'
	ELSE R1_Data WHEN IR(6 DOWNTO 4) = "001" and CanRead='1'
	ELSE R2_Data WHEN IR(6 DOWNTO 4) = "010" and CanRead='1'
        ELSE R3_Data WHEN IR(6 DOWNTO 4) = "011" and CanRead='1'
	ELSE R4_Data WHEN IR(6 DOWNTO 4) = "100" and CanRead='1'
        ELSE R5_Data WHEN IR(6 DOWNTO 4) = "101" and CanRead='1'
	ELSE R6_Data WHEN IR(6 DOWNTO 4) = "011" and CanRead='1'
        ELSE R7_Data WHEN IR(6 DOWNTO 4) = "111" and CanRead='1'
        ELSE  (others => '0')  ;
---------------------------------------------------------------------------
     ---Read Rdst Data---> Register1Data----
       Register2Data <= R0_Data WHEN IR(9 DOWNTO 7) = "000" and CanRead='1'
	ELSE R1_Data WHEN IR(9 DOWNTO 7) = "001" and CanRead='1'
	ELSE R2_Data WHEN IR(9 DOWNTO 7) = "010" and CanRead='1'
        ELSE R3_Data WHEN IR(9 DOWNTO 7) = "011" and CanRead='1'
	ELSE R4_Data WHEN IR(9 DOWNTO 7) = "100" and CanRead='1'
        ELSE R5_Data WHEN IR(9 DOWNTO 7) = "101" and CanRead='1'
	ELSE R6_Data WHEN IR(9 DOWNTO 7) = "011" and CanRead='1'
        ELSE R7_Data WHEN IR(9 DOWNTO 7) = "111" and CanRead='1'
        ELSE  (others => '0')  ;

-------------------------------------------------------------------------

     ---Write Data----

       Writeenable <= "00000001" WHEN RdstAddress = "000" and CanRead='0' and RegisterWrite='1'
	ELSE "00000010" WHEN RdstAddress = "001" and CanRead='0' and RegisterWrite='1'
	ELSE "00000100" WHEN RdstAddress = "010" and CanRead='0' and RegisterWrite='1'
        ELSE "00001000" WHEN RdstAddress = "011" and CanRead='0' and RegisterWrite='1'
	ELSE "00010000" WHEN RdstAddress = "100" and CanRead='0' and RegisterWrite='1'
        ELSE "00100000" WHEN RdstAddress = "101" and CanRead='0' and RegisterWrite='1'
	ELSE "01000000" WHEN RdstAddress = "011" and CanRead='0' and RegisterWrite='1'
        ELSE "10000000" WHEN RdstAddress = "111" and CanRead='0' and RegisterWrite='1'
        ELSE  (others => '0')  ;

------------------------------------------------------------------------

END a_RegisterFile;