#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "cmsis_os2.h"
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"

#define LED_PIN_0 GPIO_PIN_0
#define LED_PIN_1 GPIO_PIN_1
#define LED_PIN_4 GPIO_PIN_4

#define LED_PORTN GPIO_PORTN_BASE
#define LED_PORTF GPIO_PORTF_BASE

uint32_t SysClock;
uint32_t periodo_led1;
uint32_t periodo_led2;
uint32_t periodo_led3;


// Inicializa os LEDS
void SetupLEDs(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPION);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    while(!SysCtlPeripheralReady(SYSCTL_PERIPH_GPION) || !SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOF));
    GPIOPinTypeGPIOOutput(LED_PORTN, LED_PIN_1 | LED_PIN_0);
    GPIOPinTypeGPIOOutput(LED_PORTF, LED_PIN_4);
    GPIOPinWrite(LED_PORTN, LED_PIN_1 | LED_PIN_0, 0);
    GPIOPinWrite(LED_PORTF, LED_PIN_4, 0);
}

// Inicializa os intervalos de acionamento dos leds
void SetupLedIntervals(void) {
    periodo_led1 = osKernelGetTickFreq();
    periodo_led2 = periodo_led1/4;
    periodo_led3 = periodo_led1/2;
}

void Thread_LED1(void *argument) {
    while (true) {
        GPIOPinWrite(LED_PORTN, LED_PIN_1, LED_PIN_1);
        osDelay(periodo_led1);
        GPIOPinWrite(LED_PORTN, LED_PIN_1, 0);
        osDelay(periodo_led1);
    }
}

void Thread_LED2(void *argument) {
    while (true) {
        GPIOPinWrite(LED_PORTN, LED_PIN_0, LED_PIN_0);
        osDelay(periodo_led2);
        GPIOPinWrite(LED_PORTN, LED_PIN_0, 0);
        osDelay(periodo_led2);
    }
}

void Thread_LED3(void *argument) {
    while (true) {
        GPIOPinWrite(LED_PORTF, LED_PIN_4, LED_PIN_4);
        osDelay(periodo_led3);
        GPIOPinWrite(LED_PORTF, LED_PIN_4, 0);
        osDelay(periodo_led3);
    }
}

int main(void) {
    // Configura o clock do sistema
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);

    SetupLEDs();

    //inicializa o RTOS
    osKernelInitialize();

    SetupLedIntervals();

    // Cria as threads
    osThreadNew(Thread_LED1, NULL, NULL);

    osThreadNew(Thread_LED2, NULL, NULL);

    osThreadNew(Thread_LED3, NULL, NULL);

    osKernelStart();

    while (1);
}
