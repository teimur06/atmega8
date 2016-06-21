

; ���������� ������ �� Flash ������ ���������, ��������� �� ������ ������ ��������� � Z ��������
LCD12864_out_string:
for1:
	lpm Temp, Z+
	cpi Temp1, 0
	breq exit1
	dec Temp1
	push Temp1
	mov  Data,  Temp
	rcall  LCD12864_DataOut
	pop Temp1
	rjmp for1
exit1:
	ret

LCD12864_out_string_for_ram:
LCD12864_out_ram_for1:
	ld Temp, Z+
	cpi Temp1, 0
	breq LCD12864_out_ram_exit1
	dec Temp1
	push Temp1
	mov  Data,  Temp
	rcall  LCD12864_DataOut
	pop Temp1
	rjmp LCD12864_out_ram_for1
LCD12864_out_ram_exit1:
	ret



/*************************************
������� �������� ������� � ������ �� ������������ ����� 8 ���
	LCD12864_CommandOut - ���������� �������
	LCD12864_DataOut    - ���������� ������

	������� ��� ������ ������ ��������� � �������� Data
**************************************/
.ifndef SERIAL
LCD12864_DataOut:
       sbi  PCom,  RS               ;RS=1;
	   LCD8_MACRO_DELAY 1, 1
	   sbi  PCom,  E                ;E=1.
	   out  PW,    Data             ;����� ������.
	   LCD8_MACRO_DELAY 1, 1
       cbi  PCom,  E                ;RS=0, E=0.
       cbi  Pcom,  RS   
	   LCD8_MACRO_DELAY 1, 50
       ret



LCD12864_CommandOut:                ;����� ������� �� ���������.
       cbi  PCom,  E                ;E=0 � RS.
       cbi  PCom,  RS
	   cbi  PCom,  RW
	   LCD8_MACRO_DELAY 1, 1
	   sbi  PCom,  E                ;E=1.
       out  PW,    Data             ;�������� ������.
       LCD8_MACRO_DELAY 1, 1
	   cbi  PCom,  E                ;E=0 
	   LCD8_MACRO_DELAY 1, 50
	   ret


.endif



/*************************************
������� �������� ������� � ������ �� ����������������� �����
	LCD12864_CommandOut - ���������� �������
	LCD12864_DataOut    - ���������� ������

	������� ��� ������ ������ ��������� � �������� Data
**************************************/
.ifdef SERIAL
LCD12864_CommandOut:
	ldi r20, 0
	rjmp command
LCD12864_DataOut:

	sbi DDRx, RW
	sbi DDRx, E
	ldi r20, 1	 
command:	      
	LCD8_MACRO_DELAY 1, 10
	;sbi PCom, CS
	sbi PCom, SID
	rcall strob ; 1
	rcall strob ; 1
	rcall strob ; 1
	rcall strob ; 1
	rcall strob ; 1
	cbi PCom, SID  ; rw = 0
	rcall strob

	cbi PCom, SID  ; rs = 0
	cpi r20, 0
	breq command1
	sbi PCom, SID  ; rs = 1

command1:
	rcall strob
	cbi PCom, SID  ; 0
	rcall strob


	ldi r20, 8
for_send_data:
	cpi r20, 0
	breq  stop_send_data
	cpi r20, 4
	brne  no_strob
	cbi PCom, SID
	rcall strob
	rcall strob
	rcall strob
	rcall strob
no_strob:
	dec r20
	rol		Data			
	brcs  send_bit_1
	cbi PCom, SID ; ������ 0 ���
	rcall strob
	rjmp for_send_data
send_bit_1:
	sbi PCom, SID ; ������ 1 ���
	rcall strob
	rjmp for_send_data
stop_send_data:
	cbi PCom, SID 
	rcall strob
	rcall strob
	rcall strob
	rcall strob
	cbi PCom, SID 
	;cbi PCom, CS
	ret



strob:
	LCD8_MACRO_DELAY 1, 50
	sbi PCom, SCLK	
	LCD8_MACRO_DELAY 1, 50
	cbi PCom, SCLK
	LCD8_MACRO_DELAY 1, 50
	ret
.endif
;******************************************************




LCD12864_Init:                      ;������������� �������.
	 LCD8_MACRO_DELAY 255, 255
	 LCD8_MACRO_DELAY 57, 255
     LCD8_MACRO_SET_FUNCTION (1<<SET_FUNCT)  | (1<<BIT_8) | (1<<EXT_FUNC)  ;����� �������.
	 LCD8_MACRO_DELAY 1, 255
     LCD8_MACRO_SET_FUNCTION (1<<SET_FUNCT)  | (1<<BIT_8) | (1<<EXT_FUNC)    ;����� �������.
	 LCD8_MACRO_DELAY 1, 255
	 LCD8_MACRO_SET_DISPLAY_STATUS (1<< SET_DISPLAY) |   (1<<DISPLAY_ON)  | (1<<CURSOR_ON)
	 LCD8_MACRO_DELAY 1, 255

	 LCD8_MACRO_CLEAR       ;����� �������.
   	 LCD8_MACRO_DELAY 80, 255
     LCD8_MACRO_ENTRY_MODE_SET (1<<ENTRY_MODE) | (1<<ENTRY_ID)

	


    ret

	; ������ ��������

	; E_temp - ����� ������ � ����� Temp
	; E_temp1 - ����� ������ � ����� Temp1
	; F �������
	; Tmk - ����� � ������������� �� 1 ����
	; C_temp1 - ���������� ������ (�������� Temp1) ����������� ��� temp = 255
	; C_temp - ���������� ������ (�������� Temp) ��� �����������
	; ML - ���������� ��������� �����������, ���� ���� �� ML = 1
	; MK - ���������� ��������� �����������, ���� ���� �� MK = 1

	; Tmk = 1000000/F
	; C_temp = MK / (E_temp * Tmk) 
	; C_temp1 = ( (ML * 1000) / (256 * E_temp * Tmk) ) - ( (E_temp1 * ML) / 256)


	/* ������ ��������� 12 ������������
	E_temp - 4
	E_temp1 - 8
	F = 8 000 000 ��
	Tmk = 1 000 000 / 8 000 000 = 0.125 ���
	C_temp = 255 ( ��� ��� ��� ����� ������������ )
	C_temp1 = ( (12 * 1000) / (256 * 4 * 0.125) ) - ( (8 * 12) / 256 ) = 93

	   ������: ��������� 25 �����������
	E_temp - 4
	E_temp1 - 8
	F = 8 000 000 ��
	Tmk = 1 000 000 / 8 000 000 = 0.125 ���
	C_temp = 25 / (4 * 0,125) = 50
	C_temp1 = 0 ( ��� ��� ��� ����� ������ ������������ )
	*/

LCD12864_Delay:
	; ���� E_temp1
	push  Temp                  ;��������� ������� �������� � ���.  [2 ������]		E_temp1

	; ���� E_temp
ES0:
	dec  Temp                   ;- ��������.						[1 ����]		E_temp
	cpi  Temp,  0               ;�����������?						[1 ����]		E_temp
    brne  ES0                   ;��� - ��� ���.						[2 �����]		E_temp
	
	; ���� E_temp1
	pop  Temp                   ;��? ������������ �������.			[2 �����]		E_temp1
	dec  Temp1                  ;������ �� "���������� ��������" �������. [1 ����]	E_temp1
	cpi  Temp1, 0               ;���������� �������� = 0?			[1 ����]		E_temp1
    brne  LCD12864_Delay		;									[2 �����]		E_temp1
    ret



; ������� ����������� ������� �� �������
LCD12864_mov_cursor: ; r16 - x ; r17 - y
	push r16
	push r17
	push r18

	cpi r17, 0
	breq exet5

	cpi r17, 1
	breq one

	cpi r17, 2
	breq two

	cpi r17, 3
	breq three

one:
	ldi r17, 16
	add r16, r17
	rjmp exet5
two:
	ldi r17, 8
	add r16, r17	
	rjmp exet5
three:
	ldi r17, 24
	add r16, r17

exet5:
	ldi Data, 0b10000000
	add Data, r16
	rcall  LCD12864_CommandOut
	pop r18
	pop r17
	pop r16

	ret