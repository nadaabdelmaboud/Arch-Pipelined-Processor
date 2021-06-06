LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Pipeline IS
    PORT (
        CLK, RST : IN STD_LOGIC;
        IN_PORT_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        OUT_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Pipeline;

ARCHITECTURE arch OF Pipeline IS
    COMPONENT Fetch IS
        PORT (
            RST : IN STD_LOGIC := '0';
            CLK : IN STD_LOGIC;
            JUMP : IN STD_LOGIC := '0';
            BRANCH : IN STD_LOGIC := '0';
            BRANCH_CONDITION : IN STD_LOGIC := '0';
            RET : IN STD_LOGIC := '0';
            IR_SIZE : IN STD_LOGIC := '0';
            CONTROL_HAZARD : IN STD_LOGIC := '0';
            DATA_HAZARD : IN STD_LOGIC := '0';
            HLT : IN STD_LOGIC := '0';
            RDST_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            MEM_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT DecodingStage IS
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
            HAZARD_OUT : OUT STD_LOGIC := '0'

        );

    END COMPONENT;
    COMPONENT Execution IS
        PORT (
            clk : IN STD_LOGIC;
            Signals : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            Opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            RdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RsrcAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RdstData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            RsrcData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            InData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ---From EX/MEM Buffer
            AluDataForwarded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            AluRdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RegWriteAlu, MemToRegAlu : IN STD_LOGIC;
            ---From EX/MEM Buffer
            MemDataForwarded : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MemRdstAddress : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MemToRegMem : IN STD_LOGIC;
            SP_POP_SIGNAL : IN STD_LOGIC;

            MemDataIn : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            AluDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Flags : INOUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
            SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT MemoryStage IS
        PORT (
            CLK : IN STD_LOGIC;
            MEM_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            OPcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            ALU_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP_SIGNAL : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEMEORY_READ : IN STD_LOGIC;
            MEMEORY_WRITE : IN STD_LOGIC;
            MEM_DATA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT WriteStage IS
        PORT (
            ALU_DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_DATA_OUT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_TO_REG : IN STD_LOGIC;
            WriteBackData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT IFID IS
        PORT (
            RST : IN STD_LOGIC;
            enable : IN STD_LOGIC := '1';
            clk : IN STD_LOGIC;
            IR_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IN_PORT_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            IN_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;
    COMPONENT IDEX IS
        PORT (
            RST : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            OPCODE_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rsrc_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            CONTROL_HAZARD_D : IN STD_LOGIC;
            DATA_HAZARD_D : IN STD_LOGIC;
            HAZARD_D : IN STD_LOGIC;
            PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rsrc_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rdst_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IN_PORT_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IMMEDIATE_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
            OPCODE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
            Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
            Rsrc_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
            PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            Rsrc_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            Rdst_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            IN_PORT_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            IMMEDIATE_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            CONTROL_HAZARD_IDEX : OUT STD_LOGIC := '0';
            DATA_HAZARD_IDEX : OUT STD_LOGIC := '0';
            HAZARD_IDEX : OUT STD_LOGIC := '0'

        );
    END COMPONENT;
    COMPONENT EXMEM IS
        PORT (
            RST : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            OPCODE_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEMORY_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALU_DATA_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Flags_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
            OPCODE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
            Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
            PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            MEMORY_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            ALU_DATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            SP : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            Flags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')
        );
    END COMPONENT;
    COMPONENT MEMWB IS
        PORT (
            RST : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            SIGNALS_IN : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            Rdst_Address_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MEMORY_DATAOUT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALU_DATAOUT_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SIGNALS : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) := (OTHERS => '0');
            Rdst_Address : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
            MEMORY_DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
            ALU_DATAOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')

        );
    END COMPONENT;
    SIGNAL RST_SIGNAL : STD_LOGIC;
    ----------------------------FETCH------------------------------

    SIGNAL RET : STD_LOGIC := '0'; -- ZERO --

    ------Input To IF/ID Buffer
    SIGNAL IR_FETCH : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC_FETCH : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL IFID_BUFFER_ENABLE : STD_LOGIC;

    --OUT FROM IF/ID--
    SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IN_PORT_DATA_IFID : STD_LOGIC_VECTOR(31 DOWNTO 0);
    ---------------------------------------Decode-----------------------------------

    ------Input To ID/EX Buffer FROM DECODE STAGE
    SIGNAL Register1Data_D : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Register2Data_D : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Signals_Decode : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL ImmediateData_D : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CONTROL_HAZARD_D : STD_LOGIC := '0';
    SIGNAL DATA_HAZARD_D : STD_LOGIC := '0';
    SIGNAL HAZARD_D : STD_LOGIC := '0';

    ------OUTPUT FROM ID/EX Buffer
    SIGNAL OPCODE_IDEX : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL SIGNALS_IDEX : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL Rdst_Address_IDEX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc_Address_IDEX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PC_IDEX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rsrc_DATA_IDEX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rdst_DATA_IDEX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IN_PORT_DATA_IDEX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IMMEDIATE_DATA_IDEX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CONTROL_HAZARD_IDEX : STD_LOGIC := '0';
    SIGNAL DATA_HAZARD_IDEX : STD_LOGIC := '0';
    SIGNAL HAZARD_IDEX : STD_LOGIC := '0';
    ----------------------------------Execution-------------------------------------

    ---From MEM/WB Buffer
    SIGNAL MemDataForwarded : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MemRdstAddress : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MemToRegMem : STD_LOGIC;
    ---From MEM/WB Buffer

    SIGNAL SP_EXEC_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL MemDataIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL AluDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Flags : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

    ------------------------OUTPUT FROM EXMEM BUFFER-------------

    SIGNAL SIGNALS_EXMEM : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL OPCODE_EXMEM : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Rdst_Address_EXMEM : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PC_EXMEM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MEMORY_DATA_EXMEM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_DATA_EXMEM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP_EXMEM : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FLAGS_EXMEM : STD_LOGIC_VECTOR(2 DOWNTO 0);

    ----------------------------------Memory-------------------------------------
    SIGNAL MEM_DATA_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);

    ----------------------OUTPUT FROM MEM/WB BUFFER
    SIGNAL SIGNALS_WB : STD_LOGIC_VECTOR(13 DOWNTO 0);
    SIGNAL Rdst_Address_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEMORY_DATAOUT_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_DATAOUT_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);

    ----------------------------------WriteBack-------------------------------------

    SIGNAL WriteBackData : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    RST_SIGNAL <= NOT CLK AND RST;
    OUT_PORT_DATA <= MemDataIn WHEN SIGNALS_IDEX(5) = '1'; --out signal
    IFID_BUFFER_ENABLE <= NOT DATA_HAZARD_IDEX;
    Fetch_Stage : Fetch PORT MAP(RST_SIGNAL, CLK, SIGNALS_EXMEM(13), SIGNALS_EXMEM(12), FLAGS_EXMEM(0), RET, Signals_Decode(0), CONTROL_HAZARD_D, DATA_HAZARD_D, '0', MEMORY_DATA_EXMEM, MEMORY_DATAOUT_WB, IR_FETCH, PC_FETCH);
    IFID_BUFFER : IFID PORT MAP(RST_SIGNAL, '1', CLK, IR_FETCH, PC_FETCH, IN_PORT_DATA, IR, PC, IN_PORT_DATA_IFID);

    Decoding_Stage : DecodingStage PORT MAP(IR, CLK, RST_SIGNAL, SIGNALS_WB(2), Rdst_Address_WB, WriteBackData, Rdst_Address_IDEX, SIGNALS_IDEX(11), FLAGS_EXMEM(0), SIGNALS_EXMEM(12), SIGNALS_EXMEM(13), Register1Data_D, Register2Data_D, Signals_Decode, ImmediateData_D, CONTROL_HAZARD_D, DATA_HAZARD_D, HAZARD_D);
    IDEX_BUFFER : IDEX PORT MAP(RST_SIGNAL, '1', CLK, Signals_Decode, IR(31 DOWNTO 26), IR(25 DOWNTO 23), IR(22 DOWNTO 20), CONTROL_HAZARD_D, DATA_HAZARD_D, HAZARD_D, PC, Register1Data_D, Register2Data_D, IN_PORT_DATA_IFID, ImmediateData_D, SIGNALS_IDEX, OPCODE_IDEX, Rdst_Address_IDEX, Rsrc_Address_IDEX, PC_IDEX, Rsrc_DATA_IDEX, Rdst_DATA_IDEX, IN_PORT_DATA_IDEX, IMMEDIATE_DATA_IDEX, CONTROL_HAZARD_IDEX, DATA_HAZARD_IDEX, HAZARD_IDEX);

    Execution_Stage : Execution PORT MAP(CLK, SIGNALS_IDEX, OPCODE_IDEX, Rdst_Address_IDEX, Rsrc_Address_IDEX, Rdst_DATA_IDEX, Rsrc_DATA_IDEX, IN_PORT_DATA_IDEX, IMMEDIATE_DATA_IDEX, ALU_DATA_EXMEM, Rdst_Address_EXMEM, SIGNALS_EXMEM(2), SIGNALS_EXMEM(10), WriteBackData, Rdst_Address_WB, SIGNALS_WB(2), SIGNALS_EXMEM(3), MemDataIn, AluDataOut, Flags, SP_EXEC_OUT);

    EXMEM_BUFFER : EXMEM PORT MAP(RST_SIGNAL, '1', CLK, SIGNALS_IDEX, OPCODE_IDEX, Rdst_Address_IDEX, PC_IDEX, MemDataIn, AluDataOut, SP_EXEC_OUT, Flags, SIGNALS_EXMEM, OPCODE_EXMEM, Rdst_Address_EXMEM, PC_EXMEM, MEMORY_DATA_EXMEM, ALU_DATA_EXMEM, SP_EXMEM, FLAGS_EXMEM);

    Memory_Stage : MemoryStage PORT MAP(CLK, MEMORY_DATA_EXMEM, PC_EXMEM, OPCODE_EXMEM, ALU_DATA_EXMEM, SIGNALS_EXMEM(4 DOWNTO 3), SP_EXMEM, SIGNALS_EXMEM(11), SIGNALS_EXMEM(9), MEM_DATA_OUT);
    MEMWB_BUFFER : MEMWB PORT MAP(RST_SIGNAL, '1', CLK, SIGNALS_EXMEM, Rdst_Address_EXMEM, MEM_DATA_OUT, ALU_DATA_EXMEM, SIGNALS_WB, Rdst_Address_WB, MEMORY_DATAOUT_WB, ALU_DATAOUT_WB);

    Write_Stage : WriteStage PORT MAP(ALU_DATAOUT_WB, MEMORY_DATAOUT_WB, SIGNALS_WB(10), WriteBackData);

END ARCHITECTURE;