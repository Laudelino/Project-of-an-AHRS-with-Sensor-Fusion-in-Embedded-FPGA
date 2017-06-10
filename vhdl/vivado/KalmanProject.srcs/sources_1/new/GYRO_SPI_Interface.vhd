----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2015 03:17:34 PM
-- Design Name: 
-- Module Name: GYRO_SPI_Interface - GYRO_SPI_Interface_Behavioral
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

entity GYRO_SPI_Interface is
    Port ( send_data : in STD_LOGIC_VECTOR (7 downto 0);
           begin_transmission : in STD_LOGIC;
           slave_select : in STD_LOGIC;
           miso : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in std_logic;
           recieved_data : out STD_LOGIC_VECTOR (7 downto 0);
           end_transmission : out STD_LOGIC;
           mosi : out STD_LOGIC;
           sclk : out STD_LOGIC);
end GYRO_SPI_Interface;

architecture GYRO_SPI_Interface_Behavioral of GYRO_SPI_Interface is

-- ==============================================================================
-- 								  Signals, Constants, Types
-- ==============================================================================

			constant SPI_CLK_COUNT_MAX : std_logic_vector(11 downto 0) := X"FFF";
			signal spi_clk_count : std_logic_vector(11 downto 0);

			signal sclk_buffer : std_logic;
			signal sclk_previous : std_logic;

			constant RX_COUNT_MAX : std_logic_vector(3 downto 0) := X"8";
			signal rx_count : std_logic_vector(3 downto 0);

			signal shift_register : std_logic_vector(7 downto 0);

			type RxTxTYPE is (idle , rx_tx , hold);
			signal RxTxSTATE : RxTxTYPE;
			
-- ==============================================================================
-- 										  Implementation
-- ==============================================================================

begin

			-- operates in SPI mode3
			tx_rx_process : process( clk ) begin
			if rising_edge( clk ) then
				if RST = '1' then 
					mosi <= '1';
					RxTxSTATE <= idle;
					recieved_data <= ( others => '0' );
					shift_register <= ( others => '0' );
				else
					case RxTxSTATE is
						
						-- idle
						when idle =>
						end_transmission <= '0';
							if begin_transmission = '1' then
								RxTxSTATE <= rx_tx;
								rx_count <= ( others => '0' );
								shift_register <= send_data;
							end if;

						-- rx_tx
						when rx_tx =>
							--send bit
							if rx_count < RX_COUNT_MAX then
								if sclk_previous = '1' and sclk_buffer = '0' then
									mosi <= shift_register(7);
								--recieve bit
								elsif sclk_previous = '0' and sclk_buffer = '1' then
									shift_register(7 downto 1) <= shift_register(6 downto 0) ;
									shift_register(0) <= miso;
									rx_count <= rx_count + 1;
								end if;
							else 
								RxTxSTATE <= hold;
								end_transmission <='1';
								recieved_data <= shift_register;
							end if;

						-- hold
						when hold =>
							end_transmission <= '0';
							if slave_select = '1' then
								mosi <= '1';
								RxTxSTATE <= idle;
							elsif begin_transmission = '1' then
								RxTxSTATE <= rx_tx;
								rx_count <= ( others => '0' );
								shift_register <= send_data;
							end if;

						-- default
						when others =>
							null;
					end case;
				end if;
			end if;
			end process;

			-----------------------------------------------------
			-- 					   Serial Clock
			-----------------------------------------------------
			spi_clk_generation : process( clk ) begin
			if rising_edge( clk ) then 
				if RST = '1' then
					sclk_previous <= '1';
					sclk_buffer <= '1';
					spi_clk_count <= ( others => '0' );
				
				elsif RxTxSTATE = rx_tx then
					if spi_clk_count = SPI_CLK_COUNT_MAX then
						sclk_buffer <= not sclk_buffer;
						spi_clk_count <= ( others => '0' );
					else
						sclk_previous <= sclk_buffer;
						spi_clk_count <= spi_clk_count + 1;
					end if;
				else 
					sclk_previous <= '1';
				end if;
			end if;
			end process;

			-- Assign serial clock output
			sclk <= sclk_previous;


end GYRO_SPI_Interface_Behavioral;