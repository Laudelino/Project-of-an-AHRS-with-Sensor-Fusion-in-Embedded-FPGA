----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2016 08:36:23 PM
-- Design Name: 
-- Module Name: KalmanFilter - KalmanFilter_Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Matrix_def.all;

entity KalmanFilter is
   generic (
      NN : INTEGER := 7;
      PP : INTEGER := 6
    );
    port (
      ACLK : in STD_LOGIC;
      ACLKEn : in STD_LOGIC := '0';
      AResetn : in STD_LOGIC := '0';
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
end KalmanFilter;

architecture KalmanFilter_Behavioral of KalmanFilter is
-- COMPONENTS
COMPONENT PredictKF is
    generic (
        NN : INTEGER := 7;
        PP : INTEGER := 6
    );
    port (
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '0';
        TREADY : out STD_LOGIC;
        
        x_TVALID : in STD_LOGIC;
        x : in MATRIX(0 to NN-1, 0 to 0);
        
        P_TVALID : in STD_LOGIC;
        P : in MATRIX(0 to NN-1, 0 to NN-1);
        
        Gyro_TVALID : in STD_LOGIC;
        Gyroscope : in MATRIX(0 to 2, 0 to 0);
        
        Predict_TValid : out STD_LOGIC;
        Predict_TReady : in STD_LOGIC;
        xhat : out MATRIX(0 to NN-1, 0 to 0);
        Phat : out MATRIX(0 to NN-1, 0 to NN-1)
    );
end COMPONENT;

COMPONENT CorrectKF is
   generic (
     NN : INTEGER := 7;
     PP : INTEGER := 6
 );
 port (
     ACLK : in STD_LOGIC;
     ACLKEn : in STD_LOGIC := '0';
     AResetn : in STD_LOGIC  := '0';
     TREADY : out STD_LOGIC;
     
     xhat_TVALID : in STD_LOGIC;
     xhat : in MATRIX(0 to NN-1, 0 to 0);
     
     Phat_TVALID : in STD_LOGIC;
     Phat : in MATRIX(0 to NN-1, 0 to NN-1);
     
     Sensor_TVALID : in STD_LOGIC;
     Sensor_base : in MATRIX(0 to 2, 0 to 0);
     Sensor_R : in MATRIX(0 to 2, 0 to 0);
     Sensor : in MATRIX(0 to 2, 0 to 0);
     
     Correct_TValid : out STD_LOGIC;
     Correct_TReady : in STD_LOGIC;
     x : out MATRIX(0 to NN-1, 0 to 0);
     P : out MATRIX(0 to NN-1, 0 to NN-1)
 );
end COMPONENT;
-- END COMPONENT SECTION
SIGNAL CORRECT_EN : STD_LOGIC := '0';

--FSM States definition
TYPE STATE_KF IS (KF_Init, KF_WaitReady, KF_WaitInput, KF_PredictOnly, KF_ResetAll, KF_WaitReset, KF_WaitPredict, KF_All, KF_Accelerometer, KF_WaitAccelerometer, KF_Magnetometer, KF_WaitMagnetometer);
SIGNAL pr_state, nx_state : STATE_KF;

TYPE CORRECT_TYPE IS (Correct_AccelerometerOnly, Correct_MagnetometerOnly, Correct_Both, Correct_Sleep);
SIGNAL correct : CORRECT_TYPE := Correct_Sleep;

TYPE STATE_CORRECT IS (Init, waitCorrectEnNReady, startCorrectAccelerometer, waitAccelerometer, waitResetAccelerometer, startCorrectMagnetometer, waitMagnetometer, waitResetMagnetometer);
SIGNAL pr_correct, nx_correct : STATE_CORRECT := Init;

--Internal Signals
SIGNAL INTERNAL_INPUT_READY : STD_LOGIC := '0';
SIGNAL INTERNAL_OUTPUT_VALID : STD_LOGIC := '0';

----Gyroscope internal signals
SIGNAL INTERNAL_Gyroscope_TVALID : STD_LOGIC := '0';
SIGNAL INTERNAL_Gyroscope_FALL : STD_LOGIC := '1';
SIGNAL INTERNAL_Gyroscope_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));

----Accelerometer internal signals
SIGNAL INTERNAL_Accelerometer_TVALID : STD_LOGIC := '0';
SIGNAL INTERNAL_Accelerometer_FALL : STD_LOGIC := '1';
SIGNAL INTERNAL_Accelerometer_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));

----Magnetometer internal signals
SIGNAL INTERNAL_Magnetometer_TVALID : STD_LOGIC := '0';
SIGNAL INTERNAL_Magnetometer_FALL : STD_LOGIC := '1';
SIGNAL INTERNAL_Magnetometer_DATA : MATRIX(0 to 2, 0 to 0) := (others => (others => ZERO));


----Internal memory signals
SIGNAL INTERNAL_x : MATRIX(0 to NN-1, 0 to 0) := (3 =>(ONE, others => ZERO), 
                                                  4 =>("00111010110000100000011110001011", others => ZERO),
                                                  5 =>("10111010101001001010001010011001", others => ZERO),
                                                  6 =>("00111011000111111110111111011000", others => ZERO),
                                                  others => (others => ZERO));
SIGNAL INTERNAL_P : MATRIX(0 to NN-1, 0 to NN-1) := (0 => (0 => "00111100101101010100110100011001", others => ZERO),
                                                     1 => (1 => "00111100011110110110010111000010", others => ZERO),
                                                     2 => (2 => "00111101011001111110110111111111", others => ZERO),
                                                     3 => (3 => "00111101110000000001100101110011", others => ZERO),
                                                     4 => (4 => "00111000001001000111000110111000", others => ZERO),
                                                     5 => (5 => "00111000001100101101011110010001", others => ZERO),
                                                     6 => (6 => "00111000000011110000011101001101", others => ZERO));

--Predict Signals definition
SIGNAL Predict_ACLKEn : STD_LOGIC := '0';
SIGNAL Predict_AResetn : STD_LOGIC := '0';
SIGNAL Predict_INPUT_READY, Predict_x_TVALID, Predict_P_TVALID, Predict_Gyroscope_TVALID, Predict_OUTPUT_TValid, Predict_OUTPUT_Ready : STD_LOGIC;
SIGNAL Predict_INPUT_x, Predict_OUTPUT_x : MATRIX(0 to NN-1, 0 to 0);
SIGNAL Predict_INPUT_P, Predict_OUTPUT_P : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL Predict_Gyroscope_DATA : MATRIX(0 to 2, 0 to 0); 

--Correct Signals definition
---Correct generic
SIGNAL Correct_ACLKEn : STD_LOGIC := '0';
SIGNAL Correct_AResetn : STD_LOGIC := '0';
SIGNAL Correct_INPUT_READY, Correct_x_TVALID, Correct_P_TVALID, Correct_Sensor_TVALID, Correct_OUTPUT_TValid, Correct_OUTPUT_Ready : STD_LOGIC;
SIGNAL Correct_OUTPUT_x, Correct_INPUT_x : MATRIX(0 to NN-1, 0 to 0);
SIGNAL Correct_OUTPUT_P, Correct_INPUT_P : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL Correct_Sensor_Data, Correct_base, Correct_R : MATRIX(0 to 2, 0 to 0); 

---Accelerometer Correct
SIGNAL Accelerometer_ACLKEn : STD_LOGIC := '0';
SIGNAL Accelerometer_AResetn : STD_LOGIC := '0';
SIGNAL Accelerometer_INPUT_READY, Accelerometer_x_TVALID, Accelerometer_P_TVALID, Accelerometer_Sensor_TVALID, Accelerometer_OUTPUT_TValid, Accelerometer_OUTPUT_Ready : STD_LOGIC;
SIGNAL Accelerometer_OUTPUT_x, Accelerometer_INPUT_x : MATRIX(0 to NN-1, 0 to 0);
SIGNAL Accelerometer_OUTPUT_P, Accelerometer_INPUT_P : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL Accelerometer_Sensor_Data : MATRIX(0 to 2, 0 to 0); 
SIGNAL Accelerometer_base : MATRIX(0 to 2, 0 to 0) := (2 =>(0=> "00111111100000000000000000000000", others => ZERO),
                                               others => (others => ZERO));
SIGNAL Accelerometer_R : MATRIX(0 to 2, 0 to 0) := (0 => (0=> "00110111110010111010110111010011", others => ZERO),
                                                    1 => (0=> "00110111100001110011010000101110", others => ZERO),
                                                    2 => (0=> "00111000101011111111100011001000", others => ZERO));


---Magnetometer Correct
SIGNAL Magnetometer_ACLKEn : STD_LOGIC := '0';
SIGNAL Magnetometer_AResetn : STD_LOGIC := '0';
SIGNAL Magnetometer_INPUT_READY, Magnetometer_x_TVALID, Magnetometer_P_TVALID, Magnetometer_Sensor_TVALID, Magnetometer_OUTPUT_TValid, Magnetometer_OUTPUT_Ready : STD_LOGIC;
SIGNAL Magnetometer_OUTPUT_x, Magnetometer_INPUT_x : MATRIX(0 to NN-1, 0 to 0);
SIGNAL Magnetometer_OUTPUT_P, Magnetometer_INPUT_P : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL Magnetometer_Sensor_Data : MATRIX(0 to 2, 0 to 0); 
SIGNAL Magnetometer_base : MATRIX(0 to 2, 0 to 0) := (0 => (0 => "00111101001011011010010110111101", others => ZERO),
                                                      1 => (0 => "00111010011001011000101010010110", others => ZERO),
                                                      2 => (0 => "10111111011111111100010011111100", others => ZERO));
SIGNAL Magnetometer_R : MATRIX(0 to 2, 0 to 0) := (0 => (0=> "01000111110000110101000000000000", others => ZERO),
                                                   1 => (0=> "01000111110000110101000000000000", others => ZERO),
                                                   2 => (0=> "01000111110000110101000000000000", others => ZERO));

SIGNAL SensorNonUsed : MATRIX(0 to 2, 0 to 0) := (others => (others => "11111111111111111111111111111111"));

					
-- Output write control
SIGNAL WR_Predict_OUTPUT_EN : STD_LOGIC := '0';									 
SIGNAL WR_Accelerometer_OUTPUT_EN : STD_LOGIC := '0';	
SIGNAL WR_Magnetometer_OUTPUT_EN : STD_LOGIC := '0';	
											 
begin


--Assign external signals and internal signals.
INPUT_READY <= INTERNAL_INPUT_READY;
OUTPUT_VALID <= INTERNAL_OUTPUT_VALID;

x <= INTERNAL_x;
P <= INTERNAL_P;

                                  
                                   
--Sensor input control
--When Sensor_TVALID rises, internal_sensor_TVALID go high if internal_input_ready is high
--If internal_input_ready goes down, so does internal_sensor_TVALID
GYROSCOPEP: PROCESS(ACLK)
begin
    if (rising_edge(ACLK)) then  
        if(Gyroscope_TVALID = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_Gyroscope_FALL = '1') then
            INTERNAL_Gyroscope_TVALID <= '1';
            INTERNAL_Gyroscope_FALL <= '0';
            INTERNAL_Gyroscope_DATA <= Gyroscope;     
        end if;
        if(Gyroscope_TVALID = '0' OR INTERNAL_INPUT_READY = '0') then
            INTERNAL_Gyroscope_TVALID <= '0';
        end if;
        if(Gyroscope_TVALID = '0') then
            INTERNAL_Gyroscope_FALL <= '1';
        end if;
    end if;
end process;

ACCELEROMETERP: PROCESS(ACLK)
begin
    if (rising_edge(ACLK)) then  
        if(Accelerometer_TVALID = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_Accelerometer_FALL = '1') then
            INTERNAL_Accelerometer_TVALID <= '1';
            INTERNAL_Accelerometer_FALL <= '0';
            INTERNAL_Accelerometer_DATA <= Accelerometer;     
        end if;
        if(Accelerometer_TVALID = '0' OR INTERNAL_INPUT_READY = '0') then
            INTERNAL_Accelerometer_TVALID <= '0';
        end if;
        if(Accelerometer_TVALID = '0') then
            INTERNAL_Accelerometer_FALL <= '1';
        end if;
    end if;    
end process;

MAGNETOMETERP: PROCESS(ACLK)
begin
    if (rising_edge(ACLK)) then  
        if(Magnetometer_TVALID = '1' AND INTERNAL_INPUT_READY = '1' AND INTERNAL_Magnetometer_FALL = '1') then
            INTERNAL_Magnetometer_TVALID <= '1';
            INTERNAL_Magnetometer_FALL <= '0';
            INTERNAL_Magnetometer_DATA <= Magnetometer;     
        end if;
        if(Magnetometer_TVALID = '0' OR INTERNAL_INPUT_READY = '0') then
            INTERNAL_Magnetometer_TVALID <= '0';
        end if;
        if(Magnetometer_TVALID = '0') then
            INTERNAL_Magnetometer_FALL <= '1';
        end if;    
    end if;    
end process;


--Predict
ComponentPredict: PredictKF generic map (NN, PP)
                   port map    (ACLK, Predict_ACLKEn, Predict_AResetn, Predict_INPUT_READY,
                                Predict_x_TVALID, Predict_INPUT_x,
                                Predict_P_TVALID, Predict_INPUT_P,
                                Predict_Gyroscope_TVALID, Predict_Gyroscope_DATA,            
                                Predict_OUTPUT_TValid, Predict_OUTPUT_Ready,
                                Predict_OUTPUT_x, Predict_OUTPUT_P);


--Correct
ComponentCorrect: CorrectKF generic map (NN,PP)
                      port map    (ACLK, Correct_ACLKEn, Correct_AResetn, Correct_INPUT_READY,
                                   Correct_x_TVALID, Correct_INPUT_x,
                                   Correct_P_TVALID, Correct_INPUT_P,
                                   Correct_Sensor_TVALID, Correct_base, Correct_R, Correct_Sensor_Data,
                                   Correct_OUTPUT_TValid, Correct_OUTPUT_Ready,
                                   Correct_OUTPUT_x, Correct_OUTPUT_P);




--KalmanFilter Control Process
LFSM: PROCESS(ACLK, AResetn, ACLKEn)
	begin
	if(AResetn='0' OR ACLKEn='0') then
	   pr_state <= KF_Init;
	elsif (rising_edge(ACLK) AND ACLKEn='1') then
	   pr_state <= nx_state;
	end if; 
end process;
                                   
UFSM: PROCESS(ACLK)
    VARIABLE count : INTEGER RANGE 0 to 15 := 0;
begin
    if (rising_edge(ACLK)) then       
       if(ACLKEn='0' OR AResetn='0') then
            Predict_ACLKEn <= '0';
            Predict_AResetn <= '0';
            
            INTERNAL_INPUT_READY <= '0';
            INTERNAL_OUTPUT_VALID <= '0';
            
            CORRECT_EN <= '0';
            correct <= Correct_Sleep;

            --Reset Predict
            Predict_ACLKEn <= '0';
            Predict_AResetn <= '0';
            Predict_x_TVALID <= '0';
            Predict_P_TVALID <= '0';                                        
            Predict_Gyroscope_TVALID <= '0';
            Predict_OUTPUT_Ready <= '0';
            
            --reset Accelerometer
            Accelerometer_ACLKEn <= '0';
            Accelerometer_AResetn <= '0';
            Accelerometer_x_TVALID <= '0';
            Accelerometer_P_TVALID <= '0';
            Accelerometer_Sensor_TVALID <= '0';
            
            --reset Magnetometer
            Magnetometer_ACLKEn <= '0';
            Magnetometer_AResetn <= '0';
            Magnetometer_x_TVALID <= '0';                                        
            Magnetometer_P_TVALID <= '0';                                        
            Magnetometer_Sensor_TVALID <= '0';
            Magnetometer_OUTPUT_Ready <= '0';    

            OUTPUT_Gyroscope <= SensorNonUsed;
            OUTPUT_Accelerometer <= SensorNonUsed;
            OUTPUT_Magnetometer <= SensorNonUsed;        
            
            INTERNAL_x <= (3 =>(ONE, others => ZERO), 
                          4 =>("00111010110000100000011110001011", others => ZERO),
                          5 =>("10111010101001001010001010011001", others => ZERO),
                          6 =>("00111011000111111110111111011000", others => ZERO),
                          others => (others => ZERO));
            INTERNAL_P <= (0 => (0 => "00111100101101010100110100011001", others => ZERO),
                             1 => (1 => "00111100011110110110010111000010", others => ZERO),
                             2 => (2 => "00111101011001111110110111111111", others => ZERO),
                             3 => (3 => "00111101110000000001100101110011", others => ZERO),
                             4 => (4 => "00111000001001000111000110111000", others => ZERO),
                             5 => (5 => "00111000001100101101011110010001", others => ZERO),
                             6 => (6 => "00111000000011110000011101001101", others => ZERO));
                                                                    
            nx_state <= KF_Init;
       elsif(ACLKEn='1') then
           case pr_state is
                -- Init - Enable Predict, set outputs
               when KF_Init =>
                    Predict_ACLKEn <= '1';
                    Predict_AResetn <= '1';
                            
                    INTERNAL_INPUT_READY <= '0';
                    INTERNAL_OUTPUT_VALID <= '0';
                    
                    CORRECT_EN <= '0';
                    correct <= Correct_Sleep;
                    
                    OUTPUT_Gyroscope <= SensorNonUsed;
                    OUTPUT_Accelerometer <= SensorNonUsed;
                    OUTPUT_Magnetometer <= SensorNonUsed;        
                                      
                    nx_state <= KF_WaitReady; 
                --Wait for Predict to be ready, when it is, goes to next state
                when KF_WaitReady =>
                    if(Predict_INPUT_READY = '1') then
                        INTERNAL_INPUT_READY <= '1';
                        nx_state <= KF_WaitInput;  
                    else
                        nx_state <= nx_state;  
                    end if;
                --Wait for inputs
                when KF_WaitInput =>	
                    if(INTERNAL_Gyroscope_TVALID = '1' AND INTERNAL_Accelerometer_TVALID = '1' AND INTERNAL_Magnetometer_TVALID = '1') then
                        INTERNAL_INPUT_READY <= '0';
                        OUTPUT_Gyroscope <= INTERNAL_Gyroscope_DATA;
                        OUTPUT_Accelerometer <= INTERNAL_Accelerometer_DATA;
                        OUTPUT_Magnetometer <= INTERNAL_Magnetometer_DATA;  
                        nx_state <= KF_All;            
                    elsif(INTERNAL_Gyroscope_TVALID = '1' AND INTERNAL_Accelerometer_TVALID = '1') then
                        INTERNAL_INPUT_READY <= '0';
                        OUTPUT_Gyroscope <= INTERNAL_Gyroscope_DATA;
                        OUTPUT_Accelerometer <= INTERNAL_Accelerometer_DATA;
                        OUTPUT_Magnetometer <= SensorNonUsed;  
                        nx_state <= KF_Accelerometer;              
                    elsif(INTERNAL_Gyroscope_TVALID = '1' AND INTERNAL_Magnetometer_TVALID = '1') then
                        INTERNAL_INPUT_READY <= '0';
                        OUTPUT_Gyroscope <= INTERNAL_Gyroscope_DATA;
                        OUTPUT_Accelerometer <= SensorNonUsed;
                        OUTPUT_Magnetometer <= INTERNAL_Magnetometer_DATA;  
                        nx_state <= KF_Magnetometer;              
                    elsif(INTERNAL_Gyroscope_TVALID = '1') then
                        INTERNAL_INPUT_READY <= '0';
                        OUTPUT_Gyroscope <= INTERNAL_Gyroscope_DATA;
                        OUTPUT_Accelerometer <= SensorNonUsed;
                        OUTPUT_Magnetometer <= SensorNonUsed;  
                        nx_state <= KF_PredictOnly;              
                    else
                        nx_state <= nx_state;   
                    end if;
                --Set inputs for PredictKF
                when KF_PredictOnly =>
                    Predict_x_TVALID <= '1';
                    Predict_INPUT_x <= INTERNAL_x;
                    
                    Predict_P_TVALID <= '1';                        				
                    Predict_INPUT_P <= INTERNAL_P;
                    
                    Predict_Gyroscope_TVALID <= '1';
                    Predict_Gyroscope_DATA <= INTERNAL_Gyroscope_DATA;
                    
                    Predict_OUTPUT_Ready <= '1';
                    
                    nx_state <= KF_WaitPredict;
                --Wait Predict to finish, when it does, set output valid and store result	 
                when KF_WaitPredict =>
                   if(Predict_OUTPUT_TValid = '1') then
                        INTERNAL_OUTPUT_VALID <= '1';
                        WR_Predict_OUTPUT_EN <= '1';
                        INTERNAL_x <= Predict_OUTPUT_x;
                        INTERNAL_P <= Predict_OUTPUT_P ;
                        nx_state <= KF_ResetAll;
                    else
                        nx_state <= nx_state;
                   end if;
                --Set inputs for 
                when KF_All =>
                    CORRECT_EN <= '1';
                    correct <= Correct_Both;
                
                    --Set Predict
                    Predict_x_TVALID <= '1';
                    Predict_INPUT_x <= INTERNAL_x;
                    
                    Predict_P_TVALID <= '1';                        				
                    Predict_INPUT_P <= INTERNAL_P;
                    
                    Predict_Gyroscope_TVALID <= '1';
                    Predict_Gyroscope_DATA <= INTERNAL_Gyroscope_DATA;
                    
                    Predict_OUTPUT_Ready <= Accelerometer_INPUT_READY;
                    
                    --Conect Accelerometer
                    Accelerometer_ACLKEn <= '1';
                    Accelerometer_AResetn <= '1';
                    
                    Accelerometer_x_TVALID <= Predict_OUTPUT_TValid;
                    Accelerometer_INPUT_x <= Predict_OUTPUT_x;
                    
                    Accelerometer_P_TVALID <= Predict_OUTPUT_TValid;
                    Accelerometer_INPUT_P <= Predict_OUTPUT_P;
                    
                    Accelerometer_Sensor_Data <= INTERNAL_Accelerometer_DATA;
                    Accelerometer_Sensor_TVALID <= '1';
                    
                    Accelerometer_OUTPUT_Ready <= Magnetometer_INPUT_READY;
                    
                    --Conect Magnetometer
                    Magnetometer_ACLKEn <= '1';
                    Magnetometer_AResetn <= '1';
                    
                    Magnetometer_x_TVALID <= Accelerometer_OUTPUT_TValid;
                    Magnetometer_INPUT_x <= Accelerometer_OUTPUT_x;
                    
                    Magnetometer_P_TVALID <= Accelerometer_OUTPUT_TValid;
                    Magnetometer_INPUT_P <= Accelerometer_OUTPUT_P;
                    
                    Magnetometer_Sensor_Data <= INTERNAL_Magnetometer_DATA;
                    Magnetometer_Sensor_TVALID <= '1';
                    
                    Magnetometer_OUTPUT_Ready <= '1';	

                    --nx_state <= KF_WaitMagnetometer;
                    if(Magnetometer_OUTPUT_TValid = '1') then
                        nx_state <= KF_WaitMagnetometer;
                    else
                        nx_state <= nx_state;
                    end if;    
                --Set inputs for 
                when KF_Accelerometer =>
                    CORRECT_EN <= '1';
                    correct <= Correct_AccelerometerOnly;
                    
                    --Set Predict
                    Predict_x_TVALID <= '1';
                    Predict_INPUT_x <= INTERNAL_x;
                    
                    Predict_P_TVALID <= '1';                        				
                    Predict_INPUT_P <= INTERNAL_P;
                    
                    Predict_Gyroscope_TVALID <= '1';
                    Predict_Gyroscope_DATA <= INTERNAL_Gyroscope_DATA;
                    
                    Predict_OUTPUT_Ready <= Accelerometer_INPUT_READY;
                    
                    --Conect Accelerometer
                    Accelerometer_ACLKEn <= '1';
                    Accelerometer_AResetn <= '1';
                    
                    Accelerometer_x_TVALID <= Predict_OUTPUT_TValid;
                    Accelerometer_INPUT_x <= Predict_OUTPUT_x;
                    
                    Accelerometer_P_TVALID <= Predict_OUTPUT_TValid;
                    Accelerometer_INPUT_P <= Predict_OUTPUT_P;
                    
                    Accelerometer_Sensor_Data <= INTERNAL_Accelerometer_DATA;
                    Accelerometer_Sensor_TVALID <= '1';
                    
                    Accelerometer_OUTPUT_Ready <= '1';				

                    nx_state <= KF_WaitAccelerometer;
                    if(Accelerometer_OUTPUT_TValid = '1') then
                        nx_state <= KF_WaitAccelerometer;
                    else
                        nx_state <= nx_state;
                    end if;    
                when KF_WaitAccelerometer => 
--                    if(Accelerometer_OUTPUT_TValid = '1') then
                        INTERNAL_OUTPUT_VALID <= '1';
                        WR_Accelerometer_OUTPUT_EN <= '1';
                        INTERNAL_x <= Accelerometer_OUTPUT_x;
                        INTERNAL_P <= Accelerometer_OUTPUT_P;
                        nx_state <= KF_ResetAll;
--                    else
--                        nx_state <= nx_state;
--                   end if;
                when KF_Magnetometer =>
                    CORRECT_EN <= '1';
                    correct <= Correct_MagnetometerOnly;
                    
                    --Set Predict
                    Predict_x_TVALID <= '1';
                    Predict_INPUT_x <= INTERNAL_x;
                    
                    Predict_P_TVALID <= '1';                        				
                    Predict_INPUT_P <= INTERNAL_P;
                    
                    Predict_Gyroscope_TVALID <= '1';
                    Predict_Gyroscope_DATA <= INTERNAL_Gyroscope_DATA;
                    
                    Predict_OUTPUT_Ready <= Magnetometer_INPUT_READY;
    
                    --Conect Magnetometer
                    Magnetometer_ACLKEn <= '1';
                    Magnetometer_AResetn <= '1';
                    
                    Magnetometer_x_TVALID <= Predict_OUTPUT_TValid;
                    Magnetometer_INPUT_x <= Predict_OUTPUT_x;
                    
                    Magnetometer_P_TVALID <= Predict_OUTPUT_TValid;
                    Magnetometer_INPUT_P <= Predict_OUTPUT_P;
                    
                    Magnetometer_Sensor_Data <= INTERNAL_Magnetometer_DATA;
                    Magnetometer_Sensor_TVALID <= '1';
                    
                    Magnetometer_OUTPUT_Ready <= '1';	
                    if(Magnetometer_OUTPUT_TValid = '1') then
                        nx_state <= KF_WaitMagnetometer;
                    else
                        nx_state <= nx_state;
                    end if;    
                when KF_WaitMagnetometer =>
--                    if(Magnetometer_OUTPUT_TValid = '1') then
                        INTERNAL_OUTPUT_VALID <= '1';
                        WR_Magnetometer_OUTPUT_EN <= '1';
                        INTERNAL_x <= Magnetometer_OUTPUT_x;
                        INTERNAL_P <= Magnetometer_OUTPUT_P;
                        nx_state <= KF_ResetAll;
--                    else
--                        nx_state <= nx_state;
--                   end if;			
                -- Reset all components. Disable Write output
                when KF_ResetAll =>
                    WR_Predict_OUTPUT_EN <= '0';
                    
                    CORRECT_EN <= '0';
                    correct <= Correct_Sleep;
                                    
                    --Reset Predict
                    Predict_ACLKEn <= '0';
                    Predict_AResetn <= '0';
                    Predict_x_TVALID <= '0';
                    Predict_P_TVALID <= '0';                                        
                    Predict_Gyroscope_TVALID <= '0';
                    Predict_OUTPUT_Ready <= '0';
                    
                    --reset Accelerometer
                    Accelerometer_ACLKEn <= '0';
                    Accelerometer_AResetn <= '0';
                    Accelerometer_x_TVALID <= '0';
                    Accelerometer_P_TVALID <= '0';
                    Accelerometer_Sensor_TVALID <= '0';
                    
                    --reset Magnetometer
                    Magnetometer_ACLKEn <= '0';
                    Magnetometer_AResetn <= '0';
                    Magnetometer_x_TVALID <= '0';                                        
                    Magnetometer_P_TVALID <= '0';                                        
                    Magnetometer_Sensor_TVALID <= '0';
                    Magnetometer_OUTPUT_Ready <= '0';    
                    
                    nx_state <= KF_WaitReset;
                when KF_WaitReset =>	
                    if(count > 3) then
                        count := 0;
                        nx_state <= KF_Init;
                    else
                        count := count + 1;
                        nx_state <= nx_state;
                    end if;
                when others =>
                    nx_state <= KF_ResetAll;
           end case;  
       end if; 
	end if;             
end process;                                   

--Control input and output for CorrectKF
Correct_LFSM: PROCESS(ACLK, AResetn, ACLKEn)
	begin
	if(AResetn='0' OR ACLKEn='0') then
	   pr_correct <= Init;
	elsif (rising_edge(ACLK) AND ACLKEn='1') then
	   pr_correct <= nx_correct;
	end if; 
end process;


Correct_UFSM: process(ACLK)
    VARIABLE count : INTEGER RANGE 0 to 15 := 0;
begin
	if(rising_edge(ACLK)) then
		if(AResetn='0' OR ACLKEn='0') then
			Correct_ACLKEn <= '0';
			Correct_AResetn <= '0';
			Magnetometer_OUTPUT_TValid <= '0';
			Accelerometer_OUTPUT_TValid <= '0';
			
			nx_correct <= Init;
			count := 0;
		elsif(AResetn = '1' AND ACLKEn='1') then
			case pr_correct is
				when Init =>
					nx_correct <= waitCorrectEnNReady;
				when waitCorrectEnNReady =>
                    Magnetometer_OUTPUT_TValid <= '0';
                    Accelerometer_OUTPUT_TValid <= '0';
					if(CORRECT_EN = '1') then
						case CORRECT is
							when Correct_AccelerometerOnly =>
								nx_correct <= startCorrectAccelerometer;
							when Correct_MagnetometerOnly =>
								nx_correct <= startCorrectMagnetometer;
							when Correct_Both => 
								nx_correct <= startCorrectAccelerometer;
							when others =>
								nx_correct <= waitCorrectEnNReady;
						end case;
					else
						nx_correct <= waitCorrectEnNReady;
					end if;
				when startCorrectAccelerometer =>
					Correct_ACLKEn <= '1';
					Correct_AResetn <= '1';
					Accelerometer_INPUT_READY <= Correct_INPUT_READY;       
					if(Correct_INPUT_READY = '1' AND Accelerometer_x_TVALID = '1' AND Accelerometer_P_TVALID = '1' AND Accelerometer_Sensor_TVALID = '1') then
						Correct_INPUT_x <= Accelerometer_INPUT_x;
						Correct_x_TVALID <= '1';
						Correct_INPUT_P <= Accelerometer_INPUT_P;
						Correct_P_TVALID <= '1';
						Correct_base <= Accelerometer_base;
						Correct_R <= Accelerometer_R;
						Correct_Sensor_Data <= Accelerometer_Sensor_Data;
						Correct_Sensor_TVALID <= '1';
						Correct_OUTPUT_Ready <= '1';
						nx_correct <= waitAccelerometer;
					else
						nx_correct <= startCorrectAccelerometer;
					end if;
				when waitAccelerometer =>
					if(Correct_OUTPUT_TValid = '1') then
						Accelerometer_OUTPUT_x <= Correct_OUTPUT_x;
						Accelerometer_OUTPUT_P <= Correct_OUTPUT_P;
						Accelerometer_OUTPUT_TValid <= '1';
						
						Correct_x_TVALID <= '0';
						Correct_P_TVALID <= '0';
						Correct_Sensor_TVALID <= '0';
						 
						Correct_ACLKEn <= '0';
						Correct_AResetn <= '0';
						Correct_OUTPUT_Ready <= '0';
						nx_correct <= waitResetAccelerometer;
					else
						nx_correct <= waitAccelerometer;
					end if;                    
				 when waitResetAccelerometer =>
					if(count = 3) then
						count := 0;
						case CORRECT is
							when Correct_AccelerometerOnly =>
								nx_correct <= Init;
							when Correct_Both =>
								nx_correct <= startCorrectMagnetometer;
							when others =>
								nx_correct <= Init;
						end case;
					else
						count := count + 1;
					end if;
				when startCorrectMagnetometer =>
					Correct_ACLKEn <= '1';
					Correct_AResetn <= '1';
					Magnetometer_INPUT_READY <= Correct_INPUT_READY;       
					if(Correct_INPUT_READY = '1' AND Magnetometer_x_TVALID = '1' AND Magnetometer_P_TVALID = '1' AND Magnetometer_Sensor_TVALID = '1') then
						Correct_INPUT_x <= Magnetometer_INPUT_x;
						Correct_x_TVALID <= '1';
						Correct_INPUT_P <= Magnetometer_INPUT_P;
						Correct_P_TVALID <= '1';
						Correct_base <= Magnetometer_base;
						Correct_R <= Magnetometer_R;
						Correct_Sensor_Data <= Magnetometer_Sensor_Data;
						Correct_Sensor_TVALID <= '1';
						Correct_OUTPUT_Ready <= '1';
						nx_correct <= waitMagnetometer;
					else
						nx_correct <= startCorrectMagnetometer;
					end if;
				when waitMagnetometer =>
					if(Correct_OUTPUT_TValid = '1') then
						Magnetometer_OUTPUT_x <= Correct_OUTPUT_x;
						Magnetometer_OUTPUT_P <= Correct_OUTPUT_P;
						Magnetometer_OUTPUT_TValid <= '1';
						
						Correct_x_TVALID <= '0';
						Correct_P_TVALID <= '0';
						Correct_Sensor_TVALID <= '0';
						 
						Correct_ACLKEn <= '0';
						Correct_AResetn <= '0';
						Correct_OUTPUT_Ready <= '0';
						nx_correct <= waitResetMagnetometer;
					else
						nx_correct <= waitMagnetometer;
					end if;           
				when waitResetMagnetometer =>
					if(count = 3) then
						count := 0;
						nx_correct <= Init;
					else
						count := count + 1;
					end if;
				when others =>
					nx_correct <= Init;
			end case;						
		end if;
	end if;
end process;
								
end KalmanFilter_Behavioral;
