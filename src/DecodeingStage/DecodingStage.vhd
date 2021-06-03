LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY DecodingStatge IS
    PORT( 
	     
	      IR_D : IN std_logic_vector(15 DOWNTO 0);
		  --------to register fie-------------------
          Clk_D : IN std_logic;
          Rest_D : IN std_logic;
          RegisterWrite_D: IN std_logic;
          RdstAddress_D : IN std_logic_vector(2 DOWNTO 0);
          WriteData_D : IN std_logic_vector(31 DOWNTO 0);
		  -------------------for Hazard Detection Unit------------------------------
		  
           RDST_IDEX_D : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
           MEM_READ_IDEX_D : IN STD_LOGIC := '0';
           BRANCH_CONDITION_D : IN STD_LOGIC := '0';
           BRANCH_D : IN STD_LOGIC := '0';
           JUMP_D : IN STD_LOGIC := '0';
		 ------------------------------------------------------------------------------
		 ------------------------------------------------
          Register1Data_D : OUT std_logic_vector(31 DOWNTO 0);
          Register2Data_D : OUT std_logic_vector(31 DOWNTO 0);
		  ----------------------------------------------
		  ControlSignals_D : OUT std_logic_vector(13 DOWNTO 0);
		  ---------------------------------------------
		  ImmediateData_D : OUT std_logic_vector(31 DOWNTO 0)

		  
		  );
		
END DecodingStatge;

ARCHITECTURE a_DecodingStatge OF DecodingStatge IS

COMPONENT RegisterFile IS
    PORT( 
	      IR : IN std_logic_vector(15 DOWNTO 0);
          Clk : IN std_logic;
          Rest : IN std_logic;
          RegisterWrite : IN std_logic;
          RdstAddress : IN std_logic_vector(2 DOWNTO 0);
          WriteData : IN std_logic_vector(31 DOWNTO 0);
          Register1Data : OUT std_logic_vector(31 DOWNTO 0);
          Register2Data : OUT std_logic_vector(31 DOWNTO 0)
         );
END COMPONENT;

--------------------------------------------------------------

COMPONENT ControlUnit IS
    PORT( 
	  IR : IN std_logic_vector(15 DOWNTO 0);
      ControlSignals : OUT std_logic_vector(13 DOWNTO 0)
	  );
END COMPONENT;    

------------------------------------------------------------   
COMPONENT SignExtend IS
    PORT( IR : IN std_logic_vector(15 DOWNTO 0);
          ImmediateData : OUT std_logic_vector(31 DOWNTO 0)
         );
END COMPONENT;
-----------------------------
COMPONENT MuxSignals IS
    PORT( ControlSignals : IN std_logic_vector(13 DOWNTO 0);
          CONTROL_HAZARD : IN STD_LOGIC ;
          DATA_HAZARD : IN STD_LOGIC ;
          OutSignals : OUT std_logic_vector(13 DOWNTO 0));
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

	SIGNAL SignalsfromcontrolUnit:std_logic_vector(13 DOWNTO 0);
	Signal CONTROL_HAZARDSignal :  STD_LOGIC ;
    Signal DATA_HAZARDSignal :  STD_LOGIC ;	      

  BEGIN

Registerfile_COMPONENT:RegisterFile PORT MAP(IR_D,Clk_D,Rest_D,RegisterWrite_D,RdstAddress_D,WriteData_D,Register1Data_D,Register2Data_D);
SignExtend_COMPONENT:SignExtend PORT MAP(IR_D,ImmediateData_D);
ControlUnit_COMPONENT:ControlUnit PORT MAP(IR_D,SignalsfromcontrolUnit);
HAZARD_COMPONENT:HAZARD PORT MAP(IR_D(6 DOWNTO 4),IR_D(9 DOWNTO 7),RDST_IDEX_D,MEM_READ_IDEX_D,BRANCH_CONDITION_D,BRANCH_D,JUMP_D,CONTROL_HAZARDSignal,DATA_HAZARDSignal);
MuxSignals_COMPONENT:MuxSignals PORT MAP(SignalsfromcontrolUnit,CONTROL_HAZARDSignal,DATA_HAZARDSignal,ControlSignals_D);






END a_DecodingStatge;
