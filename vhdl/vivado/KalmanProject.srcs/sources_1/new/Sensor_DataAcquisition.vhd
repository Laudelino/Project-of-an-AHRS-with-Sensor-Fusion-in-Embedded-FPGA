library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Sensor_DataAcquisition is
    Port (  ACLK : in STD_LOGIC;
            capture_clk : in STD_LOGIC;
            user_r_read_rden : in STD_LOGIC;
            user_r_read_open : in STD_LOGIC;
            user_r_read_data : out STD_LOGIC_VECTOR(31 downto 0);
            user_r_read_empty : out STD_LOGIC;
            user_r_read_eof : out STD_LOGIC;
            Sensor_in : in STD_LOGIC_VECTOR(31 downto 0)
    );
end Sensor_DataAcquisition;

architecture Sensor_DataAcquisition_Behavioral of Sensor_DataAcquisition is

-- ==============================================================================
--                  Component Declarations
-- ==============================================================================
    COMPONENT PLPS_FIFO
      PORT (
        rst : IN STD_LOGIC;
        wr_clk : IN STD_LOGIC;
        rd_clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END COMPONENT;
-- ==============================================================================
--                                Signals, Constants, Types
-- ==============================================================================
signal reset, FIFO_wr_en, FIFO_Full : STD_LOGIC;
signal Sensor_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal capture_has_been_full : std_logic;
signal capture_has_been_nonfull : std_logic;
signal capture_open         : std_logic;
signal capture_open_cross   : std_logic;
signal has_been_full        : std_logic;
signal has_been_full_cross  : std_logic;


-- ==============================================================================
--                                           Implementation
-- ==============================================================================
begin

Sensor_FIFO : PLPS_FIFO
     PORT MAP (
       rst => reset,
       wr_clk => capture_clk,
       rd_clk => ACLK,
       din => Sensor_Data,
       wr_en => FIFO_wr_en,
       rd_en => user_r_read_rden,
       dout => user_r_read_data,
       full => FIFO_Full,
       empty => user_r_read_empty
     );    
     
--Sensor capture
    process (capture_clk)
      begin
        if (capture_clk'event and capture_clk = '1') then
            if  (FIFO_wr_en = '1') then
                Sensor_Data <= Sensor_in;
            end if;
    
            if  (FIFO_Full = '0' ) then
                capture_has_been_nonfull <= '1' ;
            elsif  ( capture_open = '0' ) then
                capture_has_been_nonfull <= '0' ;
            end if;
    
            if  (FIFO_Full = '1' and capture_has_been_nonfull = '1' ) then
                capture_has_been_full <= '1' ;
            elsif  ( capture_open = '0' ) then
                capture_has_been_full <= '0' ;
            end if;
        end if;
      end process;

      --change from clock domain.    
      process (capture_clk)
      begin
        if (capture_clk'event and capture_clk = '1') then
          capture_open_cross <= user_r_read_open;
          capture_open <= capture_open_cross ;
        end if;
      end process;
    
      --change from clock domain.
      process (ACLK)
      begin
        if (ACLK'event and ACLK = '1') then
          has_been_full_cross <= capture_has_been_full ;
          has_been_full <= has_been_full_cross ;
        end if;
      end process;
--end Sensor capture   


    FIFO_wr_en <= capture_open and not FIFO_Full
                 and not capture_has_been_full ;
    reset <= NOT (user_r_read_open);
    user_r_read_eof <= '0';
end Sensor_DataAcquisition_Behavioral;