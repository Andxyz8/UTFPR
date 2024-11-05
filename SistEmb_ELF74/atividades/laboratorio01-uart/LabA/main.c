// main.c
// Developed for EK-TM4C1294XL board


#include<stdint.h>
#include "tm4c1294ncpdt.h"
#include <stdlib.h>
#include <time.h>
#include "uart.h"


///////// DEFINES, MACROS AND STRUCTS //////////
#define INVALID_NUMBER        0xFF

///////// EXTERNAL FUNCTIONS INCLUSIONS //////////
// Since there is no .h in most files, theis functions must be included by hand.
// Same as if we were using IMPORT from assembly

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);

void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortF_Output(uint32_t valor);
void PortN_Output(uint32_t valor);
void timerInit(void);

///////// LOCAL FUNCTIONS IMPLEMENTATIONS //////////

int main(void){
	PLL_Init();
	SysTick_Init();
	UART_init();
	GPIO_Init();
	timerInit();

	char a = '0';

	while(1){
		a = UART_receive();

		switch (a) {
			case '1':
				PortN_Output(0x2); // 00000010

				UART_send_str("L1\n\r");

				SysTick_Wait1ms(250);
				PortN_Output(0x00);
				break;	
			case '2':
				PortN_Output(0x1);

				UART_send_str("L2\n\r");

				SysTick_Wait1ms(250);
				PortN_Output(0x00);
				break;
			case '3':
				PortF_Output(0x10);

				UART_send_str("LE\n\r");

				SysTick_Wait1ms(250);
				PortF_Output(0x00);
				break;
			case '4':
				PortF_Output(0x01);

				UART_send_str("L4\n\r");

				SysTick_Wait1ms(250);
				PortF_Output(0x00);
				break;
			case '5':
				if(PortJ_Input() & 0x02)
					UART_send_str("W1\n\r");
				else if(PortJ_Input() & 0x01)
					UART_send_str("W2\n\r");
				else if(PortJ_Input() & 0x03)
					UART_send_str("12\n\r");
				else
					UART_send_str("OO\n\r");
			default:
				PortF_Output(0x00);
				break;
		}
	}
}




