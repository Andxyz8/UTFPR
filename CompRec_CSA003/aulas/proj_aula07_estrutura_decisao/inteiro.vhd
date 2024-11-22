LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

ENTITY inteiro IS

	PORT(
		valor_int : IN INTEGER RANGE 0 TO 15;
		y : OUT BIT
	);

END inteiro;

ARCHITECTURE regra OF inteiro IS
BEGIN
	PROCESS (valor_int)
		BEGIN
			IF (valor_int > 9) THEN y <= '1';
			ELSE y <= '0';
			END IF;
	END PROCESS;
END regra;