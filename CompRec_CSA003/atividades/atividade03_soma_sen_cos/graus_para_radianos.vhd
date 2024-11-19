LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY graus_para_radianos IS
	PORT (
		ang_ent_graus: IN INTEGER RANGE 0 TO 90;
		ang_sai_radianos: OUT INTEGER
	);
END graus_para_radianos;


ARCHITECTURE regra_conversao OF graus_para_radianos IS
	CONSTANT PI: INTEGER := 314;

BEGIN
	PROCESS(ang_ent_graus)

		BEGIN
			ang_sai_radianos <= ang_ent_graus * PI / 180;
	END PROCESS;
END regra_conversao;
