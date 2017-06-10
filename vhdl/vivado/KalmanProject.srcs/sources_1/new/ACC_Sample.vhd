----------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Author:  Albert Fazakas
--          Copyright 2014 Digilent, Inc.
----------------------------------------------------------------------------
-- 
-- Create Date:    15:00:45 03/04/2014 
-- Design Name: 
-- Module Name:    AccelerometerCtl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--       This is the main module for the the Nexys4 onboard ADXL362 accelerometer.
--    The module consists of two components, AXDX362Ctrl and AccelArithmetics. The first one
--    configures the ADXL362 accelerometer and continuously reads X, Y, Z acceleration data and
--    temperature data in 12-bit two's complement format. 
--       The data read is sent to the AccelArithmetics module that formats X and Y acceleration 
--    data to be displayed on the VGA screen in a 512 X 512 pixel area. Therefore the X and Y 
--    acceleration data will be scaled and limited to -1g: 0, 0g: 255, 1g: 511.
--       The AccelArithmetics module also determines the acceleration  magnitude using the
--    SQRT (X^2 + Y^2 + Z^2) formula. The magnitude value is also displayed on the VGA screen.
--    To perform SQRT calculation a Logicore component is used.
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Matrix_def.all;

entity ACC_Sample is
    generic 
    (
        SYSCLK_FREQUENCY_HZ : integer := 100000000;
        SCLK_FREQUENCY_HZ   : integer := 1000000;
        NUM_READS_AVG       : integer := 16;
        UPDATE_FREQUENCY_HZ : integer := 100
    );
    port
    (
        ACLK     : in STD_LOGIC; -- System Clock
        RESET      : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;


        -- Spi interface Signals
        ACC : inout  STD_LOGIC_VECTOR (3 downto 0);
        
        Acc_TValid : out STD_LOGIC;
        Acc_TReady : in STD_LOGIC;
        -- Accelerometer data signals
        ACCEL_X_OUT    : out STD_LOGIC_VECTOR (31 downto 0);
        ACCEL_Y_OUT    : out STD_LOGIC_VECTOR (31 downto 0);
        ACCEL_Z_OUT  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end ACC_Sample;

architecture Behavioral of ACC_Sample is

    component ACC_SPI_Master
    generic 
    (
        SYSCLK_FREQUENCY_HZ : integer := 100000000;
        SCLK_FREQUENCY_HZ   : integer := 1000000;
        NUM_READS_AVG       : integer := 16;
        UPDATE_FREQUENCY_HZ : integer := 1000
    );
    port
    (
        SYSCLK     : in STD_LOGIC; -- System Clock
        RESET      : in STD_LOGIC;
        
        -- Accelerometer data signals
        ACCEL_X    : out STD_LOGIC_VECTOR (15 downto 0);
        ACCEL_Y    : out STD_LOGIC_VECTOR (15 downto 0);
        ACCEL_Z    : out STD_LOGIC_VECTOR (15 downto 0);
        ACCEL_TMP  : out STD_LOGIC_VECTOR (15 downto 0);
        Data_Ready : out STD_LOGIC;
        
        --SPI Interface Signals
        SCLK       : out STD_LOGIC;
        MOSI       : out STD_LOGIC;
        MISO       : in STD_LOGIC;
        SS         : out STD_LOGIC
    );
    end component;

    COMPONENT fp_conv
      PORT (
        aclk : IN STD_LOGIC;
        aclken : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tready : OUT STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;

    COMPONENT fp_mul
      PORT (
        aclk : IN STD_LOGIC;
        aclken : IN STD_LOGIC;
        aresetn : IN STD_LOGIC;
        s_axis_a_tvalid : IN STD_LOGIC;
        s_axis_a_tready : OUT STD_LOGIC;
        s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axis_b_tvalid : IN STD_LOGIC;
        s_axis_b_tready : OUT STD_LOGIC;
        s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;
    -- Self-blocking reset counter constants
    constant ACC_RESET_PERIOD_US : integer := 10;
    constant ACC_RESET_IDLE_CLOCKS   : integer := ((ACC_RESET_PERIOD_US*1000)/(1000000000/SYSCLK_FREQUENCY_HZ));
    
    signal  ACCEL_X    : STD_LOGIC_VECTOR (15 downto 0);
    signal  ACCEL_Y    : STD_LOGIC_VECTOR (15 downto 0);
    signal  ACCEL_Z    : STD_LOGIC_VECTOR (15 downto 0);
    
    signal Data_Ready : STD_LOGIC;
    
    -- Self-blocking reset counter
    signal cnt_acc_reset : integer range 0 to (ACC_RESET_IDLE_CLOCKS - 1):= 0;
    signal RESET_INT: std_logic;
    
    signal  ACCEL_TMP_OUT  : STD_LOGIC_VECTOR (15 downto 0);
    
    signal tmpex_X : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;  
    signal tmpex_Y : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;          
    signal tmpex_Z : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;    
    signal tmp_X : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;  
    signal tmp_Y : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;          
    signal tmp_Z : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;
    signal tmpfp_X : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;  
    signal tmpfp_Y : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;          
    signal tmpfp_Z : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;   
    signal tmpsc_X : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;  
    signal tmpsc_Y : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;          
    signal tmpsc_Z : STD_LOGIC_VECTOR(31 DOWNTO 0) := ZERO;
    
    signal scalez : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00111010100000110001001001101111";
    signal scale : STD_LOGIC_VECTOR(31 DOWNTO 0) := "10111010100000110001001001101111";     
    signal Acc_IN_TVALID, TREADYX, TREADYY, TREADYZ, AccXConv_TValid, AccYConv_TValid, AccZConv_TValid, Acc_TValid_i : STD_LOGIC;
    signal Acc_ConvXTReady, Acc_ConvYTReady, Acc_ConvZTReady, AccX_TValid, AccY_TValid, AccZ_TValid : STD_LOGIC;
    signal ScaleXReady, ScaleYReady, ScaleZReady : STD_LOGIC;

    SIGNAL C_ACLKEn : STD_LOGIC := '0';
    SIGNAL C_AResetn : STD_LOGIC := '0';
    SIGNAL C_IN_VALID : STD_LOGIC := '0';
    SIGNAL C_IN_READY : STD_LOGIC := '0';
    SIGNAL C_IN_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL C_OUT_VALID : STD_LOGIC := '0';
    SIGNAL C_OUT_READY : STD_LOGIC := '0';
    SIGNAL C_OUT_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL M_ACLKEn : STD_LOGIC := '0';
    SIGNAL M_AResetn : STD_LOGIC := '0';
    SIGNAL M_IN_VALID : STD_LOGIC := '0';
    SIGNAL M_IN_READY : STD_LOGIC := '0';
    SIGNAL M_IN_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M_IN_SCALE : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M_OUT_VALID : STD_LOGIC := '0';
    SIGNAL M_OUT_READY : STD_LOGIC := '0';
    SIGNAL M_OUT_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M_IN_SCALE_VALID  : STD_LOGIC := '0';
    SIGNAL M_IN_SCALE_READY : STD_LOGIC := '0';

    SIGNAL state : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL INTERNAL_INPUT_READY  : STD_LOGIC := '0';
    SIGNAL INTERNAL_DATAREADY_FALL : STD_LOGIC := '1';
    SIGNAL INTERNAL_DATAREADY_TVALID : STD_LOGIC := '0';
begin


-- Create the self-blocking reset counter
COUNT_RESET: process(ACLK, cnt_acc_reset, RESET)
begin
   if ACLK'EVENT and ACLK = '1' then
      if (RESET = '1') then
         cnt_acc_reset <= 0;
         RESET_INT <= '1';
      elsif cnt_acc_reset = (ACC_RESET_IDLE_CLOCKS - 1) then
         cnt_acc_reset <= (ACC_RESET_IDLE_CLOCKS - 1);
         RESET_INT <= '0';
      else
         cnt_acc_reset <= cnt_acc_reset + 1;
         RESET_INT <= '1';
      end if;
   end if;
end process COUNT_RESET;


ADXL_Control: ACC_SPI_Master
generic map
(
   SYSCLK_FREQUENCY_HZ  => SYSCLK_FREQUENCY_HZ,
   SCLK_FREQUENCY_HZ    => SCLK_FREQUENCY_HZ,
   NUM_READS_AVG        => NUM_READS_AVG,   
   UPDATE_FREQUENCY_HZ  => UPDATE_FREQUENCY_HZ
)
port map
(
 SYSCLK     => ACLK, 
 RESET      => RESET_INT, 
 
 -- Accelerometer data signals
 ACCEL_X    => ACCEL_X,
 ACCEL_Y    => ACCEL_Y, 
 ACCEL_Z    => ACCEL_Z,
 ACCEL_TMP  => ACCEL_TMP_OUT, 
 Data_Ready => Data_Ready, 
 
 --SPI Interface Signals
 SCLK       => ACC(3), 
 MOSI       => ACC(1),
 MISO       => ACC(2), 
 SS         => ACC(0)
);


tmpex_X   <= "0000000000000000" & ACCEL_X WHEN ACCEL_X(15) = '0'
                 ELSE "1111111111111111" & ACCEL_X;
tmpex_Y   <= "0000000000000000" & ACCEL_Y WHEN ACCEL_Y(15) = '0'
                 ELSE "1111111111111111" & ACCEL_Y; 
tmpex_Z   <= "0000000000000000" & ACCEL_Z WHEN ACCEL_Z(15) = '0'
                 ELSE "1111111111111111" & ACCEL_Z;

CONV_C: fp_conv
PORT MAP (
 aclk => ACLK,
 aclken => C_ACLKEn,
 aresetn => C_AResetn,
 s_axis_a_tvalid => C_IN_VALID,
 s_axis_a_tready => C_IN_READY,
 s_axis_a_tdata => C_IN_DATA,
 m_axis_result_tvalid => C_OUT_VALID,
 m_axis_result_tready => C_OUT_READY,
 m_axis_result_tdata => C_OUT_DATA
);

SCALE_M: fp_mul
PORT MAP (
 aclk => ACLK,
 aclken => M_ACLKEn,
 aresetn => M_AResetn,
 s_axis_a_tvalid => M_IN_VALID,
 s_axis_a_tready => M_IN_READY,
 s_axis_a_tdata => M_IN_DATA,
 s_axis_b_tvalid => M_IN_SCALE_VALID,
 s_axis_b_tready => M_IN_SCALE_READY,
 s_axis_b_tdata => M_IN_SCALE,
 m_axis_result_tvalid => M_OUT_VALID,
 m_axis_result_tready => M_OUT_READY,
 m_axis_result_tdata => M_OUT_DATA
);


DATAREADYP: PROCESS(ACLK)
begin
   if (rising_edge(ACLK)) then  
       if(Data_Ready = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_DATAREADY_FALL = '1') then
           INTERNAL_DATAREADY_TVALID <= '1';
           INTERNAL_DATAREADY_FALL <= '0';
           tmp_X   <= tmpex_X;
           tmp_Y   <= tmpex_Y; 
           tmp_Z   <= tmpex_Z;   
       end if;
       if(Data_Ready = '0' OR INTERNAL_INPUT_READY = '0') then
           INTERNAL_DATAREADY_TVALID <= '0';
       end if;
       if(Data_Ready = '0') then
           INTERNAL_DATAREADY_FALL <= '1';
       end if;
   end if;
end process;

TREADY <= INTERNAL_INPUT_READY;

P_CONV: process(ACLK)
variable count : integer := 0;
begin
if(rising_edge(ACLK)) then
    if(AResetn = '0' OR ACLKEn = '0') then
       C_ACLKEn <= '0';
       C_AResetn <= '0';
       C_IN_VALID <= '0';
       C_IN_DATA <= ZERO;
       C_OUT_READY <= '0';
       M_ACLKEn <= '0';
       M_AResetn <= '0';
       M_IN_VALID <= '0';
       M_IN_DATA <= ZERO;
       M_IN_SCALE <= ZERO; 
       M_OUT_READY <= '0';
       INTERNAL_INPUT_READY <= '0';
       Acc_TValid <= '0';
      
       ACCEL_X_OUT <= ZERO;
       ACCEL_Y_OUT <= ZERO;
       ACCEL_Z_OUT <= ZERO; 
        
       state <= "00000"; 
       count := 0;
    elsif(AResetn = '1' AND ACLKEn = '1') then
        case state is
            when "00000" =>
               INTERNAL_INPUT_READY <= '1';
                if(INTERNAL_DATAREADY_TVALID = '1') then
                   C_ACLKEn <= '0';
                   C_AResetn <= '0';
                   C_IN_VALID <= '0';
                   C_IN_DATA <= ZERO;
                   C_OUT_READY <= '0';
                   M_ACLKEn <= '0';
                   M_AResetn <= '0';
                   M_IN_VALID <= '0';
                   M_IN_DATA <= ZERO;
                   M_IN_SCALE <= ZERO;
                   M_OUT_READY <= '0';
                   INTERNAL_INPUT_READY <= '0';
                   Acc_TValid <= '0';
                  
                   ACCEL_X_OUT <= ZERO;
                   ACCEL_Y_OUT <= ZERO;
                   ACCEL_Z_OUT <= ZERO; 
                   
                   state <= "00001";    
                end if;
            when "00001" =>
                C_ACLKEn <= '1';
                C_AResetn <= '1';    
                TREADYX <= C_IN_READY;       
                if(C_IN_READY = '1') then
                    C_IN_DATA <= tmp_X;
                    C_IN_VALID <= '1';
                    C_OUT_READY <= '1';
                    state <= "00010";
                end if;
            when "00010" =>
                if(C_OUT_VALID = '1') then
                    tmpfp_X <= C_OUT_DATA;
                    AccXConv_TValid <= '1';
                    C_IN_VALID <= '0';
                    C_OUT_READY <= '0';
                    
                    C_ACLKEn <= '0';
                    C_AResetn <= '0';
                    state <= "00011";
                end if;                    
            when "00011" =>
                if(count > 3) then
                    count := 0;
                    state <= "00100";
                else
                    count := count + 1;
                end if;
            when "00100" =>
                C_ACLKEn <= '1';
                C_AResetn <= '1';    
                TREADYY <= C_IN_READY;       
                if(C_IN_READY = '1') then
                    C_IN_DATA <= tmp_Y;
                    C_IN_VALID <= '1';
                    C_OUT_READY <= '1';
                    state <= "00110";
                end if;
            when "00110" =>
                if(C_OUT_VALID = '1') then
                    tmpfp_Y <= C_OUT_DATA;
                    AccYConv_TValid <= '1';
                    C_IN_VALID <= '0';
                    C_OUT_READY <= '0';
                    
                    C_ACLKEn <= '0';
                    C_AResetn <= '0';
                    state <= "00111";
                end if;         
            when "00111" =>
                if(count > 3) then
                    count := 0;
                    state <= "01000";
                else
                    count := count + 1;
                end if;
            when "01000" =>
                    C_ACLKEn <= '1';
                    C_AResetn <= '1';    
                    TREADYZ <= C_IN_READY;       
                    if(C_IN_READY = '1') then
                        C_IN_DATA <= tmp_Z;
                        C_IN_VALID <= '1';
                        C_OUT_READY <= '1';
                        state <= "01001";
                    end if;
            when "01001" =>
                if(C_OUT_VALID = '1') then
                    tmpfp_Z <= C_OUT_DATA;
                    AccZConv_TValid <= '1';
                    C_IN_VALID <= '0';
                    C_OUT_READY <= '0';
                    
                    C_ACLKEn <= '0';
                    C_AResetn <= '0';
                    state <= "01010";
                end if;                      
            when "01010" =>
                if(count > 3) then
                    count := 0;
                    state <= "01011";
                else
                    count := count + 1;
                end if;
            --- Multiplication
            --MX
            when "01011" =>
                M_ACLKEn <= '1';
                M_AResetn <= '1';    
                Acc_ConvXTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_X;
                    M_IN_SCALE <= scale;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "01100";
                end if;
            when "01100" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_X <= M_OUT_DATA;
                   AccX_TValid <= '1';
                   M_IN_VALID <= '0';
                   M_IN_SCALE_VALID <= '0';
                   M_IN_SCALE_READY <= '0';
                   M_OUT_READY <= '0';
                   
                   M_ACLKEn <= '0';
                   M_AResetn <= '0';
                   state <= "01101";
               end if;                      
            when "01101" =>
                if(count > 3) then
                    count := 0;
                    state <= "01110";
                else
                    count := count + 1;
                end if;
            --MY
            when "01110" =>
                M_ACLKEn <= '1';
                M_AResetn <= '1';    
                Acc_ConvYTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_Y;
                    M_IN_SCALE <= scale;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "01111";
                end if;
            when "01111" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_Y <= M_OUT_DATA;
                   AccY_TValid <= '1';
                   M_IN_VALID <= '0';
                   M_IN_SCALE_VALID <= '0';
                   M_IN_SCALE_READY <= '0';
                   M_OUT_READY <= '0';
                   
                   M_ACLKEn <= '0';
                   M_AResetn <= '0';
                   state <= "10000";
               end if;                      
            when "10000" =>
                if(count > 3) then
                    count := 0;
                    state <= "10001";
                else
                    count := count + 1;
                end if; 
            --MZ 
            when "10001" =>
                M_ACLKEn <= '1';
                M_AResetn <= '1';    
                Acc_ConvZTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_Z;
                    M_IN_SCALE <= scalez;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "10010";
                end if;
            when "10010" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_Z <= M_OUT_DATA;
                   AccZ_TValid <= '1';
                   M_IN_VALID <= '0';
                   M_IN_SCALE_VALID <= '0';
                   M_IN_SCALE_READY <= '0';
                   M_OUT_READY <= '0';
                   
                   M_ACLKEn <= '0';
                   M_AResetn <= '0';
                   state <= "10011";
               end if;                      
            when "10011" =>
                if(count > 3) then
                    count := 0;
                    state <= "10100";
                else
                    count := count + 1;
                end if;  
            when "10100" => 
                ACCEL_X_OUT <= tmpsc_X;
                ACCEL_Y_OUT <= tmpsc_Y;
                ACCEL_Z_OUT <= tmpsc_Z;  
                Acc_TValid <= '1';  
                state <= "10101";                 
            when "10101" =>
                if(count > 1000) then
                    count := 0;
                    state <= "00000";
                else
                    count := count + 1;
                end if;                                                                            
            when others =>
                state <= "00000";
        end case;
    end if;
end if;
end process;
   


end Behavioral;
