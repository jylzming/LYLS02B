   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
3254                     ; 7 void TIM4_Init(void)
3254                     ; 8 {
3256                     	switch	.text
3257  0000               _TIM4_Init:
3261                     ; 9 	_asm("sim");
3264  0000 9b            sim
3266                     ; 10 	TIM4_IER = 0x00;//disable TIM4 interrupt
3268  0001 725f5343      	clr	_TIM4_IER
3269                     ; 12 	TIM4_CR1 = 0x00;//Counter go on when update occur
3271  0005 725f5340      	clr	_TIM4_CR1
3272                     ; 13 	TIM4_PSCR= 0x03;//Fcpu:8Mhz,counter:1uS
3274  0009 35035347      	mov	_TIM4_PSCR,#3
3275                     ; 14 	TIM4_ARR = 0x2E;//test:0x2E~51.5uS, 0x2D~50uS
3277  000d 352e5348      	mov	_TIM4_ARR,#46
3278                     ; 15 	TIM4_CNTR = 0x00;
3280  0011 725f5346      	clr	_TIM4_CNTR
3281                     ; 17 	ITC_SPR6 |= 0x80;//set TIM4 UPD_INT priority to 1
3283  0015 721e7f75      	bset	_ITC_SPR6,#7
3284                     ; 18 	ITC_SPR6 &= 0xBF;	
3286  0019 721d7f75      	bres	_ITC_SPR6,#6
3287                     ; 19 	_asm("rim");
3290  001d 9a            rim
3292                     ; 20 }
3295  001e 81            	ret
3338                     ; 22 void Delay(void)
3338                     ; 23 {
3339                     	switch	.text
3340  001f               _Delay:
3342  001f 5204          	subw	sp,#4
3343       00000004      OFST:	set	4
3346                     ; 25 	for(i=0; i<1024; i++)
3348  0021 5f            	clrw	x
3349  0022 1f01          	ldw	(OFST-3,sp),x
3351  0024 201a          	jra	L7322
3352  0026               L3322:
3353                     ; 27 		for(j=0; j<512; j++); 
3355  0026 5f            	clrw	x
3356  0027 1f03          	ldw	(OFST-1,sp),x
3358  0029 2007          	jra	L7422
3359  002b               L3422:
3363  002b 1e03          	ldw	x,(OFST-1,sp)
3364  002d 1c0001        	addw	x,#1
3365  0030 1f03          	ldw	(OFST-1,sp),x
3366  0032               L7422:
3369  0032 1e03          	ldw	x,(OFST-1,sp)
3370  0034 a30200        	cpw	x,#512
3371  0037 25f2          	jrult	L3422
3372                     ; 25 	for(i=0; i<1024; i++)
3374  0039 1e01          	ldw	x,(OFST-3,sp)
3375  003b 1c0001        	addw	x,#1
3376  003e 1f01          	ldw	(OFST-3,sp),x
3377  0040               L7322:
3380  0040 1e01          	ldw	x,(OFST-3,sp)
3381  0042 a30400        	cpw	x,#1024
3382  0045 25df          	jrult	L3322
3383                     ; 29 }
3386  0047 5b04          	addw	sp,#4
3387  0049 81            	ret
3413                     ; 31 void Delay50us(void)
3413                     ; 32 {
3414                     	switch	.text
3415  004a               _Delay50us:
3419                     ; 33 	TIM4_CNTR = 0x00;
3421  004a 725f5346      	clr	_TIM4_CNTR
3422                     ; 34 	TIM4_CR1 |= 0x01;//Enable TIM4
3424  004e 72105340      	bset	_TIM4_CR1,#0
3426  0052               L5622:
3427                     ; 35 	while((TIM4_SR&0x01)==0);
3429  0052 c65344        	ld	a,_TIM4_SR
3430  0055 a501          	bcp	a,#1
3431  0057 27f9          	jreq	L5622
3432                     ; 36 	TIM4_SR=0x00;//????§Ø?
3434  0059 725f5344      	clr	_TIM4_SR
3435                     ; 37 	TIM4_CR1 &= 0xFE;
3437  005d 72115340      	bres	_TIM4_CR1,#0
3438                     ; 38 }
3441  0061 81            	ret
3476                     ; 40 void Delay500ms(void)
3476                     ; 41 {
3477                     	switch	.text
3478  0062               _Delay500ms:
3480  0062 89            	pushw	x
3481       00000002      OFST:	set	2
3484                     ; 43 	for(i=0;i<=9850;i++)
3486  0063 5f            	clrw	x
3487  0064 1f01          	ldw	(OFST-1,sp),x
3488  0066               L7032:
3489                     ; 45 		Delay50us();
3491  0066 ade2          	call	_Delay50us
3493                     ; 43 	for(i=0;i<=9850;i++)
3495  0068 1e01          	ldw	x,(OFST-1,sp)
3496  006a 1c0001        	addw	x,#1
3497  006d 1f01          	ldw	(OFST-1,sp),x
3500  006f 1e01          	ldw	x,(OFST-1,sp)
3501  0071 a3267b        	cpw	x,#9851
3502  0074 25f0          	jrult	L7032
3503                     ; 47 }
3506  0076 85            	popw	x
3507  0077 81            	ret
3542                     ; 49 void Delay1s(void)
3542                     ; 50 {
3543                     	switch	.text
3544  0078               _Delay1s:
3546  0078 89            	pushw	x
3547       00000002      OFST:	set	2
3550                     ; 52 	for(i=0;i<=19450;i++)
3552  0079 5f            	clrw	x
3553  007a 1f01          	ldw	(OFST-1,sp),x
3554  007c               L3332:
3555                     ; 54 		Delay50us();
3557  007c adcc          	call	_Delay50us
3559                     ; 52 	for(i=0;i<=19450;i++)
3561  007e 1e01          	ldw	x,(OFST-1,sp)
3562  0080 1c0001        	addw	x,#1
3563  0083 1f01          	ldw	(OFST-1,sp),x
3566  0085 1e01          	ldw	x,(OFST-1,sp)
3567  0087 a34bfb        	cpw	x,#19451
3568  008a 25f0          	jrult	L3332
3569                     ; 56 }
3572  008c 85            	popw	x
3573  008d 81            	ret
3597                     ; 58 @far @interrupt void TIM4_UPD_IRQHandler(void)
3597                     ; 59 {
3599                     	switch	.text
3600  008e               f_TIM4_UPD_IRQHandler:
3605                     ; 61 }
3608  008e 80            	iret
3620                     	xdef	f_TIM4_UPD_IRQHandler
3621                     	xdef	_TIM4_Init
3622                     	xdef	_Delay1s
3623                     	xdef	_Delay500ms
3624                     	xdef	_Delay50us
3625                     	xdef	_Delay
3644                     	end
