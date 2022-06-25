/*============================================================================*/
/* GERADOR DE CASOS DE TESTE PARA O PROBLEMA DO CLASSIFICADOR DE VEÍCULOS     */
/*----------------------------------------------------------------------------*/
/* Autor: Bogdan T. Nassu - nassu@dainf.ct.utfpr.edu.br                       */
/*============================================================================*/
/** Um gerador de casos de teste para o problema do classificador de veículos.
 * O gerador funciona abrindo uma imagem de referência e adicionando sobre ela
 * imagens de veículos, além de algum ruído. A quantidade e os tipos de
 * veículos gerados é armazenada, para futura comparação. O código deste
 * módulo ficou um pouco "ingênuo", porque decidi mantê-lo compacto e sem
 * precisar tratar de fatores como escala e rotação. */
/*============================================================================*/

#include <stdlib.h>
#include <math.h>

#include "gerador_de_testes.h"

/*============================================================================*/

#define CHANCE_MOD 50 /* Quanto maior, maior a chance de gerar imagens com muitos veículos. */
#define PARAMETRO_SUAVIZACAO 50 /* Quanto menor, mais borradas as imagens tendem a ficar. */
#define SIGMA_RUIDO 10 /* Quanto maior, mais ruído. */
#define DISTANCIA_ENTRE_VEICULOS 5

/* Estes parâmetros se referem às imagens usadas pelo gerador. Idealmente, este
 tipo de coisa não deveria ficar no fonte, mas aqui o ganho em generalidade que
 teríamos usando um arquivo de configurações simplesmente não compensaria a
 complexidade extra! */

#define BACKGROUND_FILE "gen/back1.bmp"
#define PATHS_FILE "gen/path1.bmp"

#define N_VEICULOS 7

char* VEICULOS [] =
{
	"gen/VEI1.BMP",
	"gen/VEI2.BMP",
	"gen/VEI3.BMP",
	"gen/VEI4.BMP",
	"gen/VEI5.BMP",
	"gen/VEI6.BMP",
	"gen/VEI7.BMP",
};

typedef enum
{
	MOTO,
	VEICULO_M,
	VEICULO_G,
	VEICULO_GG,
} TiposDeVeiculos;

int TIPOS_VEICULOS [] =
{
	VEICULO_G,
	VEICULO_M,
	VEICULO_M,
	MOTO,
	VEICULO_M,
	VEICULO_G,
	VEICULO_GG,
};

/*============================================================================*/

void povoaImagem (GeradorDeTestes* g, Imagem* img);
int insereVeiculo (GeradorDeTestes* g, Imagem* img, int row_v, int col_v);
Imagem* copiaImagem (Imagem* img);
void suavizaImagem (Imagem* img);
double rand_normal (double mean, double stddev);
void adicionaRuido (Imagem* img);

#define MIN(a,b) ((a<b)?a:b)
#define MAX(a,b) ((a>b)?a:b)

/*============================================================================*/
/** Cria um gerador de testes.
 *
 * Parâmetros: nenhum.
 *
 * Valor de retorno: ponteiro para o gerador de testes criado. */

GeradorDeTestes* criaGeradorDeTestes ()
{
	int i;
	GeradorDeTestes* g;
	g = (GeradorDeTestes*) malloc (sizeof (GeradorDeTestes));

	g->n_gerados = 0;
	for (i = 0; i < N_TIPOS_DE_VEICULOS; i++)
		g->contagem_de_veiculos [i] = 0;

	/* Lê já TODAS as imagens de veículos. É mais eficiente que ler tudo de novo para cada imagem gerada... */
	g->img_veiculos = (Imagem**) malloc (sizeof (Imagem*) * N_VEICULOS);
	for (i = 0; i < N_VEICULOS; i++)
	{
		g->img_veiculos [i] = abreImagem (VEICULOS [i]);
		if (!g->img_veiculos [i])
			return (NULL);
	}

	/* Lê o fundo e a imagem dos caminhos. */
	g->background = abreImagem (BACKGROUND_FILE);
	g->path = abreImagem (PATHS_FILE);

	return (g);
}

/*----------------------------------------------------------------------------*/
/** Desaloca um gerador de testes.
 *
 * Parâmetros: GeradorDeTestes* g: gerador de testes a destruir.
 *
 * Valor de retorno: nenhum. */

void destroiGeradorDeTestes (GeradorDeTestes* g)
{
	int i;

	free (g->background);
	free (g->path);

	/* Joga fora as imagens dos veículos. */
	for (i = 0; i < N_VEICULOS; i++)
		destroiImagem (g->img_veiculos [i]);
	free (g->img_veiculos);

	free (g);
}

/*----------------------------------------------------------------------------*/
/** Função central do gerador, cria uma imagem de testes.
 *
 * Parâmetros: GeradorDeTestes* g: o gerador a usar.
 *             int seed: a semente para o gerador de números aleatórios.
 *
 * Valor de retorno: a imagem criada. O chamador é responsável por desalocá-la. */

Imagem* geraCasoDeTeste (GeradorDeTestes* g, int seed)
{
	Imagem* img;

	srand (seed);

	/* Copia a imagem do fundo. */
	img = copiaImagem (g->background);
	if (!img)
		return (NULL);

	/* Povoa a imagem com veículos. */
	povoaImagem (g, img);

	/* Suaviza um pouco a imagem. */
	suavizaImagem (img);

	/* Adiciona um pouco de ruído. */
	adicionaRuido (img);

	return (img);
}

/*----------------------------------------------------------------------------*/
/** Apenas uma sub-parte da geraCasoDeTeste, esta função povoa uma imagem com
 * veículos.
 *
 * Parâmetros: GeradorDeTestes* g: o gerador usado.
 *             Imagem* img: imagem a povoar.
 *
 * Valor de retorno: nenhum. O gerador de testes passado tem vários campos atualizados, e a imagem é alterada. */

void povoaImagem (GeradorDeTestes* g, Imagem* img)
{
	int chance, i;
	unsigned long row, col;

	for (i = 0; i < N_TIPOS_DE_VEICULOS; i++)
		g->contagem_de_veiculos [i] = 0;
	g->n_gerados = 0;

	/* Define a chance de inserir um veículo em cada ponto do caminho... */
	chance = rand () % CHANCE_MOD;

	/* Percorre a imagem procurando por pixels de caminho. */
	for (row = 0; row < g->path->altura; row++)
		for (col = 0; col < g->path->largura; col++)
			if (g->path->dados [0][row][col] && rand () % 1000 < chance)
			{
				int offset = insereVeiculo (g, img, row, col);
				col += offset;
				if (offset != DISTANCIA_ENTRE_VEICULOS)
					g->n_gerados++;
			}
}

/*----------------------------------------------------------------------------*/
/** Sub-parte da povoaImagem, coloca UM veículo na imagem. O centro do veículo
 * é posicionado sobre a linha dada, com o canto esquerdo na coluna dada.
 *
 * Parâmetros: GeradorDeTestes* g: o gerador usado.
 *             Imagem* img: imagem a povoar.
 *             int row_v: linha da imagem.
 *             int col_v: coluna da imagem.
 *
 * Valor de retorno: um modificador para a direita, que diz onde novos veículos podem aparecer. O gerador de testes passado tem alguns campos atualizados, e a imagem é alterada. */

int insereVeiculo (GeradorDeTestes* g, Imagem* img, int row_v, int col_v)
{
	unsigned long row, col;
	Imagem* img_veiculo;
	int pega_r, pega_g, pega_b;

	/* Escolhe um veículo para colocar na imagem... */
	int tipo_veiculo = rand () % N_VEICULOS;
	img_veiculo = g->img_veiculos [tipo_veiculo];

	/* Verifica se este veículo vai caber aqui... */
	if (col_v + img_veiculo->largura >= g->path->largura || !g->path->dados [0][row_v][col_v + img_veiculo->largura])
		return (DISTANCIA_ENTRE_VEICULOS);

	/* Verifica se este veículo vai caber aqui... */
	if (TIPOS_VEICULOS [tipo_veiculo] >= 0)
		g->contagem_de_veiculos [TIPOS_VEICULOS [tipo_veiculo]]++;

	/* Define uma variação de cor. Nos arquivos originais, o canal dominante é
	 o R, o G é o intermediário, e o B é o canal mais fraco. Para gerar as
	 variações, selecionamos um canal aleatório da imagem original para cada
	 canal da imagem colada. */
	do
	{
		pega_r = rand () % 3;
		pega_g = rand () % 3;
		pega_b = rand () % 3;
	} while (pega_r == pega_g && pega_g == pega_b); /* Evita que os 3 canais sejam iguais. Meio irrealista, mas evitamos com isso alguns tons de cinza complicados, confundidos com o asfalto! */

	/* Cola. */
	for (row = 0; row < img_veiculo->altura; row++)
		for (col = 0; col < img_veiculo->largura; col++)
		{
			unsigned long x = col_v + col;
			unsigned long y = row_v - img_veiculo->altura/2 + row;

			if (x >= 0 && x < img->largura && y >= 0 && y < img->altura)
			{
				/* Magenta == translúcido. */
				if (img_veiculo->dados [CANAL_R][row][col] == img_veiculo->dados [CANAL_B][row][col] &&
					img_veiculo->dados [CANAL_G][row][col] == 0)
				{
					float tone = img_veiculo->dados [CANAL_R][row][col] / 255.0f;
					img->dados [0][y][x] = (int) (img->dados [0][y][x] * tone);
					img->dados [1][y][x] = (int) (img->dados [1][y][x] * tone);
					img->dados [2][y][x] = (int) (img->dados [2][y][x] * tone);

				}
				else
				{
					img->dados [CANAL_R][y][x] = img_veiculo->dados [pega_r][row][col];
					img->dados [CANAL_G][y][x] = img_veiculo->dados [pega_g][row][col];
					img->dados [CANAL_B][y][x] = img_veiculo->dados [pega_b][row][col];
				}
			}
		}

	return (img_veiculo->largura + DISTANCIA_ENTRE_VEICULOS);
}

/*----------------------------------------------------------------------------*/
/** Cria uma cópia da imagem dada.
 *
 * Parâmetros: Imagem* img: imagem a copiar.
 *
 * Valor de retorno: uma cópia da imagem dada, NULL se não puder criar. Precisa ser desalocada pelo chamador. */

Imagem* copiaImagem (Imagem* img)
{
	unsigned long i, j, k;
	Imagem* copia;

	copia = criaImagem (img->largura, img->altura, img->n_canais);

	if (!copia)
		return (NULL);

	for (i = 0; i < copia->n_canais; i++)
		for (j = 0; j < copia->altura; j++)
			for (k = 0; k < copia->largura; k++)
				copia->dados [i][j][k] = img->dados [i][j][k];

	return (copia);
}

/*----------------------------------------------------------------------------*/
/** Suaviza a imagem com um filtro 3x3. O peso do pixel central é escolhido
 * aleatoriamente, ou seja, a imagem pode ficar mais ou menos borrada.
 *
 * Parâmetros: Imagem* img: imagem a suavizar.
 *
 * Valor de retorno: a imagem suavizada. */

void suavizaImagem (Imagem* img)
{
	unsigned long row, col;
	int canal, peso_centro;
	Imagem* copia; /* Precisamos guardar os dados originais. Seria bem mais eficiente guardar apenas uma janela, mas copiar tudo é bem mais simples... */
	copia = copiaImagem (img);

	peso_centro = rand () % PARAMETRO_SUAVIZACAO + 6;
	for (canal = 0; canal < img->n_canais; canal++)
		for (row = 1; row < img->altura-1; row++)
			for (col = 1; col < img->largura-1; col++)
				img->dados [canal][row][col] = (copia->dados [canal][row-1][col-1] +
				                                copia->dados [canal][row-1][col]*2 +
												copia->dados [canal][row-1][col+1] +
			                                    copia->dados [canal][row][col-1]*2 +
												copia->dados [canal][row][col]*peso_centro +
												copia->dados [canal][row][col+1]*2 +
												copia->dados [canal][row+1][col-1] +
												copia->dados [canal][row+1][col]*2 +
												copia->dados [canal][row+1][col+1])/(peso_centro + 12);
	destroiImagem (copia);
}

/*----------------------------------------------------------------------------*/
/** Adiciona ruído a uma imagem.
 *
 * Parâmetros: Imagem* img: imagem à qual adicionaremos ruído.
 *
 * Valor de retorno: nenhum. */

void adicionaRuido (Imagem* img)
{
	unsigned long row, col, canal;

	for (canal = 0; canal < img->n_canais; canal++)
		for (row = 0; row < img->altura; row++)
			for (col = 0; col < img->largura; col++)
			{
				double ruido = rand_normal (0, SIGMA_RUIDO);
				img->dados [canal][row][col] = (unsigned char) (MIN (255, MAX (0, img->dados [canal][row][col] + ruido)));
			}
}

/*----------------------------------------------------------------------------*/
/** Código copiado de outro lugar para gerar números aleatórios seguindo uma
 * distribuição normal. Original em:
 * en.literateprograms.org/Box-Muller_transform_%28C%29#chunk%20use:complete%20Box-Muller%20function */

double rand_normal (double mean, double stddev)
{
	static double n2 = 0.0;
	static int n2_cached = 0;
	if (!n2_cached) {
		double x, y, r;
		do {
			x = 2.0*rand()/RAND_MAX - 1;
			y = 2.0*rand()/RAND_MAX - 1;
			r = x*x + y*y;
		} while (r == 0.0 || r > 1.0);
		{
			double result;
			double d = sqrt(-2.0*log(r)/r);
			double n1 = x*d;
			n2 = y*d;
			result = n1*stddev + mean;
			n2_cached = 1;
			return result;
		}
	}
	else {
		n2_cached = 0;
		return n2*stddev + mean;
	}
}

/*----------------------------------------------------------------------------*/
/** Retorna uma cópia do último background usado. A imagem deve ser desalocada
 * pelo chamador!
 *
 * Parâmetros: GeradorDeTestes* g: gerador cujo background vamos copiar.
 *
 * Valor de retorno: uma cópia do último background usado. Lembre-se de desalocá-lo! */

Imagem* getBackground (GeradorDeTestes* g)
{
	return (copiaImagem (g->background));
}

/*----------------------------------------------------------------------------*/
/** Retorna o número de veículos gerados na última chamada ao gerador.
 *
 * Parâmetros: GeradorDeTestes* g: gerador cujo número de veículos queremos obter.
 *
 * Valor de retorno: o número de veículos gerados. */

int pegaNVeiculosGerados (GeradorDeTestes* g)
{
	return (g->n_gerados);
}

int pegaNGerados (GeradorDeTestes* g, int tipo_veiculo)
{
	if (tipo_veiculo >= 0 && tipo_veiculo < N_TIPOS_DE_VEICULOS)
		return (g->contagem_de_veiculos [tipo_veiculo]);
	return (0);
}

/*============================================================================*/
