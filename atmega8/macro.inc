/*
 * macro.inc
 *
 *  Created: 19.05.2016 13:17:37
 *   Author: Asus-PC
 */ 
 
.macro OUTI 
	ldi r16, @1
	out @0, r16	
.endm


.macro DELAY_MS
	push R16				
	push R17
	push R24
	push R28

	ldi R28, LOW(@0)
	ldi R24, HIGH(@0)
	rjmp cycMKS	

cycSEK: 				
	subi R24,1
	ldi R28, 255
cycMKS:					

	cpi R28, 1		
	brlo decMKS				
	subi R28,1				
	
ldi R16, LOW(@1/1000)	
	ldi R17, HIGH(@1/1000)
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

	pop R28					
	pop R24					
	pop R17					
	pop R16					
.endm