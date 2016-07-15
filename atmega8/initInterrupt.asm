/*
 * initInterrupt.asm
 *
 *  Created: 14.06.2016 10:32:32
 *   Author: Asus-PC
 */ 
 .cseg
  .org 0
	rjmp reset
	rjmp i_int0
.org 3
	rjmp T2
.org 6
	rjmp T1_A
.org 9
	rjmp T0