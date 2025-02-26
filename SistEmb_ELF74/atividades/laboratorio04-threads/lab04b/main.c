#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "cmsis_os2.h"
#include "inc/hw_memmap.h"
#include "driverlib/sysctl.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/adc.h"

#define LM35_ADC_BASE ADC0_BASE
#define LM35_ADC_SEQ  3
#define LM35_ADC_CHANNEL 0  // Sequência de ADC para o sensor

#define UART_PORT_BASE UART0_BASE
#define UART_PERIPH SYSCTL_PERIPH_UART0
#define UART_GPIO_PERIPH SYSCTL_PERIPH_GPIOA
#define UART_TX_PIN GPIO_PIN_1
#define UART_RX_PIN GPIO_PIN_0
#define UART_GPIO_BASE GPIO_PORTA_BASE

uint32_t SysClock;

volatile uint32_t sensor_readings[10] = {0};
volatile uint8_t index_reading = 0;
volatile float average_temperature = 0.0;
osMutexId_t mutex;


void setupSensor() {
    SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);
    while (!SysCtlPeripheralReady(SYSCTL_PERIPH_ADC0));

    ADCSequenceConfigure(LM35_ADC_BASE, LM35_ADC_SEQ, ADC_TRIGGER_PROCESSOR, 0);
    ADCSequenceStepConfigure(LM35_ADC_BASE, LM35_ADC_SEQ, 0, LM35_ADC_CHANNEL | ADC_CTL_IE | ADC_CTL_END);
    ADCSequenceEnable(LM35_ADC_BASE, LM35_ADC_SEQ);
}

void setupUART(void) {
    SysCtlPeripheralEnable(UART_PERIPH);
    SysCtlPeripheralEnable(UART_GPIO_PERIPH);
    
    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);
    GPIOPinTypeUART(UART_GPIO_BASE, UART_TX_PIN | UART_RX_PIN);
    
    UARTConfigSetExpClk(
        UART_PORT_BASE,
        SysClock,
        115200,
        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE)
    );
}

// Imprimir UART
void WriteUART(char *msg) {
    while (*msg) {
        UARTCharPut(UART_PORT_BASE, *(msg++));
    }
}

// Thread para leitura dos dados
void Thread_ReadSensor(void *arg) {
    uint32_t adc_value;

    while (1) {
        ADCIntClear(LM35_ADC_BASE, LM35_ADC_SEQ);
        ADCProcessorTrigger(LM35_ADC_BASE, LM35_ADC_SEQ);
        while (!ADCIntStatus(LM35_ADC_BASE, LM35_ADC_SEQ, false));
        ADCSequenceDataGet(LM35_ADC_BASE, LM35_ADC_SEQ, &adc_value);

        // Conver graus celsius
        float temperature = (adc_value * 3.3 / 4096.0) * 100.0;

        // Acesso à memória compartilhada
        osMutexAcquire(mutex, osWaitForever);
        sensor_readings[index_reading] = temperature;
        index_reading = (index_reading + 1) % 10;
        osMutexRelease(mutex);

        osDelay(500);
    }
}

// Thread da média dos últimas 10 leituras
void Thread_Average(void *arg) {
    while (1) {
        osMutexAcquire(mutex, osWaitForever);

        float sum = 0.0;

        for (int i = 0; i < 10; i++) {
            sum += sensor_readings[i];
        }

        average_temperature = sum / 10.0;

        osMutexRelease(mutex);

        osDelay(500);
    }
}

// Thread que imprime os dados médios na UART
void Thread_UARTWriteAverage(void *arg) {
    char buffer[50];
    while (1) {
        osMutexAcquire(mutex, osWaitForever);

        snprintf(
            buffer,
            sizeof(buffer),
            "Temperatura Média: %.2f C\n",
            average_temperature
        );

        osMutexRelease(mutex);

        WriteUART(buffer);

        osDelay(1000);
    }
}

int main(void) {
    // Configura o clock do sistema
    SysClock = SysCtlClockFreqSet((SYSCTL_XTAL_25MHZ | SYSCTL_OSC_MAIN | SYSCTL_USE_PLL | SYSCTL_CFG_VCO_240), 120000000);

    setupSensor();
    setupUART();

    //inicializa o RTOS
    osKernelInitialize();

    // Criação do mutex
    mutex = osMutexNew(NULL);

    osThreadNew(Thread_ReadSensor, NULL, NULL);
    osThreadNew(Thread_Average, NULL, NULL);
    osThreadNew(Thread_UARTWriteAverage, NULL, NULL);

    osKernelStart();

    while (1);
}
