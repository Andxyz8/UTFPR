#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include "cmsis_os2.h"
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/interrupt.h"

osMessageQueueId_t queueFibonacciRecursiveHigh;
osMessageQueueId_t queueFibonacciRecursiveLow;
osMessageQueueId_t queueResp;

typedef struct {
    uint32_t result;
    double timeTaken;
    char type[30];
} ResponseData;

uint32_t SysClock;
char inputBuffer[100];
int bufferIndex = 0;

uint32_t FibonacciRecursive(uint32_t n) {
    if (n <= 1)
        return n;
    else
        return FibonacciRecursive(n - 1) + FibonacciRecursive(n - 2);
}

void UARTIntHandler(void) {
    uint32_t status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, status);
    char receivedChar;

    while (UARTCharsAvail(UART0_BASE)) {
        receivedChar = (char)UARTCharGet(UART0_BASE);
        if (receivedChar == '\r' || receivedChar == '\n') {
            if (bufferIndex > 0) {
                inputBuffer[bufferIndex] = '\0';
                uint32_t num = strtoul(inputBuffer, NULL, 10);
                osMessageQueuePut(queueFibonacciRecursiveHigh, &num, 0, 0);
                osMessageQueuePut(queueFibonacciRecursiveLow, &num, 0, 0);
                bufferIndex = 0;
            }
        } else if (receivedChar >= '0' && receivedChar <= '9') {
            if (bufferIndex < sizeof(inputBuffer) - 1) {
                inputBuffer[bufferIndex++] = receivedChar;
            }
        }
    }
}

void SetupUart(void) {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_UART0));
    UARTConfigSetExpClk(UART0_BASE, SysClock, 115200,
                        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    UARTFIFODisable(UART0_BASE);
    UARTIntEnable(UART0_BASE, UART_INT_RX);
    UARTIntRegister(UART0_BASE, UARTIntHandler);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_GPIOA));
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);
}

void Thread_FibonacciRecursiveHigh(void *argument) {
    uint32_t num;
    while (true) {
        osStatus_t status = osMessageQueueGet(queueFibonacciRecursiveHigh, &num, NULL, osWaitForever);
        if (status == osOK) {
            for (int i = 0; i < 10; i++) { // Calculate Fibonacci 10 times
                uint32_t result;
                uint32_t start = osKernelGetTickCount();
                result = FibonacciRecursive(num);
                uint32_t end = osKernelGetTickCount();
                ResponseData response = {.result = result, .timeTaken = (double)(end - start) / osKernelGetTickFreq()};
                snprintf(response.type, sizeof(response.type), "Fibonacci_High");
                osMessageQueuePut(queueResp, &response, 0, osWaitForever);
            }
        }
    }
}

void Thread_FibonacciRecursiveLow(void *argument) {
    uint32_t num;
    while (true) {
        osStatus_t status = osMessageQueueGet(queueFibonacciRecursiveLow, &num, NULL, osWaitForever);
        if (status == osOK) {
            for (int i = 0; i < 10; i++) { // Calculate Fibonacci 10 times
                uint32_t result;
                uint32_t start = osKernelGetTickCount();
                result = FibonacciRecursive(num);
                uint32_t end = osKernelGetTickCount();
                ResponseData response = {.result = result, .timeTaken = (double)(end - start) / osKernelGetTickFreq()};
                snprintf(response.type, sizeof(response.type), "Fibonacci_Low");
                osMessageQueuePut(queueResp, &response, 0, osWaitForever);
            }
        }
    }
}



void Thread_UARTWrite(void *argument) {
    ResponseData response;
    while (true) {
        if (osMessageQueueGet(queueResp, &response, NULL, osWaitForever) == osOK) {
            char buffer[80];
            snprintf(buffer, sizeof(buffer), "Result = %u (%s - %.8f seconds)\r\n", response.result, response.type, response.timeTaken < 0.000001 ? response.timeTaken * 1000000 : response.timeTaken);

            for (char *p = buffer; *p; p++) {
                UARTCharPut(UART0_BASE, *p);
            }
        }
    }
}

int main(void) {
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);

    SetupUart();
    osKernelInitialize();
    queueFibonacciRecursiveHigh = osMessageQueueNew(10, sizeof(uint32_t), NULL);
    queueFibonacciRecursiveLow = osMessageQueueNew(10, sizeof(uint32_t), NULL);
    queueResp = osMessageQueueNew(20, sizeof(ResponseData), NULL);
    
    osThreadId_t highThreadId = osThreadNew(Thread_FibonacciRecursiveHigh, NULL, NULL);
    osThreadId_t lowThreadId = osThreadNew(Thread_FibonacciRecursiveLow, NULL, NULL);
    
    if (highThreadId != NULL) {
        osThreadSetPriority(highThreadId,  osPriorityNormal);
    }
    
    if (lowThreadId != NULL) {
        osThreadSetPriority(lowThreadId,  osPriorityNormal);
    }
    
    osThreadNew(Thread_UARTWrite, NULL, NULL);
    osKernelStart();

    while (1);
}
