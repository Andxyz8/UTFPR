LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY frameview IS 
	PORT
	(
		coluna: IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Posição pixel processado em x
		linha: IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Posicao pixel processado em y

		botao_k0_cima: IN STD_LOGIC; -- Estado push button key0
		botao_k1_baixo: IN STD_LOGIC; -- Estado push button key1

		clk_barra: IN STD_LOGIC; -- Clock da barra
		a:  OUT  STD_LOGIC -- Saída binária para desenhar ou não o pixel
	);
END frameview;

ARCHITECTURE frameview OF frameview IS


SIGNAL coluna_int_x : integer;
SIGNAL linha_int_y : integer;


BEGIN

	PROCESS (coluna, linha, clk_barra)
	
	VARIABLE tam_barra_x: INTEGER := 10;
	VARIABLE tam_barra_y: INTEGER := 50;
	
	VARIABLE pos_barra_coluna_x: INTEGER := 0; -- Posição inical barra em X (colunas)
	VARIABLE pos_barra_linha_y: INTEGER := 240 - tam_barra_x; -- Posição inicial da barra em Y (linhas)

	VARIABLE ORIGEM_LINHA: INTEGER := 0;
	VARIABLE FINAL_LINHA: INTEGER := 480;

	BEGIN

		-- MOVIMENTO DA BARRA --
		IF (clk_barra'EVENT AND clk_barra = '1') THEN
			IF ( -- EXECUTA O MOVIMENTO PARA CIMA NAS LINHAS
				botao_k0_cima = '0'
				AND botao_k1_baixo /= '0'
				AND pos_barra_linha_y > ORIGEM_LINHA
			) THEN
				pos_barra_linha_y := pos_barra_linha_y - 1;
			ELSIF ( -- EXECUTA O MOVIMENTO PARA BAIXO NAS LINHAS
				botao_k0_cima /= '0'
				AND botao_k1_baixo = '0'
				AND pos_barra_linha_y < (FINAL_LINHA - tam_barra_y)
			) THEN
				pos_barra_linha_y := pos_barra_linha_y + 1;
			END IF;
		END IF;
		-- MOVIMENTO DA BARRA --

		-- converte linha e coluna de entrada para inteiro
		coluna_int_x <= TO_INTEGER(UNSIGNED(coluna));
		linha_int_y <= TO_INTEGER(UNSIGNED(linha));
	
		-- CONDICIONAIS PARA DESENHAR OU NÃO O PIXEL ATUAL NA SAÍDA VGA --
		
		-- DESENHO DA PLATAFORMA --
		IF((  -- Px dentro da barra horizontal maior que a origem barra horizontal (linhas)
				(coluna_int_x > pos_barra_coluna_x)
				-- Px dentro da barra menor que tamanho barra horizontal (linhas)
				AND (coluna_int_x <= tam_barra_x + pos_barra_coluna_x)
			) AND (
				-- Py dentro da barra vertical maior que a origem barra vertical (colunas)
				linha_int_y >= pos_barra_linha_y
				-- Py dentro da barra vertical menor que tamanho barra vertical (colunas)
				AND linha_int_y < pos_barra_linha_y + tam_barra_y
			)
		) THEN
			a <= '1';
		-- DESENHO DA PLATAFORMA --

		ELSE
			a <= '0';
		END IF;
		-- CONDICIONAIS PARA DESENHAR OU NÃO O PIXEL ATUAL NA SAÍDA VGA --

	END PROCESS;

END frameview;