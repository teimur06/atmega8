/*
 * main.asm
 *
 *  Created: 14.06.2016 10:35:22
 *   Author: Asus-PC
 */ 
 



 reset:
	cli

	; set stack
	OUTI sph, high(RAMEND)
	OUTI spl, low(RAMEND)
	
	; off Analog Comparator
	OUTI ACSR, 0x00

	; set ports
	ldi r16, 0xFF
	out DDRB, r16
	out DDRC, r16
	out DDRD, r16
	out PORTB, r16
	out PORTC, r16
	out PORTD, r16
	cbi PORTB, 0

	; init RAM
	ldi r16, 0x00
	sts delayInt0Bool, r16
	sts num, r16
	
	OUTI TIMSK, 0

	; on timer2
	OUTI OCR2, 2
	OUTI TCNT2, 0
	OUTI TCCR2, (1<<WGM20) | (1<<WGM21) |(1<<CS22) | (1<<CS20) | (1<<COM20)| (1<<COM21)

	
	; on timer1 
	
	OUTI OCR1AH, high(time)
	OUTI OCR1AL, low(time)

	OUTI TCNT1H, 0
	OUTI TCNT1L, 0

	OUTI TCCR1A, (1<<COM1A0) 
	OUTI TCCR1B, (1<<CS10) | (1<<CS12) | (1<<WGM12)
	

	; on int0
	cbi DDRD, 2
	sbi PIND, 2

	OUTI MCUCR, 0

	OUTI GICR, (1<<INT0)

	; init display
	rcall LCD12864_Init
	LCD8_MACRO_VERTICAL_SCROLL
	LCD8_MACRO_OUT_COMMAND 0b00100000

	LCD8_MACRO_OUT_STRING text,8
	LCD8_MACRO_MOV_CURSOR 0,1
	LCD8_MACRO_OUT_STRING debuge,13

	LCD8_MACRO_MOV_CURSOR 3,2
	ldi r16, 0
	rcall print_number

	


	sei

main:
	lds r16, delayInt0Bool
	sbrc r16, 0
	rcall invertPortB_0
 rjmp main

invertPortB_0:
	sbis PIND,2
	ret

	push r16
	push r17
	in r16, PORTB
	ldi r17, 0x01
	eor r16, r17
	out PORTB, r16

	LCD8_MACRO_MOV_CURSOR 3,2
	lds r16, num
	inc r16
	sts num, r16
	rcall print_number


	DELAY_MS 100, F_CPU
	ldi r16, 0x00
	sts delayInt0Bool, r16

	OUTI GICR, (1<<INT0)
	pop r17
	pop r16
ret


i_int0:
	cli
	OUTI GICR, 0
	
	lds r16, delayInt0Bool
	sbrc r16, 0
	reti
	
	ldi r16, 0x01
	sts delayInt0Bool, r16
	sei
reti


; in r16 number
; out r16 length line
binToAnsii:
	push r17
	push r18
	ldi r18,0
	cpi r16, 0xA
	brlo less10
	cpi r16, 0x64
	brlo less100
	cpi r16, 0xC8
	brlo less200
	rjmp larger200

	less10:
		ldi r18, 1
		ldi r17, 48
		add r16, r17
		sts numberOut+2, r16
		rjmp endBinToAnsii
	
	less100: 
		cpi r18, 0
		brne else
		ldi r18, 2
		else:
		ldi r17, 0xA
		rcall div8u_c
		ldi r17, 48
		add r16, r17
		add r15, r17
		sts numberOut+2,r15
		sts numberOut+1, r16  
		rjmp endBinToAnsii

	less200:
		ldi r18, 3
		ldi r17, 0x31
		sts numberOut, r17
		subi r16, 100
		rjmp less100

	larger200:
		ldi r18,3
		ldi r17, 0x32
		sts numberOut, r17
		subi r16, 200
		rjmp less100

	endBinToAnsii:
		mov r16, r18
		pop r18
		pop r17
ret


; in r16 number
print_number:
	rcall binToAnsii
	
	ldi ZL, low(numberOut)
	ldi ZH, high(numberOut)
	ldi temp1, 3
	sub temp1, Temp
	
	add ZL, temp1 
	ldi temp1, 0
	adc ZH, temp1 

	mov temp1, temp

	rcall LCD12864_out_string_for_ram
ret



 text: .db "init: ok"
 debuge: .db "display debug",0

