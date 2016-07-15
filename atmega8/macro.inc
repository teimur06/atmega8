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


// delay MS
.macro delay
	push R16				
	push R17
	push R24
	push R28

	ldi R28, LOW(@0)
	ldi R24, HIGH(@0)
	rcall cycMKS	

	pop R28					
	pop R24					
	pop R17					
	pop R16					
.endm


