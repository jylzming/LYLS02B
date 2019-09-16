   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
3213                     	bsct
3214  0000               _relayStat:
3215  0000 00            	dc.b	0
3216  0001               L3712_adcCount:
3217  0001 00            	dc.b	0
3218  0002               L5712_adcData:
3219  0002 0000          	dc.w	0
3220  0004 000000000000  	ds.b	38
3313                     ; 19 main()
3313                     ; 20 {
3315                     	switch	.text
3316  0000               _main:
3318  0000 5203          	subw	sp,#3
3319       00000003      OFST:	set	3
3322                     ; 21 	unsigned char i = 0;
3324  0002 0f03          	clr	(OFST+0,sp)
3325                     ; 23 	volatile unsigned char offCount = 0;
3327  0004 0f01          	clr	(OFST-2,sp)
3328                     ; 24 	volatile unsigned char onCount = 0;
3330  0006 0f02          	clr	(OFST-1,sp)
3331                     ; 27 	CLK_CKDIVR = 0x08;//f = f HSI RCÊä³ö/2=8MHz
3333  0008 350850c6      	mov	_CLK_CKDIVR,#8
3334                     ; 28 	TIM4_Init();//use for delay, high
3336  000c cd0000        	call	_TIM4_Init
3338                     ; 31 	InitADC();	
3340  000f cd0000        	call	_InitADC
3342                     ; 33 	adcData[0] = GetADC();
3344  0012 cd0000        	call	_GetADC
3346  0015 bf02          	ldw	L5712_adcData,x
3347                     ; 35 	Rly_GPIO_Config();
3349  0017 cd0000        	call	_Rly_GPIO_Config
3351                     ; 37 	if(adcData[0] < ON_LUX)//initial LIGHT IO
3353  001a be02          	ldw	x,L5712_adcData
3354  001c a30960        	cpw	x,#2400
3355  001f 2406          	jruge	L3422
3356                     ; 39 		LIGHT = OFF;
3358  0021 721a500a      	bset	_PC_ODR_5
3360  0025 2004          	jra	L5422
3361  0027               L3422:
3362                     ; 43 		LIGHT = ON;
3364  0027 721b500a      	bres	_PC_ODR_5
3365  002b               L5422:
3366                     ; 45 	_asm("rim"); //Enable interrupt
3369  002b 9a            rim
3371  002c               L7422:
3372                     ; 49 		adcData[adcCount++] = GetADC();
3374  002c cd0000        	call	_GetADC
3376  002f b601          	ld	a,L3712_adcCount
3377  0031 9097          	ld	yl,a
3378  0033 3c01          	inc	L3712_adcCount
3379  0035 909f          	ld	a,yl
3380  0037 905f          	clrw	y
3381  0039 9097          	ld	yl,a
3382  003b 9058          	sllw	y
3383  003d 90ef02        	ldw	(L5712_adcData,y),x
3384                     ; 50 		if(adcCount >= 20)	
3386  0040 b601          	ld	a,L3712_adcCount
3387  0042 a114          	cp	a,#20
3388  0044 2502          	jrult	L3522
3389                     ; 51 			adcCount = 0;
3391  0046 3f01          	clr	L3712_adcCount
3392  0048               L3522:
3393                     ; 54 		for(i=0; i<20;i++)
3395  0048 0f03          	clr	(OFST+0,sp)
3396  004a               L5522:
3397                     ; 56 			if(adcData[i] < OFF_LUX)
3399  004a 7b03          	ld	a,(OFST+0,sp)
3400  004c 5f            	clrw	x
3401  004d 97            	ld	xl,a
3402  004e 58            	sllw	x
3403  004f 9093          	ldw	y,x
3404  0051 90ee02        	ldw	y,(L5712_adcData,y)
3405  0054 90a3009d      	cpw	y,#157
3406  0058 2404          	jruge	L3622
3407                     ; 57 				offCount += 1;
3409  005a 0c01          	inc	(OFST-2,sp)
3411  005c 2012          	jra	L5622
3412  005e               L3622:
3413                     ; 58 			else if(adcData[i] > ON_LUX)
3415  005e 7b03          	ld	a,(OFST+0,sp)
3416  0060 5f            	clrw	x
3417  0061 97            	ld	xl,a
3418  0062 58            	sllw	x
3419  0063 9093          	ldw	y,x
3420  0065 90ee02        	ldw	y,(L5712_adcData,y)
3421  0068 90a30961      	cpw	y,#2401
3422  006c 2502          	jrult	L5622
3423                     ; 59 				onCount += 1;
3425  006e 0c02          	inc	(OFST-1,sp)
3427  0070               L5622:
3428                     ; 54 		for(i=0; i<20;i++)
3430  0070 0c03          	inc	(OFST+0,sp)
3433  0072 7b03          	ld	a,(OFST+0,sp)
3434  0074 a114          	cp	a,#20
3435  0076 25d2          	jrult	L5522
3436                     ; 62 		if(offCount >= 20)
3438  0078 7b01          	ld	a,(OFST-2,sp)
3439  007a a114          	cp	a,#20
3440  007c 250d          	jrult	L3722
3441                     ; 64 			if(LIGHT == ON)//only when light on/off change 
3443                     	btst	_PC_ODR_5
3444  0083 2517          	jrult	L7722
3445                     ; 66 				LIGHT = OFF;//Relay_IO = 1
3447  0085 721a500a      	bset	_PC_ODR_5
3448  0089 2011          	jra	L7722
3449  008b               L3722:
3450                     ; 69 		else if(onCount >= 20)
3452  008b 7b02          	ld	a,(OFST-1,sp)
3453  008d a114          	cp	a,#20
3454  008f 250b          	jrult	L7722
3455                     ; 71 			if(LIGHT == OFF)//only when light on/off change 
3457                     	btst	_PC_ODR_5
3458  0096 2404          	jruge	L7722
3459                     ; 73 				LIGHT = ON;//Relay_IO = 1
3461  0098 721b500a      	bres	_PC_ODR_5
3462  009c               L7722:
3463                     ; 76 		offCount = 0;
3465  009c 0f01          	clr	(OFST-2,sp)
3466                     ; 77 		onCount  = 0;
3468  009e 0f02          	clr	(OFST-1,sp)
3469                     ; 79 		Delay500ms();
3471  00a0 cd0000        	call	_Delay500ms
3474  00a3 2087          	jra	L7422
3519                     	xdef	_main
3520                     	xdef	_relayStat
3521                     	xref	_TIM4_Init
3522                     	xref	_Delay500ms
3523                     	xref	_GetADC
3524                     	xref	_InitADC
3525                     	xref	_Rly_GPIO_Config
3544                     	end
