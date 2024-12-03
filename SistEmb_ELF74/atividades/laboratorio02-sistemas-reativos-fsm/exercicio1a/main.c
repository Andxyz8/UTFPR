#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"

//#define UART0_BASE 0x4000C000 // Endereço base da UART0

uint32_t SysClock;

// Define uma struct para representar os estados da máquina de estados
typedef enum {
    STATE_E0E1,
    STATE_O0E1,
    STATE_E0O1,
    STATE_O0O1
} State;

// Define o estado inicial do sistema
State state = STATE_E0E1;

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

    // Descreve o estado atual da máquina de estados
    if (state == STATE_E0E1) {
        escreveUART("ANTES E0E1\n\r");
    }
    if (state == STATE_O0E1) {
        escreveUART("ANTES O0E1\n\r");
    }
    if (state == STATE_E0O1) {
        escreveUART("ANTES E0O1\n\r");
    }
    if (state == STATE_O0O1) {
        escreveUART("ANTES O0O1\n\r");
    }

    escreveUART("ENTRADA ");
    escreveUART(&receivedChar);
    escreveUART("\n\r");

    if (state == STATE_E0E1 && receivedChar == '0') {
        state = STATE_O0E1;
    } else if (state == STATE_E0E1 && receivedChar == '1') {
        state = STATE_E0O1;
    } else if (state == STATE_O0E1 && receivedChar == '0') {
        state = STATE_E0E1;
    } else if (state == STATE_O0E1 && receivedChar == '1') {
        state = STATE_O0O1;
    } else if (state == STATE_E0O1 && receivedChar == '0') {
        state = STATE_O0O1;
    } else if (state == STATE_E0O1 && receivedChar == '1') {
        state = STATE_E0E1;
    } else if (state == STATE_O0O1 && receivedChar == '0') {
        state = STATE_E0O1;
    } else if (state == STATE_O0O1 && receivedChar == '1') {
        state = STATE_O0E1;
    } else {
        escreveUART("Entrada Desconhecida...\n\r");
    }

    // Descreve o estado atual da máquina de estados
    if (state == STATE_E0E1) {
        escreveUART("DEPOIS E0E1\n\r");
    }
    if (state == STATE_O0E1) {
        escreveUART("DEPOIS O0E1\n\r");
    }
    if (state == STATE_E0O1) {
        escreveUART("DEPOIS E0O1\n\r");
    } 
    if (state == STATE_O0O1) {
        escreveUART("DEPOIS O0O1\n\r");
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