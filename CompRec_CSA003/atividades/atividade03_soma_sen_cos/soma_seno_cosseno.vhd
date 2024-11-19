LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY soma_seno_cosseno IS
	PORT (
		valor_seno, valor_cosseno: IN INTEGER;
		resultado_final: OUT INTEGER
	);
END soma_seno_cosseno;


ARCHITECTURE soma_final OF soma_seno_cosseno IS

BEGIN
	PROCESS(valor_seno, valor_cosseno)

		BEGIN
			resultado_final <= (valor_seno + valor_cosseno);

	END PROCESS;
END soma_final;
