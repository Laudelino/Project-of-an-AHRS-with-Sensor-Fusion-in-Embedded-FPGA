----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2016 09:23:19 AM
-- Design Name: 
-- Module Name: Clock_Divider - Clock_Divider_Behavioral
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

entity Clock_Divider is
    generic ( f_in : INTEGER := 100000000;
              f_out : integer);
    Port (    clk_in : in STD_LOGIC;
              clk_out : out STD_LOGIC);
end Clock_Divider;

architecture Clock_Divider_Behavioral of Clock_Divider is
    signal tmp : STD_LOGIC;
    signal cnt : integer range 0 to (f_in/(f_out)) := 0;
    constant cntEndVal : integer := (f_in/(2*f_out));
begin
    frequency_divider : process (clk_in) begin
        if(rising_edge(clk_in)) then 
            if(cnt = cntEndVal) then 
                tmp <= NOT(tmp);
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
         end if;
     end process;
clk_out <= tmp;    

end Clock_Divider_Behavioral;
