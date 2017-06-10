----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2016 03:27:30 PM
-- Design Name: 
-- Module Name: Quaternion_Norm - Quaternion_Norm_Behavioral
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

entity Quaternion_Norm is
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;
        
        Q_TVALID : in STD_LOGIC;
        Q_Data : in VECTOR (0 to 3);
        
        QN_TValid : out STD_LOGIC;
        QN_TReady : in STD_LOGIC;
        QN_Data : out NUM
    );
end Quaternion_Norm;

architecture Quaternion_Norm_Behavioral of Quaternion_Norm is

--components
COMPONENT Vector_dotProduct is
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
end COMPONENT;

COMPONENT fp_sqrt
  PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;



SIGNAL SQ : NUM;

SIGNAL SQ_TValid : STD_LOGIC;
SIGNAL SQ_READY : STD_LOGIC;

begin



VdP: Vector_dotProduct port map(ACLK, ACLKEn, AResetn, TREADY, 
                               Q_TVALID, Q_Data, Q_TVALID, Q_Data,
                               SQ_TValid, SQ_READY, SQ);

SRRT: fp_sqrt PORT MAP(ACLK, ACLKEn, AResetn,
                       SQ_TValid, SQ_READY, SQ,
                       QN_TValid, QN_TReady, QN_Data);

end Quaternion_Norm_Behavioral;
