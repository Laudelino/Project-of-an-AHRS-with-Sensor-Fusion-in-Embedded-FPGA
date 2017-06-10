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
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all; -- used for the 'to_integer' type conversion

entity MAG_I2C_Master is 
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
end MAG_I2C_Master; 
-- * although the SDA line is bidirectional, input and output signals are separated so that the I/O buffering is accomplished inside the top-level source 
architecture behavioral of MAG_I2C_Master is 

component MAG_I2C_Interface is -- for the actual I2C SDA and SCL lines control, the i2c_master module is used (see i2c_master.vhd for more info) 
port ( 
    clk100mhz_in : in std_logic; 
    reset_in : in std_logic; 
    oper_in : in std_logic_vector(2 downto 0); 
    en_in : in std_logic; 
    done_out : out std_logic; 
    ack_out : out std_logic; 
    data_in: in std_logic_vector(7 downto 0); 
    data_out: out std_logic_vector(7 downto 0); 
    sda : inout std_logic; 
    scl_out: out std_logic); 
end component;  -- for universal interfacing to the i2c_master, the op_type signal is converted to std_logic_vector, allowing easier component port signals declarations (see the with..select command bellow) 

type op_type is (i2c_start, i2c_restart, i2c_write, i2c_read_ack, i2c_read_nack, i2c_stop); 
signal i2c_op : op_type := i2c_start; 
signal i2c_oper : std_logic_vector (2 downto 0) := "001"; 
signal i2c_en, i2c_done, i2c_ack : std_logic; -- status signals inputted/outputted from the i2c_master module 
signal data_out_buff : std_logic_vector(47 downto 0); -- read 8-bit MSB and 8-bit LSB data for X and Y axis - MSB(X)&LSB(X)&MSB(Y)&MSB(Y) 
signal i2c_data_in, i2c_data_out : std_logic_vector(7 downto 0); -- I2C interface 8-bit inputted (from slave to master) and outputted (from master to slave) 
signal initialised : std_logic := '0'; -- to assure correct operation, at startup or after a reset signal, a number of HMC5883L registers are read and verified
signal done : std_logic := '1'; -- signals that this module has finished reading the registers and data_out is refreshed 
signal state : integer range 0 to 24 := 0; -- internal state machine counter 


begin 
	i2c_master_module : MAG_I2C_Interface port map (clk100mhz_in, reset_in, i2c_oper, i2c_en, i2c_done, i2c_ack, i2c_data_out, i2c_data_in, magn_sda, magn_scl_out); -- component instantiation 
	with i2c_op select i2c_oper <= "001" when i2c_start, 
								   "011" when i2c_restart, 
								   "010" when i2c_write, 
								   "110" when i2c_read_ack, 
								   "100" when i2c_read_nack, 
								   "000" when i2c_stop; -- converts op_type to std_logic_vector 
    done_out <= done; -- connects the internal 'done' signal to the module output 'done_out' 

	magn_i2c_ctrl: process (clk100mhz_in) 
		variable count : integer range 0 to 9999999; -- counter for time delays (for 100MHz clock, 1.000.000 pulses = 10mSecs) 
		variable error_count : integer range 0 to 10; -- counts the number of I2C acknowledge errors 

	begin 
		if (rising_edge(clk100mhz_in)) then 
			if (reset_in = '1') then -- resets all signals used by this process 
				done <= '1'; 
				i2c_en <= '0'; 
				i2c_op <= i2c_start; 
				i2c_data_out <= (others => '0'); 
				data_out_buff <= (others => '0'); 
				state <= 0; 
				initialised <= '0'; 
				count := 0; 
				error_count:=0; 
			else 
				if (initialised = '0') then -- at startup or after a reset signal, a number of HMC5883L registers are read and verified 
					if (done = '0') then -- if not done, continue the state machine 
						if (i2c_en = '1') then -- the i2c_en signal needs to be a one-shot for each operation 
							i2c_en <= '0'; 
						elsif (i2c_done='1') then -- wait for i2c_master to finish 
							case state is 
								when 0 => -- START operation 
									i2c_op <= i2c_start; 
									state <= 1; 
								when 1 => -- WRITE operation (11110 is the HMC5883L I2C address, LSB bit is the operation requested) 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111100"; 
									state <= 2; 
								when 2 => -- Targeted register (0x00 - magnetometer sample averaging) 
									if (i2c_ack = '0') then -- continue if the slave acknowledge correctly, else restart
										i2c_op <= i2c_write; 
										i2c_data_out <= "00000000"; 
										state <= 3; 
									else 
										state <= 24; 
									end if; 
								when 3 => -- Set sample averaging to 8x 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "01110000"; 
										state <= 4; 
									else 
										state <= 24; 
									end if; 
								when 4 => -- Restart operation 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_restart;  
										state <= 5; 
									else
										state <= 24; 
									end if; 
								when 5 => -- Write operation (LSB='1' equals register reading, LSB='0' equals writing) 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111100"; 
									
									state <= 6; 
								when 6 => -- Targeted register (0x00 - magnetometer sample averaging) 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "00000000"; 
										state <= 7; 
									else 
										state <= 24; 
									end if; 
								when 7 => -- Restart operation 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_restart; 
										state <= 8; 
									else 
										state <= 24; 
									end if; 
								when 8 => -- Read operation 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111101"; 
									state <= 9; 
								when 9 => -- Read register 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_read_nack; 
										state <= 10; 
									else 
										state <= 24; 
									end if; 
								when 10 => -- Sample averaging register read 
									data_out_buff(31 downto 24) <= i2c_data_in; 
									state <= 11; 
								when 11 => -- Restart operation 
									i2c_op <= i2c_restart; 
									state <= 12; 
								when 12 => -- Write operation 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111100"; 
									state <= 13; 
								when 13 => -- Targeted starting register (0xA - magnetometer ID) 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "00001010"; 
										state <= 14; 
									else 
										state <= 24; 
									end if; 
								when 14 => -- Restart operation 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_restart; 
										state <= 15; 
									else 
										state <= 24; 
									end if; 
								when 15 => -- Read operation 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111101";
									state <= 16;
								when 16 => -- Magnetometer ID registers read 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_read_ack; 
										state <= 17; 
									else 
										state <= 24; 
									end if; 
								when 17 => -- First ID register read 
									data_out_buff(23 downto 16) <= i2c_data_in; 
									state <= 18; 
								when 18 => 
									i2c_op <= i2c_read_ack; 
									state <= 19; 
								when 19 => -- Second ID register read 
									data_out_buff(15 downto 8) <= i2c_data_in; 
									state <= 20; 
								when 20 => 
									i2c_op <= i2c_read_nack; 
									state <= 21; 
								when 21 => -- Third ID register read 
									data_out_buff(7 downto 0) <= i2c_data_in; 
									state <= 22; 
								when 22 => -- Stop operation 
									i2c_op <= i2c_stop; 
									state <= 23; 
								when 23 => -- check the read registers with the HMC5883L's datasheet values, retry if not correct 
									if (data_out_buff(31 downto 0) = "01110000010010000011010000110011") then -- the correct values are 0x70 & 0x48 & 0x34 & 0x33 
										error_count:=0; 
										done <= '1'; 
										initialised <= '1'; 
									end if; 
                                        									
									state <= 0; 
								when others => -- Acknowledge error (the SDA line was not pulled low) 
									i2c_op <= i2c_stop; 
									state <= 0; 
									
									if (error_count = 10) then -- try 10 times, then give up 
										error_count:=0; 
										done <= '1'; 
									else 
										error_count := error_count + 1; 
									end if; 
							end case; 
								
							if (state /= 10 and state /= 17 and state /= 19 and state /= 21 and state /= 23) then -- set the i2c_en high only when a I2C operation is required 
								i2c_en <= '1'; 
							end if; 
						end if; 
					else 
						done <= '0'; 
					end if; 
				else -- registers have been verified, thus it's safe to communicate with the HMC5883L 
					if (start_in = '1' and done = '1') then -- wait for the start signal 
						done <= '0'; 
					end if; 
					
					if (done = '0') then 
						if (i2c_en = '1') then 
							i2c_en <= '0'; 
						elsif (i2c_done='1') then 
							case state is			
								when 0 => -- START operation 
									i2c_op <= i2c_start; 
									state <= 1; 
								when 1 => -- WRITE operation 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111100"; -- mode 
									state <= 2; 
								when 2 => -- Targeted register (0x02 - magnetometer measurement mode) 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "00000010"; 
										state <= 3; 
									else 
										state <= 23; 
									end if; 
								when 3 => -- Set measurement mode to single mode 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "00000001"; 
										state <= 4; 
									else 
										state <= 23; 
									end if; 
								when 4 => -- Stop operation 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_stop; 
										state <= 5; 
									else 
										state <= 23; 
									end if; 
								when 5 => -- Wait for 10mSecs, or when HMC5883L Int pin is low (meaning measurement is complete) 
									if ((count > 560000 AND magn_drdy = '0') OR count = 900000) then 
										state <= 6; 
										count := 0; 
									else 
										count := count + 1; 
									end if; 
								when 6 => -- Start operation 
									i2c_op <= i2c_start; 
									state <= 7; 
								when 7 => -- Write operation 
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111100"; 
									state <= 8; 
								when 8 => -- Targeted register (0x03 - magnetometer X axis MSB register) 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_write; 
										i2c_data_out <= "00000011"; 
										state <= 9; 
									else 
										state <= 23; 
									end if; 
								when 9 => -- Restart operation 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_restart; 
										state <= 10; 
									else 
										state <= 23; 
									end if; 
								when 10 => -- Read operation	
									i2c_op <= i2c_write; 
									i2c_data_out <= "00111101"; 
									state <= 11; 
								when 11 => -- Read register 
									if (i2c_ack = '0') then 
										i2c_op <= i2c_read_ack; 
										state <= 12; 
									else 
										state <= 23; 
									end if; 
								when 12 => -- X axis MSB register read 
									data_out_buff(31 downto 24) <= i2c_data_in; 
									state <= 13; 
								when 13 => 
									i2c_op <= i2c_read_ack; 
									state <= 14; 
								when 14 => -- X axis LSB register read 
									data_out_buff(23 downto 16) <= i2c_data_in; 
									state <= 15; 
								when 15 => -- Z axis MSB register read (this axis is not required, so it is read, but saving it's values is skipped) 
									data_out_buff(47 downto 40) <= i2c_data_in;
									i2c_op <= i2c_read_ack; 
									state <= 16; 
								when 16 => -- Z axis LSB register read
								    data_out_buff(39 downto 32) <= i2c_data_in; 
									i2c_op <= i2c_read_ack; 
									state <= 17; 
								when 17 => 
									i2c_op <= i2c_read_ack; 
									state <= 18; 
								when 18 => -- Y axis MSB register read 
									data_out_buff(15 downto 8) <= i2c_data_in; 
									state <= 19; 
								when 19 => 
									i2c_op <= i2c_read_nack; 
									state <= 20; 
								when 20 => -- Y axis LSB register read 
									data_out_buff(7 downto 0) <= i2c_data_in; 
									state <= 21; 
								when 21 => -- Stop operation 
									i2c_op <= i2c_stop; 
									state <= 22; 
								when 22 => -- Register reading done 
									error_count:=0; 
									done <= '1'; 
									state <= 0; 
								when others => -- Acknowledge error (the SDA line was not pulled low) 
									i2c_op <= i2c_stop; 
									state <= 0; 
									
									if (error_count = 10) then 
										error_count:=0; 
										done <= '1'; 
									else 
										error_count := error_count + 1; 
									end if; 
							end case; 
							
                            if (state /= 5 and state /= 12 and state /= 14 and state /= 18 and state /= 20 and state /= 22) then 
                                i2c_en <= '1'; 
                            end if; 
						end if; 
					end if; 
				end if;	
			end if; 
		end if; 
	end process magn_i2c_ctrl;

	atan2_approx: process (done) 
	begin 
		if (rising_edge(done)) then -- this process is triggered when the main process (magn_i2c_ctrl) is done (meaning all required registers have been read) 
			if (reset_in = '1') then 
				x_axis_data <= (others => '0'); 
				y_axis_data <= (others => '0'); 
                z_axis_data <= (others => '0');
			else -- if HMC5883L's measurements have over- or under-flown, the value stored will be -4096, so a quick check is required to prevent erroneous calculations (checks for null values are also used) 
 				x_axis_data <= data_out_buff(31 downto 16);
 				y_axis_data <= data_out_buff(15 downto 0);
                z_axis_data <= data_out_buff(47 downto 32);
			end if;

		end if; 
	end process atan2_approx;			
end behavioral;						