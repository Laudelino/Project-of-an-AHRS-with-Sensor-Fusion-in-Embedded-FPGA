----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2015 03:07:31 PM
-- Design Name: 
-- Module Name: GYRO_SPI_Master - GYRO_SPI_Master_Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GYRO_SPI_Master is
    Port ( begin_transmission : out STD_LOGIC;
           recieved_data : in STD_LOGIC_VECTOR (7 downto 0);
           end_transmission : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           start : in STD_LOGIC;
           slave_select : out STD_LOGIC;
           send_data : out STD_LOGIC_VECTOR (7 downto 0);
           temp_data : out STD_LOGIC_VECTOR (7 downto 0);
           x_axis_data : out STD_LOGIC_VECTOR (15 downto 0);
           y_axis_data : out STD_LOGIC_VECTOR (15 downto 0);
           z_axis_data : out STD_LOGIC_VECTOR (15 downto 0);
           TVALID : out STD_LOGIC
           );
end GYRO_SPI_Master;

architecture GYRO_SPI_Master_Behavioral of GYRO_SPI_Master is
-- ==============================================================================
-- 								  Signals, Constants, Types
-- ==============================================================================

			type StateTYPE is ( idle , setup , temp , run , hold , wait_ss  , wait_run );
			signal STATE : StateTYPE;
			signal previousSTATE : StateTYPE;

			-- setup control register 1 to enable x, y, and z. CTRL_REG1 (0x20)
			-- with read and multiple bytes not selected
			-- output data rate of 100 Hz
			-- will output 8.75 mdps/digit at 250 dps maximum
			constant SETUP_GYRO : std_logic_vector(15 downto 0) := X"0F20";
			-- address of X_AXIS (0x28) with read and multiple bytes selected (0xC0)
			constant DATA_READ_BEGIN : std_logic_vector(7 downto 0) := X"E8";
			-- address of TEMP (0x26) with read selected (0x80)
			constant TEMP_READ_BEGIN : std_logic_vector(7 downto 0) := X"A6";

			constant MAX_BYTE_COUNT : integer := 6;
			signal byte_count : integer range 0 to 7;

			constant SS_COUNT_MAX : std_logic_vector(11 downto 0) := X"FFF";
			signal ss_count : std_logic_vector(11 downto 0);

			constant COUNT_WAIT_MAX : std_logic_vector(23 downto 0) := X"07FFFF";--X"7FFFFF"; --X"000FFF";
			signal count_wait : std_logic_vector(23 downto 0);
			signal axis_data : std_logic_vector(47 downto 0);

-- ==============================================================================
-- 										  Implementation
-- ==============================================================================
begin

			-----------------------------------------------------
			-- 				  Master Controller FSM
			-----------------------------------------------------
			spi_interface : process( clk ) begin
			if rising_edge( clk ) then 
				if RST = '1' then
					slave_select <= '1';
					byte_count <= 0;
					count_wait <= ( others => '0' );
					axis_data <= ( others => '0' );
					x_axis_data <= ( others => '0' );
					y_axis_data <= ( others => '0' );
					z_axis_data <= ( others => '0' );
					ss_count <= ( others => '0' );
					STATE <= idle;
					previousSTATE <= idle;
				else
					case STATE is
					
						-- idle
						when idle =>
							slave_select <= '1';
							if start = '1' then 
								byte_count <= 0;
								axis_data <= ( others => '0' );
								STATE <= setup;
							end if;
				
				
						-- setup							
						when setup =>
							if byte_count < 2 then
								send_data <= SETUP_GYRO((byte_count+1)*8-1 downto (byte_count)*8);
								slave_select <= '0';
								byte_count <= byte_count + 1;
								begin_transmission <= '1';
								previousSTATE <= setup;
								STATE <= hold;
							else
								byte_count <= 0;
								previousSTATE <= setup;
								STATE <= wait_ss;
							end if;
				
				
						-- temp				
						when temp =>
							if byte_count = 0 then
								slave_select <= '0';
								send_data <= TEMP_READ_BEGIN;
								byte_count <= byte_count + 1;
								begin_transmission <= '1';
								previousSTATE <= temp;
								STATE <= hold;
							elsif byte_count = 1 then
								send_data <= X"00";
								byte_count <= byte_count + 1;
								begin_transmission <= '1';
								previousSTATE <= temp;
								STATE <= hold;
							else 
								byte_count <= 0;
								previousSTATE <= temp;
								STATE <= wait_ss;
							end if;



						-- run
						when run =>
							if byte_count = 0 then
								slave_select <= '0';
								send_data <= DATA_READ_BEGIN;
								byte_count <= byte_count + 1;
								begin_transmission <= '1';
								previousSTATE <= run;
								STATE <= hold;
							elsif byte_count <= 6 then
								send_data <= X"00";
								byte_count <= byte_count + 1;
								begin_transmission <= '1';
								previousSTATE <= run;
								STATE <= hold;
							else
								byte_count <= 0;
								x_axis_data <= axis_data(15 downto 0);
								y_axis_data <= axis_data(31 downto 16);
								z_axis_data <= axis_data(47 downto 32);
								TVALID <= '1';
								previousSTATE <= run;
								STATE <= wait_ss;
							end if;


						-- hold
						when hold =>
							begin_transmission <= '0';
							if end_transmission = '1' then
								if ( previousSTATE = temp and byte_count /= 1 ) then
									temp_data <= recieved_data;
								elsif ( previousSTATE = run and byte_count /= 1 ) then
								    TVALID <= '0';
									axis_data((byte_count-1)*8-1 downto (byte_count - 2)*8) <= recieved_data;
								end if;
								STATE <= previousSTATE;
							end if;
						

						-- wait_ss
						when wait_ss =>
							begin_transmission <= '0';
							if ss_count = SS_COUNT_MAX then
								slave_select <= '1';
								ss_count <= ( others => '0' );
								STATE <= wait_run;
							else
								ss_count <= ss_count + 1;
							end if;

							
						-- wait_run
						when wait_run =>
						begin_transmission <= '0';
							if start = '0' then
								STATE <= idle;
							end if;
							if count_wait = COUNT_WAIT_MAX then
								count_wait <= ( others => '0' );
--								if previousSTATE = temp then
									STATE <= run;
--								else
--									STATE <= temp;
--								end if;
							else
								count_wait <= count_wait + 1;
							end if;
							
						when others =>
							null;
					end case;
				end if;
			end if;
			end process;

end GYRO_SPI_Master_Behavioral;
