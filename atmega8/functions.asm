/*
 * text.asm
 *
 *  Created: 14.06.2016 10:43:31
 *   Author: Asus-PC
 */ 



cycSEK: 				
	subi R24,1
	ldi R28, 255
cycMKS:					

	cpi R28, 1		
	brlo decMKS				
	subi R28,1				
	
	ldi R16, DELAY_MS_LOW	
	ldi R17, DELAY_MS_HIGH
	rjmp _delay_c

new_cycle: 
	subi R17, 1
	ldi R16, 255
_delay_c:					
	subi R16, 4				
	cpi R16, 4				
	brsh _delay_c			
	NOP			
	NOP
	cpi R17, 0			
	brne new_cycle			
	rjmp cycMKS			

decMKS:						 
	cpi R24,0				
	brne cycSEK	
ret	




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


printCurrentColor:
	LCD8_MACRO_MOV_CURSOR 0,2
	LCD8_MACRO_OUT_STRING r, 2
	LCD8_MACRO_MOV_CURSOR 1,2
	LCD8_MACRO_OUT_STRING clear_number, 4
	LCD8_MACRO_MOV_CURSOR 1,2
	lds r16, LED1_RED
	rcall print_number

	LCD8_MACRO_MOV_CURSOR 3,2
	LCD8_MACRO_OUT_STRING g, 2
	LCD8_MACRO_MOV_CURSOR 4,2
	LCD8_MACRO_OUT_STRING clear_number, 4
	LCD8_MACRO_MOV_CURSOR 4,2
	lds r16, LED1_GREEN
	rcall print_number

	LCD8_MACRO_MOV_CURSOR 0,3
	LCD8_MACRO_OUT_STRING b, 2
	LCD8_MACRO_MOV_CURSOR 1,3
	LCD8_MACRO_OUT_STRING clear_number, 4
	LCD8_MACRO_MOV_CURSOR 1,3
	lds r16, LED1_BLUE
	rcall print_number
ret