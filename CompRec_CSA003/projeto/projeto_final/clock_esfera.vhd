LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.NUMERIC_STD.ALL;

ENTITY clock_esfera IS 
	PORT (
		switch1: IN STD_LOGIC; -- Estado do segundo switch na placa SW1
		switch2: IN STD_LOGIC; -- Estado do terceiro switch na placa SW2

		clk: IN STD_LOGIC;
		clk_source: IN STD_LOGIC_VECTOR(24 DOWNTO 0); -- Clock fonte
		clk_esfera :  OUT  STD_LOGIC -- Clock de saída para estabelecer a velocidade da bola
	);
END clock_esfera;


ARCHITECTURE velocidade_esfera OF clock_esfera IS 

BEGIN

	PROCESS (clk, switch1, switch2)
		BEGIN
	
		-- CONTROLADOR DA VELOCIDADE DA ESFERA
		IF (clk'EVENT AND clk='1') THEN
			IF(
				switch1 = '0' and switch2 = '0'
			) THEN -- Fácil
				clk_esfera <= clk_source(16);
			ELSIF(
				switch1 = '1' and switch2 = '0'
			) THEN -- Médio
				clk_esfera <= clk_source(15);
			ELSIF(
				switch1 = '0' and switch2 = '1'
			) THEN -- Difícil
				clk_esfera <= clk_source(14);
			ELSE -- Expert: quando ambos os switchs estão ativados
				clk_esfera <= clk_source(13);
			END IF;
		END IF;
	END PROCESS;

END velocidade_esfera;
