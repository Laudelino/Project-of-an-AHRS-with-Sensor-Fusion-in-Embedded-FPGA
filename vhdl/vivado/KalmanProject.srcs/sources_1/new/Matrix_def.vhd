----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2016 04:42:54 PM
-- Design Name: 
-- Module Name: Matrix_def
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

PACKAGE Matrix_def IS
	CONSTANT NUM_SIZE: INTEGER := 32;
	SUBTYPE NUM IS STD_LOGIC_VECTOR(NUM_SIZE-1 downto 0);
	TYPE VECTOR IS ARRAY (NATURAL RANGE <>) OF NUM;--STD_LOGIC_VECTOR(INT_SIZE-1 downto 0);
	TYPE MATRIX IS ARRAY(NATURAL RANGE<>, NATURAL RANGE<>) OF NUM;
	TYPE STD_LOGIC_MATRIX IS ARRAY(NATURAL RANGE<>, NATURAL RANGE<>) OF STD_LOGIC;
    CONSTANT ZERO : NUM := "00000000000000000000000000000000";
    CONSTANT ONE : NUM := "00111111100000000000000000000000";
	FUNCTION trunc (D : STD_LOGIC_VECTOR(2*NUM_SIZE-1 downto 0)) RETURN NUM;
	FUNCTION matrix2vector (A: MATRIX; I : NATURAL; row : STD_LOGIC) RETURN vector;
	FUNCTION invert (A: NUM) RETURN NUM;
END PACKAGE;

PACKAGE BODY Matrix_def IS
	-- SIGNAL A : MATRIX (0 to N, 0 to M)
	-- A'range(1) = 0 to N for row vector
	-- A'range(2) = 0 to M for col vector
	-- A00 A01 A02 A03
	-- A10 A11 A12 A13
	-- A20 A21 A22 A23
	-- row == 1, I==0 -> [A00 A01 A02 A03]
	-- row == 0, I==0 -> [A00 A10 A20]
	FUNCTION matrix2vector (A: MATRIX; I : NATURAL; row : STD_LOGIC) RETURN VECTOR IS
		variable rvector : VECTOR(A'range(2));
		variable cvector : VECTOR(A'range(1));
	BEGIN
		if row = '1' then
			for j in A'range(2) loop
				rvector(j) := A(I, j);
			end loop;
			return rvector;
		else
			for j in A'range(1) loop
				cvector(j) := A(j, I);
			end loop;	
			return cvector;
		end if;
	END FUNCTION;
	
	FUNCTION trunc (D : STD_LOGIC_VECTOR(2*NUM_SIZE-1 downto 0)) RETURN NUM IS
	variable T : NUM;
	BEGIN
		T := D(NUM_SIZE-1 downto 0);
		
		return T;
	END FUNCTION;

    FUNCTION invert (A: NUM) RETURN NUM IS
    variable T : NUM;
    BEGIN
        T := NOT A(NUM_SIZE-1) & A(NUM_SIZE-2 DOWNTO 0);
        return T;
    END FUNCTION;
	
END PACKAGE BODY;
