----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2016 02:35:58 PM
-- Design Name: 
-- Module Name: Matrix_Multiplication - Matrix_Multiplication_Behavioral
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

entity Matrix_Multiplication is
	generic(
		Ar : integer := 4;
        Bc : integer := 4;
        N : integer := 4
        );
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;
    
        A_TVALID : in STD_LOGIC;
        A_Data : in MATRIX (0 to Ar-1,0 to N-1);
        
        B_TVALID : in STD_LOGIC;
        B_Data : in MATRIX (0 to N-1,0 to Bc-1);
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out MATRIX (0 to Ar-1, 0 to Bc-1)
    );
end Matrix_Multiplication;

architecture Matrix_Multiplication_Behavioral of Matrix_Multiplication is

--components
    COMPONENT Vector_dotProduct is
    generic(
		N : integer := N
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
    end COMPONENT;

-- Signals  
    SIGNAL A_TVALID_i, B_TVALID_i, OP_TReady, R_TValid_aux : STD_LOGIC := '0';
    SIGNAL ACLKEn_i, AResetn_i, TREADY_EN : STD_LOGIC := '0';
    SIGNAL A_Vector_i, B_Vector_j : VECTOR (0 to N-1) :=  (others => ZERO);
    SIGNAL R_Data_i : NUM :=  ZERO;
    SIGNAL R_Data_aux : MATRIX (0 to Ar-1,0 to Bc-1) := (others => (others => ZERO));

    SIGNAL state : STD_LOGIC_VECTOR(2 downto 0) := "000";  

begin

-- Unify all TReady for each input of multiplication used in the matrix multiplication
TREADY <= '1' WHEN TREADY_EN = '1'
          ELSE '0'; 

R_Data <= R_Data_aux;

VMX: Vector_dotProduct port map(ACLK, ACLKEn_i, AResetn_i, OP_TReady, 
                                A_TValid_i, A_Vector_i, 
                                B_TValid_i, B_Vector_j, 
                                R_TValid_aux, R_TReady, R_Data_i);

MMP: process(ACLK)
    VARIABLE i : INTEGER RANGE 0 to Ar+1 := 0;
    VARIABLE j : INTEGER RANGE 0 to Bc+1 := 0;
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
            state <= "000"; 
        elsif(AResetn = '1' AND ACLKEn = '1') then
            case state is
                when "000" =>
                    TREADY_EN <= '1';
                    state <= "001";  
                    A_TValid_i <= '0';
                    B_TValid_i <= '0';
                    i := 0;						
                    j := 0;
                when "001" =>
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';                
                    if(OP_TReady = '1' AND A_TVALID = '1' AND B_TVALID = '1' AND j < Bc AND i < Ar) then
                        A_Vector_i <= matrix2vector(A_Data,i,'1');
						B_Vector_j <= matrix2vector(B_Data,j,'0');
                        A_TVALID_i <= '1';
                        B_TVALID_i <= '1';
                        j := j + 1; 
                        state <= "010";
                    elsif ( i = Ar) then
                        state <= "011";                        
                    end if;
                when "010" =>
                    if(R_TValid_aux = '1') then
                        if(i < Ar) then 
                            state <= "100";
                        else
                            state <= "011";
                        end if; 

                        R_Data_aux(i, j-1) <= R_Data_i;
                        A_TVALID_i<= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "011" =>
                        R_TValid <= '1';
                when "100" =>
                    if(count > 10) then
                        state <= "001";
						if(j = Bc) then 
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
    
    

end Matrix_Multiplication_Behavioral;
