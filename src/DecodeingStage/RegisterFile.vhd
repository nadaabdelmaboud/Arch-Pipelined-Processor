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
                Register2Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
END RegisterFile;

ARCHITECTURE a_RegisterFile OF RegisterFile IS

        COMPONENT Regggg IS
                GENERIC (n : INTEGER := 32);
                PORT (
                        clk, rst, enable : IN STD_LOGIC;
                        d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
                        storevalue : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0'));
        END COMPONENT;

        SIGNAL Writeenable : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

        SIGNAL CanRead : STD_LOGIC := '0';

        SIGNAL Data0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIGNAL Data7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

        Register0 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(0), WriteData, Data0);
        Register1 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(1), WriteData, Data1);
        Register2 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(2), WriteData, Data2);
        Register3 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(3), WriteData, Data3);
        Register4 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(4), WriteData, Data4);
        Register5 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(5), WriteData, Data5);
        Register6 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(6), WriteData, Data6);
        Register7 : Regggg GENERIC MAP(32) PORT MAP(Clk, Rest, Writeenable(7), WriteData, Data7);
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
        Register1Data <= Data0 WHEN IR(6 DOWNTO 4) = "000" AND CanRead = '1'
                ELSE
                Data1 WHEN IR(6 DOWNTO 4) = "001" AND CanRead = '1'
                ELSE
                Data2 WHEN IR(6 DOWNTO 4) = "010" AND CanRead = '1'
                ELSE
                Data3 WHEN IR(6 DOWNTO 4) = "011" AND CanRead = '1'
                ELSE
                Data4 WHEN IR(6 DOWNTO 4) = "100" AND CanRead = '1'
                ELSE
                Data5 WHEN IR(6 DOWNTO 4) = "101" AND CanRead = '1'
                ELSE
                Data6 WHEN IR(6 DOWNTO 4) = "011" AND CanRead = '1'
                ELSE
                Data7 WHEN IR(6 DOWNTO 4) = "111" AND CanRead = '1'
                ELSE
                (OTHERS => '0');
        ---------------------------------------------------------------------------
        ---Read Rdst Data---> Register1Data----
        Register2Data <= Data0 WHEN IR(9 DOWNTO 7) = "000" AND CanRead = '1'
                ELSE
                Data1 WHEN IR(9 DOWNTO 7) = "001" AND CanRead = '1'
                ELSE
                Data2 WHEN IR(9 DOWNTO 7) = "010" AND CanRead = '1'
                ELSE
                Data3 WHEN IR(9 DOWNTO 7) = "011" AND CanRead = '1'
                ELSE
                Data4 WHEN IR(9 DOWNTO 7) = "100" AND CanRead = '1'
                ELSE
                Data5 WHEN IR(9 DOWNTO 7) = "101" AND CanRead = '1'
                ELSE
                Data6 WHEN IR(9 DOWNTO 7) = "011" AND CanRead = '1'
                ELSE
                Data7 WHEN IR(9 DOWNTO 7) = "111" AND CanRead = '1'
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