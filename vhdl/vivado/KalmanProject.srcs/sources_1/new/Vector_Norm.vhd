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

entity Vector_Norm is
	generic(
        N : integer := 4
    );
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '1';
        TREADY : out STD_LOGIC;
        
        V_TVALID : in STD_LOGIC;
        V_Data : in VECTOR (0 to N-1);
        
        VN_TValid : out STD_LOGIC;
        VN_TReady : in STD_LOGIC;
        VN_Data : out NUM
    );
end Vector_Norm;

architecture Vector_Norm_Behavioral of Vector_Norm is

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



SIGNAL SV : NUM;
SIGNAL SSV : VECTOR(0 TO N-1);

SIGNAL SV_TValid : STD_LOGIC;
SIGNAL SV_READY : STD_LOGIC;

begin



VdP: Vector_dotProduct generic map(N) port map(ACLK, ACLKEn, AResetn, TREADY, 
                               V_TVALID, V_Data, V_TVALID, V_Data,
                               SV_TValid, SV_READY, SV);

SRRT: fp_sqrt PORT MAP(ACLK, ACLKEn, AResetn,
                       SV_TValid, SV_READY, SV,
                       VN_TValid, VN_TReady, VN_Data);

end Vector_Norm_Behavioral;
