LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY frameview IS 
	PORT (
		coluna: IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Posição pixel processado em x
		linha: IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Posicao pixel processado em y

		botao_k0_cima: IN STD_LOGIC; -- Estado push button key0
		botao_k1_baixo: IN STD_LOGIC; -- Estado push button key1

		clk: IN STD_LOGIC; -- Clock da fonte
		clk_barra: IN STD_LOGIC; -- Clock da barra
		clk_esfera: IN STD_LOGIC; -- Clock da esfera

		a:  OUT  STD_LOGIC -- Saída binária para desenhar ou não o pixel
	);
END frameview;

ARCHITECTURE frameview OF frameview IS


SIGNAL coluna_int_x: INTEGER;
SIGNAL linha_int_y: INTEGER;


BEGIN

	PROCESS (coluna, linha, clk_barra)

	-- CARACTERÍSTICAS DO CENÁRIO
	VARIABLE ORIGEM_LINHA: INTEGER := 20; -- Limite superior vertical linhas cenário
	VARIABLE FINAL_LINHA: INTEGER := 460; -- Limite inferior vertical linhas cenário
	VARIABLE FINAL_COLUNA: INTEGER := 620; -- Limite horizontal colunas cenário

	-- CARACTERÍSTICAS DA BARRA
	VARIABLE tam_barra_x: INTEGER := 10;
	VARIABLE tam_barra_y: INTEGER := 60;
	-- POSICIONAMENTO DA BARRA
	VARIABLE pos_barra_coluna_x: INTEGER := 0; -- Posição inical barra em X (colunas)
	VARIABLE pos_barra_linha_y: INTEGER := 240 - tam_barra_x; -- Posição inicial da barra em Y (linhas)

	-- CARACTERÍSTICAS DA ESFERA
	VARIABLE tam_esfera_x: INTEGER := 5;
	VARIABLE tam_esfera_y: INTEGER := 5;

	-- POSICIONAMENTO DA ESFERA
	VARIABLE pos_esfera_coluna_x: INTEGER := 320000;
	VARIABLE pos_esfera_linha_y: INTEGER := 240000;
	VARIABLE pos_fator_suavidade: INTEGER := 1000;
	VARIABLE pos_esfera_colunas_y_reinicio : INTEGER:= ORIGEM_LINHA*1000;

	-- REFLEXÃO ESFERA COM A BARRA
	VARIABLE velocidade_x_30: INTEGER := 125; -- Velocidade de reflexão de 30° com a plataforma 
	VARIABLE velocidade_y_30: INTEGER := 216;

	VARIABLE vel_esfera_coluna_x_45: INTEGER := 176; -- Velocidade de reflexão de 45° com a plataforma 
	VARIABLE vel_esfera_linha_y_45: INTEGER := 176;

	VARIABLE velocidade_x_60: INTEGER := 216; -- -- Velocidade de reflexão de 60° com a plataforma 
	VARIABLE velocidade_y_60: INTEGER := 125;

	-- MOVIMENTO DA ESFERA
	VARIABLE vel_esfera_coluna_x: INTEGER := vel_esfera_coluna_x_45;
	VARIABLE vel_esfera_linha_y: INTEGER := vel_esfera_linha_y_45;

	BEGIN
		-- GERADOR POSIÇÃO INICIAL ESFERA --
		IF (clk'EVENT AND clk='1') THEN
			pos_esfera_colunas_y_reinicio := pos_esfera_colunas_y_reinicio + 1;

			IF (
				pos_esfera_colunas_y_reinicio/1000 = FINAL_LINHA
			) THEN
				pos_esfera_colunas_y_reinicio := ORIGEM_LINHA*1000;
			END IF;
		END IF;
		-- GERADOR POSIÇÃO INICIAL ESFERA --


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


		IF (clk_esfera'EVENT AND clk_esfera = '1') THEN
			pos_esfera_coluna_x := pos_esfera_coluna_x + vel_esfera_coluna_x;
			pos_esfera_linha_y := pos_esfera_linha_y + vel_esfera_linha_y;

			-- MOVIMENTO ESFERA NO CENÁRIO --
			-- Se a bola ultrapassou o cenário à direita:
			IF(
				pos_esfera_coluna_x/pos_fator_suavidade >= FINAL_COLUNA - tam_esfera_x
			) THEN
				pos_esfera_coluna_x := (FINAL_COLUNA - tam_esfera_x)*pos_fator_suavidade;
				vel_esfera_coluna_x := -vel_esfera_coluna_x; -- Inverte a velocidade em x
			-- Se a bola ultrapassou o cenário à esquerda, perde:
			ELSIF(
				pos_esfera_coluna_x <= 0
			) THEN
				pos_esfera_coluna_x := 600000; -- Posição em x do reinício
				pos_esfera_linha_y := pos_esfera_colunas_y_reinicio; -- Posição em y do reinício
				vel_esfera_coluna_x := -vel_esfera_coluna_x_45; -- Velocidade de renício
				vel_esfera_linha_y := vel_esfera_linha_y_45;
			END IF;

			-- Se a bola ultrapassou o cenário por baixo:
			IF (
				pos_esfera_linha_y/pos_fator_suavidade >= FINAL_LINHA-tam_esfera_y
			) THEN
				pos_esfera_linha_y := (FINAL_LINHA - tam_esfera_y)*pos_fator_suavidade;
				vel_esfera_linha_y := -vel_esfera_linha_y;
			-- Se a bola ultrapassou o cenário por cima:
			ELSIF(
				pos_esfera_linha_y/pos_fator_suavidade < ORIGEM_LINHA
			) THEN
				pos_esfera_linha_y := ORIGEM_LINHA*pos_fator_suavidade + 1;
				vel_esfera_linha_y := -vel_esfera_linha_y;
			END IF;
			-- MOVIMENTO ESFERA NO CENÁRIO --


			-- COLISÃO ENTRE ESFERA E A BARRA --
			IF (
				pos_esfera_coluna_x/pos_fator_suavidade >= pos_barra_coluna_x
				AND pos_esfera_coluna_x/pos_fator_suavidade < pos_barra_coluna_x + tam_barra_x
				AND pos_esfera_linha_y/pos_fator_suavidade + tam_esfera_y >= pos_barra_linha_y
				AND pos_esfera_linha_y/pos_fator_suavidade < pos_barra_linha_y + tam_barra_y
			) THEN
				-- Ajusta posição da bola após colisão.
				pos_esfera_coluna_x := (pos_barra_coluna_x + tam_barra_x + 1)*1000;

				-- Calcula em que parte da plataforma houve a colisão. Com isso, ajusta a velocidade de reflexão de acordo com o local de colisão.
				IF (pos_esfera_linha_y/pos_fator_suavidade < pos_barra_linha_y + tam_barra_y/5) THEN
					vel_esfera_linha_y := vel_esfera_linha_y/(ABS(vel_esfera_linha_y))*velocidade_y_30;
					vel_esfera_coluna_x := velocidade_x_30;
				ELSIF (pos_esfera_linha_y/pos_fator_suavidade < pos_barra_linha_y + 2*tam_barra_y/5) THEN
					vel_esfera_linha_y := vel_esfera_linha_y/(ABS(vel_esfera_linha_y))*vel_esfera_linha_y_45;
					vel_esfera_coluna_x := vel_esfera_coluna_x_45;
				ELSIF (pos_esfera_linha_y/pos_fator_suavidade < pos_barra_linha_y + 3*tam_barra_y/5) THEN
					vel_esfera_linha_y := vel_esfera_linha_y/(ABS(vel_esfera_linha_y))*velocidade_y_60;
					vel_esfera_coluna_x := velocidade_x_60;
				ELSIF (pos_esfera_linha_y/pos_fator_suavidade < pos_barra_linha_y + 4*tam_barra_y/5) THEN
					vel_esfera_linha_y := vel_esfera_linha_y/(ABS(vel_esfera_linha_y))*vel_esfera_linha_y_45;
					vel_esfera_coluna_x := vel_esfera_coluna_x_45;
				ELSE
					vel_esfera_linha_y := vel_esfera_linha_y/(ABS(vel_esfera_linha_y))*velocidade_y_30;
					vel_esfera_coluna_x := velocidade_x_30;
				END IF;

				-- Verifica se, quando houve a colisão, a plataforma estava se movimentando na mesma direção da bolinha em relação ao eixo y.
				-- Se sim, dobra a velocidade da bola.
				IF (
					(botao_k0_cima = '0' AND botao_k1_baixo /= '0' AND vel_esfera_linha_y < 0)
					OR (botao_k1_baixo = '0' AND botao_k0_cima /= '0' AND vel_esfera_linha_y > 0)
				) THEN
					vel_esfera_linha_y := vel_esfera_linha_y*2;
					vel_esfera_coluna_x := vel_esfera_coluna_x*2;
				END IF;
			END IF;
		END IF;
		-- COLISÃO ENTRE ESFERA E A BARRA --


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

		-- DESENHO DA ESFERA --
		ELSIF ((
				(coluna_int_x > pos_esfera_coluna_x/pos_fator_suavidade)
				AND (coluna_int_x <= tam_esfera_x + pos_esfera_coluna_x/pos_fator_suavidade)
			) AND (
				(linha_int_y >= pos_esfera_linha_y/pos_fator_suavidade)
				AND (linha_int_y < tam_esfera_y + pos_esfera_linha_y/pos_fator_suavidade)
			)
		) THEN
			a <= '1';
		-- DESENHO DA ESFERA --

		-- DESENHO DO CENÁRIO SUPERIOR E INFERIOR --
		ELSIF(
			(linha_int_y <= ORIGEM_LINHA AND linha_int_y >= 0)
			OR (linha_int_y >= FINAL_LINHA AND linha_int_y <= 480)
		) THEN
			a <= '1';
		-- DESENHO DO CENÁRIO SUPERIOR E INFERIOR --

		-- DESENHO DO CENÁRIO DIREITA --
		ELSIF (
			(coluna_int_x >= FINAL_COLUNA AND coluna_int_x <= 640)
		) THEN
			a <= '1';
		-- DESENHO DO CENÁRIO DIREITA --

		ELSE
			a <= '0';
		END IF;
		-- CONDICIONAIS PARA DESENHAR OU NÃO O PIXEL ATUAL NA SAÍDA VGA --

	END PROCESS;

END frameview;