// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron


#include <stdint.h>

#include "tm4c1294ncpdt.h"

#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTF  (0x0020) // bit 5
#define GPIO_PORTA  (0x0001) // bit 0
#define GPIO_PORTQ  (0x4000) // bit 14
#define GPIO_PORTP  (0x2000) // bit 13

extern void timerInit(void);

// -------------------------------------------------------------------------------
// Funcao GPIO_Init
// Inicializa os ports J e N
// Parametro de entrada: Nao tem
// Parametro de saida: Nao tem
void GPIO_Init(void)
{
   //1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
   SYSCTL_RCGCGPIO_R = (GPIO_PORTF | GPIO_PORTN | GPIO_PORTJ);
   //1b.   apos isso verificar no PRGPIO se a porta esta pronta para uso.
   while((SYSCTL_PRGPIO_R & (GPIO_PORTF | GPIO_PORTN | GPIO_PORTJ) ) !=
                        (GPIO_PORTF | GPIO_PORTN | GPIO_PORTJ ))
   
   // 2. Limpar o AMSEL para desabilitar a analogica
   GPIO_PORTF_AHB_AMSEL_R = 0x00;
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
   GPIO_PORTN_AMSEL_R = 0x00;
   
   // 3. Limpar PCTL para selecionar o GPIO
   GPIO_PORTF_AHB_PCTL_R = 0x00;
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
   GPIO_PORTN_PCTL_R = 0x00;

   // 4. DIR para 0 se for entrada, 1 se for saida
   GPIO_PORTF_AHB_DIR_R = 0x11;
	GPIO_PORTJ_AHB_DIR_R = 0x00;
   GPIO_PORTN_DIR_R = 0x03;
      
   // 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem funcao alternativa
   GPIO_PORTF_AHB_AFSEL_R = 0x00;
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
   GPIO_PORTN_AFSEL_R = 0x00;
      
   // 6. Setar os bits de DEN para habilitar I/O digital
   GPIO_PORTF_AHB_DEN_R = 0x11;   //Bit0 e bit1
	GPIO_PORTJ_AHB_DEN_R = 0x03;   //Bit0 e bit1
   GPIO_PORTN_DEN_R = 0x03;   //Bit0 e bit1

   
   // 7. Habilitar resistor de pull-up interno, setar PUR para 1
   GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1

   // INTERRUPTION SETTINGS
   // Disable interrupt
   GPIO_PORTJ_AHB_IM_R = 0;
   
   // Border or level
   GPIO_PORTJ_AHB_IS_R = 0;
   
   // Activate in 1 or 2 borders
   GPIO_PORTJ_AHB_IBE_R = 0;
   
   // Activate in rising or lowering border 0 = lowering, 1 = rising
   GPIO_PORTJ_AHB_IEV_R = 0x2;
   
   // Enable GPIORIS AND GPIOMIS reset
   GPIO_PORTJ_AHB_ICR_R = 0x3;
   
   // Enable interrupt
   GPIO_PORTJ_AHB_IM_R = 0x3;
   
   // Enable interrut in Nvidea
   NVIC_EN1_R = (0x1 << 19);
   
   // Set port interrupt priority
   NVIC_PRI12_R = (0x5 << 29);
}

extern void timerInit(void)
{
   SYSCTL_RCGCTIMER_R |= 0x4; // Enable clock to TIMER2

   while ((SYSCTL_PRTIMER_R & 0x4) != 0x4) // Wait for config to be ready

   TIMER2_CTL_R = 0; // Disables timer

   TIMER2_CFG_R = 0; // Uses 32 bits

   TIMER2_TAMR_R = 1; // Using 1-shot timer on timer A

   TIMER2_TAILR_R = 15999999; // CUNTER = (200ms / (1/80MHz)) - 1

   TIMER2_TAPR_R = 0; // No prescale configured

   TIMER2_ICR_R = 1; // ACKS the interruption

   TIMER2_IMR_R = 1; // Enables interruption

   NVIC_EN0_R |= (1 << 23); // Enables interruption in NVIC

   NVIC_PRI5_R = (3 << 29);

   // TIMER2_CTL_R = 1; // Enables timer
}

// -------------------------------------------------------------------------------
// Funcao PortJ_Input
// Le os valores de entrada do port J
// Parametro de entrada: Nao tem
// Parametro de saida: o valor da leitura do port
uint32_t PortJ_Input(void)
{
   return GPIO_PORTJ_AHB_DATA_R;
}

// ------------------------------------------------------------------------------

void PortF_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigavel nos bits 0 e 1
    temp = GPIO_PORTF_AHB_DATA_R & 0x00;
    //agora vamos fazer o OR com o valor recebido na funcao
    temp = temp | valor;
    GPIO_PORTF_AHB_DATA_R = temp; 
}

// ------------------------------------------------------------------------------
// Funcao PortN_Output
// Escreve os valores no port N
// Parametro de entrada: Valor a ser escrito
// Parametro de saida: nao tem
void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigavel nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC;
    //agora vamos fazer o OR com o valor recebido na funcao
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}

