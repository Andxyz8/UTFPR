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

osMessageQueueId_t queueFactorial;
osMessageQueueId_t queueFibonacci;
osMessageQueueId_t queueResp;

uint32_t SysClock;  


void UARTIntHandler(void) {
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status);
    char cmd = (char)UARTCharGetNonBlocking(UART0_BASE);
    if (cmd >= '1' && cmd <= '9') {
        uint32_t num = cmd - '0';  
        osMessageQueuePut(queueFactorial, &num, 0, 0);
        osMessageQueuePut(queueFibonacci, &num, 0, 0);
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

void Thread_Factorial(void *argument) {
    uint32_t num;
    while (true) {
        osStatus_t status = osMessageQueueGet(queueFactorial, &num, NULL, 1000); // Espera 1 segundo
        if (status == osOK) {
            uint32_t result = 1;
            for (uint32_t i = 1; i <= num; i++) {
                result *= i;
            }
            osMessageQueuePut(queueResp, &result, 0, 0);
        }
    }
}

void Thread_Fibonacci(void *argument) {
    uint32_t num;
    while (true) {
        osStatus_t status = osMessageQueueGet(queueFibonacci, &num, NULL, 1000); // Espera 1 segundo
        if (status == osOK) {
            uint32_t a = 0, b = 1, result = num;
            for (uint32_t i = 2; i <= num; i++) {
                result = a + b;
                a = b;
                b = result;
            }
            osMessageQueuePut(queueResp, &result, 0, 0);
        }
    }
}

void Thread_UARTWrite(void *argument) {
    uint32_t result;
    while (true) {
        osStatus_t status = osMessageQueueGet(queueResp, &result, NULL, osWaitForever);
        if (status == osOK) {
            char buffer[50];
            snprintf(buffer, sizeof(buffer), "Result: %u\r\n", result);
            for (char *p = buffer; *p; p++) {
                while (!UARTCharPutNonBlocking(UART0_BASE, *p));
            }
        }
    }
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);
    
    SetupUart();
    
    osKernelInitialize();
    queueFactorial = osMessageQueueNew(10, sizeof(uint32_t), NULL);
    queueFibonacci = osMessageQueueNew(10, sizeof(uint32_t), NULL);
    queueResp = osMessageQueueNew(20, sizeof(uint32_t), NULL);
    osThreadNew(Thread_Factorial, NULL, NULL);
    osThreadNew(Thread_Fibonacci, NULL, NULL);
    osThreadNew(Thread_UARTWrite, NULL, NULL);
    osKernelStart();
    
    while (1);
}
