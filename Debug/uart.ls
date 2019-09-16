   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.4 - 19 Dec 2007
3213                     	bsct
3214  0000               _HexTable:
3215  0000 30            	dc.b	48
3216  0001 31            	dc.b	49
3217  0002 32            	dc.b	50
3218  0003 33            	dc.b	51
3219  0004 34            	dc.b	52
3220  0005 35            	dc.b	53
3221  0006 36            	dc.b	54
3222  0007 37            	dc.b	55
3223  0008 38            	dc.b	56
3224  0009 39            	dc.b	57
3225  000a 41            	dc.b	65
3226  000b 42            	dc.b	66
3227  000c 43            	dc.b	67
3228  000d 44            	dc.b	68
3229  000e 45            	dc.b	69
3230  000f 46            	dc.b	70
3231  0010               _RX_Buf:
3232  0010 00            	dc.b	0
3233  0011 000000000000  	ds.b	63
3234  0050               _RX_End:
3235  0050 00            	dc.b	0
3236  0051               _BufLength:
3237  0051 00            	dc.b	0
3238  0052               _RX_FRAME:
3239  0052 00            	dc.b	0
3240  0053               _frameStart:
3241  0053 00            	dc.b	0
3242  0054               _frameEnd:
3243  0054 00            	dc.b	0
3284                     ; 12 void UART_RXGPIO_Config(void)
3284                     ; 13 {
3286                     	switch	.text
3287  0000               _UART_RXGPIO_Config:
3291                     ; 14 	EXTI_CR1 |= 0x80;//PD only down trigger
3293  0000 721e50a0      	bset	_EXTI_CR1,#7
3294                     ; 15 	PD_DDR &= 0xFD;//PD1 IOset as input
3296  0004 72135011      	bres	_PD_DDR,#1
3297                     ; 16 	PD_CR1 |= 0x02;//pull up
3299  0008 72125012      	bset	_PD_CR1,#1
3300                     ; 17 	PD_CR2 |= 0x02;//EXT interrupt	
3302  000c 72125013      	bset	_PD_CR2,#1
3303                     ; 18 }
3306  0010 81            	ret
3354                     ; 21 char StartRXD(void)//use Delay
3354                     ; 22 {
3355                     	switch	.text
3356  0011               _StartRXD:
3358  0011 89            	pushw	x
3359       00000002      OFST:	set	2
3362                     ; 23 	unsigned char cnt = 0;
3364  0012 7b02          	ld	a,(OFST+0,sp)
3365  0014 97            	ld	xl,a
3366                     ; 24 	char RX_Byte = 0;
3368  0015 0f01          	clr	(OFST-1,sp)
3369                     ; 25 	RX_End = 0;	
3371  0017 3f50          	clr	_RX_End
3372                     ; 26 	Delay50us();//to the middle of a bit
3374  0019 cd0000        	call	_Delay50us
3376                     ; 27 	if(RX_BIT == 0)//confirm start bit
3378                     	btst	_PD_IDR_1
3379  0021 2538          	jrult	L3322
3380                     ; 29 		for(cnt=0;cnt<8;cnt++)
3382  0023 0f02          	clr	(OFST+0,sp)
3383  0025               L5322:
3384                     ; 31 			Delay50us();Delay50us();//104uS,to the middle of a bit
3386  0025 cd0000        	call	_Delay50us
3390  0028 cd0000        	call	_Delay50us
3392                     ; 32 			RX_Byte >>= 1;//low bit to high bit 
3394  002b 0401          	srl	(OFST-1,sp)
3395                     ; 33 			if(RX_BIT)
3397                     	btst	_PD_IDR_1
3398  0032 2406          	jruge	L3422
3399                     ; 34 				RX_Byte |= 0x80;
3401  0034 7b01          	ld	a,(OFST-1,sp)
3402  0036 aa80          	or	a,#128
3403  0038 6b01          	ld	(OFST-1,sp),a
3404  003a               L3422:
3405                     ; 29 		for(cnt=0;cnt<8;cnt++)
3407  003a 0c02          	inc	(OFST+0,sp)
3410  003c 7b02          	ld	a,(OFST+0,sp)
3411  003e a108          	cp	a,#8
3412  0040 25e3          	jrult	L5322
3413                     ; 36 		Delay50us();Delay50us();//104uS,to the middle of a bit
3415  0042 cd0000        	call	_Delay50us
3419  0045 cd0000        	call	_Delay50us
3421                     ; 37 		if(RX_BIT)//stop bit?
3423                     	btst	_PD_IDR_1
3424  004d 2408          	jruge	L5422
3425                     ; 39 			RX_End = 1;	
3427  004f 35010050      	mov	_RX_End,#1
3428                     ; 40 			return RX_Byte;
3430  0053 7b01          	ld	a,(OFST-1,sp)
3432  0055 2002          	jra	L01
3433  0057               L5422:
3434                     ; 48 			return -1;
3436  0057 a6ff          	ld	a,#255
3438  0059               L01:
3440  0059 85            	popw	x
3441  005a 81            	ret
3442  005b               L3322:
3443                     ; 52 		return -1;
3445  005b a6ff          	ld	a,#255
3447  005d 20fa          	jra	L01
3450                     	bsct
3451  0055               L3522_index:
3452  0055 00            	dc.b	0
3520                     ; 56 @far @interrupt void EXTI3_IRQHandler(void)
3520                     ; 57 {
3522                     	switch	.text
3523  005f               f_EXTI3_IRQHandler:
3526       00000003      OFST:	set	3
3527  005f 3b0002        	push	c_x+2
3528  0062 be00          	ldw	x,c_x
3529  0064 89            	pushw	x
3530  0065 3b0002        	push	c_y+2
3531  0068 be00          	ldw	x,c_y
3532  006a 89            	pushw	x
3533  006b 5203          	subw	sp,#3
3536                     ; 59 	volatile char temp = 0;
3538  006d 0f01          	clr	(OFST-2,sp)
3539                     ; 60 	char i = 0, error = 0;
3541  006f 7b03          	ld	a,(OFST+0,sp)
3542  0071 97            	ld	xl,a
3545  0072 0f02          	clr	(OFST-1,sp)
3546                     ; 61 	PD_CR2 &= 0xFD;//EXT interrupt disable
3548  0074 72135013      	bres	_PD_CR2,#1
3549                     ; 62 	temp=StartRXD();
3551  0078 ad97          	call	_StartRXD
3553  007a 6b01          	ld	(OFST-2,sp),a
3554                     ; 66 	if(0xFE == temp)//begin: 0xFE
3556  007c 7b01          	ld	a,(OFST-2,sp)
3557  007e a1fe          	cp	a,#254
3558  0080 2612          	jrne	L7032
3559                     ; 68 		frameStart = 1;
3561  0082 35010053      	mov	_frameStart,#1
3562                     ; 69 		frameEnd = 0;
3564  0086 3f54          	clr	_frameEnd
3565                     ; 70 		index = 0;
3567  0088 3f55          	clr	L3522_index
3568                     ; 71 		memset(RX_Buf, '', BUFFER_SIZE);
3570  008a ae0040        	ldw	x,#64
3571  008d               L41:
3572  008d 6f0f          	clr	(_RX_Buf-1,x)
3573  008f 5a            	decw	x
3574  0090 26fb          	jrne	L41
3576  0092 206d          	jra	L1132
3577  0094               L7032:
3578                     ; 73 	else if(0xEF == temp)//end: 0xEF
3580  0094 7b01          	ld	a,(OFST-2,sp)
3581  0096 a1ef          	cp	a,#239
3582  0098 2653          	jrne	L3132
3583                     ; 75 		for(i=0;i<=14;i++)//confirm data is correct
3585  009a 0f03          	clr	(OFST+0,sp)
3586  009c               L5132:
3587                     ; 77 			if(RX_Buf[i] != RX_Buf[i+15])
3589  009c 7b03          	ld	a,(OFST+0,sp)
3590  009e 5f            	clrw	x
3591  009f 97            	ld	xl,a
3592  00a0 7b03          	ld	a,(OFST+0,sp)
3593  00a2 905f          	clrw	y
3594  00a4 9097          	ld	yl,a
3595  00a6 90e610        	ld	a,(_RX_Buf,y)
3596  00a9 e11f          	cp	a,(_RX_Buf+15,x)
3597  00ab 2704          	jreq	L3232
3598                     ; 78 			error = 1;//data error
3600  00ad a601          	ld	a,#1
3601  00af 6b02          	ld	(OFST-1,sp),a
3602  00b1               L3232:
3603                     ; 75 		for(i=0;i<=14;i++)//confirm data is correct
3605  00b1 0c03          	inc	(OFST+0,sp)
3608  00b3 7b03          	ld	a,(OFST+0,sp)
3609  00b5 a10f          	cp	a,#15
3610  00b7 25e3          	jrult	L5132
3611                     ; 81 		if(error == 1)//data error, clear receive data
3613  00b9 7b02          	ld	a,(OFST-1,sp)
3614  00bb a101          	cp	a,#1
3615  00bd 2610          	jrne	L5232
3616                     ; 83 			frameStart = 0;
3618  00bf 3f53          	clr	_frameStart
3619                     ; 84 			frameEnd = 0;
3621  00c1 3f54          	clr	_frameEnd
3622                     ; 85 			index = 0;
3624  00c3 3f55          	clr	L3522_index
3625                     ; 86 			memset(RX_Buf, '', BUFFER_SIZE);			
3627  00c5 ae0040        	ldw	x,#64
3628  00c8               L61:
3629  00c8 6f0f          	clr	(_RX_Buf-1,x)
3630  00ca 5a            	decw	x
3631  00cb 26fb          	jrne	L61
3633  00cd 201a          	jra	L7232
3634  00cf               L5232:
3635                     ; 91 for(index=0; index<5; index++)
3637  00cf 3f55          	clr	L3522_index
3638  00d1               L1332:
3639                     ; 93 	LIGHT = !LIGHT;
3641  00d1 901a500a      	bcpl	_PC_ODR_5
3642                     ; 94 	Delay1s();
3644  00d5 cd0000        	call	_Delay1s
3646                     ; 91 for(index=0; index<5; index++)
3648  00d8 3c55          	inc	L3522_index
3651  00da b655          	ld	a,L3522_index
3652  00dc a105          	cp	a,#5
3653  00de 25f1          	jrult	L1332
3654                     ; 97 			frameEnd = 1;
3656  00e0 35010054      	mov	_frameEnd,#1
3657                     ; 98 			frameStart = 0;
3659  00e4 3f53          	clr	_frameStart
3660                     ; 99 			BufLength = index;
3662  00e6 455551        	mov	_BufLength,L3522_index
3663  00e9               L7232:
3664                     ; 101 		index = 0;
3666  00e9 3f55          	clr	L3522_index
3668  00eb 2014          	jra	L1132
3669  00ed               L3132:
3670                     ; 105 		RX_Buf[index++] = temp;
3672  00ed b655          	ld	a,L3522_index
3673  00ef 97            	ld	xl,a
3674  00f0 3c55          	inc	L3522_index
3675  00f2 9f            	ld	a,xl
3676  00f3 5f            	clrw	x
3677  00f4 97            	ld	xl,a
3678  00f5 7b01          	ld	a,(OFST-2,sp)
3679  00f7 e710          	ld	(_RX_Buf,x),a
3680                     ; 106 		if(index >= BUFFER_SIZE)
3682  00f9 b655          	ld	a,L3522_index
3683  00fb a140          	cp	a,#64
3684  00fd 2502          	jrult	L1132
3685                     ; 107 			index = 0;
3687  00ff 3f55          	clr	L3522_index
3688  0101               L1132:
3689                     ; 109 	PD_CR2 |= 0x02;//EXT interrupt enable
3691  0101 72125013      	bset	_PD_CR2,#1
3692                     ; 110 }
3695  0105 5b03          	addw	sp,#3
3696  0107 85            	popw	x
3697  0108 bf00          	ldw	c_y,x
3698  010a 320002        	pop	c_y+2
3699  010d 85            	popw	x
3700  010e bf00          	ldw	c_x,x
3701  0110 320002        	pop	c_x+2
3702  0113 80            	iret
3781                     	xdef	f_EXTI3_IRQHandler
3782                     	xdef	_HexTable
3783                     	xdef	_StartRXD
3784                     	xdef	_UART_RXGPIO_Config
3785                     	xdef	_frameEnd
3786                     	xdef	_frameStart
3787                     	xdef	_RX_FRAME
3788                     	xdef	_BufLength
3789                     	xdef	_RX_End
3790                     	xdef	_RX_Buf
3791                     	xref	_Delay1s
3792                     	xref	_Delay50us
3793                     	xref	_memset
3794                     	xref.b	c_x
3795                     	xref.b	c_y
3814                     	end
