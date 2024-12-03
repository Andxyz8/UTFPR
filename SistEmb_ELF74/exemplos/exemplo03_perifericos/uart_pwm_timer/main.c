/*
 * Disciplina: Sistemas Embarcados - DAELN-UTFPR
 * Autor: Prof. Eduardo N. dos Santos
 * 
 * Este programa exemplifica o uso do PWM com interrupções de Timers na placa Tiva C Series TM4C1294
 * Monitore PG1 através de um osciloscópio ou use um LED para avaliar seu efeito.
 * 
 */

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/pwm.h"
#include "driverlib/pin_map.h"
#include "driverlib/timer.h"
#include "driverlib/uart.h"
#include "driverlib/interrupt.h"

#define PWM_FREQUENCY 12000 // Frequencia do PWM

uint32_t SysClock;
volatile uint32_t g_ui32PWMDutyCycle = 0; // Var. para guardar o status do DutyCycle
bool g_bFadeUp = true; //Controle e direcao do fade.

void setupPWM(void);
void setupTimer(void);
void setupUART(void);
void Timer0IntHandler(void);
void UARTSend(const char *pui8Buffer);

int main(void) {
    // Configuração do clock do sistema para 120 MHz
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_480), 120000000);
    setupUART(); 
    setupPWM();      
	  setupTimer();

    while (1) {
        // Loop principal que não faz nada, todos os ajustes de PWM são gerenciados pela interrupção do timer
    }
}
void setupPWM(void) {
    // Habiplita PWM e o port do PWM
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOG);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_PWM0);
    GPIOPinTypePWM(GPIO_PORTG_BASE, GPIO_PIN_1);
    GPIOPinConfigure(GPIO_PG1_M0PWM5);
    // Configura o clock do PWM 
    SysCtlPWMClockSet(SYSCTL_PWMDIV_2); 

    // Configura gerador PWM
    uint32_t pwmPeriod = (SysClock/1) / PWM_FREQUENCY;  // Adjust clock division here
    PWMGenConfigure(PWM0_BASE, PWM_GEN_2, PWM_GEN_MODE_DOWN);
    PWMGenPeriodSet(PWM0_BASE, PWM_GEN_2, pwmPeriod);
    PWMPulseWidthSet(PWM0_BASE, PWM_OUT_5, g_ui32PWMDutyCycle);
    PWMOutputState(PWM0_BASE, PWM_OUT_5_BIT, true);
    PWMGenEnable(PWM0_BASE, PWM_GEN_2);

    char debugBuffer[100];
    sprintf(debugBuffer, "Set PWM Period: %u\r\n", pwmPeriod);
    UARTSend(debugBuffer);
}

void setupTimer(void) {
    // Habilitação o Timer 0 
    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
    TimerLoadSet(TIMER0_BASE, TIMER_A, SysClock / 120);  //para 1 segundo
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    TimerIntRegister(TIMER0_BASE, TIMER_A, Timer0IntHandler);
    TimerEnable(TIMER0_BASE, TIMER_A);
}

void Timer0IntHandler(void) {
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT); // Clear na interrupção (tira o dedo da campainha)

    uint32_t maxPeriod = PWMGenPeriodGet(PWM0_BASE, PWM_GEN_2);	  
	
    uint32_t increment = maxPeriod / 100;  // ncremento baseado no período do PWM1000 = 10 s  100 = 1s
    if (g_bFadeUp) {
        if (g_ui32PWMDutyCycle + increment <= maxPeriod) {
            g_ui32PWMDutyCycle += increment;
        } else {
            g_ui32PWMDutyCycle = maxPeriod;
            g_bFadeUp = false;
        }
    } else {
        if (g_ui32PWMDutyCycle > increment) {
            g_ui32PWMDutyCycle -= increment;
        } else {
            g_ui32PWMDutyCycle = 0;
            g_bFadeUp = true;
        }
    }

    PWMPulseWidthSet(PWM0_BASE, PWM_OUT_5, g_ui32PWMDutyCycle);

    char buffer[50];
    sprintf(buffer, "Duty Cycle: %u\r\n", g_ui32PWMDutyCycle); 
    UARTSend(buffer);
}

void setupUART(void) {
    // Configuração da UART0 em GPIOA 
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    // 115200, 8-N-1 
    UARTConfigSetExpClk(UART0_BASE, SysClock, 115200,
                        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    UARTIntEnable(UART0_BASE, UART_INT_RX | UART_INT_RT);
}

void UARTSend(const char *pui8Buffer)
// Função para enviar strings via UART
{
    while (*pui8Buffer) {
        UARTCharPut(UART0_BASE, *pui8Buffer++);
    }
}
