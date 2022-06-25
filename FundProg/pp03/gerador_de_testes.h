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

#ifndef __GERADOR_DE_TESTES_H
#define __GERADOR_DE_TESTES_H

/*============================================================================*/

#include "imagem.h"
#include "trabalho3.h"

/*============================================================================*/

typedef struct
{
	Imagem* background;
	Imagem* path;
	Imagem** img_veiculos;
	int contagem_de_veiculos [N_TIPOS_DE_VEICULOS];
	int n_gerados;

} GeradorDeTestes;

/*============================================================================*/

GeradorDeTestes* criaGeradorDeTestes ();
void destroiGeradorDeTestes (GeradorDeTestes* g);
Imagem* geraCasoDeTeste (GeradorDeTestes* g, int seed);
Imagem* getBackground (GeradorDeTestes* g);
int pegaNVeiculosGerados (GeradorDeTestes* g);
int pegaNGerados (GeradorDeTestes* g, int tipo_veiculo);

/*============================================================================*/
#endif /* __GERADOR_DE_TESTES_H */
