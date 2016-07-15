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


	ldi r16, 0
	sts color, r16


	; Начальный цвет светодиода
	ldi r16, 0
	sts LED1_RED, r16
	ldi r16, 0
	sts LED1_GREEN, r16
	ldi r16, 0
	sts LED1_BLUE, r16



    


	; init RAM
	ldi r16, 0x00
	sts delayInt0Bool, r16
	sts T0Bool, r16
	sts T0Bool, r16
	
	sts num, r16
	
	ldi r24, 0xFF

	OUTI TIMSK, (1<<TOIE0) | (1<<OCF2)

	; on timer0
	OUTI TCNT0, 0
	OUTI TCCR0, (1<<CS00)


	; on timer2
	OUTI OCR2, 1
	OUTI TCNT2, 0
	OUTI TCCR2, (1<<CS10)  |(1<<CS12) | (1<< WGM21)
	
	; on timer1 
	
/*	OUTI OCR1AH, high(time)
	OUTI OCR1AL, low(time)

	OUTI TCNT1H, 0
	OUTI TCNT1L, 0

	OUTI TCCR1A, 0 
	OUTI TCCR1B,  (1<<CS10)  |(1<<CS12) | (1<<WGM12)*/
	

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

	rcall printCurrentColor

	sei



; Главная программа
main:
	lds r16, delayInt0Bool
	sbrc r16, 0
	rcall int0_proc
rjmp main



 

; Прерывание нажатия кнопки int0
i_int0:
	push r16
	in r16, SREG
	push r16

	OUTI GICR, 0
	

	lds r16, delayInt0Bool
	sbrc r16, 0
	rjmp i_int0_exit
	
	ldi r16, 0x01
	sts delayInt0Bool, r16
	
  i_int0_exit:
	pop r16
	out SREG, r16
	pop r16
reti


; Подпрограмма управления RGB светодиодом
; PD0 = RED
; PD1 = GREEN
; PD2 = BLUE

.def reg1 = r25
.def reg2 = r26
.def reg3 = r27
T0:
	push reg1
	push reg2
	push reg3

	in reg1, SREG
	push reg1

	in reg1, PORTD
	lds reg2, COUNT_PWM ; Счетчик ШИМ
	cpi reg2, 0
	brne T0_red
	cbr reg1, 0x0B ; Если счетчик ШИМ на нуле включаем все светодиоды

	; Если значение счетчика ШИМ достигло LED1_*** то выключаем нужные светодиоды
  T0_red:
	lds reg3, LED1_RED
	cp reg2, reg3
	brne T0_green
	sbr reg1, 0x01 ; Отключам RED

  T0_green:
	lds reg3, LED1_GREEN
	cp reg2, reg3
	brne T0_blue
	sbr reg1, 0x02 ; Отключам GREEN

  T0_blue:
	lds reg3, LED1_BLUE
	cp reg2, reg3
	brne T0_exit
	sbr reg1, 0x08 ; Отключам BLUE

  T0_exit:
	out PortD, reg1
	; Увеличиваем счетчик ШИМ

	inc reg2
	sts COUNT_PWM, reg2

	pop reg1
	out SREG, reg1

	pop reg3
	pop reg2
	pop reg1
reti

; Прерывания таймера счетчика Т2 
T2:
	push r16
	push r17
	in r16, SREG
	push r16
	
	lds r16, LED1_RED
	ldi r17, 1
	add r16, r17
	sts LED1_RED, r16
	ldi r17, 0
	lds r16, LED1_GREEN
	adc r16,r17
	sts LED1_GREEN, r16
	lds r16, LED1_BLUE
	adc r16,r17
	sts LED1_BLUE, r16



	pop r16
	out SREG, r16
	pop r17
	pop r16		
reti

; Прерывания таймера счетчика Т1 при совпадении А
T1_A:

reti



; Подпрограмма инвертирования 
int0_proc:
	sbis PIND,2
	ret

	push r16
	push r17

/*	LCD8_MACRO_MOV_CURSOR 3,2
	LCD8_MACRO_OUT_STRING clear_number, 4
	LCD8_MACRO_MOV_CURSOR 3,2
	lds r16, num
	inc r16
	sts num, r16
	;sts LED1_GREEN, r16
	rcall print_number*/

	rcall printCurrentColor

	delay 100
	ldi r16, 0
	sts delayInt0Bool, r16

	OUTI GICR, (1<<INT0)
	pop r17
	pop r16
ret



; Текст
 text: .db "init: ok"
 debuge: .db "display debug",0
 clear_number: .db "    "
 r: .db "R:"
 g: .db "G:"
 b: .db "B:"

