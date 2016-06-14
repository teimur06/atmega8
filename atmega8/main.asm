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
	

	; on timer1 
	OUTI TIMSK, 0

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

	rcall LCD12864_Init

	LCD8_MACRO_OUT_STRING text,8
	LCD8_MACRO_MOV_CURSOR 0,1
	LCD8_MACRO_OUT_STRING debuge,13




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

 text: .db "init: ok"
 debuge: .db "display debug",0