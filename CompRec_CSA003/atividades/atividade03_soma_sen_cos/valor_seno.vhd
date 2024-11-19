LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY valor_seno IS
	PORT (
		ang_radianos: IN INTEGER;
		valor_seno: OUT INTEGER
	);
END valor_seno;


ARCHITECTURE operacao_seno OF valor_seno IS

BEGIN
	PROCESS(ang_radianos)

		BEGIN
			valor_seno <= ang_radianos - (ang_radianos**3) / 6 + (ang_radianos**5) / 120;
	END PROCESS;
END operacao_seno;
