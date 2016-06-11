/*
 * atmega8.asm
 *
 *  Created: 18.05.2016 22:50:49
 *   Author: Asus-PC
 */ 
 .include "macro.inc"
 
 .equ F_CPU = 8001000
 .equ time = 1000 ;7812

 .dseg
	delayInt0Bool: .byte 1

 .cseg
 .org 0
	rjmp reset
	rjmp i_int0

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

	sei

main:
	lds r16, delayInt0Bool
	sbrc r16, 0
	rcall invertPortB_0
 rjmp main

invertPortB_0:
	push r16
	push r17
	in r16, PORTB
	ldi r17, 0x01
	eor r16, r17
	out PORTB, r16

	DELAY_MS 300, F_CPU
	ldi r16, 0x00
	sts delayInt0Bool, r16

	OUTI GICR, (1<<INT0)
	pop r17
	pop r16
ret


i_int0:
	cli
	push r16
	OUTI GICR, 0
	
	lds r16, delayInt0Bool
	sbrc r16, 0
	reti
	
	ldi r16, 0x01
	sts delayInt0Bool, r16
	pop r16
	sei
reti