----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/31/2016 02:47:11 PM
-- Design Name: 
-- Module Name: PredictKF - PredictKF_Behavioral
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

entity PredictKF is
    generic (
        NN : INTEGER := 7;
        PP : INTEGER := 6
    );
    port (
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '0';
        TREADY : out STD_LOGIC;
        
        x_TVALID : in STD_LOGIC;
        x : in MATRIX(0 to NN-1, 0 to 0);
        
        P_TVALID : in STD_LOGIC;
        P : in MATRIX(0 to NN-1, 0 to NN-1);
        
        Gyro_TVALID : in STD_LOGIC;
        Gyroscope : in MATRIX(0 to 2, 0 to 0);
        
        Predict_TValid : out STD_LOGIC;
        Predict_TReady : in STD_LOGIC;
        xhat : out MATRIX(0 to NN-1, 0 to 0);
        Phat : out MATRIX(0 to NN-1, 0 to NN-1)
    );
end PredictKF;

architecture PredictKF_Behavioral of PredictKF is

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

-- END COMPONENT SECTION

-- CONTROL SIGNALS

SIGNAL What_ACLKEn : STD_LOGIC := '0';
SIGNAL What_AResetn : STD_LOGIC := '0';
SIGNAL What_IN_TREADY,What_Gyro_TVALID,What_dw_TVALID,What_TValid,What_out_TReady : STD_LOGIC;

SIGNAL F_ACLKEn : STD_LOGIC := '0';
SIGNAL F_AResetn : STD_LOGIC := '0';
SIGNAL F_IN_TREADY, F_out_TReady : STD_LOGIC;
SIGNAL F_TValid : STD_LOGIC := '0';
SIGNAL F_W_TVALID, F_S_TVALID : STD_LOGIC;


SIGNAL FP_ACLKEn : STD_LOGIC := '0';
SIGNAL FP_AResetn : STD_LOGIC := '0';
SIGNAL FP_IN_TReady, FP_F_TVALID, FP_P_TVALID, FP_out_TReady : STD_LOGIC;
SIGNAL FP_TValid : STD_LOGIC := '0';

SIGNAL FPFt_ACLKEn : STD_LOGIC := '0';
SIGNAL FPFt_AResetn : STD_LOGIC := '0';
SIGNAL FPFt_IN_TREADY, FPFt_FP_TVALID, FPFt_Ft_TVALID, FPFt_out_TReady : STD_LOGIC;
SIGNAL FPFt_TValid : STD_LOGIC := '0';

SIGNAL Phat_ACLKEn : STD_LOGIC := '0';
SIGNAL Phat_AResetn : STD_LOGIC := '0';
SIGNAL Phat_IN_TREADY, Phat_FPFt_TVALID, Phat_Q_TVALID, Phat_out_TReady : STD_LOGIC;
SIGNAL Phat_TValid : STD_LOGIC := '0';

SIGNAL xnonnorm_ACLKEn : STD_LOGIC := '0';
SIGNAL xnonnorm_AResetn : STD_LOGIC := '0';
SIGNAL xnonnorm_IN_TREADY, xnonnorm_F_TVALID, xnonnorm_x_TVALID, xnonnorm_TValid, xnonnorm_out_TReady  : STD_LOGIC;

SIGNAL normq_ACLKEn : STD_LOGIC := '0';
SIGNAL normq_AResetn : STD_LOGIC := '0';
SIGNAL normq_IN_TREADY, normq_Q_TVALID, normq_QN_TValid, normq_out_TReady : STD_LOGIC;

SIGNAL qn_ACLKEn : STD_LOGIC := '0';
SIGNAL qn_AResetn : STD_LOGIC := '0';
SIGNAL qn_IN_TREADY, qn_A_TVALID, qn_S_TVALID, qn_TValid, qn_out_TReady : STD_LOGIC;

SIGNAL MM_NxN_ACLKEn : STD_LOGIC := '0';
SIGNAL MM_NxN_AResetn : STD_LOGIC := '0';
SIGNAL MM_NxN_IN_TREADY, MM_NxN_A_TVALID, MM_NxN_B_TVALID, MM_NxN_TValid, MM_NxN_out_TReady : STD_LOGIC;


-- END CONTROL SIGNALS SECTION

-- BEGIN INTERNAL SIGNAL DEFINITION

--SIGNAL x : MATRIX(0 to NN-1, 0 to 0) := (3 =>(ONE, others => ZERO), 
--                                         others => (others => ZERO));

SIGNAL xnonnorm : MATRIX(0 to NN-1, 0 to 0);

--SIGNAL P : MATRIX(0 to NN-1, 0 to NN-1) := (0 => (0 => ONE, others => ZERO),
--                                            1 => (1 => ONE, others => ZERO),
--                                            2 => (2 => ONE, others => ZERO),
--                                            3 => (3 => ONE, others => ZERO),
--                                            4 => (4 => ONE, others => ZERO),
--                                            5 => (5 => ONE, others => ZERO),
--                                            6 => (6 => ONE, others => ZERO));
                                            
SIGNAL Q : MATRIX(0 to NN-1, 0 to NN-1) := (0 => (0 => "00110010001010111100110001110111", others => ZERO),
                                            1 => (1 => "00110010001010111100110001110111", others => ZERO),
                                            2 => (2 => "00110010001010111100110001110111", others => ZERO),
                                            3 => (3 => "00110010001010111100110001110111", others => ZERO),
                                            4 => (4 => "00110010001010111100110001110111", others => ZERO),
                                            5 => (5 => "00110010001010111100110001110111", others => ZERO),
                                            6 => (6 => "00110010001010111100110001110111", others => ZERO));
                                            
SIGNAL F : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));

--SIGNAL quat : MATRIX(0 to 4-1, 0 to 0);
--SIGNAL nQuat : VECTOR(0 to 4-1);

SIGNAL quatNonNorm : VECTOR(0 to 4-1);
SIGNAL quatNorm : VECTOR(0 to 4-1);
SIGNAL normQuat : NUM := ONE;
SIGNAL normQuatNZ : NUM := ONE;

--SIGNAL Gyroscope : MATRIX(0 to 3-1, 0 to 0);
SIGNAL dw : MATRIX(0 to 3-1, 0 to 0);
SIGNAL What : MATRIX(0 to 3-1, 0 to 0) := (others => (others => ZERO));
SIGNAL nWhat : MATRIX(0 to 3-1, 0 to 0) := (others => (others => ZERO));
--SIGNAL W : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL Warray : MATRIX(0 to NN-1, 0 to 0) := (others => (others => ZERO));
SIGNAL WarrayXhalfdT : MATRIX(0 to NN-1, 0 to 0) := (others => (others => ZERO));
SIGNAL nWarrayXhalfdT : MATRIX(0 to NN-1, 0 to 0) := (others => (others => ZERO));

SIGNAL Ft : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL FP : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL FPFt : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
--SIGNAL qNorm : NUM := ONE;

--SIGNAL zero : NUM := ZERO;
SIGNAL half_dT : NUM := "00111011101000111101011100001010";
-- END INTERNAL SIGNAL DEFINITION

SIGNAL MM_NxN_A : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL MM_NxN_B : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL MM_NxN : MATRIX(0 to NN-1, 0 to NN-1) := (others => (others => ZERO));

signal state_MM_NxN : std_logic_vector(2 downto 0) := "000";

begin

-- BEGIN CONTROL SIGNAL ASSIGNMENT
-- Ready
TREADY <= What_IN_TREADY AND xnonnorm_IN_TREADY;

What_out_TReady <= F_IN_TREADY;

F_out_TReady <= FP_IN_TREADY;
FP_out_TReady <= FPFt_IN_TREADY;
FPFt_out_TReady <= Phat_IN_TREADY;

xnonnorm_out_TReady <= normq_IN_TREADY;
normq_out_TReady <= qn_IN_TREADY;

Phat_out_TReady <= Predict_TReady;
qn_out_TReady <= Predict_TReady;

MM_NxN_out_TReady <= '1';
-- Valid
What_Gyro_TVALID <= Gyro_TVALID;
What_dw_TVALID <= x_TVALID;

F_W_TVALID <= What_TValid;
F_S_TVALID <= '1';

FP_F_TVALID <= F_TValid;
FP_P_TVALID <= P_TVALID;

FPFt_FP_TVALID <= FP_TValid;
FPFt_Ft_TVALID <= '1';

Phat_FPFt_TVALID <= FPFt_TValid;
Phat_Q_TVALID <= '1';

xnonnorm_F_TVALID <= F_TValid;
xnonnorm_x_TVALID <= x_TVALID;

normq_Q_TVALID <= xnonnorm_TValid;

qn_A_TVALID <=  xnonnorm_TValid;
qn_S_TVALID <= normq_QN_TValid;

Predict_TValid <= Phat_TValid AND qn_TValid;

-- END CONTROL SIGNAL ASSIGNMENT

-- EQUATION ASSIGNMENT


--dw = x(5:7)
dw(0,0) <= x(4,0);
dw(1,0) <= x(5,0);
dw(2,0) <= x(6,0);

xhat(4,0) <= dw(0,0);
xhat(5,0) <= dw(1,0);
xhat(6,0) <= dw(2,0);



--What = Gyroscope - dw;
MS: Matrix_Subtraction generic map (3,1)
                   port map (ACLK, What_ACLKEn, What_AResetn, What_IN_TREADY,
                             What_Gyro_TVALID, Gyroscope,
                             What_dw_TVALID, dw, 
                             What_TValid, What_out_TReady, What);

Warray(0,0) <= x(0,0);
Warray(1,0) <= x(1,0);
Warray(2,0) <= x(2,0);
Warray(3,0) <= x(3,0);
Warray(4,0) <= What(0,0);
Warray(5,0) <= What(1,0);
Warray(6,0) <= What(2,0);

--F = 0.5dT*W;
MMS: Matrix_MultiplicationScalar generic map (NN, 1)
                            port map (ACLK, F_ACLKEn, F_AResetn, F_IN_TREADY,
                                      F_W_TVALID, Warray,         
                                      F_S_TVALID, half_dT,        
                                      F_TValid, F_out_TReady, WarrayXhalfdT);

nWarrayXhalfdT(0,0) <= invert(WarrayXhalfdT(0,0));
nWarrayXhalfdT(1,0) <= invert(WarrayXhalfdT(1,0));
nWarrayXhalfdT(2,0) <= invert(WarrayXhalfdT(2,0));
nWarrayXhalfdT(3,0) <= invert(WarrayXhalfdT(3,0));
nWarrayXhalfdT(4,0) <= invert(WarrayXhalfdT(4,0));
nWarrayXhalfdT(5,0) <= invert(WarrayXhalfdT(5,0));
nWarrayXhalfdT(6,0) <= invert(WarrayXhalfdT(6,0));

--W = [0,        What(3), -What(2), What(1), -q(4),  q(3), -q(2);...
--    -What(3),  0,        What(1), What(2), -q(3), -q(4),  q(1);...
--     What(2), -What(1),  0,       What(3),  q(2), -q(1), -q(4);...
--    -What(1), -What(2), -What(3), 0,       -q(1), -q(2), -q(3);...
--     0,        0,        0,       0,        0,     0,     0;...
--     0,        0,        0,       0,        0,     0      0;...
--     0,        0,        0,       0,        0,     0,     0];
--W <= (0 => (ZERO,        What(2,0), nWhat(1,0), What(0,0), nQuat(3),  quat(2), nQuat(1)),
--      1 => (nWhat(2,0),  ZERO,       What(0,0), What(1,0), nQuat(2), nQuat(3),  quat(0)),
--      2 => ( What(1,0), nWhat(0,0),  ZERO,      What(2,0),  quat(1), nQuat(0), nQuat(3)),
--      3 => (nWhat(0,0), nWhat(1,0), nWhat(2,0), ZERO,      nQuat(0), nQuat(1), nQuat(2)),
--      others => (others => ZERO));

F <= (0 => ( ONE,                 WarrayXhalfdT(6,0), nWarrayXhalfdT(5,0), WarrayXhalfdT(4,0), nWarrayXhalfdT(3,0),  WarrayXhalfdT(2,0), nWarrayXhalfdT(1,0)),
      1 => (nWarrayXhalfdT(6,0),  ONE,                 WarrayXhalfdT(4,0), WarrayXhalfdT(5,0), nWarrayXhalfdT(2,0), nWarrayXhalfdT(3,0),  WarrayXhalfdT(0,0)),
      2 => ( WarrayXhalfdT(5,0), nWarrayXhalfdT(4,0),  ONE,                WarrayXhalfdT(6,0),  WarrayXhalfdT(1,0), nWarrayXhalfdT(0,0), nWarrayXhalfdT(3,0)),
      3 => (nWarrayXhalfdT(4,0), nWarrayXhalfdT(5,0), nWarrayXhalfdT(6,0), ONE,                nWarrayXhalfdT(0,0), nWarrayXhalfdT(1,0), nWarrayXhalfdT(2,0)),
	  4 => (4 => ONE, others => ZERO),
	  5 => (5 => ONE, others => ZERO),
	  6 => (6 => ONE, others => ZERO));      
--F1 = 0.5*W;
--MMS: Matrix_MultiplicationScalar generic map (NN, NN)
--                            port map (ACLK, F1_ACLKEn, F1_AResetn, F1_IN_TREADY,
--                                      F_W_TVALID, W,         
--                                      F_S_TVALID, half_dT,        
--                                      F1_TValid, F1_out_TReady, F1);

------F = F1+F2;%0.5*W+diag(ones(7,1));
--MA: Matrix_Addition generic map (NN, NN)
--                port map(ACLK, F_ACLKEn, F_AResetn, F_IN_TREADY,
--                         F_F1_TVALID, F1,
--                         F_F2_TVALID, F2,        
--                         F_TValid, F_out_TReady, F);


--Ft= F';
MT: Matrix_Transpose generic map(NN,NN) port map (F, Ft);

----FP = F*P;
--MM1: Matrix_Multiplication generic map (NN, NN, NN)
--                           port map (ACLK, FP_ACLKEn, FP_AResetn, FP_IN_TREADY,
--                                     FP_F_TVALID, F,
--                                     FP_P_TVALID, P,        
--                                     FP_TValid, FP_out_TReady, FP);
              



----FPFt = FP*Ft;
--MM2: Matrix_Multiplication generic map (NN,NN,NN)
--                                   port map (ACLK, FPFt_ACLKEn, FPFt_AResetn, FPFt_IN_TREADY,
--                                             FPFt_FP_TVALID, FP,
--                                             FPFt_Ft_TVALID, Ft,        
--                                             FPFt_TValid, FPFt_out_TReady, FPFt);
-----------------------------------------------------------------------------------------------
MM12: Matrix_Multiplication generic map (NN, NN, NN)
                           port map (ACLK, MM_NxN_ACLKEn, MM_NxN_AResetn, MM_NxN_IN_TREADY,
                                     MM_NxN_A_TVALID, MM_NxN_A,
                                     MM_NxN_B_TVALID, MM_NxN_B,        
                                     MM_NxN_TValid, MM_NxN_out_TReady, MM_NxN);

P_MM_NxN: process(ACLK)
    VARIABLE count : INTEGER RANGE 0 to 15 := 0;
begin
 if(rising_edge(ACLK)) then
     if(AResetn = '0') then
         MM_NxN_AResetn <= '0';
         MM_NxN_A_TVALID <= '0';
         MM_NxN_B_TVALID <= '0';  
         
         FP_TValid <= '0';
         FPFt_TValid <= '0';
         FP_IN_TREADY <= '0';
         FPFt_IN_TREADY <= '0';    
         
         state_MM_NxN <= "000"; 
         count := 0;
     elsif(AResetn = '1') then
         case state_MM_NxN is
             when "000" =>
                 if(ACLKEn = '1') then
                     state_MM_NxN <= "001";    
                 end if;
             when "001" =>
                 MM_NxN_ACLKEn <= '1';
                 MM_NxN_AResetn <= '1';    
                 FP_IN_TREADY <= MM_NxN_IN_TREADY;       
                 if(MM_NxN_IN_TREADY = '1' AND FP_F_TVALID = '1' AND FP_P_TVALID = '1' AND FP_TValid /= '1' AND FPFt_TValid /= '1') then
                     MM_NxN_A <= F;
                     MM_NxN_A_TVALID <= '1';
                     MM_NxN_B <= P;
                     MM_NxN_B_TVALID <= '1';
                     state_MM_NxN <= "010";
                 end if;
             when "010" =>
                 if(MM_NxN_TValid = '1') then
                     FP <= MM_NxN;
                     FP_TValid <= '1';
                     MM_NxN_A_TVALID <= '0';
                     MM_NxN_B_TVALID <= '0';
                     MM_NxN_ACLKEn <= '0';
                     MM_NxN_AResetn <= '0';
                     state_MM_NxN <= "011";
                 end if;                    
             when "011" =>
                 if(count = 3) then
                     count := 0;
                     state_MM_NxN <= "100";
                 else
                     count := count + 1;
                 end if;
             when "100" =>
                 MM_NxN_ACLKEn <= '1';
                 MM_NxN_AResetn <= '1';   
                 FPFt_IN_TREADY <= MM_NxN_IN_TREADY;       
                 if(MM_NxN_IN_TREADY = '1' AND FPFt_Ft_TVALID = '1') then
                     MM_NxN_A <= FP;
                     MM_NxN_A_TVALID <= '1';
                     MM_NxN_B <= Ft;
                     MM_NxN_B_TVALID <= '1';
                     state_MM_NxN <= "110";
                 end if;
             when "110" =>
                 if(MM_NxN_TValid = '1') then
                     FPFt <= MM_NxN;
                     FPFt_TValid <= '1';
                     MM_NxN_A_TVALID <= '0';
                     MM_NxN_B_TVALID <= '0';
                     MM_NxN_ACLKEn <= '0';
                     MM_NxN_AResetn <= '0';
                     state_MM_NxN <= "111";
                 end if;                    
             when "111" =>
                 if(count = 3) then
                     count := 0;
                     state_MM_NxN <= "000";
                 else
                     count := count + 1;
                 end if;
             when others =>
                 state_MM_NxN <= "000";
         end case;
     end if;
 end if;
end process;
-----------------------------------------------------------------------------------------------


              
----P = FPFt+Q;%F*P*F'+Q;
MA2: Matrix_Addition generic map (NN, NN)
                port map (ACLK, Phat_ACLKEn, Phat_AResetn, Phat_IN_TREADY,
                          Phat_FPFt_TVALID, FPFt,
                          Phat_Q_TVALID, Q,
                          Phat_TValid, Phat_out_TReady, Phat);

----x = F*x;
MM3: Matrix_Multiplication generic map (NN,1,NN)
    port map (ACLK, xnonnorm_ACLKEn, xnonnorm_AResetn, xnonnorm_IN_TREADY,
              xnonnorm_F_TVALID, F,
              xnonnorm_x_TVALID, x,        
              xnonnorm_TValid,xnonnorm_out_TReady, xnonnorm);
              
--q = x(1:4)';
quatNonNorm(0) <= xnonnorm(0,0);
quatNonNorm(1) <= xnonnorm(1,0);
quatNonNorm(2) <= xnonnorm(2,0);
quatNonNorm(3) <= xnonnorm(3,0);

--qnorm = norm(q);
QNL: Quaternion_Norm port map (ACLK, normq_ACLKEn, normq_AResetn, normq_IN_TREADY,        
                          normq_Q_TVALID, quatNonNorm,        
                          normq_QN_TValid, normq_out_TReady, normQuat);
 
normQuatNZ <= normQuat WHEN normQuat /= ZERO
              ELSE ONE;   
--q = q/qnorm;
VSD: Vector_ScalarDivision generic map(4)
                      port map (ACLK, qn_ACLKEn, qn_AResetn, qn_IN_TREADY, 
                      qn_A_TVALID, quatNonNorm,
                      qn_S_TVALID, normQuatNZ,
                      qn_TValid, qn_out_TReady, quatNorm);

--x(1:4) = q';
xhat(0,0) <= quatNorm(0);
xhat(1,0) <= quatNorm(1);
xhat(2,0) <= quatNorm(2);
xhat(3,0) <= quatNorm(3);

-- END EQUATION ASSIGNMENT

What_ACLKEn <= ACLKEn;
F_ACLKEn <= ACLKEn;
FP_ACLKEn <= ACLKEn;
FPFt_ACLKEn <= ACLKEn;
Phat_ACLKEn <= ACLKEn;
xnonnorm_ACLKEn <= ACLKEn;
normq_ACLKEn <= ACLKEn;
qn_ACLKEn <= ACLKEn;

What_AResetn <= AResetn;
F_AResetn <= AResetn;
FP_AResetn <= AResetn;
FPFt_AResetn <= AResetn;
Phat_AResetn <= AResetn;
xnonnorm_AResetn <= AResetn;
normq_AResetn <= AResetn;
qn_AResetn <= AResetn;

end PredictKF_Behavioral;