----------------------------------------------------------------------------------
-- Company: UTFPR
-- Engineer: Laudelino Adao Junior (laudelino.adao@gmail.com)
-- 
-- Create Date: 05/07/2016 03:22:07 PM
-- Design Name: 
-- Module Name: Vector_dotProduct - Vector_dotProduct_Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This module calculates the dot product between two arrays with length N
-- The array's elements are STD_LOGIC_VECTOR with size determinied on Matrix_def
-- 
-- Dependencies: Matrix_def (Matrix_def.vhd)
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Matrix_def.all;

entity Vector_dotProduct is
    generic(
		N : integer := 4
	);
	port(
	    ACLK : in STD_LOGIC;
	    ACLKEn : in STD_LOGIC := '0';
	    AResetn : in STD_LOGIC  := '1';
	    TREADY : out STD_LOGIC;
	    
	    A_TVALID : in STD_LOGIC;
	    A_Data : in VECTOR (0 to N-1);
	    
	    B_TVALID : in STD_LOGIC;
        B_Data : in VECTOR (0 to N-1);
		
		R_TValid : out STD_LOGIC;
		R_TReady : in STD_LOGIC;
		R_Data : out NUM
	);
end Vector_dotProduct;

architecture Vector_dotProduct_Behavioral of Vector_dotProduct is
    --Components
    COMPONENT fp_MLA
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
        
        s_axis_c_tvalid : IN STD_LOGIC;
        s_axis_c_tready : OUT STD_LOGIC;
        s_axis_c_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    END COMPONENT;    
    
	signal sum : VECTOR (0 to N-1);

	
	SIGNAL TValid, R_TValid_aux, C_TValid : STD_LOGIC;
	SIGNAL R_TValid_out : STD_LOGIC := '0';
	SIGNAL A_TReady, B_TReady, TReady_aux : STD_LOGIC;
	SIGNAL C_TReady : STD_LOGIC;
    signal TREADY_EN : STD_LOGIC := '1';
    signal TREADY_OUT : STD_LOGIC := '0';
    
	signal A_Data_i : NUM := ZERO;
    signal B_Data_i : NUM := ZERO;
    signal C_Data_i : NUM := ZERO;
    signal R_Data_i : NUM := ZERO;
    signal R_Data_aux : NUM := ZERO;
    signal R_Data_out : NUM := ZERO;

    signal A_TVALID_i : STD_LOGIC := '0';
    signal B_TVALID_i : STD_LOGIC := '0';
    signal C_TVALID_i : STD_LOGIC := '0'; 
    signal ACLKEn_i : STD_LOGIC := '0';
    signal AResetn_i : STD_LOGIC := '0';

    
    signal state : std_logic_vector(2 downto 0) := "000";
begin
    R_Data <= R_Data_out;
    R_TValid <= R_TValid_out;
    -- Out signal that fp ops are ready to use
    TReady_aux <=  A_TReady AND B_TReady AND C_TReady;
    TREADY <= TREADY_OUT;
    TREADY_OUT <= '1' WHEN TREADY_EN = '1'
                  ELSE '0';         

MLAX: fp_MLA PORT MAP  (ACLK, ACLKEn_i, AResetn_i, 
               A_TVALID_i, A_TReady, A_Data_i, 
               B_TVALID_i, B_TReady, B_Data_i, 
               C_TVALID_i, C_TReady, C_Data_i, 
               R_TValid_aux, R_TReady, R_Data_i); 
		--sum(i) <= sum(i-1) + A(i)*B(i);




MULP: process(ACLK, TReady_aux)
    VARIABLE i : INTEGER RANGE 0 to N+1 := 0;
    VARIABLE count : integer range 0 to 15 := 0;
begin
    if(rising_edge(ACLK)) then
        if(AResetn = '0') then
            TREADY_EN <= '1';
            ACLKEn_i <= '0';
            AResetn_i <= '0';  
            R_TValid_out <= '0';
            state <= "000"; 
        elsif(AResetn = '1') then
            case state is
                when "000" =>
                    TREADY_EN <= '1';
                    if(ACLKEn = '1') then
                        state <= "001";    
                        A_Data_i <= ZERO;
                        B_Data_i <= ZERO;
                        C_Data_i <= ZERO;
                        R_Data_aux <= ZERO;
                        i := 0;
                    end if;
                when "001" =>
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';                
                    if(TReady_aux = '1' AND A_TVALID = '1' AND B_TVALID = '1' AND i < N) then
                        A_Data_i <= A_Data(i);
                        A_TVALID_i <= '1';
                        B_Data_i <= B_Data(i);
                        B_TVALID_i <= '1';
                        C_Data_i <= R_Data_aux;
                        C_TVALID_i <= '1'; 
                        i := i + 1; 
                        state <= "010";
                    end if;
                when "010" =>
                    if(R_TValid_aux = '1' AND i < N) then
                        state <= "100";
                        R_Data_aux <= R_Data_i;
                        A_TVALID_i <= '0';
                        B_TVALID_i <= '0';
                        C_TVALID_i <= '0'; 
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    elsif(R_TValid_aux = '1' AND i = N) then
                        state <= "011";
                        A_TVALID_i <= '0';
                        B_TVALID_i <= '0';
                        C_TVALID_i <= '0'; 
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "011" =>
                        R_Data_out <= R_Data_i;
                        R_TValid_out <= '1';
--                        state <= "000";
                when "100" =>
                    if(count = 3) then
                        state <= "001";
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                when others =>
                    state <= "000";
            end case;
        end if;
    end if;
end process;

end Vector_dotProduct_Behavioral;
