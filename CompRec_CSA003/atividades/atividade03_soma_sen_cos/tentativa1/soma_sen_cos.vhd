LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY soma_sen_cos IS
	PORT (
		angulo_entrada: IN INTEGER RANGE 0 TO 90;
		resultado_saida: OUT INTEGER
	);
END soma_sen_cos;


ARCHITECTURE operacoes OF soma_sen_cos IS
	CONSTANT PI: INTEGER := 31415;
	CONSTANT ESCALA: INTEGER := 10000;
	
BEGIN
	PROCESS(angulo_entrada)

		VARIABLE angulo_rad : INTEGER := 0;
		VARIABLE valor_sen : INTEGER := 0;
		VARIABLE valor_cos : INTEGER := 0;
		VARIABLE resultado : INTEGER := 0;


		BEGIN
			-- Converter para radianos
			angulo_rad := angulo_entrada * PI / 180;

			-- Seno utilizando 3 termos da série de Taylor
			valor_sen := angulo_rad - (angulo_rad**3) / 6 + (angulo_rad**5) / 120;

			-- Cosseno utilizando 3 termos da série de Taylor
			valor_cos := 1 - (angulo_rad**2) / 2 + (angulo_rad**4) / 24;

			-- Soma e ajuste de escala
			resultado := (valor_sen + valor_cos) / ESCALA;
			resultado_saida <= INTEGER(resultado); -- Converter para inteiro
	END PROCESS;
END operacoes;