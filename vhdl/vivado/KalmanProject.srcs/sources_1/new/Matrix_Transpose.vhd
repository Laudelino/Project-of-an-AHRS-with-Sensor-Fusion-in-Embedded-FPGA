----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Laudelino Adao Junior (laudelino.adao@gmail.com)
-- 
-- Create Date: 05/09/2016 10:22:35 AM
-- Design Name: 
-- Module Name: Matrix_Transpose - Matrix_Transpose_Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This module calculates the product between two matrix. Matrix A has dimensions Ar x N
-- Matrix B has dimensions N x Bc. The result Matrix C has dimensions Ar x Bc
-- The matrix's elements are STD_LOGIC_VECTOR with size determinied on Matrix_def
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

entity Matrix_Transpose is
    generic(
		N : integer := 4;
		M : integer := 4
	);
	port(
		A : in MATRIX (0 to N-1,0 to M-1);
		AT : out MATRIX (0 to M-1,0 to N-1)
	);
end Matrix_Transpose;

architecture Matrix_Transpose_Behavioral of Matrix_Transpose is


begin
	rows: for i in 0 to N-1 generate
		cols: for j in 0 to M-1 generate
			AT(j, i) <= A(i,j);
		end generate cols;
	end generate rows;

end Matrix_Transpose_Behavioral;
