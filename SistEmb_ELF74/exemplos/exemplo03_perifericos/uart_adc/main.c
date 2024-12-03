/**
 * Disciplina: Sistemas Embarcados - DAELN-UTFPR
 * Autor: Prof. Eduardo N. dos Santos
 * 
 * Este programa exemplifica o uso do ADC na placa Tiva C Series TM4C1294
 * utilizando TIMER enviado os dados para a UART
 * 
 */

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"
#include "driverlib/timer.h"
#include "driverlib/adc.h"

#define ADC_SEQUENCER 3 // Usando o sequenciador 3 do ADC para uma única amostra

uint32_t SysClock;

void UARTIntHandler(void) {
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status);
}

void Timer0IntHandler(void) {
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT); //clear interrupcao do timer

    uint32_t adcValue;
    ADCProcessorTrigger(ADC0_BASE, ADC_SEQUENCER); // inicia o processo de conversao
    while(!ADCIntStatus(ADC0_BASE, ADC_SEQUENCER, false)); //espera a conversao finalizar
    ADCIntClear(ADC0_BASE, ADC_SEQUENCER); // clear a interrupcao do ADC
    ADCSequenceDataGet(ADC0_BASE, ADC_SEQUENCER, &adcValue); //pega o valor lido

    char buffer[10];
    int len = snprintf(buffer, sizeof(buffer), "%u\r\n", adcValue);
    for (int i = 0; i < len; i++) {
        UARTCharPut(UART0_BASE, buffer[i]);
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
    uint32_t timerPeriod = SysClock / 100; 
    TimerLoadSet(TIMER0_BASE, TIMER_A, timerPeriod - 1);
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    TimerIntRegister(TIMER0_BASE, TIMER_A, Timer0IntHandler);
    TimerEnable(TIMER0_BASE, TIMER_A);
}

void SetupADC(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_ADC0));
    ADCSequenceConfigure(ADC0_BASE, ADC_SEQUENCER, ADC_TRIGGER_PROCESSOR, 0);
    ADCSequenceStepConfigure(ADC0_BASE, ADC_SEQUENCER, 0, ADC_CTL_CH0 | ADC_CTL_IE | ADC_CTL_END);
    ADCSequenceEnable(ADC0_BASE, ADC_SEQUENCER);
    ADCIntClear(ADC0_BASE, ADC_SEQUENCER);
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);
    
    SetupUart();
    SetupTimer();
    SetupADC();

    while(1) 
    {        
    }
}
