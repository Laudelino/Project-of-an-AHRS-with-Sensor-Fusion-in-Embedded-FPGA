----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2016 12:03:49 PM
-- Design Name: 
-- Module Name: CorrectSingleKF - CorrectSingleKF_Behavioral
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


entity CorrectSingleKF is
   generic (
      NN : INTEGER := 7;
      PP : INTEGER := 6
    );
    port (
      ACLK : in STD_LOGIC;
      ACLKEn : in STD_LOGIC := '0';
      AResetn : in STD_LOGIC  := '1';
      TREADY : out STD_LOGIC;
      
      x_in_TVALID : in STD_LOGIC;
      x_in : in MATRIX(0 to NN-1, 0 to 0);
      
      P_in_TVALID : in STD_LOGIC;
      P_in : in MATRIX(0 to NN-1, 0 to NN-1);
      
      y_TVALID : in STD_LOGIC;
      y : in NUM;
      
      R_TVALID : in STD_LOGIC;
      Sensor_R : in NUM;
      
      Hi_TVALID : in STD_LOGIC;
      Hi : in MATRIX(0 to 0, 0 to NN-1);
      
      Correct_TValid : out STD_LOGIC;
      Correct_TReady : in STD_LOGIC;
      x_out : out MATRIX(0 to NN-1, 0 to 0);
      P_out : out MATRIX(0 to NN-1, 0 to NN-1)
    );
end CorrectSingleKF;

architecture CorrectSingleKF_Behavioral of CorrectSingleKF is

-- COMPONENTS
COMPONENT Matrix_Transpose is
    generic(
		N : integer := 4;
		M : integer := 4
	);
	port(
		A : in MATRIX (0 to N-1,0 to M-1);
		AT : out MATRIX (0 to M-1,0 to N-1)
	);
end COMPONENT;

COMPONENT Matrix_Addition is
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
        
        B_TVALID : in STD_LOGIC;
        B_Data : in MATRIX (0 to N-1,0 to M-1);
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out MATRIX (0 to N-1,0 to M-1)
    );
end COMPONENT;

COMPONENT Matrix_Subtraction is
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
        
        B_TVALID : in STD_LOGIC;
        B_Data : in MATRIX (0 to N-1,0 to M-1);
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out MATRIX (0 to N-1,0 to M-1)
    );
end COMPONENT;


COMPONENT Matrix_Multiplication is
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
end COMPONENT;

COMPONENT Matrix_MultiplicationScalar is
	generic(
        N : integer := NN;
        M : integer := NN
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
    end COMPONENT;

COMPONENT Matrix_DivisionScalar is
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
end COMPONENT;

COMPONENT Vector_ScalarDivision is
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
        
        S_TVALID : in STD_LOGIC;
        S_Data : in NUM;
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out VECTOR (0 to N-1)
    );
end COMPONENT;

COMPONENT Quaternion_Norm is
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
end COMPONENT;

COMPONENT fp_add
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

-- END COMPONENT SECTION

-- CONTROL SIGNALS

SIGNAL PHt_ACLKEn : STD_LOGIC := '0';
SIGNAL PHt_AResetn : STD_LOGIC := '1';
SIGNAL PHt_IN_TREADY, PHt_P_TVALID, PHt_Ht_TVALID, PHt_TValid, PHt_out_TReady : STD_LOGIC;

SIGNAL HPHt_ACLKEn : STD_LOGIC := '0';
SIGNAL HPHt_AResetn : STD_LOGIC := '1';
SIGNAL HPHt_IN_TREADY,HPHt_H_TVALID, HPHt_PHt_TVALID, HPHt_TValid, HPHt_out_TReady : STD_LOGIC;

SIGNAL S_ACLKEn : STD_LOGIC := '0';
SIGNAL S_AResetn : STD_LOGIC := '1';
SIGNAL S_HPHt_TVALID, S_HPHt_TReady, S_R_TVALID, S_R_TReady,S_TValid, S_out_TReady : STD_LOGIC;

SIGNAL K_ACLKEn : STD_LOGIC := '0';
SIGNAL K_AResetn : STD_LOGIC := '1';
SIGNAL K_IN_TREADY, K_PHt_TVALID,K_S_TVALID, K_TValid, K_out_TReady : STD_LOGIC;

SIGNAL KH_ACLKEn : STD_LOGIC := '0';
SIGNAL KH_AResetn : STD_LOGIC := '1';
SIGNAL KH_IN_TREADY, KH_K_TVALID, KH_H_TVALID, KH_TValid, KH_out_TReady : STD_LOGIC;

SIGNAL KHP_ACLKEn : STD_LOGIC := '0';
SIGNAL KHP_AResetn : STD_LOGIC := '1';
SIGNAL KHP_IN_TREADY, KHP_KH_TVALID, KHP_P_TVALID, KHP_TValid, KHP_out_TReady : STD_LOGIC;

SIGNAL P_out_ACLKEn : STD_LOGIC := '0';
SIGNAL P_out_AResetn : STD_LOGIC := '1';
SIGNAL P_out_IN_TREADY, P_out_P_TVALID,P_out_KHP_TVALID, P_out_TValid, P_out_out_TReady : STD_LOGIC;

SIGNAL Ky_ACLKEn : STD_LOGIC := '0';
SIGNAL Ky_AResetn : STD_LOGIC := '1';
SIGNAL Ky_IN_TREADY,  Ky_K_TVALID,Ky_y_TVALID, Ky_TValid, Ky_out_TReady : STD_LOGIC;

SIGNAL x_out_ACLKEn : STD_LOGIC := '0';
SIGNAL x_out_AResetn : STD_LOGIC := '1';
SIGNAL x_out_IN_TREADY, x_out_x_in_TVALID,x_out_Ky_TVALID, x_out_TValid, x_out_out_TReady : STD_LOGIC;

-- END CONTROL SIGNALS SECTION

-- BEGIN INTERNAL SIGNAL DEFINITION
SIGNAL Ht : MATRIX(0 to NN-1, 0 to 0);
SIGNAL PHt : MATRIX(0 to NN-1, 0 to 0);
SIGNAL HPHt : MATRIX(0 to 0, 0 to 0);
SIGNAL S : NUM;
SIGNAL K : MATRIX(0 to NN-1, 0 to 0);
SIGNAL KH : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL KHP : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL Ky : MATRIX(0 to NN-1, 0 to 0);

-- END INTERNAL SIGNAL DEFINITION


    SIGNAL A_TVALID_i, B_TVALID_i, A_TReady, B_TReady, R_TReady, R_TValid_aux : STD_LOGIC := '0';
    SIGNAL ACLKEn_i, AResetn_i, TREADY_EN, CELL_TVALID : STD_LOGIC := '0';
    SIGNAL A_Data_i, B_Data_i, R_Data_i : NUM := ZERO;

begin

-- BEGIN CONTROL SIGNAL ASSIGNMENT
-- Ready
TREADY <= PHt_IN_TREADY;
PHt_out_TReady <= HPHt_IN_TREADY AND K_IN_TREADY;
HPHt_out_TReady <= S_HPHt_TReady AND S_R_TReady;
S_out_TReady <= K_IN_TREADY;
K_out_TReady <= KH_IN_TREADY AND Ky_IN_TREADY;
KH_out_TReady <= KHP_IN_TREADY;
KHP_out_TReady <= P_out_IN_TREADY;
Ky_out_TReady <= x_out_IN_TREADY;
P_out_out_TReady <= Correct_TReady;
x_out_out_TReady <= Correct_TReady;

-- Valid

PHt_P_TVALID <= P_in_TVALID;
PHt_Ht_TVALID <= Hi_TVALID;
HPHt_H_TVALID <= Hi_TVALID;
HPHt_PHt_TVALID <= PHt_TValid;
S_HPHt_TVALID <= HPHt_TValid;
S_R_TVALID <= R_TVALID;
K_PHt_TVALID <= PHt_TValid;
K_S_TVALID <= S_TValid;
KH_K_TVALID <= K_TValid;
KH_H_TVALID <= Hi_TVALID;
KHP_KH_TVALID <= KH_TValid;
KHP_P_TVALID <= P_in_TVALID;
P_out_P_TVALID <= P_in_TVALID;
P_out_KHP_TVALID <= KHP_TValid;
Ky_K_TVALID <= K_TValid;
Ky_y_TVALID <= y_TVALID;
x_out_x_in_TVALID <= x_in_TVALID;
x_out_Ky_TVALID <= Ky_TValid;
Correct_TValid <= x_out_TValid AND P_out_TValid;


PHt_ACLKEn <= ACLKEn;
HPHt_ACLKEn <= ACLKEn;
S_ACLKEn <= ACLKEn;
K_ACLKEn <= ACLKEn;
KH_ACLKEn <= ACLKEn;
KHP_ACLKEn <= ACLKEn;
P_out_ACLKEn <= ACLKEn;
Ky_ACLKEn <= ACLKEn;
x_out_ACLKEn <= ACLKEn;

PHt_AResetn <= AResetn;
HPHt_AResetn <= AResetn;
S_AResetn <= AResetn;
K_AResetn <= AResetn;
KH_AResetn <= AResetn;
KHP_AResetn <= AResetn;
P_out_AResetn <= AResetn;
Ky_AResetn <= AResetn;
x_out_AResetn <= AResetn;
-- END CONTROL SIGNAL ASSIGNMENT

-- EQUATION ASSIGNMENT
--%AX - 1
-- Ht = H(1,:)';
MT: Matrix_Transpose generic map(1,NN) port map (Hi, Ht);

--PHt = P*Ht;
MM1: Matrix_Multiplication generic map (Ar=>NN, N=> NN, Bc=>1)
                           port map (ACLK, PHt_ACLKEn, PHt_AResetn, PHt_IN_TREADY,
                                     PHt_P_TVALID, P_in,
                                     PHt_Ht_TVALID, Ht,        
                                     PHt_TValid, PHt_out_TReady, PHt);

-- HPHt = H*PHt
MM2: Matrix_Multiplication generic map (Ar=>1,N=> NN,Bc=> 1)
                           port map (ACLK, HPHt_ACLKEn, HPHt_AResetn, HPHt_IN_TREADY,
                                     HPHt_H_TVALID, Hi,
                                     HPHt_PHt_TVALID, PHt,        
                                     HPHt_TValid, HPHt_out_TReady, HPHt);
--ACLKEn_i <= ACLKEn;
--AResetn_i <= AResetn;
--HPHt_out_TReady <= A_TReady AND B_TReady;
--R_TReady <= K_IN_TREADY;
--A_TVALID_i <= HPHt_TValid;
--B_TVALID_i <= R_TVALID;
--A_Data_i <= HPHt(0,0);
--B_Data_i <= Sensor_R;
--S = HPHt + R;
ADD: fp_add PORT MAP ( ACLK, S_ACLKEn, S_AResetn, 
                       S_HPHt_TVALID, S_HPHt_TReady, HPHt(0,0), 
                       S_R_TVALID, S_R_TReady, Sensor_R, 
                       S_TValid, S_out_TReady, S);

--K = PHt/S;
MDS: Matrix_DivisionScalar generic map (NN, 1)
                            port map (ACLK, K_ACLKEn, K_AResetn, K_IN_TREADY,
                                      K_PHt_TVALID, PHt,         
                                      K_S_TVALID, S,        
                                      K_TValid, K_out_TReady, K);

-- KH = K*H(1,:)
MM3: Matrix_Multiplication generic map (Ar=>NN, N=>1, Bc=>NN)
                           port map (ACLK, KH_ACLKEn, KH_AResetn, KH_IN_TREADY,
                                     KH_K_TVALID, K,
                                     KH_H_TVALID, Hi,        
                                     KH_TValid, KH_out_TReady, KH);
-- KHP = KH*P
MM4: Matrix_Multiplication generic map (NN, NN, NN)
                           port map (ACLK, KHP_ACLKEn, KHP_AResetn, KHP_IN_TREADY,
                                     KHP_KH_TVALID, KH,
                                     KHP_P_TVALID, P_in,        
                                     KHP_TValid, KHP_out_TReady, KHP);

-- P = P - KHP;
MS1: Matrix_Subtraction generic map (NN, NN)
                port map (ACLK, P_out_ACLKEn, P_out_AResetn, P_out_IN_TREADY,
                          P_out_P_TVALID, P_in,
                          P_out_KHP_TVALID, KHP,
                          P_out_TValid, P_out_out_TReady, P_out);

-- Ky = K*y(1);
MMS: Matrix_MultiplicationScalar generic map (NN, 1)
                            port map (ACLK, Ky_ACLKEn, Ky_AResetn, Ky_IN_TREADY,
                                      Ky_K_TVALID, K,         
                                      Ky_y_TVALID, y,        
                                      Ky_TValid, Ky_out_TReady, Ky);
-- x = x + Ky;
MA: Matrix_Addition generic map (NN, 1)
                port map(ACLK, x_out_ACLKEn, x_out_AResetn, x_out_IN_TREADY,
                         x_out_x_in_TVALID, x_in,
                         x_out_Ky_TVALID, Ky,        
                         x_out_TValid, x_out_out_TReady, x_out);

-- END EQUATION ASSIGNMENT
end CorrectSingleKF_Behavioral;
