----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2016 07:33:44 PM
-- Design Name: 
-- Module Name: CorrectKF - CorrectKF_Behavioral
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

entity CorrectKF is
   generic (
     NN : INTEGER := 7;
     PP : INTEGER := 6
 );
 port (
     ACLK : in STD_LOGIC;
     ACLKEn : in STD_LOGIC := '0';
     AResetn : in STD_LOGIC  := '0';
     TREADY : out STD_LOGIC;
     
     xhat_TVALID : in STD_LOGIC;
     xhat : in MATRIX(0 to NN-1, 0 to 0);
     
     Phat_TVALID : in STD_LOGIC;
     Phat : in MATRIX(0 to NN-1, 0 to NN-1);
     
     Sensor_TVALID : in STD_LOGIC;
     Sensor_base : in MATRIX(0 to 2, 0 to 0);
     Sensor_R : in MATRIX(0 to 2, 0 to 0);
     Sensor : in MATRIX(0 to 2, 0 to 0);
     
     Correct_TValid : out STD_LOGIC;
     Correct_TReady : in STD_LOGIC;
	 x : out MATRIX(0 to NN-1, 0 to 0);
     P : out MATRIX(0 to NN-1, 0 to NN-1)	 
 );
end CorrectKF;

architecture CorrectKF_Behavioral of CorrectKF is
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
        AResetn : in STD_LOGIC  := '0';
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
        AResetn : in STD_LOGIC  := '0';
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
		Ar : integer := 3;
        Bc : integer := 1;
        N : integer := 7
        );
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '0';
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
        AResetn : in STD_LOGIC  := '0';
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
        AResetn : in STD_LOGIC  := '0';
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
        AResetn : in STD_LOGIC  := '0';
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
        AResetn : in STD_LOGIC  := '0';
        TREADY : out STD_LOGIC;
        
        Q_TVALID : in STD_LOGIC;
        Q_Data : in VECTOR (0 to 3);
        
        QN_TValid : out STD_LOGIC;
        QN_TReady : in STD_LOGIC;
        QN_Data : out NUM
    );
end COMPONENT;

COMPONENT CorrectSingleKF is
   generic (
      NN : INTEGER := 7;
      PP : INTEGER := 6
    );
    port (
      ACLK : in STD_LOGIC;
      ACLKEn : in STD_LOGIC := '0';
      AResetn : in STD_LOGIC  := '0';
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
end COMPONENT;

COMPONENT Vector_Norm is
	generic(
        N : integer := 4
    );
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '0';
        TREADY : out STD_LOGIC;
        
        V_TVALID : in STD_LOGIC;
        V_Data : in VECTOR (0 to N-1);
        
        VN_TValid : out STD_LOGIC;
        VN_TReady : in STD_LOGIC;
        VN_Data : out NUM
    );
end COMPONENT;

COMPONENT Quaternion_Multiplication is
    port(
        ACLK : in STD_LOGIC;
        ACLKEn : in STD_LOGIC := '0';
        AResetn : in STD_LOGIC  := '0';
        TREADY : out STD_LOGIC;
        
        Q_TVALID : in STD_LOGIC;
        Q_Data : in VECTOR (0 to 3);
        
        P_TVALID : in STD_LOGIC;
        P_Data : in VECTOR (0 to 3);
        
        R_TValid : out STD_LOGIC;
        R_TReady : in STD_LOGIC;
        R_Data : out VECTOR (0 to 3)
    );
end COMPONENT;

-- END COMPONENT SECTION

-- CONTROL SIGNALS
SIGNAL SensorNorm_ACLKEn : STD_LOGIC := '0';
SIGNAL SensorNorm_AResetn : STD_LOGIC := '0';
SIGNAL SensorNorm_IN_TREADY,  SensorNorm_out_TReady : STD_LOGIC;
SIGNAL SensorNorm_Sensor_TVALID,SensorNorm_TValid : STD_LOGIC;

SIGNAL zv_ACLKEn : STD_LOGIC := '0';
SIGNAL zv_AResetn : STD_LOGIC := '0';
SIGNAL zv_IN_TREADY, zv_out_TReady : STD_LOGIC;
SIGNAL zv_Sensor_TVALID, zv_SensorNorm_TVALID, zv_TValid : STD_LOGIC;

SIGNAL ha_ACLKEn : STD_LOGIC := '0';
SIGNAL ha_AResetn : STD_LOGIC := '0';
SIGNAL ha_IN_TREADY, ha_out_TReady : STD_LOGIC;
SIGNAL ha_qiConj_TVALID, ha_anq_TVALID, ha_TValid : STD_LOGIC;

SIGNAL Yhat_ACLKEn : STD_LOGIC := '0';
SIGNAL Yhat_AResetn : STD_LOGIC := '0';
SIGNAL Yhat_IN_TREADY, Yhat_out_TReady : STD_LOGIC;
SIGNAL Yhat_H_TVALID, Yhat_xhat_TVALID, Yhat_TValid : STD_LOGIC;

SIGNAL y_ACLKEn : STD_LOGIC := '0';
SIGNAL y_AResetn : STD_LOGIC := '0';
SIGNAL y_IN_TREADY, y_out_TReady : STD_LOGIC;
SIGNAL y_z_TVALID, y_Yhat_TVALID, y_TValid : STD_LOGIC;

SIGNAL Sx_ACLKEn : STD_LOGIC := '0';
SIGNAL Sx_AResetn : STD_LOGIC := '0';
SIGNAL Sx_IN_TREADY,  Sx_Correct_TReady : STD_LOGIC;
SIGNAL Sx_xhat_TVALID, Sx_Phat_TVALID, Sx_y_TVALID, Sx_Sensor_R_TVALID, Sx_HX_TVALID, Sx_Correct_TValid : STD_LOGIC;

SIGNAL Sy_ACLKEn : STD_LOGIC := '0';
SIGNAL Sy_AResetn : STD_LOGIC := '0';
SIGNAL Sy_IN_TREADY, Sy_Correct_TReady : STD_LOGIC;
SIGNAL Sy_Sx_x_out_TVALID, Sy_Sx_P_out_TVALID, Sy_y_TVALID, Sy_Sensor_R_TVALID, Sy_HY_TVALID, Sy_Correct_TValid : STD_LOGIC;

SIGNAL Sz_ACLKEn : STD_LOGIC := '0';
SIGNAL Sz_AResetn : STD_LOGIC := '0';
SIGNAL Sz_IN_TREADY,  Sz_Correct_TReady : STD_LOGIC;
SIGNAL Sz_Sy_x_out_TVALID, Sz_Sy_P_out_TVALID, Sz_y_TVALID, Sz_Sensor_R_TVALID, Sz_HY_TVALID, Sz_Correct_TValid : STD_LOGIC;

SIGNAL S_ACLKEn : STD_LOGIC := '0';
SIGNAL S_AResetn : STD_LOGIC := '0';
SIGNAL S_IN_TREADY,  S_Correct_TReady : STD_LOGIC;
SIGNAL S_xhat_TVALID, S_Phat_TVALID, S_y_TVALID, S_Sensor_R_TVALID, S_H_TVALID, S_Correct_TValid : STD_LOGIC;
-- END CONTROL SIGNALS SECTION

-- BEGIN INTERNAL SIGNAL DEFINITION

SIGNAL zero : NUM := ZERO;
SIGNAL SensorNorm : NUM := ZERO;
SIGNAL S_y : NUM;
SIGNAL zv,SensorV : VECTOR(0 to 3-1);
SIGNAL zx, zy, zz : NUM;
SIGNAL qi, qiConj, anq, ha, nha : VECTOR(0 to 4-1);
SIGNAL HX, HY, HZ, S_H : MATRIX(0 to 0, 0 to NN-1);
SIGNAL H : MATRIX(0 to PP/2-1, 0 to NN-1) := (others => (others => ZERO));
SIGNAL Yhat, z, y : MATRIX(0 to 3-1, 0 to 0);
SIGNAL Sx_x_out, Sy_x_out, Sz_x_out,S_x_out, S_xhat : MATRIX(0 to NN-1, 0 to 0); 
SIGNAL Sx_P_out, Sy_P_out, Sz_P_out, S_P_out, S_Phat : MATRIX(0 to NN-1, 0 to NN-1);
SIGNAL S_Sensor_R : NUM;

SIGNAL SensorNonUsed : MATRIX(0 to 2, 0 to 0) := (others => (others => "11111111111111111111111111111111"));

signal state_P_CSKF : std_logic_vector(3 downto 0) := "0000";
-- END INTERNAL SIGNAL DEFINITION

begin
-- BEGIN CONTROL SIGNAL ASSIGNMENT
SensorNorm_ACLKEn <= ACLKEn;
zv_ACLKEn <= ACLKEn;
ha_ACLKEn <= ACLKEn;
Yhat_ACLKEn <= ACLKEn;
y_ACLKEn <= ACLKEn;
Sx_ACLKEn <= ACLKEn;
Sy_ACLKEn <= ACLKEn;
Sz_ACLKEn <= ACLKEn;

SensorNorm_AResetn <= AResetn;
zv_AResetn <= AResetn;
ha_AResetn <= AResetn;
Yhat_AResetn <= AResetn;
y_AResetn <= AResetn;
Sx_AResetn <= AResetn;
Sy_AResetn <= AResetn;
Sz_AResetn <= AResetn;

-- Ready
TREADY <= SensorNorm_IN_TREADY;
SensorNorm_out_TReady <= zv_IN_TREADY;
zv_out_TReady <= ha_IN_TREADY;
Yhat_out_TReady <= y_IN_TREADY;
ha_out_TReady <= Yhat_IN_TREADY;
y_out_TReady <= Sx_IN_TREADY AND Sy_IN_TREADY AND Sz_IN_TREADY;
Sx_Correct_TReady <= Correct_TReady;
Sy_Correct_TReady <= Correct_TReady;
Sz_Correct_TReady <= Correct_TReady;

-- Valid
SensorNorm_Sensor_TVALID <= Sensor_TVALID;
zv_SensorNorm_TVALID <= SensorNorm_TValid;
zv_Sensor_TVALID <= Sensor_TVALID;
y_z_TVALID <= zv_TValid;
ha_qiConj_TVALID <= xhat_TVALID;
ha_anq_TVALID <= Sensor_TVALID;
Yhat_H_TVALID <= ha_TValid;
Yhat_xhat_TVALID <= xhat_TVALID;
y_Yhat_TVALID <= Yhat_TValid;
Sx_xhat_TVALID <= xhat_TVALID;
Sx_Phat_TVALID <= Phat_TVALID;
Sx_y_TVALID <= y_TValid;
Sx_Sensor_R_TVALID <= Sensor_TVALID;
Sx_HX_TVALID <= ha_TValid;

Sy_Sx_x_out_TVALID <= Sx_Correct_TValid;
Sy_Sx_P_out_TVALID <= Sx_Correct_TValid;
Sy_y_TVALID <= y_TValid;
Sy_Sensor_R_TVALID <= Sensor_TVALID;
Sy_HY_TVALID <= ha_TValid;

Sz_Sy_x_out_TVALID <= Sy_Correct_TValid;
Sz_Sy_P_out_TVALID <= Sy_Correct_TValid;
Sz_y_TVALID <= y_TValid;
Sz_Sensor_R_TVALID <= Sensor_TVALID;
Sz_HY_TVALID <= ha_TValid;

Correct_TValid <= Sz_Correct_TValid;

-- END CONTROL SIGNAL ASSIGNMENT

-- EQUATION ASSIGNMENT


--Normalise accelerometer measurement
--norm(Sensor);
SensorV(0) <= Sensor(0,0);
SensorV(1) <= Sensor(1,0);
SensorV(2) <= Sensor(2,0);
VNL: Vector_Norm generic map(3) port map (ACLK, SensorNorm_ACLKEn, SensorNorm_AResetn, SensorNorm_IN_TREADY,        
                                          SensorNorm_Sensor_TVALID, SensorV,        
                                          SensorNorm_TValid, SensorNorm_out_TReady, SensorNorm);
    
--z = Sensor / norm(Sensor);    % normalise magnitude
MSD: Matrix_DivisionScalar generic map(3,1)
                      port map (ACLK, zv_ACLKEn, zv_AResetn, zv_IN_TREADY, 
                      zv_Sensor_TVALID, Sensor,
                      zv_SensorNorm_TVALID, SensorNorm,
                      zv_TValid, zv_out_TReady, z);


--qi = x(1:4)';
qi(0) <= xhat(0,0);
qi(1) <= xhat(1,0);
qi(2) <= xhat(2,0);
qi(3) <= xhat(3,0);

--quaternConjB(qi)
qiConj(0) <= invert(qi(0));
qiConj(1) <= invert(qi(1));
qiConj(2) <= invert(qi(2));
qiConj(3) <= qi(3);

anq(0) <= Sensor_base(0,0);
anq(1) <= Sensor_base(1,0);
anq(2) <= Sensor_base(2,0);
anq(3) <= zero;


--ha = quaternProdB(quaternConjB(qi), [an 0]);
QM: Quaternion_Multiplication port map (ACLK, ha_ACLKEn, ha_AResetn, ha_IN_TREADY,       
                                        ha_qiConj_TVALID, qiConj,        
                                        ha_anq_TVALID, anq,
                                        ha_TValid, ha_out_TReady, ha); 
 
            
nha(0) <= invert(ha(0));
nha(1) <= invert(ha(1));
nha(2) <= invert(ha(2));
nha(3) <= invert(ha(3));
            
--H = [ ha(4)  ha(3) -ha(2) ha(1) 0 0 0;...
--     -ha(3)  ha(4)  ha(1) ha(2) 0 0 0;...
--      ha(2) -ha(1)  ha(4) ha(3) 0 0 0];

HX <= (0 => ( ha(3),  ha(2), nha(1), ha(0),zero,zero,zero),others => (others => zero));
HY <= (0 => (nha(2),  ha(3),  ha(0), ha(1),zero,zero,zero),others => (others => zero));
HZ <= (0 => ( ha(1), nha(0),  ha(3), ha(2),zero,zero,zero),others => (others => zero));

H <= (0 => ( ha(3),  ha(2), nha(1), ha(0),zero,zero,zero),
      1 => (nha(2),  ha(3),  ha(0), ha(1),zero,zero,zero),
      2 => ( ha(1), nha(0),  ha(3), ha(2),zero,zero,zero),
      others => (others => zero));

--Yhat = H*x;
MM1: Matrix_Multiplication generic map (Ar => PP/2, N => NN, Bc => 1)
                           port map (ACLK, Yhat_ACLKEn, Yhat_AResetn, Yhat_IN_TREADY,
                                     Yhat_H_TVALID, H,
                                     Yhat_xhat_TVALID, xhat,        
                                     Yhat_TValid, Yhat_out_TReady, Yhat);
--Yhat(0,0) <= ha(0);
--Yhat(1,0) <= ha(1);
--Yhat(2,0) <= ha(2);


--z = [Accelerometer'];
--z(0,0) <= zv(0);
--z(1,0) <= zv(1);
--z(2,0) <= zv(2);

--y = z - Yhat;
MS1: Matrix_Subtraction generic map (PP/2, 1)
                port map (ACLK, y_ACLKEn, y_AResetn, y_IN_TREADY,
                          y_z_TVALID, z,
                          y_Yhat_TVALID, Yhat,
                          y_TValid, y_out_TReady, y);

						  
						  
CSKF: CorrectSingleKF  generic map(NN, PP)
                        port map (ACLK, S_ACLKEn, S_AResetn, S_IN_TREADY,
                                  S_xhat_TVALID, S_xhat,
                                  S_Phat_TVALID, S_Phat,
                                  S_y_TVALID, S_y,
                                  S_Sensor_R_TVALID, S_Sensor_R,
                                  S_H_TVALID, S_H,
                                  S_Correct_TValid, S_Correct_TReady, S_x_out, S_P_out);

P_CSKF: process(ACLK)
 variable count : integer := 0;
begin
 if(rising_edge(ACLK)) then
     if(AResetn = '0') then
         S_AResetn <= '0';
         S_ACLKEn <= '0';
		 
         S_xhat_TVALID <= '0';
         S_Phat_TVALID <= '0';  
         S_y_TVALID <= '0';
         S_Sensor_R_TVALID <= '0';
         S_H_TVALID <= '0';
         
         Sx_Correct_TValid <= '0';
         Sx_IN_TREADY <= '0';

         Sy_Correct_TValid <= '0';
         Sy_IN_TREADY <= '0';

         Sz_Correct_TValid <= '0';
         Sz_IN_TREADY <= '0';		
         
         S_Correct_TReady <= '0'; 

         state_P_CSKF <= "0000"; 
         count := 0;
     elsif(AResetn = '1') then
         case state_P_CSKF is
             when "0000" =>
                 if(ACLKEn = '1') then
                     state_P_CSKF <= "0001";    
                 end if;
             when "0001" =>
                 S_AResetn <= '1';
                 S_ACLKEn <= '1';    
                 Sx_IN_TREADY <= S_IN_TREADY;       
                 if(S_IN_TREADY = '1' AND Sx_xhat_TVALID = '1' AND Sx_Phat_TVALID = '1' AND ha_TValid = '1' AND y_TValid = '1'
						AND S_xhat_TVALID /= '1' AND Sy_Correct_TValid /= '1' AND Sz_Correct_TValid /= '1') then
                     S_xhat <= xhat;
                     S_xhat_TVALID <= '1';
                     S_Phat <= Phat;
                     S_Phat_TVALID <= '1';
					 S_y <= y(0,0);
					 S_y_TVALID <= '1';
					 S_Sensor_R <= Sensor_R(0,0);
					 S_Sensor_R_TVALID <= '1';
					 S_H <= HX;
					 S_H_TVALID <= '1';
					 S_Correct_TReady <= '1';
                     state_P_CSKF <= "0010";
                 end if;
             when "0010" =>
                 if(S_Correct_TValid = '1') then
                     Sx_x_out <= S_x_out;
					 Sx_P_out <= S_P_out;
					 
                     Sx_Correct_TValid <= '1';
                     S_xhat_TVALID <= '0';
                     S_Phat_TVALID <= '0';
					 S_y_TVALID <= '0';
                     S_Sensor_R_TVALID <= '0';
					 S_H_TVALID <= '0';
					 S_Correct_TReady <= '0';
					 
                     S_ACLKEn <= '0';
                     S_AResetn <= '0';
                     state_P_CSKF <= "0011";
                 end if;                    
             when "0011" =>
                 if(count = 3) then
                     count := 0;
                     state_P_CSKF <= "0100";
                 else
                     count := count + 1;
                 end if;
             when "0100" =>
                 S_ACLKEn <= '1';
                 S_AResetn <= '1';   
                 Sy_IN_TREADY <= S_IN_TREADY;     
			 
                 if(S_IN_TREADY = '1' AND Sy_Sx_x_out_TVALID = '1' AND Sy_Sx_P_out_TVALID = '1') then
					 S_xhat <= Sx_x_out;
                     S_xhat_TVALID <= '1';
                     S_Phat <= Sx_P_out;
                     S_Phat_TVALID <= '1';
					 S_y <= y(1,0);
					 S_y_TVALID <= '1';
					 S_Sensor_R <= Sensor_R(1,0);
					 S_Sensor_R_TVALID <= '1';
					 S_H <= HY;
					 S_H_TVALID <= '1';
					 S_Correct_TReady <= '1';
                     state_P_CSKF <= "0110";
                 end if;
             when "0110" =>
                 if(S_Correct_TValid = '1') then
					 Sy_x_out <= S_x_out;
					 Sy_P_out <= S_P_out;
					 
                     Sy_Correct_TValid <= '1';
                     S_xhat_TVALID <= '0';
                     S_Phat_TVALID <= '0';
					 S_y_TVALID <= '0';
                     S_Sensor_R_TVALID <= '0';
					 S_H_TVALID <= '0';
					 S_Correct_TReady <= '0';
					 
                     S_ACLKEn <= '0';
                     S_AResetn <= '0';
				 
                     state_P_CSKF <= "0111";
                 end if;                    
             when "0111" =>
                 if(count = 3) then
                     count := 0;
                     state_P_CSKF <= "1000";
                 else
                     count := count + 1;
                 end if;
			 when "1000" =>
                 S_ACLKEn <= '1';
                 S_AResetn <= '1';   
                 Sz_IN_TREADY <= S_IN_TREADY;     
			 
                 if(S_IN_TREADY = '1' AND Sz_Sy_x_out_TVALID = '1' AND Sz_Sy_P_out_TVALID = '1') then
					 S_xhat <= Sy_x_out;
                     S_xhat_TVALID <= '1';
                     S_Phat <= Sy_P_out;
                     S_Phat_TVALID <= '1';
					 S_y <= y(2,0);
					 S_y_TVALID <= '1';
					 S_Sensor_R <= Sensor_R(2,0);
					 S_Sensor_R_TVALID <= '1';
					 S_H <= HZ;
					 S_H_TVALID <= '1';
					 S_Correct_TReady <= '1';
                     state_P_CSKF <= "1001";
                 end if;
             when "1001" =>
                 if(S_Correct_TValid = '1') then
					 x <= S_x_out;
					 P <= S_P_out;
					 
                     Sz_Correct_TValid <= '1';
                     S_xhat_TVALID <= '0';
                     S_Phat_TVALID <= '0';
					 S_y_TVALID <= '0';
                     S_Sensor_R_TVALID <= '0';
					 S_H_TVALID <= '0';
					 S_Correct_TReady <= '0';
					 
                     S_ACLKEn <= '0';
                     S_AResetn <= '0';
				 
                     state_P_CSKF <= "1010";
                 end if;                    
             when "1010" =>
                 if(count = 3) then
                     count := 0;
                     state_P_CSKF <= "0000";
                 else
                     count := count + 1;
                 end if;
             when others =>
                 state_P_CSKF <= "0000";
         end case;
     end if;
 end if;
end process;

end CorrectKF_Behavioral;
