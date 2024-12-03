/**
 * Disciplina: Sistemas Embarcados - DAELN-UTFPR
 * Autor: Prof. Eduardo N. dos Santos
 * 
 * Este programa controla a ativação de LEDs em uma placa Tiva C Series TM4C1294
 * baseado em comandos recebidos via UART. Os comandos determinam O tempo que o led
 * permanece aceso
 * 
 * Utilize um terminal serial para enviar comandos no formato "P1", onde 'P' ou 'B' indica a ação
 * de acender e o número indica a quantidade segundos que o led ficará aceso. 
 * 
 * É necessário apertar a tecla [ENTER] depois do comando para que ele seja enviado.
 * Exemplo: "P3[ENTER]"
 */

#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"
#include "driverlib/systick.h"

#define LED_PORTN GPIO_PORTN_BASE
#define LED_PORTF GPIO_PORTF_BASE
#define LED_PIN_1 GPIO_PIN_1
#define LED_PIN_0 GPIO_PIN_0
#define LED_PIN_4 GPIO_PIN_4

uint32_t SysClock;
volatile unsigned int SysTicks1ms = 0;
unsigned char rxbuffer[3] = {0};
volatile int blinkTime = 0;


void UARTSendString(const char *str);

// Handler UART
void UARTIntHandler(void) { 
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status);
    uint8_t last = (uint8_t)UARTCharGetNonBlocking(UART0_BASE);

    rxbuffer[0] = rxbuffer[1];
    rxbuffer[1] = rxbuffer[2];
    rxbuffer[2] = last;

    if ((rxbuffer[0] == 'P' || rxbuffer[0] == 'B') && rxbuffer[1] >= '1' && rxbuffer[1] <= '9' && rxbuffer[2] == '\r') {
        blinkTime = (rxbuffer[1] - '0') * 1000;
        SysTicks1ms = 0;
        GPIOPinWrite(LED_PORTN, LED_PIN_1 | LED_PIN_0, LED_PIN_1 | LED_PIN_0);
        GPIOPinWrite(LED_PORTF, LED_PIN_4, LED_PIN_4);
    }
}
// Handler SysTick
void SysTickIntHandler(void) {
    SysTicks1ms++;
    if (SysTicks1ms >= blinkTime && blinkTime != 0) {
        GPIOPinWrite(LED_PORTN, LED_PIN_1 | LED_PIN_0, 0);
        GPIOPinWrite(LED_PORTF, LED_PIN_4, 0);
        blinkTime = 0;
        
        UARTCharPut(UART0_BASE, 'O');
        UARTCharPut(UART0_BASE, 'K');
        UARTCharPut(UART0_BASE, '\r');
        UARTCharPut(UART0_BASE, '\n');
        UARTSendString("Teste completo\r\n");
    }
}

void SetupSysTick(void) {
    SysTickPeriodSet(SysClock / 1000);
    SysTickIntRegister(SysTickIntHandler);
    SysTickIntEnable();
    SysTickEnable();
}

void SetupUart(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_UART0));
    UARTConfigSetExpClk(UART0_BASE, SysClock, 115200,(UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    UARTFIFODisable(UART0_BASE);
    UARTIntEnable(UART0_BASE, UART_INT_RX);
    UARTIntRegister(UART0_BASE, UARTIntHandler);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOA));
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);
}

void ConfigLEDs(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    GPIOPinTypeGPIOOutput(LED_PORTN, LED_PIN_1 | LED_PIN_0);
    GPIOPinTypeGPIOOutput(LED_PORTF, LED_PIN_4);
}

// String
void UARTSendString(const char *str) {
    while (*str != '\0') { 
        UARTCharPut(UART0_BASE, *str++);
    }
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);
    
    ConfigLEDs();
    SetupUart();
    SetupSysTick();

    while (1) {
        __asm(" WFI"); // espera por interrupção, modo low power
    }
}
