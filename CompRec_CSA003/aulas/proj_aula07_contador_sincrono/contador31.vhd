LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

ENTITY contador31 IS

	PORT (
		clk: IN STD_LOGIC;
		valor: OUT INTEGER RANGE 0 TO 31
	);
END contador31;

ARCHITECTURE contador31 OF contador31 IS

BEGIN
	CONTA: PROCESS(clk)

		VARIABLE aux1: INTEGER RANGE 0 TO 32 := 0;

		BEGIN
		IF (clk'EVENT AND clk='1') THEN
			aux1 := aux1 + 1;

			IF (aux1 = 32) THEN
				aux1 := 0;
			END IF;
		END IF;
		valor <= aux1;
	END PROCESS CONTA;
END contador31;
