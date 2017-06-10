----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2016 08:59:35 PM
-- Design Name: 
-- Module Name: Quaternion_Multiplication - Quaternion_Multiplication_Behavioral
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

entity Quaternion_Multiplication is
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;
        
        Q_TVALID : in STD_LOGIC;
        Q_Data : in VECTOR (0 to 3);
        
        P_TVALID : in STD_LOGIC;
        P_Data : in VECTOR (0 to 3);
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out VECTOR (0 to 3)
    );
end Quaternion_Multiplication;

architecture Quaternion_Multiplication_Behavioral of Quaternion_Multiplication is

   --Components
    COMPONENT Vector_dotProduct 
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
    END COMPONENT;

    SIGNAL OP_TValid : STD_LOGIC_VECTOR(0 to 3);
    
    SIGNAL Pq1, Pq2, Pq3, Pq4 : VECTOR (0 TO 3);
    SIGNAL P1, P2, P3, P4 : NUM;
    
    SIGNAL A_TVALID_i, B_TVALID_i, OP_TReady, R_TValid_aux : STD_LOGIC := '0';
    SIGNAL ACLKEn_i, AResetn_i, TREADY_EN : STD_LOGIC := '0';
    SIGNAL A_Vector_i, B_Vector_i : VECTOR (0 to 3) :=  (others => ZERO);
    SIGNAL R_Data_i : NUM :=  ZERO;
    SIGNAL R_Data_aux : VECTOR (0 to 3) := (others => ZERO);

    SIGNAL state : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
    
begin

P1 <= P_Data(0);
P2 <= P_Data(1);
P3 <= P_Data(2);
P4 <= P_Data(3);

--(q1,q2,q3,q4)(p4,-p3,p2,p1)
--(q1,q2,q3,q4)(p3,p4,-p1,p2)
--(q1,q2,q3,q4)(-p2,p1,p4,p3)
--(q1,q2,q3,q4)(-p1,-p2,-p3,p4)

Pq1(0) <= P4;
Pq1(1) <= NOT P3(NUM_SIZE-1) & P3(NUM_SIZE-2 DOWNTO 0); 
Pq1(2) <= P2;
Pq1(3) <= P1;

Pq2(0) <= P3;
Pq2(1) <= P4; 
Pq2(2) <= NOT P1(NUM_SIZE-1) & P1(NUM_SIZE-2 DOWNTO 0);
Pq2(3) <= P2;

Pq3(0) <= NOT P2(NUM_SIZE-1) & P2(NUM_SIZE-2 DOWNTO 0);
Pq3(1) <= P1;
Pq3(2) <= P4;
Pq3(3) <= P3;

Pq4(0) <= NOT P1(NUM_SIZE-1) & P1(NUM_SIZE-2 DOWNTO 0);
Pq4(1) <= NOT P2(NUM_SIZE-1) & P2(NUM_SIZE-2 DOWNTO 0); 
Pq4(2) <= NOT P3(NUM_SIZE-1) & P3(NUM_SIZE-2 DOWNTO 0);
Pq4(3) <= P4;


--TREADY <= OP_TReady(3) AND OP_TReady(2) AND OP_TReady(1) AND OP_TReady(0);

--R1CALC: Vector_dotProduct port map(ACLK, ACLKEn, AResetn, OP_TReady(0), 
--                                Q_TVALID, Q_Data, P_TVALID, Pq1, 
--                                OP_TValid(0), R_TReady, R_Data(0));

--R2CALC: Vector_dotProduct port map(ACLK, ACLKEn, AResetn, OP_TReady(1), 
--                                Q_TVALID, Q_Data, P_TVALID, Pq2, 
--                                OP_TValid(1), R_TReady, R_Data(1));

--R3CALC: Vector_dotProduct port map(ACLK, ACLKEn, AResetn, OP_TReady(2), 
--                                Q_TVALID, Q_Data, P_TVALID, Pq3, 
--                                OP_TValid(2), R_TReady, R_Data(2));

--R4CALC: Vector_dotProduct port map(ACLK, ACLKEn, AResetn, OP_TReady(3), 
--                                Q_TVALID, Q_Data, P_TVALID, Pq4, 
--                                OP_TValid(3), R_TReady, R_Data(3));

--R_TValid <= OP_TValid(3) AND OP_TValid(2) AND OP_TValid(1) AND OP_TValid(0);

VMX: Vector_dotProduct port map(ACLK, ACLKEn_i, AResetn_i, OP_TReady, 
                                A_TValid_i, A_Vector_i, 
                                B_TValid_i, B_Vector_i, 
                                R_TValid_aux, R_TReady, R_Data_i);

TREADY <= '1' WHEN TREADY_EN = '1'
              ELSE '0';
               
R_Data <= R_Data_aux;

QMP: process(ACLK)
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
            state <= "0000"; 
        elsif(AResetn = '1' AND ACLKEn = '1') then
            case state is
                when "0000" =>
                    TREADY_EN <= '1';
                    state <= "0001";  
                    A_TValid_i <= '0';
                    B_TValid_i <= '0';			
                when "0001" =>
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';                
                    if(OP_TReady = '1' AND Q_TVALID = '1' AND P_TVALID = '1') then
                        A_Vector_i <= Q_Data;
						B_Vector_i <= Pq1;
                        A_TVALID_i <= '1';
                        B_TVALID_i <= '1';
                        state <= "0010";                      
                    end if;
                when "0010" =>
                    if(R_TValid_aux = '1') then
                        state <= "0011";
                        R_Data_aux(0) <= R_Data_i;
                        A_TVALID_i<= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "0011" =>
                    if(count > 10) then
                        state <= "0100";
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                when "0100" =>  
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';                
                    if(OP_TReady = '1' AND Q_TVALID = '1' AND P_TVALID = '1') then
                        A_Vector_i <= Q_Data;
                        B_Vector_i <= Pq2;
                        A_TVALID_i <= '1';
                        B_TVALID_i <= '1';
                        state <= "0101";                      
                    end if;
                when "0101" =>
                    if(R_TValid_aux = '1') then
                        state <= "0110";
                        R_Data_aux(1) <= R_Data_i;
                        A_TVALID_i<= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "0110" =>
                    if(count > 10) then
                        state <= "0111";
                        count := 0;
                    else
                        count := count + 1;
                    end if;  
                when "0111" =>                    
                    ACLKEn_i <= '1';
                    AResetn_i <= '1';                
                    if(OP_TReady = '1' AND Q_TVALID = '1' AND P_TVALID = '1') then
                        A_Vector_i <= Q_Data;
                        B_Vector_i <= Pq3;
                        A_TVALID_i <= '1';
                        B_TVALID_i <= '1';
                        state <= "1000";                      
                    end if;
                when "1000" =>
                    if(R_TValid_aux = '1') then
                        state <= "1001";
                        R_Data_aux(2) <= R_Data_i;
                        A_TVALID_i<= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "1001" =>
                    if(count > 10) then
                        state <= "1010";
                        count := 0;
                    else
                        count := count + 1;
                    end if; 
                when "1010" =>                    
                        ACLKEn_i <= '1';
                        AResetn_i <= '1';                
                        if(OP_TReady = '1' AND Q_TVALID = '1' AND P_TVALID = '1') then
                            A_Vector_i <= Q_Data;
                            B_Vector_i <= Pq4;
                            A_TVALID_i <= '1';
                            B_TVALID_i <= '1';
                            state <= "1011";                      
                        end if;
                when "1011" =>
                    if(R_TValid_aux = '1') then
                        state <= "1100";
                        R_Data_aux(3) <= R_Data_i;
                        A_TVALID_i<= '0';
                        B_TVALID_i <= '0';
                        ACLKEn_i <= '0';
                        AResetn_i <= '0';
                    end if;                    
                when "1100" =>
                    if(count > 10) then
                        state <= "1101";
                        count := 0;
                    else
                        count := count + 1;
                    end if;                                        
                when "1101" =>
                    R_TValid <= '1';
                when others =>
                    state <= "0000";
            end case;
        end if;
    end if;
end process;

end Quaternion_Multiplication_Behavioral;
