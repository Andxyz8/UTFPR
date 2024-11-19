LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY valor_cosseno IS
	PORT (
		ang_radianos: IN INTEGER;
		valor_cosseno: OUT INTEGER
	);
END valor_cosseno;


ARCHITECTURE operacao_cosseno OF valor_cosseno IS
	
BEGIN
	PROCESS(ang_radianos)

		BEGIN
			valor_cosseno <= 1 - (ang_radianos**2) / 2 + (ang_radianos**4) / 24;
	END PROCESS;
END operacao_cosseno;
