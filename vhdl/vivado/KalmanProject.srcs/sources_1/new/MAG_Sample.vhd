---------------------------------------------------------------------------------------------------- 
---- TITLE: Honeywell HMC5883L I2C 3-axis magnetometer interfacer (magnetometer.vhd) 
---- REVISION: 1.0 (10.05.2015) 
---- DEPENDENCIES: I2C Master Controller (i2c_master.vhd) 
---- REQUIRENMENTS: - SDA and SCL I/O buffers on the top-level source (see top_module.vhd) 
-- - DSP48 slice(s) for heading's calculation required arithmetic operations 
---- DEVICE, ENVIRONMENT: Digilent Nexys4DDR, Xilinx Vivado 2014.4 
---- CONTACT: Pop Mihnea Vlad (pcmihnea@gmail.com), Tatar Alex (tataralex16@gmail.com) 
---------------------------------------------------------------------------------------------------- 
---- DESCRIPTION: This module allows the reading of HMC5883L's X and Y axis 16-bit magnetic strength 
-- registers, converting them to a 0-360 degrees heading 
---------------------------------------------------------------------------------------------------- 
library ieee; 
use ieee.std_logic_1164.all; 
use work.Matrix_def.all;

entity MAG_Sample is 
port ( 
	ACLK : in std_logic; -- 100MHz global clock 
    ACLKEn : in STD_LOGIC := '0';
    AResetn : in STD_LOGIC  := '1';	
    TREADY : out STD_LOGIC;
	
    Mag : inout  STD_LOGIC_VECTOR (3 downto 0);

    Mag_TValid : out STD_LOGIC;
    Mag_TReady : in STD_LOGIC;    
    Mag_X : out STD_LOGIC_VECTOR(31 downto 0);
    Mag_Y : out STD_LOGIC_VECTOR(31 downto 0);
    Mag_Z : out STD_LOGIC_VECTOR(31 downto 0)); 
end MAG_Sample;
 
architecture behavioral of MAG_Sample is 

component MAG_I2C_Master is 
port ( 
	clk100mhz_in : in std_logic; -- 100MHz global clock 
	reset_in : in std_logic; -- active-high 
	start_in : in std_logic; -- active-high 
	magn_drdy : in std_logic; -- active-low signal from the HMC5883L Int pin 
	done_out : out std_logic; -- active-high 
    x_axis_data : out std_logic_vector(15 downto 0);
    y_axis_data : out std_logic_vector(15 downto 0);
    z_axis_data : out std_logic_vector(15 downto 0);
    magn_sda : inout std_logic; -- SDA input* 
    magn_scl_out : out std_logic); -- SCL output 
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

    signal start : std_logic := '0';
    signal rst : std_logic := '1';

    signal  x_axis_data    : STD_LOGIC_VECTOR (15 downto 0);
    signal  y_axis_data    : STD_LOGIC_VECTOR (15 downto 0);
    signal  z_axis_data    : STD_LOGIC_VECTOR (15 downto 0);

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
    
    signal scaleY : STD_LOGIC_VECTOR(31 DOWNTO 0) := "10111111011010111000010100011111"; 
    signal scale : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00111111011010111000010100011111";     
    signal Mag_IN_TVALID, TREADYX, TREADYY, TREADYZ, MagXConv_TValid, MagYConv_TValid, MagZConv_TValid, Mag_TValid_i : STD_LOGIC;
    signal Mag_ConvXTReady, Mag_ConvYTReady, Mag_ConvZTReady, MagX_TValid, MagY_TValid, MagZ_TValid : STD_LOGIC;
    signal ScaleXReady, ScaleYReady, ScaleZReady : STD_LOGIC;
    signal done : std_logic;
    signal passby : std_logic := '0';     
    signal magn_sda_in, magn_sda_out, magn_scl_out : std_logic;
    
    
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
    SIGNAL M_IN_SCALE : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL state : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL INTERNAL_INPUT_READY  : STD_LOGIC := '0';
    SIGNAL INTERNAL_DATAREADY_FALL : STD_LOGIC := '1';
    SIGNAL INTERNAL_DATAREADY_TVALID : STD_LOGIC := '0';  
    
begin 
--Mag(3), -- SDA input* JC2_N
--Mag(2)); -- SCL output JC2_P
--done <='1';
--Mag(3) <= '0' when (magn_sda_out='0') else 'Z'; 
--Mag(2) <= '0' when (magn_scl_out='0') else 'Z'; 
--magn_sda_in <= Mag(3);


--magnetometer_module: magnetometer port map (clk100mhz, reset, magn_start, magn_drdy, magn_done, magn_data, magn_sda_in, magn_sda_out, magn_scl_out);
MAGMASTER: MAG_I2C_Master  
port map ( 
	clk100mhz_in => ACLK, -- 100MHz global clock 
	reset_in => rst, -- active-high 
	start_in => start, -- active-high 
	magn_drdy => Mag(1), -- active-low signal from the HMC5883L Int pin 
	done_out => done, -- active-high 
    x_axis_data => x_axis_data,
    y_axis_data => y_axis_data,
    z_axis_data => z_axis_data,
    magn_sda => Mag(3), -- SDA input*  
    magn_scl_out => Mag(2)); -- SCL output 

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
    s_axis_b_tdata => M_IN_SCALE,
    m_axis_result_tvalid => M_OUT_VALID,
    m_axis_result_tready => M_OUT_READY,
    m_axis_result_tdata => M_OUT_DATA
);


DATAREADYP: PROCESS(ACLK)
begin
 if (rising_edge(ACLK)) then  
     if(done = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_DATAREADY_FALL = '1') then
         INTERNAL_DATAREADY_TVALID <= '1';
         INTERNAL_DATAREADY_FALL <= '0';
         tmp_X   <= tmpex_X;
         tmp_Y   <= tmpex_Y; 
         tmp_Z   <= tmpex_Z;   
     end if;
     if(done = '0' OR INTERNAL_INPUT_READY = '0') then
         INTERNAL_DATAREADY_TVALID <= '0';
     end if;
     if(done = '0') then
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
     Mag_TValid <= '0';
     M_IN_SCALE <= ZERO;
     
     Mag_X <= ZERO;
     Mag_Y <= ZERO;
     Mag_Z <= ZERO; 
      
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
                 Mag_TValid <= '0';
                 M_IN_SCALE <= ZERO;
                
                 Mag_X <= ZERO;
                 Mag_Y <= ZERO;
                 Mag_Z <= ZERO; 
                 
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
                  MagXConv_TValid <= '1';
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
                  MagYConv_TValid <= '1';
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
                  MagZConv_TValid <= '1';
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
              Mag_ConvXTReady <= M_IN_READY;       
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
              Mag_ConvYTReady <= M_IN_READY;       
              if(M_IN_READY = '1') then
                  M_IN_DATA <= tmpfp_Y;
                  M_IN_SCALE <= scaleY;
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
              Mag_ConvZTReady <= M_IN_READY;       
              if(M_IN_READY = '1') then
                  M_IN_DATA <= tmpfp_Z;
                  M_IN_SCALE <= scale;
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
              Mag_X <= tmpsc_X;
              Mag_Y <= tmpsc_Y;
              Mag_Z <= tmpsc_Z;  
              Mag_TValid <= '1';  
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


output_process: process(ACLK) 
begin
    if rising_edge(ACLK) then
        if start = '0' then
                start <= '1';
                rst <= '0';
        end if;
    end if;
end process;  


end behavioral;	