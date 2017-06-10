library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.Matrix_def.all;
use work.all;

entity KalmanProject is
    port (
        -- For Vivado, delete the port declarations for PS_CLK, PS_PORB and
        -- PS_SRSTB, and uncomment their declarations as signals further below.
        
        clk_100 : IN std_logic;
        otg_oc : IN std_logic;
        PS_GPIO : INOUT std_logic_vector(55 DOWNTO 0);
        GPIO_LED : OUT std_logic_vector(3 DOWNTO 0);
        vga4_blue : OUT std_logic_vector(3 DOWNTO 0);
        vga4_green : OUT std_logic_vector(3 DOWNTO 0);
        vga4_red : OUT std_logic_vector(3 DOWNTO 0);
        vga_hsync : OUT std_logic;
        vga_vsync : OUT std_logic;
        audio_mclk : OUT std_logic;
        audio_dac : OUT std_logic;
        audio_adc : IN std_logic;
        audio_bclk : IN std_logic;
        audio_lrclk : IN std_logic;
        smb_sclk : OUT std_logic;
        smb_sdata : INOUT std_logic;
        smbus_addr : OUT std_logic_vector(1 DOWNTO 0));
    end KalmanProject;

architecture sample_arch of KalmanProject is
    component xillybus
    port (
        PS_CLK : IN std_logic;
        PS_PORB : IN std_logic;
        PS_SRSTB : IN std_logic;
        clk_100 : IN std_logic;
        otg_oc : IN std_logic;
        DDR_Addr : INOUT std_logic_vector(14 DOWNTO 0);
        DDR_BankAddr : INOUT std_logic_vector(2 DOWNTO 0);
        DDR_CAS_n : INOUT std_logic;
        DDR_CKE : INOUT std_logic;
        DDR_CS_n : INOUT std_logic;
        DDR_Clk : INOUT std_logic;
        DDR_Clk_n : INOUT std_logic;
        DDR_DM : INOUT std_logic_vector(3 DOWNTO 0);
        DDR_DQ : INOUT std_logic_vector(31 DOWNTO 0);
        DDR_DQS : INOUT std_logic_vector(3 DOWNTO 0);
        DDR_DQS_n : INOUT std_logic_vector(3 DOWNTO 0);
        DDR_DRSTB : INOUT std_logic;
        DDR_ODT : INOUT std_logic;
        DDR_RAS_n : INOUT std_logic;
        DDR_VRN : INOUT std_logic;
        DDR_VRP : INOUT std_logic;
        MIO : INOUT std_logic_vector(53 DOWNTO 0);
        PS_GPIO : INOUT std_logic_vector(55 DOWNTO 0);
        DDR_WEB : OUT std_logic;
        GPIO_LED : OUT std_logic_vector(3 DOWNTO 0);
        bus_clk : OUT std_logic;
        quiesce : OUT std_logic;
        vga4_blue : OUT std_logic_vector(3 DOWNTO 0);
        vga4_green : OUT std_logic_vector(3 DOWNTO 0);
        vga4_red : OUT std_logic_vector(3 DOWNTO 0);
        vga_hsync : OUT std_logic;
        vga_vsync : OUT std_logic;
        user_r_accx_read_rden : OUT std_logic;
        user_r_accx_read_empty : IN std_logic;
        user_r_accx_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_accx_read_eof : IN std_logic;
        user_r_accx_read_open : OUT std_logic;
        user_r_accy_read_rden : OUT std_logic;
        user_r_accy_read_empty : IN std_logic;
        user_r_accy_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_accy_read_eof : IN std_logic;
        user_r_accy_read_open : OUT std_logic;
        user_r_accz_read_rden : OUT std_logic;
        user_r_accz_read_empty : IN std_logic;
        user_r_accz_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_accz_read_eof : IN std_logic;
        user_r_accz_read_open : OUT std_logic;
        user_r_gyrox_read_rden : OUT std_logic;
        user_r_gyrox_read_empty : IN std_logic;
        user_r_gyrox_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_gyrox_read_eof : IN std_logic;
        user_r_gyrox_read_open : OUT std_logic;
        user_r_gyroy_read_rden : OUT std_logic;
        user_r_gyroy_read_empty : IN std_logic;
        user_r_gyroy_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_gyroy_read_eof : IN std_logic;
        user_r_gyroy_read_open : OUT std_logic;
        user_r_gyroz_read_rden : OUT std_logic;
        user_r_gyroz_read_empty : IN std_logic;
        user_r_gyroz_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_gyroz_read_eof : IN std_logic;
        user_r_gyroz_read_open : OUT std_logic;
        user_r_magx_read_rden : OUT std_logic;
        user_r_magx_read_empty : IN std_logic;
        user_r_magx_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_magx_read_eof : IN std_logic;
        user_r_magx_read_open : OUT std_logic;
        user_r_magy_read_rden : OUT std_logic;
        user_r_magy_read_empty : IN std_logic;
        user_r_magy_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_magy_read_eof : IN std_logic;
        user_r_magy_read_open : OUT std_logic;
        user_r_magz_read_rden : OUT std_logic;
        user_r_magz_read_empty : IN std_logic;
        user_r_magz_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_magz_read_eof : IN std_logic;
        user_r_magz_read_open : OUT std_logic;
        user_r_op_rden : OUT std_logic;
        user_r_op_empty : IN std_logic;
        user_r_op_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_op_eof : IN std_logic;
        user_r_op_open : OUT std_logic;
        user_w_op_wren : OUT std_logic;
        user_w_op_full : IN std_logic;
        user_w_op_data : OUT std_logic_vector(31 DOWNTO 0);
        user_w_op_open : OUT std_logic;
        user_r_qa_read_rden : OUT std_logic;
        user_r_qa_read_empty : IN std_logic;
        user_r_qa_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_qa_read_eof : IN std_logic;
        user_r_qa_read_open : OUT std_logic;
        user_r_qb_read_rden : OUT std_logic;
        user_r_qb_read_empty : IN std_logic;
        user_r_qb_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_qb_read_eof : IN std_logic;
        user_r_qb_read_open : OUT std_logic;
        user_r_qc_read_rden : OUT std_logic;
        user_r_qc_read_empty : IN std_logic;
        user_r_qc_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_qc_read_eof : IN std_logic;
        user_r_qc_read_open : OUT std_logic;
        user_r_qs_read_rden : OUT std_logic;
        user_r_qs_read_empty : IN std_logic;
        user_r_qs_read_data : IN std_logic_vector(31 DOWNTO 0);
        user_r_qs_read_eof : IN std_logic;
        user_r_qs_read_open : OUT std_logic;
        user_clk : OUT std_logic;
        user_wren : OUT std_logic;
        user_rden : OUT std_logic;
        user_wstrb : OUT std_logic_vector(3 DOWNTO 0);
        user_addr : OUT std_logic_vector(31 DOWNTO 0);
        user_rd_data : IN std_logic_vector(31 DOWNTO 0);
        user_wr_data : OUT std_logic_vector(31 DOWNTO 0);
        user_irq : IN std_logic);
    end component;

    COMPONENT Clock_Divider is
        generic ( f_in : INTEGER := 100000000;
                  f_out : integer);
        Port (    clk_in : in STD_LOGIC;
                  clk_out : out STD_LOGIC);
    end COMPONENT;
    
    COMPONENT GYRO_Sample is
        Port (  ACLK : in STD_LOGIC;
                ACLKEn : in STD_LOGIC := '0';
                AResetn : in STD_LOGIC  := '1';
                TREADY : out STD_LOGIC;
                GYRO : inout  STD_LOGIC_VECTOR (3 downto 0);
                Gyro_TValid : out STD_LOGIC;
                Gyro_TReady : in STD_LOGIC;
                Gyro_X : out STD_LOGIC_VECTOR(31 downto 0);
                Gyro_Y : out STD_LOGIC_VECTOR(31 downto 0);
                Gyro_Z : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end COMPONENT;
    
    COMPONENT ACC_Sample is
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
    end COMPONENT;    

    COMPONENT MAG_Sample is 
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
        Mag_Z : out STD_LOGIC_VECTOR(31 downto 0)); -- Spi interface Signals
    end COMPONENT;

    COMPONENT Sensor_DataAcquisition is
        Port (  ACLK : in STD_LOGIC;
                capture_clk : in STD_LOGIC;
                user_r_read_rden : in STD_LOGIC;
                user_r_read_open : in STD_LOGIC;
                user_r_read_data : out STD_LOGIC_VECTOR(31 downto 0);
                user_r_read_empty : out STD_LOGIC;
                user_r_read_eof : out STD_LOGIC;
                Sensor_in : in STD_LOGIC_VECTOR(31 downto 0)
        );
    END COMPONENT;
       
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
    
    COMPONENT KalmanFilter is
       generic (
          NN : INTEGER := 7;
          PP : INTEGER := 6
        );
        port (
            ACLK : in STD_LOGIC;
            ACLKEn : in STD_LOGIC := '0';
            AResetn : in STD_LOGIC := '1';
            INPUT_READY : out STD_LOGIC;
            
            Gyroscope_TVALID : in STD_LOGIC;
            Gyroscope : in MATRIX(0 to 2, 0 to 0);
            
            Accelerometer_TVALID : in STD_LOGIC;
            Accelerometer : in MATRIX(0 to 2, 0 to 0);
            
            Magnetometer_TVALID : in STD_LOGIC;
            Magnetometer : in MATRIX(0 to 2, 0 to 0);
          
            OUTPUT_VALID : OUT STD_LOGIC;
            OUTPUT_READY : IN STD_LOGIC;
            OUTPUT_Gyroscope : OUT MATRIX(0 to 2, 0 to 0);
            OUTPUT_Accelerometer : OUT MATRIX(0 to 2, 0 to 0);
            OUTPUT_Magnetometer : OUT MATRIX(0 to 2, 0 to 0);
            x : out MATRIX(0 to NN-1, 0 to 0);
            P : out MATRIX(0 to NN-1, 0 to NN-1)
        );
    end COMPONENT;
       
    type demo_mem is array(0 TO 31) of std_logic_vector(7 DOWNTO 0);
    signal demoarray : demo_mem;
    signal litearray0 : demo_mem;
    signal litearray1 : demo_mem;
    signal litearray2 : demo_mem;
    signal litearray3 : demo_mem;
    
    signal bus_clk :  std_logic;
    signal quiesce : std_logic;
    
    signal ram_addr : integer range 0 to 31;
    signal lite_addr : integer range 0 to 31;
    
    signal user_r_accx_read_rden :  std_logic;
    signal user_r_accx_read_empty :  std_logic;
    signal user_r_accx_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_accx_read_eof :  std_logic;
    signal user_r_accx_read_open :  std_logic;
    signal user_r_accy_read_rden :  std_logic;
    signal user_r_accy_read_empty :  std_logic;
    signal user_r_accy_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_accy_read_eof :  std_logic;
    signal user_r_accy_read_open :  std_logic;
    signal user_r_accz_read_rden :  std_logic;
    signal user_r_accz_read_empty :  std_logic;
    signal user_r_accz_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_accz_read_eof :  std_logic;
    signal user_r_accz_read_open :  std_logic;
    signal user_r_gyrox_read_rden :  std_logic;
    signal user_r_gyrox_read_empty :  std_logic;
    signal user_r_gyrox_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_gyrox_read_eof :  std_logic;
    signal user_r_gyrox_read_open :  std_logic;
    signal user_r_gyroy_read_rden :  std_logic;
    signal user_r_gyroy_read_empty :  std_logic;
    signal user_r_gyroy_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_gyroy_read_eof :  std_logic;
    signal user_r_gyroy_read_open :  std_logic;
    signal user_r_gyroz_read_rden :  std_logic;
    signal user_r_gyroz_read_empty :  std_logic;
    signal user_r_gyroz_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_gyroz_read_eof :  std_logic;
    signal user_r_gyroz_read_open :  std_logic;
    signal user_r_magx_read_rden :  std_logic;
    signal user_r_magx_read_empty :  std_logic;
    signal user_r_magx_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_magx_read_eof :  std_logic;
    signal user_r_magx_read_open :  std_logic;
    signal user_r_magy_read_rden :  std_logic;
    signal user_r_magy_read_empty :  std_logic;
    signal user_r_magy_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_magy_read_eof :  std_logic;
    signal user_r_magy_read_open :  std_logic;
    signal user_r_magz_read_rden :  std_logic;
    signal user_r_magz_read_empty :  std_logic;
    signal user_r_magz_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_magz_read_eof :  std_logic;
    signal user_r_magz_read_open :  std_logic;
    signal user_r_op_rden :  std_logic;
    signal user_r_op_empty :  std_logic;
    signal user_r_op_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_op_eof :  std_logic;
    signal user_r_op_open :  std_logic;
    signal user_w_op_wren :  std_logic;
    signal user_w_op_full :  std_logic;
    signal user_w_op_data :  std_logic_vector(31 DOWNTO 0);
    signal user_w_op_open :  std_logic;
    signal user_r_qa_read_rden :  std_logic;
    signal user_r_qa_read_empty :  std_logic;
    signal user_r_qa_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_qa_read_eof :  std_logic;
    signal user_r_qa_read_open :  std_logic;
    signal user_r_qb_read_rden :  std_logic;
    signal user_r_qb_read_empty :  std_logic;
    signal user_r_qb_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_qb_read_eof :  std_logic;
    signal user_r_qb_read_open :  std_logic;
    signal user_r_qc_read_rden :  std_logic;
    signal user_r_qc_read_empty :  std_logic;
    signal user_r_qc_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_qc_read_eof :  std_logic;
    signal user_r_qc_read_open :  std_logic;
    signal user_r_qs_read_rden :  std_logic;
    signal user_r_qs_read_empty :  std_logic;
    signal user_r_qs_read_data :  std_logic_vector(31 DOWNTO 0);
    signal user_r_qs_read_eof :  std_logic;
    signal user_r_qs_read_open :  std_logic;
    signal user_clk :  std_logic;
    signal user_wren :  std_logic;
    signal user_wstrb :  std_logic_vector(3 DOWNTO 0);
    signal user_rden :  std_logic;
    signal user_rd_data :  std_logic_vector(31 DOWNTO 0);
    signal user_wr_data :  std_logic_vector(31 DOWNTO 0);
    signal user_addr :  std_logic_vector(31 DOWNTO 0);
    signal user_irq :  std_logic;
    
    -- Note that none of the ARM processor's direct connections to pads is
    -- defined as I/O on this module. Normally, they should be connected
    -- as toplevel ports here, but that confuses Vivado 2013.4 to think that
    -- some of these ports are real I/Os, causing an implementation failure.
    -- This detachment results in a lot of warnings during synthesis and
    -- implementation, but has no practical significance, as these pads are
    -- completely unrelated to the FPGA bitstream.
    
    signal PS_CLK :  std_logic;
    signal PS_PORB :  std_logic;
    signal PS_SRSTB :  std_logic;
    signal DDR_Addr : std_logic_vector(14 DOWNTO 0);
    signal DDR_BankAddr : std_logic_vector(2 DOWNTO 0);
    signal DDR_CAS_n : std_logic;
    signal DDR_CKE : std_logic;
    signal DDR_CS_n : std_logic;
    signal DDR_Clk : std_logic;
    signal DDR_Clk_n : std_logic;
    signal DDR_DM : std_logic_vector(3 DOWNTO 0);
    signal DDR_DQ : std_logic_vector(31 DOWNTO 0);
    signal DDR_DQS : std_logic_vector(3 DOWNTO 0);
    signal DDR_DQS_n : std_logic_vector(3 DOWNTO 0);
    signal DDR_DRSTB : std_logic;
    signal DDR_ODT : std_logic;
    signal DDR_RAS_n : std_logic;
    signal DDR_VRN : std_logic;
    signal DDR_VRP : std_logic;
    signal MIO : std_logic_vector(53 DOWNTO 0);
    signal DDR_WEB : std_logic;
    
    --Laudelino's signals declaration
    signal ps_gpio_dummy : std_logic_vector(55 DOWNTO 0);
    signal USBRst : std_logic;
    signal OLED : std_logic_vector(5 downto 0);
    signal led_out : std_logic_vector(7 downto 0);
    signal SW : std_logic_vector(7 downto 0);
    signal PB : std_logic_vector(4 downto 0);
    signal JA : std_logic_vector(3 downto 0);
    signal JA2 : std_logic_vector(3 downto 0);
    signal JB : std_logic_vector(3 downto 0);
    signal JB2 : std_logic_vector(3 downto 0);
    signal JC : std_logic_vector(3 downto 0);
    signal JC2 : std_logic_vector(3 downto 0);
    signal JD : std_logic_vector(3 downto 0);
    signal JD2 : std_logic_vector(3 downto 0);
    
    
    signal reset_AccX, AccX_en, AccX_Full : STD_LOGIC;
    signal AccX_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_AccY, AccY_en, AccY_Full : STD_LOGIC;
    signal AccY_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_AccZ, AccZ_en, AccZ_Full : STD_LOGIC;
    signal AccZ_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal reset_GyroX, GyroX_en, GyroX_Full : STD_LOGIC;
    signal GyroX_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_GyroY, GyroY_en, GyroY_Full : STD_LOGIC;
    signal GyroY_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_GyroZ, GyroZ_en, GyroZ_Full : STD_LOGIC;
    signal GyroZ_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal reset_MagX, MagX_en, MagX_Full : STD_LOGIC;
    signal MagX_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_MagY, MagY_en, MagY_Full : STD_LOGIC;
    signal MagY_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_MagZ, MagZ_en, MagZ_Full : STD_LOGIC;
    signal MagZ_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal reset_Qa, Qa_en, Qa_Full : STD_LOGIC;
    signal Qa_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_Qb, Qb_en, Qb_Full : STD_LOGIC;
    signal Qb_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_Qc, Qc_en, Qc_Full : STD_LOGIC;
    signal Qc_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal reset_Qs, Qs_en, Qs_Full : STD_LOGIC;
    signal Qs_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    signal reset_op, op_en, op_Full : STD_LOGIC;
    signal op_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --  Wires and registers related to data capturing
    signal capture_data         : std_logic_vector (31 downto 0);
    signal capture_clk          : std_logic;
    signal gyro_en              : std_logic;
    signal gyro_full            : std_logic;
    signal capture_has_been_full : std_logic;
    signal capture_has_been_nonfull : std_logic;
    signal capture_open         : std_logic;
    signal capture_open_cross   : std_logic;
    signal has_been_full        : std_logic;
    signal has_been_full_cross  : std_logic;
    signal slowdown             : std_logic_vector (4 downto 0);
    signal slowdown_is_zero     : std_logic;
        
    signal led_clk          : std_logic;
    
-- Sensor Data Aquisition
	SIGNAL Sensor_Gyroscope_ACLKEn : STD_LOGIC := '0';
	SIGNAL Sensor_Gyroscope_AResetn : STD_LOGIC := '0';
	SIGNAL Sensor_Gyroscope_INPUT_READY : STD_LOGIC := '0';
	SIGNAL Sensor_Gyroscope_OUTPUT_VALID : STD_LOGIC;
	SIGNAL Sensor_Gyroscope_OUTPUT_READY : STD_LOGIC;
	SIGNAL Sensor_Gyroscope_OUTPUT_DATA_X : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Gyroscope_OUTPUT_DATA_Y : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Gyroscope_OUTPUT_DATA_Z : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL Sensor_Accelerometer_ACLKEn : STD_LOGIC := '0';
	SIGNAL Sensor_Accelerometer_AResetn : STD_LOGIC := '0';
	SIGNAL Sensor_Accelerometer_INPUT_READY : STD_LOGIC := '0';
	SIGNAL Sensor_Accelerometer_OUTPUT_VALID : STD_LOGIC;
	SIGNAL Sensor_Accelerometer_OUTPUT_READY : STD_LOGIC;
	SIGNAL Sensor_Accelerometer_OUTPUT_DATA_X : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Accelerometer_OUTPUT_DATA_Y : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Accelerometer_OUTPUT_DATA_Z : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL Sensor_Magnetometer_ACLKEn : STD_LOGIC := '0';
	SIGNAL Sensor_Magnetometer_AResetn : STD_LOGIC := '0';
	SIGNAL Sensor_Magnetometer_INPUT_READY : STD_LOGIC := '0';
	SIGNAL Sensor_Magnetometer_OUTPUT_VALID : STD_LOGIC;
	SIGNAL Sensor_Magnetometer_OUTPUT_READY : STD_LOGIC;
	SIGNAL Sensor_Magnetometer_OUTPUT_DATA_X : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Magnetometer_OUTPUT_DATA_Y : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Sensor_Magnetometer_OUTPUT_DATA_Z : STD_LOGIC_VECTOR(31 DOWNTO 0);

-- Kalman Filter
    CONSTANT NN : INTEGER := 7;
    CONSTANT PP : INTEGER := 6;   

	SIGNAL KF_ACLKEn : STD_LOGIC := '0';
	SIGNAL KF_AResetn : STD_LOGIC := '0';
	SIGNAL KF_INPUT_READY : STD_LOGIC := '0';
	SIGNAL KF_Gyroscope_INPUT_VALID : STD_LOGIC;
	SIGNAL KF_Gyroscope_INPUT_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));
	SIGNAL KF_Accelerometer_INPUT_VALID : STD_LOGIC := '0';
	SIGNAL KF_Accelerometer_INPUT_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));
	SIGNAL KF_Magnetometer_INPUT_VALID : STD_LOGIC := '0';
	SIGNAL KF_Magnetometer_INPUT_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));
	SIGNAL KF_OUTPUT_VALID : STD_LOGIC;
	SIGNAL KF_OUTPUT_READY : STD_LOGIC;
	SIGNAL KF_OUTPUT_DATA_x : MATRIX(0 to NN-1, 0 to 0);
	SIGNAL KF_OUTPUT_DATA_P : MATRIX(0 to NN-1, 0 to NN-1);
	SIGNAL KF_OUTPUT_DATA_Gyroscope : MATRIX(0 to 2, 0 to 0);
	SIGNAL KF_OUTPUT_DATA_Accelerometer : MATRIX(0 to 2, 0 to 0);
	SIGNAL KF_OUTPUT_DATA_Magnetometer : MATRIX(0 to 2, 0 to 0);

-- Test signals    
    SIGNAL state_ini : STD_LOGIC_VECTOR(1 downto 0) := "00";
    SIGNAL RST : STD_LOGIC := '0';

    SIGNAL Gyroscope_Matrix : MATRIX(0 to 2, 0 to 5) := (0 => (0 => "10111100100001100000101010010010", 1 => "10111100100001100000101010010010", 2 => "10111100100001100000101010010010", 3 => "10111100101110111010100001100110", 4 => "10111100111110100011010111011101", 5 => "10111100110111110110011011110011"),
                                                         1 => (0 => "10111100101100101011100011000010", 1 => "10111100101100101011100011000010", 2 => "10111101000001100000101010010010", 3 => "10111101000011101111101000110101", 4 => "10111101000101111110100111011000", 5 => "10111101001001010101000101001101"), 
                                                         2 => (0 => "00111100011110100011010111011101", 1 => "00111100011110100011010111011101", 2 => "00111011100011101111101000110101", 3 => "00111011000011101111101000110101", 4 => "00000000000000000000000000000000", 5 => "10111011010101100111011101010000"));
    
    SIGNAL Accelerometer_Matrix : MATRIX(0 to 2, 0 to 5) := (0 => (0 => "00111100100111000000000000000001", 1 => "00111100100111000000000000000001", 2 => "00111100100111000000000000000001", 3 => "00111100110111000000000000000001", 4 => "00111011011000000000000000000001", 5 => "00000000000000000000000000000000"),
                                                             1 => (0 => "10111101010101011111111111111111", 1 => "10111101010101011111111111111111", 2 => "10111101100010101111111111111111", 3 => "10111101000001011111111111111111", 4 => "10111101000001011111111111111111", 5 => "10111100000110000000000000000000"), 
                                                             2 => (0 => "00111111011110100101111111111111", 1 => "00111111011110100101111111111111", 2 => "00111111011111110110000000000000", 3 => "00111111011111010110000000000000", 4 => "00111111011111100101111111111111", 5 => "00111111100000101010000000000010"));
    
    SIGNAL Magnetometer_Matrix : MATRIX(0 to 2, 0 to 5) := (0 => (0 => "00111110010101101111111111111101", 1 => "00111110010101101111111111111101", 2 => "00111110010101101111111111111101", 3 => "00111110010111000000000000000011", 4 => "00111110010111000000000000000011", 5 => "00111110010111000000000000000011"),
                                                            1 => (0 => "00111101000000000000000000000000", 1 => "00111101000000000000000000000000", 2 => "00111101000000000000000000000000", 3 => "00111101001010000000000000000001", 4 => "00111101001010000000000000000001", 5 => "00111101001010000000000000000001"), 
                                                            2 => (0 => "10111110111001011100000000000001", 1 => "10111110111001011100000000000001", 2 => "10111110111001011100000000000001", 3 => "10111110111010000100000000000001", 4 => "10111110111010000100000000000001", 5 => "10111110111010000100000000000001"));
    
    
    SIGNAL state : STD_LOGIC_VECTOR(2 downto 0) := "000";
    SIGNAL statea : STD_LOGIC_VECTOR(2 downto 0) := "000";
    SIGNAL statem : STD_LOGIC_VECTOR(2 downto 0) := "000";	
    signal CTRL : STD_LOGIC_VECTOR(31 DOWNTO 0);	
begin
    xillybus_ins : xillybus
    port map (
      -- Ports related to /dev/xillybus_accx_read
    -- FPGA to CPU signals:
    user_r_accx_read_rden => user_r_accx_read_rden,
    user_r_accx_read_empty => user_r_accx_read_empty,
    user_r_accx_read_data => user_r_accx_read_data,
    user_r_accx_read_eof => user_r_accx_read_eof,
    user_r_accx_read_open => user_r_accx_read_open,

    -- Ports related to /dev/xillybus_accy_read
    -- FPGA to CPU signals:
    user_r_accy_read_rden => user_r_accy_read_rden,
    user_r_accy_read_empty => user_r_accy_read_empty,
    user_r_accy_read_data => user_r_accy_read_data,
    user_r_accy_read_eof => user_r_accy_read_eof,
    user_r_accy_read_open => user_r_accy_read_open,

    -- Ports related to /dev/xillybus_accz_read
    -- FPGA to CPU signals:
    user_r_accz_read_rden => user_r_accz_read_rden,
    user_r_accz_read_empty => user_r_accz_read_empty,
    user_r_accz_read_data => user_r_accz_read_data,
    user_r_accz_read_eof => user_r_accz_read_eof,
    user_r_accz_read_open => user_r_accz_read_open,

    -- Ports related to /dev/xillybus_gyrox_read
    -- FPGA to CPU signals:
    user_r_gyrox_read_rden => user_r_gyrox_read_rden,
    user_r_gyrox_read_empty => user_r_gyrox_read_empty,
    user_r_gyrox_read_data => user_r_gyrox_read_data,
    user_r_gyrox_read_eof => user_r_gyrox_read_eof,
    user_r_gyrox_read_open => user_r_gyrox_read_open,

    -- Ports related to /dev/xillybus_gyroy_read
    -- FPGA to CPU signals:
    user_r_gyroy_read_rden => user_r_gyroy_read_rden,
    user_r_gyroy_read_empty => user_r_gyroy_read_empty,
    user_r_gyroy_read_data => user_r_gyroy_read_data,
    user_r_gyroy_read_eof => user_r_gyroy_read_eof,
    user_r_gyroy_read_open => user_r_gyroy_read_open,

    -- Ports related to /dev/xillybus_gyroz_read
    -- FPGA to CPU signals:
    user_r_gyroz_read_rden => user_r_gyroz_read_rden,
    user_r_gyroz_read_empty => user_r_gyroz_read_empty,
    user_r_gyroz_read_data => user_r_gyroz_read_data,
    user_r_gyroz_read_eof => user_r_gyroz_read_eof,
    user_r_gyroz_read_open => user_r_gyroz_read_open,

    -- Ports related to /dev/xillybus_magx_read
    -- FPGA to CPU signals:
    user_r_magx_read_rden => user_r_magx_read_rden,
    user_r_magx_read_empty => user_r_magx_read_empty,
    user_r_magx_read_data => user_r_magx_read_data,
    user_r_magx_read_eof => user_r_magx_read_eof,
    user_r_magx_read_open => user_r_magx_read_open,

    -- Ports related to /dev/xillybus_magy_read
    -- FPGA to CPU signals:
    user_r_magy_read_rden => user_r_magy_read_rden,
    user_r_magy_read_empty => user_r_magy_read_empty,
    user_r_magy_read_data => user_r_magy_read_data,
    user_r_magy_read_eof => user_r_magy_read_eof,
    user_r_magy_read_open => user_r_magy_read_open,

    -- Ports related to /dev/xillybus_magz_read
    -- FPGA to CPU signals:
    user_r_magz_read_rden => user_r_magz_read_rden,
    user_r_magz_read_empty => user_r_magz_read_empty,
    user_r_magz_read_data => user_r_magz_read_data,
    user_r_magz_read_eof => user_r_magz_read_eof,
    user_r_magz_read_open => user_r_magz_read_open,

    -- Ports related to /dev/xillybus_op
    -- FPGA to CPU signals:
    user_r_op_rden => user_r_op_rden,
    user_r_op_empty => user_r_op_empty,
    user_r_op_data => user_r_op_data,
    user_r_op_eof => user_r_op_eof,
    user_r_op_open => user_r_op_open,
    -- CPU to FPGA signals:
    user_w_op_wren => user_w_op_wren,
    user_w_op_full => user_w_op_full,
    user_w_op_data => user_w_op_data,
    user_w_op_open => user_w_op_open,

    -- Ports related to /dev/xillybus_qa_read
    -- FPGA to CPU signals:
    user_r_qa_read_rden => user_r_qa_read_rden,
    user_r_qa_read_empty => user_r_qa_read_empty,
    user_r_qa_read_data => user_r_qa_read_data,
    user_r_qa_read_eof => user_r_qa_read_eof,
    user_r_qa_read_open => user_r_qa_read_open,

    -- Ports related to /dev/xillybus_qb_read
    -- FPGA to CPU signals:
    user_r_qb_read_rden => user_r_qb_read_rden,
    user_r_qb_read_empty => user_r_qb_read_empty,
    user_r_qb_read_data => user_r_qb_read_data,
    user_r_qb_read_eof => user_r_qb_read_eof,
    user_r_qb_read_open => user_r_qb_read_open,

    -- Ports related to /dev/xillybus_qc_read
    -- FPGA to CPU signals:
    user_r_qc_read_rden => user_r_qc_read_rden,
    user_r_qc_read_empty => user_r_qc_read_empty,
    user_r_qc_read_data => user_r_qc_read_data,
    user_r_qc_read_eof => user_r_qc_read_eof,
    user_r_qc_read_open => user_r_qc_read_open,

    -- Ports related to /dev/xillybus_qs_read
    -- FPGA to CPU signals:
    user_r_qs_read_rden => user_r_qs_read_rden,
    user_r_qs_read_empty => user_r_qs_read_empty,
    user_r_qs_read_data => user_r_qs_read_data,
    user_r_qs_read_eof => user_r_qs_read_eof,
    user_r_qs_read_open => user_r_qs_read_open,

    -- Ports related to Xillybus Lite
    user_clk => user_clk,
    user_wren => user_wren,
    user_rden => user_rden,
    user_wstrb => user_wstrb,
    user_addr => user_addr,
    user_rd_data => user_rd_data,
    user_wr_data => user_wr_data,
    user_irq => user_irq,
        
      -- General signals
        PS_CLK => PS_CLK,
        PS_PORB => PS_PORB,
        PS_SRSTB => PS_SRSTB,
        clk_100 => clk_100,
        otg_oc => otg_oc,
        DDR_Addr => DDR_Addr,
        DDR_BankAddr => DDR_BankAddr,
        DDR_CAS_n => DDR_CAS_n,
        DDR_CKE => DDR_CKE,
        DDR_CS_n => DDR_CS_n,
        DDR_Clk => DDR_Clk,
        DDR_Clk_n => DDR_Clk_n,
        DDR_DM => DDR_DM,
        DDR_DQ => DDR_DQ,
        DDR_DQS => DDR_DQS,
        DDR_DQS_n => DDR_DQS_n,
        DDR_DRSTB => DDR_DRSTB,
        DDR_ODT => DDR_ODT,
        DDR_RAS_n => DDR_RAS_n,
        DDR_VRN => DDR_VRN,
        DDR_VRP => DDR_VRP,
        MIO => MIO,
        PS_GPIO => ps_gpio_dummy,
        DDR_WEB => DDR_WEB,
        GPIO_LED => GPIO_LED,
        bus_clk => bus_clk,
        quiesce => quiesce,
        vga4_blue => vga4_blue,
        vga4_green => vga4_green,
        vga4_red => vga4_red,
        vga_hsync => vga_hsync,
        vga_vsync => vga_vsync
    );

    -- Xillybus Lite
    
--    user_irq <= '0'; -- No interrupts for now
    
--    lite_addr <= conv_integer(user_addr(6 DOWNTO 2));
    
--    process (user_clk)
--    begin
--        if (user_clk'event and user_clk = '1') then
--            if (user_wstrb(0) = '1') then 
--                litearray0(lite_addr) <= user_wr_data(7 DOWNTO 0);
--            end if;
            
--            if (user_wstrb(1) = '1') then 
--                litearray1(lite_addr) <= user_wr_data(15 DOWNTO 8);
--            end if;
            
--            if (user_wstrb(2) = '1') then 
--                litearray2(lite_addr) <= user_wr_data(23 DOWNTO 16);
--            end if;
            
--            if (user_wstrb(3) = '1') then 
--                litearray3(lite_addr) <= user_wr_data(31 DOWNTO 24);
--            end if;
            
--            if (user_rden = '1') then
--                user_rd_data <= litearray3(lite_addr) & litearray2(lite_addr) &
--                                litearray1(lite_addr) & litearray0(lite_addr);
--            end if;
--    end if;
--    end process;

-- Assign to dummy signal instead of sending it to PS, rewire for PL
    GPIO_LED                <= led_out(3 downto 0);
    PS_GPIO(0) <= USBRst; --  USB-Reset
    PS_GPIO(6 downto 1)     <= OLED(5 downto 0); -- OLED
    PS_GPIO(10 downto 7)    <= led_out(7 downto 4);  -- LED 7-4
    PS_GPIO(18 downto 11)   <= SW(7 downto 0); -- switches - 7-0
    PS_GPIO(23 downto 19)   <= PB(4 downto 0); -- pushbuttons - S, D, U, R, L
    PS_GPIO(27 downto 24)   <= JA(3 downto 0); -- JA 4-1
    PS_GPIO(31 downto 28)   <= JA2(3 downto 0); -- JA 10-7
    PS_GPIO(35 downto 32)   <= JB(3 downto 0); -- JB 4-1
    PS_GPIO(39 downto 36)   <= JB2(3 downto 0); -- JB 10-7
    PS_GPIO(43 downto 40)   <= JC(3 downto 0); -- JC 4-1
    PS_GPIO(47 downto 44)   <= JC2(3 downto 0); -- JC 10-7
    PS_GPIO(51 downto 48)   <= JD(3 downto 0); -- JD 4-1
    PS_GPIO(55 downto 52)   <= JD2(3 downto 0); -- JD 10-7

--RST <= NOT SW(0);

--                      VCC GND SCLK SO SI /CS 
-- Up:   Left to right: VCC GND J4   J3 J2  J1
-- Down: Left to right: VCC GND J10  J9 J8   J7
--                      VCC GND NC   NC INT2 INT1

CLK1HZ: Clock_Divider generic map ( 100000000, 1) Port map (clk_in => bus_clk, clk_out => led_clk);
CLK100HZ: Clock_Divider generic map ( 100000000, 100) Port map (clk_in => bus_clk, clk_out => capture_clk);

ledblink: process (led_clk)
    begin
        if(rising_edge(led_clk)) then 
            if(led_out(7 downto 4) = "0000") then
                led_out(7 downto 4) <= "1111";
            else
                led_out(7 downto 4) <= "0000";
            end if;
        end if;
    end process;
    

--- SENSOR	

-- GYROSCOPE
Sensor_Gyroscope_ACLKEn <= '1';
Sensor_Gyroscope_AResetn <= '1';
Sensor_Gyroscope_OUTPUT_READY <= KF_INPUT_READY;

GYRO_INS: GYRO_Sample 
	PORT MAP (bus_clk, Sensor_Gyroscope_ACLKEn, Sensor_Gyroscope_ACLKEn, Sensor_Gyroscope_INPUT_READY, JA, Sensor_Gyroscope_OUTPUT_VALID,
			Sensor_Gyroscope_OUTPUT_READY, Sensor_Gyroscope_OUTPUT_DATA_X, Sensor_Gyroscope_OUTPUT_DATA_Y, Sensor_Gyroscope_OUTPUT_DATA_Z);
			
--ACCELEROMETER	
Sensor_Accelerometer_ACLKEn <= '1';
Sensor_Accelerometer_AResetn <= '1';
Sensor_Accelerometer_OUTPUT_READY <= KF_INPUT_READY;			

ACC_INS: ACC_Sample
generic map 
(
    SYSCLK_FREQUENCY_HZ => 100000000,
    SCLK_FREQUENCY_HZ   => 1000000,
    NUM_READS_AVG       => 16,
    UPDATE_FREQUENCY_HZ => 100
)
port map
(
    ACLK     => bus_clk, -- System Clock
    RESET      => '0',
    ACLKEn => Sensor_Accelerometer_ACLKEn,
    AResetn => Sensor_Accelerometer_AResetn,
    TREADY => Sensor_Accelerometer_INPUT_READY,    
    -- Spi interface Signals
    ACC       => JC,

    Acc_TValid => Sensor_Accelerometer_OUTPUT_VALID,
    Acc_TReady => Sensor_Accelerometer_OUTPUT_READY,
    -- Accelerometer data signals
    ACCEL_X_OUT    => Sensor_Accelerometer_OUTPUT_DATA_X,
    ACCEL_Y_OUT    => Sensor_Accelerometer_OUTPUT_DATA_Y,
    ACCEL_Z_OUT    => Sensor_Accelerometer_OUTPUT_DATA_Z
);

-- MAGNETOMETER
Sensor_Magnetometer_ACLKEn <= '1';
Sensor_Magnetometer_AResetn <= '1';
Sensor_Magnetometer_OUTPUT_READY <= KF_INPUT_READY;

MAG_INS: MAG_Sample 
    port map( 
        ACLK => bus_clk,
        ACLKEn => Sensor_Magnetometer_ACLKEn,
        AResetn => Sensor_Magnetometer_AResetn,
        TREADY => Sensor_Magnetometer_INPUT_READY,    
        
        Mag => JB, --PS_GPIO(35 downto 32), 
    
        Mag_TValid => Sensor_Magnetometer_OUTPUT_VALID,
        Mag_TReady => Sensor_Magnetometer_OUTPUT_READY,  
        Mag_X => Sensor_Magnetometer_OUTPUT_DATA_X,
        Mag_Y => Sensor_Magnetometer_OUTPUT_DATA_Y,
        Mag_Z => Sensor_Magnetometer_OUTPUT_DATA_Z);


-- Data Acquisition
--GYROXDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyrox_read_rden, user_r_gyrox_read_open, user_r_gyrox_read_data, user_r_gyrox_read_empty, user_r_gyrox_read_eof, Sensor_Gyroscope_OUTPUT_DATA_X);    
--GYROYDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyroy_read_rden, user_r_gyroy_read_open, user_r_gyroy_read_data, user_r_gyroy_read_empty, user_r_gyroy_read_eof, Sensor_Gyroscope_OUTPUT_DATA_Y);
--GYROZDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyroz_read_rden, user_r_gyroz_read_open, user_r_gyroz_read_data, user_r_gyroz_read_empty, user_r_gyroz_read_eof, Sensor_Gyroscope_OUTPUT_DATA_Z);
--SENSOR TEST
--GYROXDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyrox_read_rden, user_r_gyrox_read_open, user_r_gyrox_read_data, user_r_gyrox_read_empty, user_r_gyrox_read_eof, Sensor_Gyroscope_OUTPUT_DATA_X);    
--GYROYDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyroy_read_rden, user_r_gyroy_read_open, user_r_gyroy_read_data, user_r_gyroy_read_empty, user_r_gyroy_read_eof, Sensor_Gyroscope_OUTPUT_DATA_Y);
--GYROZDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Gyroscope_OUTPUT_VALID, user_r_gyroz_read_rden, user_r_gyroz_read_open, user_r_gyroz_read_data, user_r_gyroz_read_empty, user_r_gyroz_read_eof, Sensor_Gyroscope_OUTPUT_DATA_Z);
                        
--ACCXDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Accelerometer_OUTPUT_VALID, user_r_accx_read_rden, user_r_accx_read_open, user_r_accx_read_data, user_r_accx_read_empty, user_r_accx_read_eof, Sensor_Accelerometer_OUTPUT_DATA_X);    
--ACCYDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Accelerometer_OUTPUT_VALID, user_r_accy_read_rden, user_r_accy_read_open, user_r_accy_read_data, user_r_accy_read_empty, user_r_accy_read_eof, Sensor_Accelerometer_OUTPUT_DATA_Y);
--ACCZDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Accelerometer_OUTPUT_VALID, user_r_accz_read_rden, user_r_accz_read_open, user_r_accz_read_data, user_r_accz_read_empty, user_r_accz_read_eof, Sensor_Accelerometer_OUTPUT_DATA_Z);    

--MAGXDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Magnetometer_OUTPUT_VALID, user_r_magx_read_rden, user_r_magx_read_open, user_r_magx_read_data, user_r_magx_read_empty, user_r_magx_read_eof, Sensor_Magnetometer_OUTPUT_DATA_X);    
--MAGYDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Magnetometer_OUTPUT_VALID, user_r_magy_read_rden, user_r_magy_read_open, user_r_magy_read_data, user_r_magy_read_empty, user_r_magy_read_eof, Sensor_Magnetometer_OUTPUT_DATA_Y);
--MAGZDA: Sensor_DataAcquisition 
--    Port map(bus_clk, Sensor_Magnetometer_OUTPUT_VALID, user_r_magz_read_rden, user_r_magz_read_open, user_r_magz_read_data, user_r_magz_read_empty, user_r_magz_read_eof, Sensor_Magnetometer_OUTPUT_DATA_Z);    

--KF RUN
GYROXDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_gyrox_read_rden, user_r_gyrox_read_open, user_r_gyrox_read_data, user_r_gyrox_read_empty, user_r_gyrox_read_eof, KF_OUTPUT_DATA_Gyroscope(0,0));    
GYROYDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_gyroy_read_rden, user_r_gyroy_read_open, user_r_gyroy_read_data, user_r_gyroy_read_empty, user_r_gyroy_read_eof, KF_OUTPUT_DATA_Gyroscope(1,0));
GYROZDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_gyroz_read_rden, user_r_gyroz_read_open, user_r_gyroz_read_data, user_r_gyroz_read_empty, user_r_gyroz_read_eof, KF_OUTPUT_DATA_Gyroscope(2,0));
                        
ACCXDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_accx_read_rden, user_r_accx_read_open, user_r_accx_read_data, user_r_accx_read_empty, user_r_accx_read_eof, KF_OUTPUT_DATA_Accelerometer(0,0));    
ACCYDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_accy_read_rden, user_r_accy_read_open, user_r_accy_read_data, user_r_accy_read_empty, user_r_accy_read_eof, KF_OUTPUT_DATA_Accelerometer(1,0));
ACCZDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_accz_read_rden, user_r_accz_read_open, user_r_accz_read_data, user_r_accz_read_empty, user_r_accz_read_eof, KF_OUTPUT_DATA_Accelerometer(2,0));    

MAGXDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_magx_read_rden, user_r_magx_read_open, user_r_magx_read_data, user_r_magx_read_empty, user_r_magx_read_eof, KF_OUTPUT_DATA_Magnetometer(0,0));    
MAGYDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_magy_read_rden, user_r_magy_read_open, user_r_magy_read_data, user_r_magy_read_empty, user_r_magy_read_eof, KF_OUTPUT_DATA_Magnetometer(1,0));
MAGZDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_magz_read_rden, user_r_magz_read_open, user_r_magz_read_data, user_r_magz_read_empty, user_r_magz_read_eof, KF_OUTPUT_DATA_Magnetometer(2,0));    

-------------------------------------------------------------------------------------------
----=======================================================================================
----Quaternion
----=======================================================================================    
-------------------------------------------------------------------------------------------
QADA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_Qa_read_rden, user_r_Qa_read_open, user_r_Qa_read_data, user_r_Qa_read_empty, user_r_Qa_read_eof, Qa_Data);    
QBDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_Qb_read_rden, user_r_Qb_read_open, user_r_Qb_read_data, user_r_Qb_read_empty, user_r_Qb_read_eof, Qb_Data);
QCDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_Qc_read_rden, user_r_Qc_read_open, user_r_Qc_read_data, user_r_Qc_read_empty, user_r_Qc_read_eof, Qc_Data);    
QSDA: Sensor_DataAcquisition 
    Port map(bus_clk, KF_OUTPUT_VALID, user_r_Qs_read_rden, user_r_Qs_read_open, user_r_Qs_read_data, user_r_Qs_read_empty, user_r_Qs_read_eof, Qs_Data);

--op_FIFO : PLPS_FIFO
--    PORT MAP (
--        rst => reset_op,
--        wr_clk => KF_OUTPUT_VALID,
--        rd_clk => bus_clk,
--        din => op_Data,
--        wr_en => op_en,
--        rd_en => user_r_op_rden,
--        dout => user_r_op_data,
--        full => op_Full,
--        empty => user_r_op_empty
--    );    
    
--    op_en <=    user_r_op_open and not op_Full;
--    reset_op <= NOT (user_r_op_open);
--    user_r_op_eof <= '0';   

Qa_Data <= KF_OUTPUT_DATA_x(0,0);
Qb_Data <= KF_OUTPUT_DATA_x(1,0);
Qc_Data <= KF_OUTPUT_DATA_x(2,0);
Qs_Data <= KF_OUTPUT_DATA_x(3,0);
--op_Data <= KF_OUTPUT_DATA_P(1,1);     

-- KF Control
--RST <= '0';
--KF_Accelerometer_INPUT_VALID <= '0';
--KF_Accelerometer_INPUT_DATA <= (others => (others => ZERO));
--KF_Magnetometer_INPUT_VALID <= '0';
--KF_Magnetometer_INPUT_DATA <= (others => (others => ZERO));

--KF_ACLKEn <= '1'; 
--KF_AResetn <= '1';
--KF_OUTPUT_READY <= '1';


--CTRL <= KF_ACLKEn & KF_AResetn & KF_INPUT_READY & KF_Gyroscope_INPUT_VALID 
--      & KF_Accelerometer_INPUT_VALID & KF_Magnetometer_INPUT_VALID & KF_OUTPUT_VALID & KF_OUTPUT_READY 
--      & RST & state_ini & state & "000000000000000000";

KF_Gyroscope_INPUT_DATA(0,0) <= Sensor_Gyroscope_OUTPUT_DATA_X;
KF_Gyroscope_INPUT_DATA(1,0) <= Sensor_Gyroscope_OUTPUT_DATA_Y;
KF_Gyroscope_INPUT_DATA(2,0) <= Sensor_Gyroscope_OUTPUT_DATA_Z;
KF_Gyroscope_INPUT_VALID <= Sensor_Gyroscope_OUTPUT_VALID;

KF_Accelerometer_INPUT_DATA(0,0) <= Sensor_Accelerometer_OUTPUT_DATA_X;
KF_Accelerometer_INPUT_DATA(1,0) <= Sensor_Accelerometer_OUTPUT_DATA_Y;
KF_Accelerometer_INPUT_DATA(2,0) <= Sensor_Accelerometer_OUTPUT_DATA_Z;
KF_Accelerometer_INPUT_VALID <= Sensor_Accelerometer_OUTPUT_VALID;

KF_Magnetometer_INPUT_DATA(0,0) <= Sensor_Magnetometer_OUTPUT_DATA_X;
KF_Magnetometer_INPUT_DATA(1,0) <= Sensor_Magnetometer_OUTPUT_DATA_Y;
KF_Magnetometer_INPUT_DATA(2,0) <= Sensor_Magnetometer_OUTPUT_DATA_Z;
KF_Magnetometer_INPUT_VALID <= Sensor_Magnetometer_OUTPUT_VALID;

RST <= SW(0);

KFP: KalmanFilter 
generic map (NN, PP)
port map(bus_clk, KF_ACLKEn, KF_AResetn, KF_INPUT_READY, 
        KF_Gyroscope_INPUT_VALID, KF_Gyroscope_INPUT_DATA, 
        KF_Accelerometer_INPUT_VALID, KF_Accelerometer_INPUT_DATA, 
        KF_Magnetometer_INPUT_VALID, KF_Magnetometer_INPUT_DATA,
        KF_OUTPUT_VALID, KF_OUTPUT_READY, 
        KF_OUTPUT_DATA_Gyroscope, KF_OUTPUT_DATA_Accelerometer, KF_OUTPUT_DATA_Magnetometer, 
        KF_OUTPUT_DATA_x, KF_OUTPUT_DATA_P);    

INIT: PROCESS(bus_clk)
	variable count : INTEGER := 0;
begin
    if (rising_edge(bus_clk)) then   
        case state_ini is
            when "00" => 
                if(count = 3000000) then -- 100MHz = 10 nS -> 1mS/10nS = 1*10-3/10*10-9 = 1/10 10^6 0.1 10^6 = 1 10^5
                    state_ini <= "01";
                else
                    count := count + 1;
                end if;
            when "01" =>   
                if(RST = '1') then       
                    KF_ACLKEn <= '1'; 
                    KF_AResetn <= '1';
                    KF_OUTPUT_READY <= '1';
                else
                    KF_ACLKEn <= '0'; 
                    KF_AResetn <= '0';
                    KF_OUTPUT_READY <= '0';    
                end if;
            when others =>        
                state_ini <= "00";     
         end case;
     end if;
end process;



--GYROSCOPEProc: PROCESS(bus_clk)
--    variable I : INTEGER RANGE 0 to 10 := 0;
--	variable count : INTEGER := 0;
--begin
--    if (rising_edge(bus_clk) AND SW(0) = '1') then   
--        case state is
--            when "000" => 
--                RST <= '0';
--                if (KF_INPUT_READY = '1') then
--                    KF_Gyroscope_INPUT_DATA(0,0) <= Gyroscope_Matrix(0,I);
--                    KF_Gyroscope_INPUT_DATA(1,0) <= Gyroscope_Matrix(1,I);
--                    KF_Gyroscope_INPUT_DATA(2,0) <= Gyroscope_Matrix(2,I);
--                    KF_Gyroscope_INPUT_VALID <= '1';
--                    I := I + 1;
--                end if;
                
--                state <= "001";
--                count := 0;
--            when "001" =>
--                if(count > 100000) then -- 100MHz = 10 nS -> 1mS/10nS = 1*10-3/10*10-9 = 1/10 10^6 0.1 10^6 = 1 10^5
--                    state <= "010";
--                else
--                    count := count + 1;
--                end if;
--            when "010" =>
--              KF_Gyroscope_INPUT_VALID <= '0';
--              count := 0;
--              state <= "011";
--            when "011" =>
--                if(count > 900000) then
--                    if(I > 5) then
--                        I := 0;
--                        count := 0;
--                        state <= "100";
--                    else
--                        state <= "000";
--                    end if;				
--                else
--                    count := count + 1;
--                end if;
--            when "100" =>
--                RST <= '1';
--                if(count > 10) then
--                    state <= "000";      
--                else
--                    count := count + 1;
--                end if;            
--            when others =>
--              state <= "000";
--        end case;
--    end if; 
--end process; 

--ACCELEROMETERProc: PROCESS(bus_clk)
--    variable I : INTEGER RANGE 0 to 10 := 0;
--	variable count : INTEGER := 0;
--begin
--    if (rising_edge(bus_clk) AND SW(0) = '1') then   
--        case statea is
--            when "000" => 
--                if (KF_INPUT_READY = '1') then
--                    KF_Accelerometer_INPUT_DATA(0,0) <= Accelerometer_Matrix(0,I);
--                    KF_Accelerometer_INPUT_DATA(1,0) <= Accelerometer_Matrix(1,I);
--                    KF_Accelerometer_INPUT_DATA(2,0) <= Accelerometer_Matrix(2,I);
--                    KF_Accelerometer_INPUT_VALID <= '1';
--                    I := I + 1;
--                end if;
                
--                statea <= "001";
--                count := 0;
--            when "001" =>
--                if(count > 100000) then -- 100MHz = 10 nS -> 1mS/10nS = 1*10-3/10*10-9 = 1/10 10^6 0.1 10^6 = 1 10^5
--                    statea <= "010";
--                else
--                    count := count + 1;
--                end if;
--            when "010" =>
--              KF_Accelerometer_INPUT_VALID <= '0';
--              count := 0;
--              statea <= "011";
--            when "011" =>
--                if(count > 900000) then
--                    if(I > 5) then
--                        I := 0;
--                        count := 0;
--                        statea <= "100";
--                    else
--                        statea <= "000";
--                    end if;				
--                else
--                    count := count + 1;
--                end if;
--            when "100" =>
--                if(count > 10) then
--                    statea <= "000";      
--                else
--                    count := count + 1;
--                end if;            
--            when others =>
--              statea <= "000";
--        end case;
--    end if; 
--end process; 


--MAGNETOMETERProc: PROCESS(bus_clk)
--    variable I : INTEGER RANGE 0 to 10 := 0;
--	variable count : INTEGER := 0;
--begin
--    if (rising_edge(bus_clk) AND SW(0) = '1') then   
--        case statem is
--            when "000" => 
--                if (KF_INPUT_READY = '1') then
--                    KF_Magnetometer_INPUT_DATA(0,0) <= Magnetometer_Matrix(0,I);
--                    KF_Magnetometer_INPUT_DATA(1,0) <= Magnetometer_Matrix(1,I);
--                    KF_Magnetometer_INPUT_DATA(2,0) <= Magnetometer_Matrix(2,I);
--                    KF_Magnetometer_INPUT_VALID <= '1';
--                    I := I + 1;
--                end if;
                
--                statem <= "001";
--                count := 0;
--            when "001" =>
--                if(count > 100000) then -- 100MHz = 10 nS -> 1mS/10nS = 1*10-3/10*10-9 = 1/10 10^6 0.1 10^6 = 1 10^5
--                    statem <= "010";
--                else
--                    count := count + 1;
--                end if;
--            when "010" =>
--              KF_Magnetometer_INPUT_VALID <= '0';
--              count := 0;
--              statem <= "011";
--            when "011" =>
--                if(count > 900000) then
--                    if(I > 5) then
--                        I := 0;
--                        count := 0;
--                        statem <= "100";
--                    else
--                        statem <= "000";
--                    end if;				
--                else
--                    count := count + 1;
--                end if;
--            when "100" =>
--                if(count > 10) then
--                    statem <= "000";      
--                else
--                    count := count + 1;
--                end if;            
--            when others =>
--              statem <= "000";
--        end case;
--    end if; 
--end process; 			
      
end sample_arch;
