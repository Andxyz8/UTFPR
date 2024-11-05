#ifndef _UART_H_
#define _UART_H_

#include "tm4c1294ncpdt.h"
#include <stdint.h>

/** @brief inicializa a UART da placa */
void UART_init(void);

/**
 * @brief faz leitura do buffer da UART
 * @return caractere lido ou -1 caso não seja possível ler
*/
char UART_receive(void);

/**
 * @brief faz a escrita do caractere via UART
 * @param c caractere a ser enviado
*/
void UART_send(char c);

/**
 * @brief faz a escrita da string via UART
 * @param str ponteiro para a string
*/
void UART_send_str(char* str);

/** 
 * @brief Comando para limpar o terminal (By CHATGPT)
*/
void UART_clear_terminal(void);


#endif //_UART_H_