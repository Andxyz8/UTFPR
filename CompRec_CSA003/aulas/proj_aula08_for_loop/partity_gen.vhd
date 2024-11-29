LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY parity_gen IS
	GENERIC (n: INTEGER := 7); -- ESPECIFICAÇÃO DE UM NÚMERO GENÉRICO
	PORT (
		input: IN BIT_VECTOR (n - 1 DOWNTO 0);
		output: OUT BIT_VECTOR (n - 1 DOWNTO 0)
	);
END parity_gen;


ARCHITECTURE parity OF parity_gen IS

BEGIN

	PROCESS (input)
	VARIABLE temp1: BIT;
	VARIABLE temp2: BIT_VECTOR (output' RANGE);
	
	BEGIN

	temp1 := '0';
	
	FOR i IN input'RANGE LOOP
		temp1 := temp1 XOR input(i);
		temp2(i) := input(i);
	END LOOP;

	temp2(output'HIGH) := temp1;
	
	output <= temp2;

	END PROCESS;
END parity;
