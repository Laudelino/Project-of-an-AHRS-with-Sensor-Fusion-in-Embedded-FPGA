------------------------------------------------------------------------------------------------------ 
---- TITLE: I2C bus master controller (i2c_master.vhd) 
---- REVISION: 1.0 (10.05.2015) 
---- DEPENDENCIES: Top-level controllers (see description) 
---- REQUIRENMENTS: - SDA and SCL I/O buffers on the top-level source (see top_module.vhd) 
-- 									- slave peripheral to not implement clock-stretching 
---- DEVICE, ENVIRONMENT: Digilent Nexys4DDR, Xilinx Vivado 2014.4 
---- CONTACT: Pop Mihnea Vlad (pcmihnea@gmail.com), Tatar Alex (tataralex16@gmail.com) 
------------------------------------------------------------------------------------------------------ 
---- DESCRIPTION: This module controls the SDA and SCL lines for a I2C bus, taking the role of the 
-- master, allowing communication with slave peripherals (such as register reading and writing). It 
-- requires an top-level source to control it, as standalone it doesn't realise any operations. This 
-- aspect results in it being universally interface-able, able to accomplish I2C operations in any 
-- order, although it may prove less efficient than dedicated I2C controllers. 
-- The SDA and SCL lines' states (pulled low (_) or high impedance 'Z' (-) ) at each I2C operation 
-- can each be divided into four sub-states (0,1,2, and 3): 
-- 012301230123012301230123012301230123 
-- Start: SCL: ---_ 
-- 		  SDA: --__ 
-- 
-- Restart SCL: _--_ 
-- 		   SDA: --__ 
-- 
-- Stop: SCL: _--- 
--       SDA: __-- 
-- 
-- Write: SCL: _--__--__--__--__--__--__--__--__--_ 
--        SDA: (7) (6) (5) (4) (3) (2) (1) (0) (ACK) = bit to write (ACK is acknowledge from slave) 
-- 
-- Read: SCL: _--__--__--__--__--__--__--__--__--_ 
--       SDA: (7) (6) (5) (4) (3) (2) (1) (0) (ACK) = bit to read (ACK is acknowledge from master) 
------------------------------------------------------------------------------------------------------ 
library ieee; 
use ieee.std_logic_1164.all;
entity MAG_I2C_Interface is 
port ( 
	clk100mhz_in : in std_logic; -- 100MHz global clock 
	reset_in : in std_logic; -- active-high 
	oper_in : in std_logic_vector (2 downto 0); 
	en_in : in std_logic; -- active-high 
	done_out : out std_logic; -- active-high 
	ack_out : out std_logic; -- active-low 
	data_in: in std_logic_vector(7 downto 0); -- data to write (master->slave) 
	data_out: out std_logic_vector(7 downto 0); -- data read (slave->master) 
	sda : inout std_logic; -- SDA input* 
	scl_out: out std_logic); -- SCL output 
end MAG_I2C_Interface; 
-- * although the SDA line is bidirectional, input and output signals are separated so that the I/O buffering is accomplished inside the top-level source 

architecture behavioral of MAG_I2C_Interface is 
-- for universal interfacing to a top-level source, the op_type signal is converted to std_logic_vector, allowing easier component port signals declarations (see the with..select command bellow) 
type op_type is (i2c_start, i2c_restart, i2c_write, i2c_read_ack, i2c_read_nack, i2c_stop); 
signal op, op_in : op_type := i2c_start; 
signal state : integer range 0 to 4 := 0; -- sub-states counter (state 4 is used to output read data) 
signal bit_cnt : integer range 0 to 8 := 0; -- number of bits read/written 
signal count : integer range 0 to 248 := 0; -- counter for time delay => 100.000.000 [clock frequency]/ 100.000 [bus bitrate])/4 [sub-states] - 2 
signal done, delayd : std_logic := '1'; -- state signals 
signal ack: std_logic := '0'; -- signal read from the slave after a write operation
signal datain : std_logic_vector(8 downto 0) := (others => '0'); -- data read including the acknowledge bit 
signal dataout : std_logic_vector(7 downto 0) := (others => '0'); -- data to write 
begin 

with oper_in select op_in <= i2c_start when "001", 
							i2c_restart when "011", 
							i2c_write when "010", 
							i2c_read_ack when "110", 
							i2c_read_nack when "100", 
							i2c_stop when others; -- converts std_logic_vector to op_type 

done_out <= done; -- connects the internal 'done' signal to the module output 'done_out'

i2c_ctrl: process(clk100mhz_in) 
begin 
	if (rising_edge(clk100mhz_in)) then -- resets all signals used by this process 
		if (reset_in='1') then 
			bit_cnt <= 0; 
			count <= 0; 
			done <= '1'; 
			state <= 0; 
			ack <= '0'; 
			delayd <= '1'; 
			op <= i2c_start; 
			datain <= (others => '0'); 
			dataout <= (others => '0'); 
			data_out<= (others => '0'); 
			ack_out<= '0'; 
			scl_out<= '1'; 
			sda<= '1'; 
		else 
			if (done='1') then -- wait for each sub-state to finish 
				if (en_in='1') then -- wait for the start signal 
					done <= '0'; 
					state <= 0; 
					op <= op_in; 
					dataout <= data_in; 
					bit_cnt<= 0; 
				end if; 
			elsif (delayd = '0') then -- delay is required only for sub-state 0,1,2,3, not 4 
				if (count=248) then -- time delay, to allow correct bitrate 
					count <= 0; 
					delayd <= '1'; 
				else 
					count <= count + 1; 
				end if; 
			else 
				case state is -- see description for SDA and SCL states at each sub-state 
					when 0 => 
						state <= 1; 
						delayd <= '0'; 
						
						case op is 
							when i2c_start => 
								scl_out<= '1'; --when '0' the line is pulled low by the master, when '1' the line is in high impedance ('Z') 
								sda<= '1'; 
							when i2c_restart => 
								scl_out<= '0'; 
								sda<= '1'; 
							when i2c_stop => 
								scl_out<= '0'; 
								sda<= '0'; 
							when i2c_write => 
								scl_out<= '0'; 
								if (bit_cnt=8) then 
									sda<= 'Z'; -- allows the reading of slave's acknowledge bit
								else 
									sda<= dataout(7);-- serially output the data required 
								end if; 
							when i2c_read_ack => 
								scl_out<= '0'; 
								if (bit_cnt=8) then 
									sda<= '0'; -- send the ACK bit (pull SDA low) 
								else 
									sda<= 'Z'; -- allow the reading slave's data bits 
								end if; 
							when i2c_read_nack => 
								scl_out<= '0'; 
								sda<= 'Z'; -- allow the reading slave's data bits, and also send the NACK bit (keep SDA in 'Z') 
						end case; 
						
						dataout <= dataout(6 downto 0) & '0'; -- bit-shift to the next bit 
					when 1 => 
						state <= 2; 
						delayd <= '0'; 
						
						case op is 
							when i2c_start => 
								scl_out<= '1'; 
								sda<= '1'; 
							when i2c_restart => 
								scl_out<= '1'; 
								sda<= '1'; 
							when i2c_stop => 
								scl_out<= '1'; 
								sda<= '0'; 
							when i2c_write => 
								scl_out<= '1';
								--sda <= 'Z';--*** 
							when i2c_read_ack => 
								scl_out<= '1'; 
                                --sda <= 'Z';--*** 
							when i2c_read_nack => 
								scl_out<= '1';
                                --sda <= 'Z';--***  
						end case; 
					when 2 => 
						state <= 3; 
						delayd <= '0'; 
						
						case op is 
							when i2c_start => 
								scl_out<= '1'; 
								sda<= '0'; 
							when i2c_restart => 
								scl_out<= '1'; 
								sda<= '0'; 
							when i2c_stop => 
								scl_out<= '1'; 
								sda <= '1'; 
							when i2c_write => 
								scl_out<= '1'; 
								if (bit_cnt=8) then 
									ack <= sda; -- read of slave's acknowledge bit 
								end if; 
							when i2c_read_ack => 
								scl_out<= '1'; 
								datain <= datain(7 downto 0) & sda; 
							when i2c_read_nack => 
								scl_out<= '1'; 
								datain <= datain(7 downto 0) & sda; 
						end case;
					when 3 => 
						delayd <= '0'; 
						
						case op is 
							when i2c_start => 
								scl_out<= '0'; 
								sda<= '0'; 
							when i2c_restart => 
								scl_out<= '0'; 
								sda<= '0'; 
							when i2c_stop => 
								scl_out<= '1'; 
								sda<= '1'; 
							when i2c_write => 
								scl_out<= '0'; 
							when i2c_read_ack => 
								scl_out<= '0'; 
							when i2c_read_nack => 
								scl_out<= '0'; 
						end case; 
						
						case op is -- depending on the operation, certain additional steps are required 
							when i2c_start | i2c_restart | i2c_stop => 
								state <= 4; 
							when i2c_write | i2c_read_ack | i2c_read_nack => -- if all 8 bits ave been read/written, go to next step, else go to next bit 
								if (bit_cnt=8) then 
									state <= 4; 
								else 
									bit_cnt <= bit_cnt + 1; 
									state <= 0; 
								end if; 
						end case; 
					when 4 => 
						done <= '1'; 
						
						if (op=i2c_read_ack or op=i2c_read_nack) then -- output the 8-bit read data 
							data_out <= datain(8 downto 1); 
						end if; 
						
						if (op=i2c_write) then -- output the slave acknowledge bit 
							ack_out <= ack; 
						end if; 
						
					end case; 
				end if; 
			end if; 
		end if; 
	end process i2c_ctrl; 
end behavioral;