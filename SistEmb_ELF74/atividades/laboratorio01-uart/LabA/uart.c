#include "uart.h"

#define GPIO_PORTA 0x0001

void UART_init(void) 
{
    // Habilitar o clock no módulo UART no registrador RCGCUART (cada bit representa uma UART)
    SYSCTL_RCGCUART_R = SYSCTL_RCGCUART_R0;

    // esperar até que a respectiva UART esteja pronta  para ser acessada no registrador PRUART (cada 
    // bit representa uma UART
    while( (SYSCTL_PRUART_R & SYSCTL_PRUART_R0) != SYSCTL_PRUART_R0) { }

    //Garantir que a UART esteja desabilitada antes de 
    // fazer as alterações (limpar o bit UARTEN) no 
    // registrador UARTCTL (Control).
    UART0_CTL_R = UART0_CTL_R & (!0x1);

    // 3. . Escrever o baud-rate nos registradores UARTIBRD e UARTFBRD
    // 80M /(18*9600) = 
    // 462,962962 = 462 
    // inteiro: 462
    // decimal: 0,962962 * 64 = 61,6 = 62
    UART0_IBRD_R = 520; // parte inteira
    UART0_FBRD_R = 53;  // parte fracionaria

    // 4. Configurar o registrador UARTLCRH para o número de bits, paridade, stop bits e fila
    UART0_LCRH_R = UART0_LCRH_R | (0x3 << 5);   // WLEN = 2_11 : tamanho da palavra: 8bits
    UART0_LCRH_R = UART0_LCRH_R | (0x1 << 4);     // FEN = 1: habilita filas
    //UART0_LCRH_R = UART0_LCRH_R & (!(0x1 << 3));  // STP2 = 0: desabilita 2 stop bits
    UART0_LCRH_R = UART0_LCRH_R | (0x1 << 2);     // EPS = 1: bit de paridade PAR
    UART0_LCRH_R = UART0_LCRH_R | (0x1 << 1);     // PEN = 1: habilita bit de paridade

    // 5. Garantir que a fonte de clock seja o clock do sistema no registrador UARTCC escrevendo 0 
    // (ou escolher qualquer uma das outras fontes de clock)
    UART0_CC_R = 0;

    // 6. Habilitar as flags RXE, TXE e UARTEN no registrador UARTCTL (habilitar a recepção, 
    // transmissão e a UART)
    UART0_CTL_R = UART0_CTL_R | (0x1 << 9); // habilita RX
    UART0_CTL_R = UART0_CTL_R | (0x1 << 8); // habilita TX
    UART0_CTL_R = UART0_CTL_R | (0x1);      // habilita UART0

    // 7. Habilitar o clock no módulo GPIO no registrador RCGGPIO (cada bit representa uma GPIO)
    SYSCTL_RCGCGPIO_R = SYSCTL_RCGCGPIO_R | (GPIO_PORTA);

    // esperar até que a respectiva GPIO esteja pronta para ser acessada no registrador PRGPIO (cada 
    // bit representa uma GPIO).
    while((SYSCTL_RCGCGPIO_R & GPIO_PORTA) != GPIO_PORTA) { }

    // 8. Desabilitar a funcionalidade analógica no  registrador GPIOAMSEL.
    GPIO_PORTA_AHB_AMSEL_R = 0x0;

    // 9. Escolher a função alternativa dos pinos respectivos TX e RX no registrador GPIOPCTL
    // ((verificar a tabela 10-2 no datasheet páginas 743-746))
    GPIO_PORTA_AHB_PCTL_R = GPIO_PORTA_AHB_PCTL_R | (0x11); // 2_0001_0001

    // 10. Habilitar os bits de função alternativa no registrador GPIOAFSEL nos pinos respectivos à 
    // UART
    GPIO_PORTA_AHB_AFSEL_R = GPIO_PORTA_AHB_AFSEL_R | (0x3); // 2_11

    // 11. Configurar os pinos como digitais no registrador GPIODEN
    GPIO_PORTA_AHB_DEN_R = GPIO_PORTA_AHB_DEN_R | (0x3); // 2_11
}

char UART_receive(void) {

    // verifica a possibilidade de leitura
    while ((UART0_FR_R & UART_FR_RXFE) == UART_FR_RXFE) {
    }
    return (UART0_DR_R & 0xFF);
}

void UART_send(char c) {
    // verifica a possibilidade de envio
    while((UART0_FR_R & UART_FR_TXFF) == UART_FR_TXFF) { }
    UART0_DR_R = c;
}

void UART_send_str(char* str) {
    char *ptr = str;
    // percorre ate o fim da string
    while((*ptr) != 0) {
        UART_send(*ptr);
        ptr++;
    }
}

void UART_clear_terminal(void)  {
    /** 
     * "\033[2J" limpa a tela
     * "\033[H" move o cursor para a posição inicial (canto superior esquerdo) do terminal.
    */
    UART_send_str("\033[2J\033[H");
}