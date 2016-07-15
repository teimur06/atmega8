/*
 * atmega8.asm
 *
 *  Created: 18.05.2016 22:50:49
 *   Author: Asus-PC
 */ 
 .equ F_CPU = 4000000
 .equ time = 80 ;7812
 .equ DELAY_MS_LOW = LOW(F_CPU/1000)
 .equ DELAY_MS_HIGH = HIGH(F_CPU/1000)


 .include "macro.inc"
 .include "LCD12864_Driver.inc"
 .include "dataseg.asm"
 .include "initInterrupt.asm"
 .include "main.asm"
 .include "functions.asm"
 .include "LCD12864_Driver.asm"
 .include "math.asm"
