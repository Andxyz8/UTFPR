LIBRARY ieee;

USE ieee.std_logic_1164.all;

ENTITY tabela1 IS
	PORT (
		a, b, c: IN BIT;
		y: OUT BIT
	);
END tabela1;

ARCHITECTURE regras OF tabela1 IS
	SIGNAL aux1: BIT_VECTOR (2 DOWNTO 0);

	BEGIN
		aux1 <= a & b & c;
		
		WITH aux1 SELECT
			y <= '0' WHEN "000", 
			     '0' WHEN "001",
				  '0' WHEN "010",
				  '1' WHEN "011",
				  '0' WHEN "100",
				  '1' WHEN "101",
				  '1' WHEN "110",
				  '1' WHEN "111";
END regras;