/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 STMicroelectronics
 */
#include "STM8S001J3.h"
#include "stm8s_bit.h"
//#include "stdio.h"
#include "relay.h"
#include "pwm.h"
#include "adc.h"
#include "delay.h"
#include "global.h"
#include "uart.h"
#include "eeprom.h"
#include <string.h>

bool relayStat = ON;

main()
{
	unsigned char i = 0;
	volatile static unsigned char adcCount = 0;
	volatile unsigned char offCount = 0;
	volatile unsigned char onCount = 0;
	static unsigned int adcData[20] = {0};

	CLK_CKDIVR = 0x08;//f = f HSI RCÊä³ö/2=8MHz
	TIM4_Init();//use for delay, high

	//Get ADC initial data and check the light ON/OFF state
	InitADC();	

	adcData[0] = GetADC();

	Rly_GPIO_Config();

	if(adcData[0] < ON_LUX)//initial LIGHT IO
	{
		LIGHT = OFF;
	}
	else
	{
		LIGHT = ON;
	}
	_asm("rim"); //Enable interrupt

	while(1)
	{
		adcData[adcCount++] = GetADC();
		if(adcCount >= 20)	
			adcCount = 0;
		
		//if it's daytime, turn the light off
		for(i=0; i<20;i++)
		{
			if(adcData[i] < OFF_LUX)
				offCount += 1;
			else if(adcData[i] > ON_LUX)
				onCount += 1;
			else;//do nothing
		}
		if(offCount >= 20)
		{
			if(LIGHT == ON)//only when light on/off change 
			{
				LIGHT = OFF;//Relay_IO = 1
			}
		}
		else if(onCount >= 20)
		{
			if(LIGHT == OFF)//only when light on/off change 
			{
				LIGHT = ON;//Relay_IO = 1
			}
		}
		offCount = 0;
		onCount  = 0;
	
		Delay500ms();
		//Delay50us();
	}
}

