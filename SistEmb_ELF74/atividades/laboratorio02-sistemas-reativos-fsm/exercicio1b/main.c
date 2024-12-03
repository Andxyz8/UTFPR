#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"
#include "string.h"

uint32_t SysClock;

// Define uma struct para representar os estados da máquina de estados
typedef enum {
    SENHA_1CH,
    SENHA_2CH,
    SENHA_3CH,
    SENHA_4CH,
    SENHA_INCORRETA,
    SENHA_CORRETA
} State;

// Define o estado inicial do sistema
State state = SENHA_1CH;

#define SENHA "1234"

// Função para escrever uma string na UART
void escreveUART(const char* msg) {
    for (int i = 0; msg[i] != '\0'; i++) {
        UARTCharPut(UART0_BASE, msg[i]);
    }
}

// Manipulador de interrupção da UART
void UARTIntHandler(void) {
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status); // Limpa a interrupção

    // Lê o caractere recebido
    char receivedChar = UARTCharGet(UART0_BASE);

    escreveUART("ENTRADA ");
    escreveUART(&receivedChar);
    escreveUART("\n\r");

    if (state == SENHA_1CH && receivedChar == SENHA[0]) {
        state = SENHA_2CH;
    } else if (state == SENHA_2CH && receivedChar == SENHA[1]) {
        state = SENHA_3CH;
    } else if (state == SENHA_3CH && receivedChar == SENHA[2]) {
        state = SENHA_4CH;
    } else if (state == SENHA_4CH && receivedChar == SENHA[3]) {
        state = SENHA_CORRETA;
    } else if (state == SENHA_INCORRETA && receivedChar == ' ') {
				state = SENHA_1CH;
		} else {
        state = SENHA_INCORRETA;
    }

    // Descreve o estado atual da máquina de estados
    if (state == SENHA_1CH) {
        escreveUART("AGUARDANDO CARACTERE 1\n\r");
    }
    if (state == SENHA_2CH) {
        escreveUART("CARACTERE 1 OK\n\r");
    }
    if (state == SENHA_3CH) {
        escreveUART("CARACTERE 2 OK\n\r");
    } 
    if (state == SENHA_4CH) {
        escreveUART("CARACTERE 3 OK\n\r");
    }
    if (state == SENHA_INCORRETA) {
        escreveUART("SENHA INCORRETA\n\r");
    }
    if (state == SENHA_CORRETA) {
        escreveUART("1\n\r");
    }
}

// Configura a UART
void SetupUart(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_UART0));

    // Configura a UART para 115200 bps
    UARTConfigSetExpClk(
        UART0_BASE,
        SysClock,
        115200,
        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE)
    );
    
    // Habilita interrupções na UART
    UARTIntEnable(UART0_BASE, UART_INT_RX);
    UARTIntRegister(UART0_BASE, UARTIntHandler); // Registra o manipulador de interrupção

    // Configura os pinos da UART
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOA));
    
    GPIOPinConfigure(GPIO_PA0_U0RX); // RX
    GPIOPinConfigure(GPIO_PA1_U0TX); // TX
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);
    
    SetupUart(); // Configura a UART

    while(1) {
        // O loop principal fica vazio; as ações ocorrem nas interrupções da UART.
    }
}