----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2015 04:50:24 PM
-- Design Name: 
-- Module Name: GYRO_Sample - GYRO_Sample_Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
--It says the range can be set to 250/500/2000 DPS, which I think is the maximum angular speed the device can measure 
--(i.e 2000 DPS is the fastest setting) DPS stands for Degrees Per Second, so 360 DPS means 60 RPM (revolutions per minute)
--or 1 revolution per second.

--The mdps/digit stands for Milli Degrees Per Second, so (I think) for instance the value of 70 mdps/digit for the 2000 
--full scale range could be converted to degrees per second by dividing by 1 / 0.07 = 14.286. 1 revolution per second
-- should therefore be 360 * 14.286 = 5413 Make sure you are reading the output registers correctly, the data is a 
-- 16-bit value in 2's complement (i.e the MSB is the sign bit, then 15 bits for the value)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Matrix_def.all;

entity GYRO_Sample is
    Port (  ACLK : in STD_LOGIC;
            ACLKEn : in STD_LOGIC := '0';
            AResetn : in STD_LOGIC  := '0';
            TREADY : out STD_LOGIC;
            GYRO : inout  STD_LOGIC_VECTOR (3 downto 0);
            Gyro_TValid : out STD_LOGIC;
            Gyro_TReady : in STD_LOGIC;
            Gyro_X : out STD_LOGIC_VECTOR(31 downto 0);
            Gyro_Y : out STD_LOGIC_VECTOR(31 downto 0);
            Gyro_Z : out STD_LOGIC_VECTOR(31 downto 0)
    );
end GYRO_Sample;

architecture GYRO_Sample_Behavioral of GYRO_Sample is

-- ==============================================================================
-- 									Component Declarations
-- ==============================================================================
    component GYRO_SPI_Master 
        port (   
            begin_transmission : out std_logic;
            recieved_data : in std_logic_vector(7 downto 0);
            end_transmission : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            start : in std_logic;
            slave_select : out std_logic;
            send_data : out std_logic_vector(7 downto 0);
            temp_data : out std_logic_vector(7 downto 0);
            x_axis_data : out std_logic_vector(15 downto 0);
            y_axis_data : out std_logic_vector(15 downto 0);
            z_axis_data : out std_logic_vector(15 downto 0);
            TVALID : out STD_LOGIC);
    end component;
  
    component GYRO_SPI_Interface
        port ( 
            begin_transmission : in std_logic;
            slave_select : in std_logic;
            send_data : in std_logic_vector(7 downto 0);
            miso : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            recieved_data : out std_logic_vector( 7 downto 0);
            end_transmission : out std_logic;
            mosi : out std_logic;
            sclk : out std_logic);
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
-- ==============================================================================
-- 								  Signals, Constants, Types
-- ==============================================================================

    signal begin_transmission : std_logic;
    signal end_transmission : std_logic;
    signal send_data : std_logic_vector(7 downto 0);
    signal recieved_data : std_logic_vector(7 downto 0);
    signal temp_data : std_logic_vector(7 downto 0);
    signal x_axis_data : std_logic_vector(15 downto 0);
    signal y_axis_data : std_logic_vector(15 downto 0);
    signal z_axis_data : std_logic_vector(15 downto 0);
    signal slave_select : std_logic;
    signal start : std_logic := '0';
    signal rst : std_logic := '1';
    signal temp : std_logic_vector(19 downto 0);
    signal unsigned_data : std_logic_vector( 15 downto 0);
    signal data : std_logic_vector (15 downto 0);

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
    
    signal scale : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00111001001000000010001001111001";-- Scale*PI/180 -> just scale="00111100000011110101110000101001";     
    signal Gyro_IN_TVALID, TREADYX, TREADYY, TREADYZ, GyroXConv_TValid, GyroYConv_TValid, GyroZConv_TValid, Gyro_TValid_i : STD_LOGIC;
    signal Gyro_ConvXTReady, Gyro_ConvYTReady, Gyro_ConvZTReady, GyroX_TValid, GyroY_TValid, GyroZ_TValid : STD_LOGIC;
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
    SIGNAL M_OUT_VALID : STD_LOGIC := '0';
    SIGNAL M_OUT_READY : STD_LOGIC := '0';
    SIGNAL M_OUT_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M_IN_SCALE_VALID  : STD_LOGIC := '0';
    SIGNAL M_IN_SCALE_READY : STD_LOGIC := '0';

    SIGNAL state : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL INTERNAL_INPUT_READY  : STD_LOGIC := '0';
    SIGNAL INTERNAL_DATAREADY_FALL : STD_LOGIC := '1';
    SIGNAL INTERNAL_DATAREADY_TVALID : STD_LOGIC := '0';    
    
    
-- ==============================================================================
--                                           Implementation
-- ==============================================================================
begin
    ----------------------------------------
    --        Serial Port Interface Controller
    ----------------------------------------
    C0 : GYRO_SPI_Master port map (
        begin_transmission => begin_transmission,
        end_transmission => end_transmission,
        send_data => send_data,
        recieved_data => recieved_data,
        clk => ACLK,
        rst => rst, --sw(0),
        slave_select => slave_select,
        start => start, --sw(1),
        temp_data => temp_data,
        x_axis_data => x_axis_data,
        y_axis_data => y_axis_data,
        z_axis_data => z_axis_data,
        TVALID => Gyro_IN_TVALID
    );
    
    ----------------------------------------
    --            Serial Port Interface
    ----------------------------------------
    C1 : GYRO_SPI_Interface port map (
        begin_transmission => begin_transmission,
        slave_select => slave_select,
        send_data => send_data,
        recieved_data => recieved_data,
        miso => GYRO(2),
        clk => ACLK,
        rst => rst, --sw(0),
        end_transmission => end_transmission,
        mosi => GYRO(1),
        sclk => GYRO(3)
    );

tmpex_X <= "1111111111111111" & x_axis_data WHEN x_axis_data(15) = '1'
          ELSE "0000000000000000" & x_axis_data;
tmpex_Y <= "1111111111111111" & y_axis_data WHEN y_axis_data(15) = '1'
          ELSE "0000000000000000" & y_axis_data;
tmpex_Z <= "1111111111111111" & z_axis_data WHEN z_axis_data(15) = '1'
          ELSE "0000000000000000" & z_axis_data;


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
 s_axis_b_tdata => scale,
 m_axis_result_tvalid => M_OUT_VALID,
 m_axis_result_tready => M_OUT_READY,
 m_axis_result_tdata => M_OUT_DATA
);


DATAREADYP: PROCESS(ACLK)
begin
   if (rising_edge(ACLK)) then  
       if(Gyro_IN_TVALID = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_DATAREADY_FALL = '1') then
           INTERNAL_DATAREADY_TVALID <= '1';
           INTERNAL_DATAREADY_FALL <= '0';
           tmp_X   <= tmpex_X;
           tmp_Y   <= tmpex_Y; 
           tmp_Z   <= tmpex_Z;   
       end if;
       if(Gyro_IN_TVALID = '0' OR INTERNAL_INPUT_READY = '0') then
           INTERNAL_DATAREADY_TVALID <= '0';
       end if;
       if(Gyro_IN_TVALID = '0') then
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
       M_OUT_READY <= '0';
       INTERNAL_INPUT_READY <= '0';
       Gyro_TValid <= '0';
      
       Gyro_X <= ZERO;
       Gyro_Y <= ZERO;
       Gyro_Z <= ZERO; 
        
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
                   M_OUT_READY <= '0';
                   INTERNAL_INPUT_READY <= '0';
                   Gyro_TValid <= '0';
                  
                   Gyro_X <= ZERO;
                   Gyro_Y <= ZERO;
                   Gyro_Z <= ZERO; 
                   
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
                    GyroXConv_TValid <= '1';
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
                    GyroYConv_TValid <= '1';
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
                    GyroZConv_TValid <= '1';
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
                Gyro_ConvXTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_X;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "01100";
                end if;
            when "01100" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_X <= M_OUT_DATA;
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
                Gyro_ConvYTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_Y;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "01111";
                end if;
            when "01111" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_Y <= M_OUT_DATA;
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
                Gyro_ConvZTReady <= M_IN_READY;       
                if(M_IN_READY = '1') then
                    M_IN_DATA <= tmpfp_Z;
                    M_IN_VALID <= '1';
                    M_OUT_READY <= '1';
                    M_IN_SCALE_VALID <= '1';
                    M_IN_SCALE_READY <= '1';
                    state <= "10010";
                end if;
            when "10010" =>
               if(M_OUT_VALID = '1') then
                   tmpsc_Z <= M_OUT_DATA;
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
                Gyro_X <= tmpsc_X;
                Gyro_Y <= tmpsc_Y;
                Gyro_Z <= tmpsc_Z;  
                Gyro_TValid <= '1';  
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
    
--    Gyro_IN_TVALID <= '1';


    --  Assign slave select output
    GYRO(0) <= slave_select;
    --ficava 16 vezes no terminal o mesmo valor. Testar assim
    output_process : process(ACLK) 
    begin
        if rising_edge(ACLK) then
            if start = '0' then
                start <= '1';
                rst <= '0';
            end if;
        end if;
    end process;    
    
end GYRO_Sample_Behavioral;
