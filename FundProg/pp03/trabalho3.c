#include <stdio.h>
#include <math.h>
#include "imagem.h"
#include "trabalho3.h"

/** Realiza a contagem de veiculos na imagem dada.
 *
 * Parametros: Imagem* img -> imagem onde deve ser realizada a contagem de veiculos.
 *             Imagem* bg -> fundo de da imagem.
 *             int contagem[] -> vetor onde deve ser dito quntos veiculos de cada tipo que tem na imagem
 *
 * Valor de retorno: retorna a quantidade de veiculos que a imagem possui e tambem por referencia quantos
 *                   veiculo de cada tipo que a imagem posui.
 *
 * */

int contaVeiculos(Imagem* img, Imagem* bg, int contagem[]){
    int largura = 0, comprimentoDir = 0, comprimentoEsq = 0, comprimento, total = 0;

    img = removeRuido(img);

    bg = removeRuido(bg);

    img = binarizacao(img, bg);

    /*Estes valores diferentes para inicio e fim do FOR são justificados pelo fato de que estamos interessados
     *apenas na parte onde é possivel ter um veiculo e certamente a borda da imagem não sera gerada com um veiculo nela
     */
    for(int i = 80; i < img->altura-80; i++){
        for(int j = 10; j < img->largura-10; j++){
            if(img->dados[0][i][j] == 255){ //Caso a cor do pixel nao seja branca nao teremos um pixel que pode pertencer a um veiculo
                //Foi usado um loop infinito, pois caso fosse usado um for com a condicao do segundo else if
                //seria necessario realizar muito mais condiçoes, acredito que tenha sido a decisao mais coerente
                //o mesmo eh valido para os outros while's a seguir
                while(1 < 2){ //Loop infinito que é quebrado sempre que nao eh encontrado um pixel
                              //branco nas proximidades de um anterior a esse
                    if(img->dados[0][i+largura][j] == 255) //fixa-se a coluna e busca a largura do veiculo variando a posicao da linha
                        largura++;
                    else if(temBrancoAinda(img, i, j, largura, 0) != 0)//caso tenha encontrado um pixel preto busca-se um branco nas proximidades
                        largura += temBrancoAinda(img, i, j, largura, 0);//soma para a largura a varicao entre a posicao do ultimo pixel branco e o proximo
                    else if(temBrancoAinda(img, i, j, largura, 0) == 0)
                        break;
                }

                //Segue a mesma explicacao do while acima
                while(1 < 2){//aqui fixa-se a linha mais a metade da largura do veiculo como se estivessemos buscando um ponto medio dessa largura
                    if(img->dados[0][(int)(i+(largura/2))][j+comprimentoDir] == 255)//variando apenas a coluna, primeiramente para a direita
                        comprimentoDir++;
                    else if(temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoDir, 1) != 0)//caso tenha encontrado um pixel preto busca-se um branco nas proximidades
                        comprimentoDir += temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoDir, 1);//soma para o comprimento a direita a varicao entre a posicao do ultimo pixel branco e o proximo
                    else if(temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoDir, 1) == 0)
                        break;
                }
                //Segue a mesma explicacao dos while's anteriores
                while(1 < 2){//segue o mesmo processo do anterior com a unica diferenca que eh feito para a esquerda da coluna fixada no primeiro while.
                    if(img->dados[0][(int)(i+(largura/2))][j-comprimentoEsq] == 255)
                        comprimentoEsq++;
                    else if(temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoEsq, 2) != 0)
                        comprimentoEsq += temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoEsq, 2);
                    else if(temBrancoAinda(img, (int)(i+(largura/2)), j, comprimentoEsq, 2) == 0)
                        break;
                }

                comprimento = comprimentoDir+comprimentoEsq;

                if(largura >= 20 && comprimento >= 40){ //Eh de conhecimento, a partir dos testes, que não havera nenhum veiculo
                                       //com comprimento menor que 40, caso seja menor que isso não tem chance de ser um veiculo
                                       //a largura entra nessa primeira condição para evitarmos de computarmos pontos ou apenas falhas
                                       //de binarização em nossa contagem, mas para diferenciar os veiculos não há a necessidade de levar
                                       //em consideração a largura, pelo menos não para os requisitos do trabalho, enretanto acredito que
                                       //seria de maneira facil diferenciar todos os tipos de veiculos presente numa imagem.
                    if(comprimento <= 80) //motocicleta
                        contagem[0]++;
                    else if(comprimento >= 85 && comprimento <= 140)//carros/vans
                        contagem[1]++;
                    else if(comprimento >= 150 && comprimento <= 320)//caminhao menor/onibus
                        contagem[2]++;
                    else if(comprimento >= 330 && comprimento <= 500)//caminhao longo
                        contagem[3]++;
                    total++;
                }
                img = apagaVeiculo(img, i, j, largura, comprimentoDir, comprimentoEsq);

                largura = 0;
                comprimentoDir = 0;
                comprimentoEsq = 0;
            }
        }
    }
    destroiImagem(img);
    destroiImagem(bg);
    return total;
}

/** Verifica após encontrar um pixel de cor preta se ainda há algum outro branco poucas posições a frente.
 *
 * Parametros: Imagem* img -> imagem que esta sendo processada atualmente
 *             int linha  -> linha onde está localizado o pixel branco encontrado inicialmente
 *             int coluna -> coluna onde está localizado o pixel branco encontrado inicialmente
 *             int posicao -> indicador de quantas posicoes além do valor inicial de linha ou coluna
 *                 - foi encontrado o pixel da cor preto
 *             int aux -> variavel indicadora de qual dos tres metodos utilizar quando:
 *                 - aux = 0, então estamos verificando se ha algum outro pixel de cor branco apos um
 *                 - de cor preta verticalmente, ou seja, iremos variar somente a linha que estamos analisando.
 *                 - A explicacao anterior serve para aux = 1 e aux = 2, a unica diferenca se encontra no fato
 *                 - de que qundo aux = 1 estaremos verificando para a direita da 'coluna' e aux = 2 para a esquerda.
 *                 - A NECESSIDADE DE SE TER UM A DIREITA E OUTRO PARA ESQUERDA EH EXPLICADA NA FUNCAO apagaVeiculo
 *
 * Valor de retorno: Retorna zero caso nao tenha mais nenhum outro pixel de cor branca naquela direcao
 *                 ou entao retorna a quantas posicoes do ultimo pixel branco esta o proximo.
 *
 * Explicacao adicional: Esta funcao eh um utilitario para superar as linhas ou falhas de binarizacao que seriam
 *                 encontradas dentro dos veiculos, portanto o valor que essa funcao verifica a frente do ultimo
 *                 pixel de cor branca nao eh alto, para evitar encontrar outro veiculo e continuar sua contagem erroneamente.
 */
int temBrancoAinda(Imagem* img, int linha, int coluna, int posicao, int aux){
    //para todos os casos verifica-se apenas 8 posicoes a frente
    switch(aux){
    case 0: //verificar verticalmentes
        for(int i = linha+posicao; i < (linha+posicao+8); i++){ //i comeca a partir do pixel de cor preta encontrado
            if(img->dados[0][i][coluna] == 255)
                return (i-linha-posicao); //retorno apenas da variacao
        }
    case 1: //verificar horizontalmene a direita da coluna inicial
        for(int i = coluna+posicao; i < coluna+posicao+8; i++){ //igual ao do caso quando aux = 0.
            if(img->dados[0][linha][i] == 255)
                return (i-coluna-posicao); //retorno apenas da variacao
        }
    case 2: //verificar horizontalmene a esquerda da coluna inicial
        for(int i = 0; i < 8; i++){ //caso um pouco distinto, pois queremos verificar em posicoes anteriores daquela inicial
            if(img->dados[0][linha][(coluna-posicao-i)] == 255) //o comentario acima explica essa expressao
                return i; //retorna apenas a variacao
        }
    }
    return 0;
}

/** Realiza a remocao de ruido na imagem dada.
 *
 * Parametros: Imagem* img -> imagem sera aplicada a remocao de ruido.
 *
 * Valor de retorno: retorna a mesma imagem recebida como parametro com uma remocao de ruido aplicada.
 *
 * Explicacao adicional: a remocao de ruido eh feita utilizando o filtro da
 *                      media de uma matriz 11x11 em torno do pixel.
 *                      Eh feito em com todos os pixeis que possuam uma matriz 11x11 em torno de si.
 *
 * */
Imagem* removeRuido(Imagem* img){
    Imagem* retorno;

    //Cria a imagem que sera usada como retorno vazia usando o metodo disponvel em imagem.c
    retorno = criaImagem(img->largura, img->altura, img->n_canais);

    int soma = 0, ordem = 11, aux = 5;

    for(int c = 0; c < img->n_canais; c++){ //Percorre todos os canais da imagem
        for(int i = aux; i < img->altura-aux; i++){ //percorre a altura da imagem comecando da posicao
                                                    //minima para existir uma matriz 11x11 em torno do primeiro pixel.
            for(int j = aux; j < img->largura-aux; j++){ //percorre a largura da imagem
                for(int k = (i-aux); k < i+aux; k++){ //percorre as linhas da matriz 11x11 em torno de um pixel
                    for(int l = (j-aux); l < j+aux; l++) //percorre as colunas da matriz 11x11 em torno de um pixel
                        soma += img->dados[c][k][l]; //soma dos valores da matiz 11x11
                }
                retorno->dados[c][i][j] = (int)(soma/((ordem*ordem))); //aplicacao da media da matriz 11x11 em torno do pixel.
                soma = 0; //zerando a soma para fazermos novamente o processe para os pixeis restantes
            }
        }
    }
    return retorno;
}

/** Realiza a remocao de ruido na imagem dada.
 *
 * Parametros: Imagem* img -> imagem sera aplicada a remocao de ruido.
 *
 * Valor de retorno: retorna a mesma imagem recebida como parametro com uma remocao de ruido aplicada.
 *
 * Explicacao adicional: a remocao de ruido eh feita utilizando o filtro da
 *                      media de uma matriz 11x11 em torno do pixel.
 *                      Eh feito em com todos os pixeis que possuam uma matriz 11x11 em torno de si.
 *
 * */

Imagem* binarizacao(Imagem* img, Imagem* bg){
    int dif = 8; //tamanho do erro que pode ter entre a diferenca de dois pixeis de mesma posicao
                 //entre img e bg para serem considerados iguais.

    Imagem* retorno;

    //Cria a imagem que sera usada como retorno vazia usando o metodo disponvel em imagem.c
    retorno = criaImagem(img->largura, img->altura, img->n_canais);
    for(int i = 0; i < img->altura; i++){
        for(int j = 0; j < img->largura; j++){
            //a taxa de diferenca entre as imagens eh obtida extraindo o modulo da diferenca.
            if((abs(img->dados[0][i][j] - bg->dados[0][i][j])) < dif &&
            abs((img->dados[1][i][j] - bg->dados[1][i][j])) < dif &&
            abs((img->dados[2][i][j] - bg->dados[2][i][j])) < dif){
                retorno->dados[0][i][j] = 0;
                retorno->dados[1][i][j] = 0;
                retorno->dados[2][i][j] = 0;
            } else {
                retorno->dados[0][i][j] = 255;
                retorno->dados[1][i][j] = 255;
                retorno->dados[2][i][j] = 255;
            }
        }
    }

    return retorno;
}

/** Realiza a remocao de um determinado veiculo que se encontra na imagem utilizando.
 *
 * Parametros:  Imagem* img -> imagem sera aplicada a remocao de ruido.
 *              int i -> linha do pixel de cor branca a esquerda mais alto encontrado do veiculo.
 *              int j -> coluna do pixel de cor branca a esquerda mais alto encontrado do veiculo.
 *              int largura -> tamanho do veiculo em lagura (vertical)
 *              int comprimentoDir -> comprimento(horizonal) do veiculo a direita de j na posicao i+(largura/2).
 *              int comprimentoEsq -> comprimento(horizonal) do veiculo a esquerda de j na posicao i+(largura/2)
 *
 * Valor de retorno: retorna a imagem recebida com uma area, determinada por largura, comprimenoDir, comprimenoEsq,
 *                   com base na posicao (i, j), que possui todos os seus pixeis pretos, dando a impressao com a img
 *                   binarizada que foi 'apagado' um veiculo.
 *
 * Explicacao adicional: Apagar os veiculos que já foram computados nos economiza muito trabalho, pois desta forma, eliminamos
 *                       toda uma area de pixeis brancos que deveriamos calcular em seguida.
 *
 * */

Imagem* apagaVeiculo(Imagem* img, int i, int j, int largura, int comprimentoDir, int comprimentoEsq){
    Imagem* retorno;

    int erro = 5;

    retorno = criaImagem(img->largura, img->altura, img->n_canais);

    for(int k = 0; k < img->altura; k++){
        for(int l = 0; l < img->largura; l++){
            retorno->dados[0][k][l] = img->dados[0][k][l];
            retorno->dados[1][k][l] = img->dados[1][k][l];
            retorno->dados[2][k][l] = img->dados[2][k][l];
        }
    }

    for(int k = i-erro; k < i+largura+erro; k++){
        for(int l = j-comprimentoEsq-erro; l < j+comprimentoDir+erro; l++){
            retorno->dados[0][k][l] = 0;
            retorno->dados[1][k][l] = 0;
            retorno->dados[2][k][l] = 0;
        }
    }

    return retorno;
}
