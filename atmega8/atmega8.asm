/*
 * atmega8.asm
 *
 *  Created: 18.05.2016 22:50:49
 *   Author: Asus-PC
 */ 
 .equ F_CPU = 8001000
 .equ time = 1000 ;7812

 .include "macro.inc"
 .include "LCD12864_Driver.inc"
 .include "dataseg.asm"
 .include "initInterrupt.asm"
 .include "main.asm"
 .include "LCD12864_Driver.asm"
 .include "text.asm"