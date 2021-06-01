library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity MemoryStage is
    GENERIC(n: INTEGER := 16);
  port (
    clk,SPsignal,enableMux: In std_logic;
    Pc,DataMemoryIn,Opcode,AluData,SP :IN std_logic_vector(n-1:0)
    Data : out std_logic_vector(n-1 : 0);
  ) ;
end MemoryStage ; 

architecture arch of MemoryStage is
signal memoryAdress,memoryData : std_logic_vector(n-1 downto 0);
begin
    process(clk)
    begin
        -- TODO :: make PcRead , SpAddress
        M1 : entity work.Mux  generic map(n) port map(clk,enableMux,Opcode,Pc,DataMemoryIn,memoryData);
        M2 : entity work.Mux  generic map(n) port map(clk,enableMux,SPsignal,AluData,SP,memoryAdress);
        Memo : entity work.ram generic map(n) port map(clk,MemoryRead,MemoryWrite,memoryAddress,memoryData,Data);
    end process;
end architecture ;