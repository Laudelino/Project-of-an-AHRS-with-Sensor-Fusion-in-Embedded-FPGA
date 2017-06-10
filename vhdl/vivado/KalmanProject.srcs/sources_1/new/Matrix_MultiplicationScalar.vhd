----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 09:26:55 PM
-- Design Name: 
-- Module Name: Matrix_MultiplicationScalar - Matrix_MultiplicationScalar_Behavioral
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


entity Matrix_MultiplicationScalar is
	generic(
        N : integer := 4;
        M : integer := 4
    );
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;
        
        A_TVALID : in STD_LOGIC;
        A_Data : in MATRIX (0 to N-1,0 to M-1);
        
        S_TVALID : in STD_LOGIC;
        S_Data : in NUM;
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out MATRIX (0 to N-1,0 to M-1)
    );
end Matrix_MultiplicationScalar;

architecture Matrix_MultiplicationScalar_Behavioral of Matrix_MultiplicationScalar is


-- components
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
 
-- Signals    
    SIGNAL A_TVALID_i, B_TVALID_i, A_TReady, B_TReady, R_TValid_aux : STD_LOGIC := '0';
    SIGNAL ACLKEn_i, AResetn_i, TREADY_EN : STD_LOGIC := '0';
    SIGNAL A_Data_i, R_Data_i : NUM := ZERO;
    SIGNAL R_Data_aux : MATRIX (0 to N-1,0 to M-1) := (others => (others => ZERO));

    SIGNAL state : STD_LOGIC_VECTOR(2 downto 0) := "000"; 

begin

-- Unify all TReady for each input of multiplication used in the matrix multiplication
TREADY <= '1' WHEN TREADY_EN = '1'
          ELSE '0'; 

R_Data <= R_Data_aux;
    
MX: fp_mul PORT MAP (ACLK, ACLKEn_i, AResetn_i, 
                       A_TVALID_i, A_TReady, A_Data_i, 
                       B_TVALID_i, B_TReady, S_Data, 
                       R_TValid_aux, R_TReady, R_Data_i);

--Each row has it's on adder. It starts by adding the first column, when it is done, starts the second
MMSP: process(ACLK)
    VARIABLE i : INTEGER RANGE 0 to N+1 := 0;
    VARIABLE j : INTEGER RANGE 0 to M+1 := 0;
    VARIABLE count : integer range 0 to 15 := 0;
begin
    if(rising_edge(ACLK)) then
        if(AResetn = '0' OR ACLKEn = '0') then
            TREADY_EN <= '0';
            ACLKEn_i <= '0';
            AResetn_i <= '0';  
            R_TValid <= '0';
            A_TValid_i <= '0';
            B_TValid_i <= '0';
            i := 0;
            j := 0;
            state <= "000"; 
        elsif(AResetn = '1' AND ACLKEn = '1') then
            case state is
                when "000" =>
                    TREADY_EN <= '1';
                    state <= "001";  
                    A_TValid_i <= '0';
                    B_TValid_i <= '0';  
                    A_Data_i <= ZERO;
                    i := 0;
                    j := 0;
                when "001" =>
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';              
                    if(A_TReady = '1' AND B_TReady = '1' AND A_TVALID = '1' AND S_TVALID = '1' AND j < M AND i < N) then
                        A_Data_i <= A_Data(i, j);
                        A_TVALID_i <= '1';
                        B_TVALID_i <= '1';
                        j := j + 1; 
                        state <= "010";
                    elsif (i = N) then
                            state <= "011";                        
                    end if;
                when "010" =>
                    if(R_TValid_aux = '1') then
                        if(i < N) then 
                            state <= "100";
                        else
                            state <= "011";
                        end if; 

                        R_Data_aux(i, j-1) <= R_Data_i;
                        
                        A_TVALID_i <= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "011" =>
                        R_TValid <= '1';
                when "100" =>
                    if(count > 10) then
                        state <= "001";
						if(j = M) then 
                            i := i + 1;
                            j := 0;
                        end if; 
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
    


end Matrix_MultiplicationScalar_Behavioral;
