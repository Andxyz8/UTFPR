/*============================================================================*/
/* IF61C - TRABALHO 3                                                         */
/*----------------------------------------------------------------------------*/
/* Autor: Bogdan T. Nassu - nassu@dainf.ct.utfpr.edu.br                       */
/*============================================================================*/
/** Programa testador para o classificador de veículos. */
/*============================================================================*/

#include <stdio.h>
#include <time.h>

#include "gerador_de_testes.h"
#include "trabalho3.h"

/*============================================================================*/
/* Um modificador para a semente usada pelo gerador de números aleatórios na
 * hora de criar imagens de teste. Todos os trabalhos usarão as mesmas
 * imagens, então o offset precisa ser igual para todos. Entretanto, usaremos
 * um valor diferente na hora de testar os trabalhos de fato. */
#define RANDOM_SEED_OFFSET 8321375

#define N_TESTES 500

#define SALVA_INTERMEDIARIOS 0 /* Flag que diz se devemos salvar as imagens de teste. Desative se for rodar muitos testes! */

/*============================================================================*/

const char* LABELS [] =
{
	"moto",
	"medio",
	"longo",
	"longo2",
};

/*============================================================================*/

int main (){
	int i, j, n_detectados;
	int por_tipo [N_TIPOS_DE_VEICULOS] = {0};

	/* E/S. */
	GeradorDeTestes* gerador;
	Imagem* img;
	Imagem* bg;
	FILE* out_file;

	/* Stats. */
	int total_gerados = 0;
	int veiculos_a_mais = 0;
	int veiculos_a_menos = 0;
	int por_tipo_a_mais [N_TIPOS_DE_VEICULOS];
	int por_tipo_a_menos [N_TIPOS_DE_VEICULOS];
	clock_t tempo_inicio, tempo_total = 0;

    /* Inicialização. */
	gerador = criaGeradorDeTestes ();
	if (!gerador){
		printf ("Nao conseguiu carregar o gerador!\n");
		return (1);
	}

	out_file = fopen ("out.txt", "w");

	for (i = 0; i < N_TIPOS_DE_VEICULOS; i++){
		por_tipo_a_mais [i] = 0;
		por_tipo_a_menos [i] = 0;
	}

    /* Executa os testes. */
	for (i = 0; i < N_TESTES; i++){
		printf ("----- Teste %d\n", i);
        int por_tipo[N_TIPOS_DE_VEICULOS] = {0};
		/* Gera uma imagem de teste. */
		img = geraCasoDeTeste (gerador, i+RANDOM_SEED_OFFSET);
		if (!img){
			printf ("???\n");
			return (1);
		}

		/* Salva (se necessário). */
		if (SALVA_INTERMEDIARIOS){
			char foostring [64];
			sprintf (foostring, "teste%d.bmp", i);
			salvaImagem (img, foostring);
		}


		/* Invoca o testador. */
		bg = getBackground (gerador);
		tempo_inicio = clock();
		n_detectados = contaVeiculos (img, bg, por_tipo);
		tempo_total += clock() - tempo_inicio;

		/* Compara os resultados com o que foi gerado. */
		total_gerados += pegaNVeiculosGerados (gerador);
		if (n_detectados > pegaNVeiculosGerados (gerador)){
			int a_mais = n_detectados - pegaNVeiculosGerados (gerador);
			veiculos_a_mais += a_mais;
			printf ("Deteccoes falsas: %d\n", a_mais);
		} else if (n_detectados < pegaNVeiculosGerados (gerador)){
			int a_menos = pegaNVeiculosGerados (gerador) - n_detectados;
			veiculos_a_menos += a_menos;
			printf ("Nao detectados: %d\n", a_menos);
		}

		for (j = 0; j < N_TIPOS_DE_VEICULOS; j++){
			if (por_tipo [j] > pegaNGerados (gerador, j)){
				int a_mais = por_tipo [j] - pegaNGerados (gerador, j);
				por_tipo_a_mais [j] += a_mais;
				printf ("%s: %d a mais.\n", LABELS [j], a_mais);
			} else if (por_tipo [j] < pegaNGerados (gerador, j)){
				int a_menos = pegaNGerados (gerador, j) - por_tipo [j];
				por_tipo_a_menos [j] += a_menos;
				printf ("%s: %d a menos.\n", LABELS [j], a_menos);
			}
		}

		printf("Motos: %d\n", por_tipo[0]);
		printf("Carros/Vans: %d\n", por_tipo[1]);
		printf("Longo1: %d\n", por_tipo[2]);
		printf("Longao: %d\n\n", por_tipo[3]);

		/* Joga fora as imagens geradas. */
		destroiImagem (img);
		destroiImagem (bg);
	}

	/* Mostra os resultados finais. */
	printf ("----------------------------------------\n");
	printf ("Tempo total: %d\n", (int) tempo_total);
	printf ("Veiculos gerados: %d\n", total_gerados);
	printf ("Deteccoes falsas: %d\n", veiculos_a_mais);
	printf ("Nao detectados: %d\n", veiculos_a_menos);
	printf ("\nPor tipo:\n");
	for (i = 0; i < N_TIPOS_DE_VEICULOS; i++)
		printf ("%s:\t%d a mais, %d a menos.\n", LABELS [i], por_tipo_a_mais [i], por_tipo_a_menos [i]);

    fprintf (out_file, "----------------------------------------\n");
	fprintf (out_file, "Tempo total: %d\n", (int) tempo_total);
	fprintf (out_file, "Veiculos gerados: %d\n", total_gerados);
	fprintf (out_file, "Deteccoes falsas: %d\n", veiculos_a_mais);
	fprintf (out_file, "Nao detectados: %d\n", veiculos_a_menos);
	fprintf (out_file, "\nPor tipo:\n");
	for (i = 0; i < N_TIPOS_DE_VEICULOS; i++)
		fprintf (out_file, "%s:\t%d a mais, %d a menos.\n", LABELS [i], por_tipo_a_mais [i], por_tipo_a_menos [i]);

    fclose (out_file);
	destroiGeradorDeTestes (gerador);
	return (0);
}

/*============================================================================*/
