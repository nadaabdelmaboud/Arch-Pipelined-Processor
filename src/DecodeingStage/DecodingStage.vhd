LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY DecodingStage IS
    PORT (

        IR_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --------to register fie-------------------
        Clk_D : IN STD_LOGIC;
        Rest_D : IN STD_LOGIC;
        RegisterWrite_D : IN STD_LOGIC;
        RdstAddress_D : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteData_D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -------------------for Hazard Detection Unit------------------------------

        RDST_IDEX_D : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM_READ_IDEX_D : IN STD_LOGIC := '0';
        BRANCH_CONDITION_D : IN STD_LOGIC := '0';
        BRANCH_D : IN STD_LOGIC := '0';
        JUMP_D : IN STD_LOGIC := '0';
        ------------------------------------------------------------------------------
        ------------------------------------------------
        Register1Data_D : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Register2Data_D : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        ----------------------------------------------
        ControlSignals_D : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
        ---------------------------------------------
        ImmediateData_D : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        --------------------------------------------
        CONTROL_HAZARD_D : OUT STD_LOGIC := '0';
        DATA_HAZARD_D : OUT STD_LOGIC := '0';
        HAZARD_OUT : OUT STD_LOGIC := '0';
        OpCode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );

END DecodingStage;

ARCHITECTURE a_DecodingStatge OF DecodingStage IS

    COMPONENT RegisterFile IS
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
    END COMPONENT;

    --------------------------------------------------------------

    COMPONENT ControlUnit IS
        PORT (
            IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ControlSignals : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
        );
    END COMPONENT;

    ------------------------------------------------------------   
    COMPONENT SignExtend IS
        PORT (
            IR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ImmediateData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    -----------------------------
    COMPONENT MuxSignals IS
        PORT (
            IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ControlSignals : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            CONTROL_HAZARD : IN STD_LOGIC;
            DATA_HAZARD : IN STD_LOGIC;
            OutSignals : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
            OpCode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
    END COMPONENT;
    -----------------------------------------------------------
    COMPONENT HAZARD IS
        PORT (
            RSRC_IFID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RDST_IFID : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RDST_IDEX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MEM_READ_IDEX : IN STD_LOGIC := '0';
            BRANCH_CONDITION : IN STD_LOGIC := '0';
            BRANCH : IN STD_LOGIC := '0';
            JUMP : IN STD_LOGIC := '0';
            CONTROL_HAZARD : OUT STD_LOGIC := '0';
            DATA_HAZARD : OUT STD_LOGIC := '0'

        );
    END COMPONENT;

    ---------------------------------------------------------------

    SIGNAL SignalsfromcontrolUnit : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL CONTROL_HAZARDSignal : STD_LOGIC;
    SIGNAL DATA_HAZARDSignal : STD_LOGIC;
    SIGNAL TESTDATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OpCodeTMP : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN

    Registerfile_COMPONENT : RegisterFile PORT MAP(IR_D(31 DOWNTO 16), Clk_D, Rest_D, RegisterWrite_D, RdstAddress_D, WriteData_D, Register1Data_D, Register2Data_D);
    SignExtend_COMPONENT : SignExtend PORT MAP(IR_D(15 DOWNTO 0), ImmediateData_D);
    ControlUnit_COMPONENT : ControlUnit PORT MAP(IR_D(31 DOWNTO 16), SignalsfromcontrolUnit);
    HAZARD_COMPONENT : HAZARD PORT MAP(IR_D(22 DOWNTO 20), IR_D(25 DOWNTO 23), RDST_IDEX_D, MEM_READ_IDEX_D, BRANCH_CONDITION_D, BRANCH_D, JUMP_D, CONTROL_HAZARDSignal, DATA_HAZARDSignal);
    MuxSignals_COMPONENT : MuxSignals PORT MAP(IR_D, SignalsfromcontrolUnit, CONTROL_HAZARDSignal, DATA_HAZARDSignal, ControlSignals_D, OpCodeTMP);

    CONTROL_HAZARD_D <= CONTROL_HAZARDSignal;
    DATA_HAZARD_D <= DATA_HAZARDSignal;
    HAZARD_OUT <= CONTROL_HAZARDSignal OR DATA_HAZARDSignal;
    OpCode <= OpCodeTMP;
END a_DecodingStatge;