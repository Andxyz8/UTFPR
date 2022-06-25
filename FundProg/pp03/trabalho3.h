/*============================================================================*/
/* MÓDULO CLASSIFICADOR DE VEÍCULOS                                           */
/*----------------------------------------------------------------------------*/
/* Autor: Bogdan T. Nassu - nassu@dainf.ct.utfpr.edu.br                       */
/*============================================================================*/

#ifndef __TRABALHO3_H
#define __TRABALHO3_H

/*============================================================================*/

#include "imagem.h"

/*============================================================================*/
/* Tipos de veículos. */

#define N_TIPOS_DE_VEICULOS 4

/*============================================================================*/
/* Função central do trabalho. */

int contaVeiculos(Imagem* img, Imagem* bg, int contagem [N_TIPOS_DE_VEICULOS]);
int temBrancoAinda(Imagem* img, int linha, int coluna, int posicao, int aux);
Imagem* removeRuido(Imagem* img);
Imagem* binarizacao(Imagem* img, Imagem* bg);
Imagem* apagaVeiculo(Imagem* img, int i, int j, int largura, int comprimentoDir, int comprimentoEsq);

/*============================================================================*/
#endif /* __TRABALHO3_H */
