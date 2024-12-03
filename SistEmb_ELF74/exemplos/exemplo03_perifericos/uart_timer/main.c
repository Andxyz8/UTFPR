/**
 * Disciplina: Sistemas Embarcados - DAELN-UTFPR
 * Autor: Prof. Eduardo N. dos Santos
 * 
 * Este programa controla a ativação de LEDs em uma placa Tiva C Series TM4C1294
 * baseado em comandos recebidos via UART e temporizações ajustadas por um timer.
 *
 * Os LEDs piscam um número especificado de vezes conforme o comando recebido via UART,
 * onde o número de piscadas é determinado pelo caractere numérico (1 a 9) recebido.
 
 * Não é necessário apertar a tecla [ENTER] depois do comando.
 */

#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"
#include "driverlib/timer.h"

#define LED_PORTN      GPIO_PORTN_BASE
#define LED_PORTF      GPIO_PORTF_BASE
#define LED_PIN_1      GPIO_PIN_1
#define LED_PIN_0      GPIO_PIN_0
#define LED_PIN_4      GPIO_PIN_4

uint32_t SysClock;
volatile int blinkCount = 0;
volatile bool ledState = false;

void UARTIntHandler(void) {
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status);
    char cmd = (char)UARTCharGetNonBlocking(UART0_BASE);
    if (cmd >= '1' && cmd <= '9') {
        blinkCount = cmd - '0';  
    }
}

void Timer0IntHandler(void) {
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);

    if (blinkCount > 0) {
        ledState = !ledState;  
        uint32_t ledVal = ledState ? (LED_PIN_1 | LED_PIN_0 | LED_PIN_4) : 0;
        GPIOPinWrite(LED_PORTN, LED_PIN_1 | LED_PIN_0, ledVal);
        GPIOPinWrite(LED_PORTF, LED_PIN_4, ledVal);
        if (!ledState) {
            blinkCount--;  
        }
    } else {
        GPIOPinWrite(LED_PORTN, LED_PIN_1 | LED_PIN_0, 0);
        GPIOPinWrite(LED_PORTF, LED_PIN_4, 0);
    }
}

void SetupUart(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_UART0));
    UARTConfigSetExpClk(UART0_BASE, SysClock, 115200,
        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    UARTFIFODisable(UART0_BASE);
    UARTIntEnable(UART0_BASE, UART_INT_RX);
    UARTIntRegister(UART0_BASE, UARTIntHandler);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOA));
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);
}

void SetupTimer(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_TIMER0));
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
    uint32_t timerPeriod = SysClock / 2; // 0.5 segundos
    TimerLoadSet(TIMER0_BASE, TIMER_A, timerPeriod - 1);
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    TimerIntRegister(TIMER0_BASE, TIMER_A, Timer0IntHandler);
    TimerEnable(TIMER0_BASE, TIMER_A);
}

void ConfigLEDs(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPION) || !SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF));
    GPIOPinTypeGPIOOutput(LED_PORTN, LED_PIN_1 | LED_PIN_0);
    GPIOPinTypeGPIOOutput(LED_PORTF, LED_PIN_4);
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);
    
    ConfigLEDs();
    SetupUart();
    SetupTimer();

    while(1) 
	  {        
    }
}
