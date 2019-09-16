#include "delay.h"
#include "pwm.h"
#include "relay.h"
#include "adc.h"
#include "global.h"

void TIM4_Init(void)
{
	_asm("sim");
	TIM4_IER = 0x00;//disable TIM4 interrupt
	//TIM4_EGR = 0X01;
	TIM4_CR1 = 0x00;//Counter go on when update occur
	TIM4_PSCR= 0x03;//Fcpu:8Mhz,counter:1uS
	TIM4_ARR = 0x2E;//test:0x2E~51.5uS, 0x2D~50uS
	TIM4_CNTR = 0x00;
	
	ITC_SPR6 |= 0x80;//set TIM4 UPD_INT priority to 1
	ITC_SPR6 &= 0xBF;	
	_asm("rim");
}

void Delay(void)
{
	volatile unsigned int i,j;
	for(i=0; i<1024; i++)
	{
		for(j=0; j<512; j++); 
	}
}

void Delay50us(void)
{
	TIM4_CNTR = 0x00;
	TIM4_CR1 |= 0x01;//Enable TIM4
	while((TIM4_SR&0x01)==0);
	TIM4_SR=0x00;//????§Ø?
	TIM4_CR1 &= 0xFE;
}

void Delay500ms(void)
{
	unsigned int i;
	for(i=0;i<=9850;i++)
	{
		Delay50us();
	}
}

void Delay1s(void)
{
	unsigned int i;
	for(i=0;i<=19450;i++)
	{
		Delay50us();
	}
}

@far @interrupt void TIM4_UPD_IRQHandler(void)
{
 	//TIM4_SR1 &= 0xFE;//clear interrupt label	
}
