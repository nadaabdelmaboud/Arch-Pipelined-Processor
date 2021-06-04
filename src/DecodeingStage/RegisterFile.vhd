LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY RegisterFile IS
        PORT (
                IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                Clk : IN STD_LOGIC;
                Rest : IN STD_LOGIC;
                RegisterWrite : IN STD_LOGIC;
                RdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                Register1Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                Register2Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END RegisterFile;

ARCHITECTURE a_RegisterFile OF RegisterFile IS

        COMPONENT Reg IS
                GENERIC (n : INTEGER := 32);
                PORT (
                        clk, rst, enable : IN STD_LOGIC;
                        d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
                        q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
                );
        END COMPONENT;

        SIGNAL R0_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R1_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R2_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R3_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R4_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R5_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R6_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL R7_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Writeenable : STD_LOGIC_VECTOR(7 DOWNTO 0);
        SIGNAL CanRead : STD_LOGIC := '0';

BEGIN

        Register0 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(0), WriteData, R0_Data);
        Register1 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(1), WriteData, R1_Data);
        Register2 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(2), WriteData, R2_Data);
        Register3 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(3), WriteData, R3_Data);
        Register4 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(4), WriteData, R4_Data);
        Register5 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(5), WriteData, R5_Data);
        Register6 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(6), WriteData, R6_Data);
        Register7 : Reg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(7), WriteData, R7_Data);
        ---------------------------------------------------------------------------------
        PROCESS (Clk) IS
        BEGIN
                IF rising_edge(Clk) THEN
                        CanRead <= '1';
                ELSIF falling_edge(Clk) THEN
                        CanRead <= '0';
                END IF;
        END PROCESS;

        -----------------------------------------------------------------------------------
        ---Read Rsrc Data---> Register1Data----
        Register1Data <= R0_Data WHEN IR(6 DOWNTO 4) = "000" AND CanRead = '1'
                ELSE
                R1_Data WHEN IR(6 DOWNTO 4) = "001" AND CanRead = '1'
                ELSE
                R2_Data WHEN IR(6 DOWNTO 4) = "010" AND CanRead = '1'
                ELSE
                R3_Data WHEN IR(6 DOWNTO 4) = "011" AND CanRead = '1'
                ELSE
                R4_Data WHEN IR(6 DOWNTO 4) = "100" AND CanRead = '1'
                ELSE
                R5_Data WHEN IR(6 DOWNTO 4) = "101" AND CanRead = '1'
                ELSE
                R6_Data WHEN IR(6 DOWNTO 4) = "011" AND CanRead = '1'
                ELSE
                R7_Data WHEN IR(6 DOWNTO 4) = "111" AND CanRead = '1'
                ELSE
                (OTHERS => '0');
        ---------------------------------------------------------------------------
        ---Read Rdst Data---> Register1Data----
        Register2Data <= R0_Data WHEN IR(9 DOWNTO 7) = "000" AND CanRead = '1'
                ELSE
                R1_Data WHEN IR(9 DOWNTO 7) = "001" AND CanRead = '1'
                ELSE
                R2_Data WHEN IR(9 DOWNTO 7) = "010" AND CanRead = '1'
                ELSE
                R3_Data WHEN IR(9 DOWNTO 7) = "011" AND CanRead = '1'
                ELSE
                R4_Data WHEN IR(9 DOWNTO 7) = "100" AND CanRead = '1'
                ELSE
                R5_Data WHEN IR(9 DOWNTO 7) = "101" AND CanRead = '1'
                ELSE
                R6_Data WHEN IR(9 DOWNTO 7) = "011" AND CanRead = '1'
                ELSE
                R7_Data WHEN IR(9 DOWNTO 7) = "111" AND CanRead = '1'
                ELSE
                (OTHERS => '0');

        -------------------------------------------------------------------------

        ---Write Data----

        Writeenable <= "00000001" WHEN RdstAddress = "000" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "00000010" WHEN RdstAddress = "001" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "00000100" WHEN RdstAddress = "010" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "00001000" WHEN RdstAddress = "011" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "00010000" WHEN RdstAddress = "100" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "00100000" WHEN RdstAddress = "101" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "01000000" WHEN RdstAddress = "011" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                "10000000" WHEN RdstAddress = "111" AND CanRead = '0' AND RegisterWrite = '1'
                ELSE
                (OTHERS => '0');

        ------------------------------------------------------------------------

END a_RegisterFile;