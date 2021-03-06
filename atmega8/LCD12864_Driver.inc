/******************************************************************************************************************
LCD ������� �� ����������� ST7920

��� ������������� ����������������� (SPI) ������ �������� ������ ���������� ��������� SERIAL
��� ������������� 8 ������ �������� ������ ������� ��������� SERIAL

										�������� �������
LCD12864_DataOut    - ���������� ������ �� �������, ������ ������ ��������� � �������� Data
LCD12864_CommandOut - ���������� ������� �� �������, ������� ������ ��������� � �������� Data
LCD12864_out_string - ���������� ������ �� Flash ������ ���������, ����� 2 ���������, 
					  1 - ��� ��������� �� ������ ������� ������ �������� � �������� Z
					  2 - ��� ���������� ������������ ��������, ������ ��������� � ��������  Temp1
LCD12864_mov_cursor - ������������� ��������� ������� �� �������, � ����� 2 ��������� ���������� X � Y
					  1 - ��� X ����������, ���������� � �������� r16
					  2 - ��� Y ����������, ���������� � �������� r17
							


										�������� ��������
LCD8_MACRO_SET_SR - ������������� ��������� SR
				   (1<<SET_SR) - ������������ ��������
				   (1<<SR) - ������������� �������� SR � 1

LCD8_MACRO_ENTRY_MODE_SET - ENTRY MODE
							(1<<ENTRY_MODE) - ������������ ��������
							(1<<ENTRY_ID)
							(1<<ENTRY_S)		
			
LCD8_MACRO_SET_FUNCTION - 	������������� �������� �������
							(1<<SET_FUNCT) - ������������ ��������
							(1<<BIT_8) - ��������������� ���� ������������ 8 ������ ����
							(1<<EXT_FUNC) - ������������ ����� ���������� �������
							(1<<GRAPH_DISP_ON) - �������� ����������� �������		
							
LCD8_MACRO_SET_DISPLAY_STATUS - ������������� ������� �������  
								(1<<SET_DISPLAY) - ������������ ��������
								(1<<BLINC_CURSOR) - ������ ��������
								(1<<CURSOR_ON) - ���������� ������
								(1<<DISPLAY_ON) - �������� �������
								

LCD8_MACRO_MOV_CURSOR - ����������� ������ � ������ ���������� ������� 
							   1 �������� ��� X
							   2 �������� ��� Y	
							   
LCD8_MACRO_DISPLAY_RIGHT - ����������� ������� ������	

LCD8_MACRO_DISPLAY_LIFT - ����������� ������� �����				

LCD8_MACRO_CLEAR - ��������� �����	

LCD8_MACRO_HOME - ����������� ������ � ������� � ������	

LCD8_MACRO_CURSOR_RIGHT - ����������� ������ ������

LCD8_MACRO_CURSOR_LIFT  - ����������� ������ ����� 

LCD8_MACRO_OUT_COMMAND - ��������� ������� 
						1 �������� - ������� 
						
LCD8_MACRO_OUT_DATA - ��������� ������ 
					  1 �������� - ������	
					  
LCD8_MACRO_DELAY - �������� � �������������
				   1 �������� ���������� ��������
				   2 ��������, ���������� ����������� � ��������
				   

LCD8_MACRO_OUT_STRING - ���������� ������ �� ������ ���������
						1 �������� ����� ������ �� ������ ���������
						2 �������� ���������� �������� 				   					  																					  
******************************************************************************************************************/

.equ DDRx = DDRC
.equ PCom = PORTC ; ���� ��������� � 8 ��� ������, � ������� �������� ������ � ���������� � ���������������� ������
.equ PW = PORTB	  ; ���� ������ � 8 ������ ������, � ���������������� ������ �� ������������
.def Temp = R16	  ; �������� �������
.def Temp1 = R17  ; ��������� �������
.def Data = R18   ; ������� ������������ ��� ������ ������ � ����

.equ SERIAL = 0 ; ���� ������������ �� �������� �� ����������������� �����,
				; ��� �� ������� ����������� ���� 8 ��� ������� ��� ���������

; ����������� ����� ��� 8 ������ �������� ������
.equ RS = 2
.equ E = 0
.equ RW = 1

; ����������� ����� ��� ���������������� �������� ������
.equ SID = 1 ; RW
.equ CS = 2  ; RS - �� ������������!!!
.equ SCLK = 0; E

; ��� ������� LCD8_MACRO_SET_SR
.equ SET_SR = 1			; - ������������� ��������� SR
.equ SR = 0				; - �������� SR

; ��� ������� LCD8_MACRO_SET_FUNCTION
.equ SET_FUNCT = 5		; ������������� ��������� ������� 
.equ BIT_8 = 4			;- ��������������� ���� ������������ 8 ������ ����
.equ EXT_FUNC = 2		; - ������������ ����� ���������� �������
.equ GRAPH_DISP_ON = 1  ; - �������� ����������� �������


; ��� ������� LCD8_MACRO_SET_DISPLAY_STATUS
.equ SET_DISPLAY = 3	; - ������������� ������� ������ � ��������
.equ BLINC_CURSOR = 0	; - ������ �������� 
.equ CURSOR_ON = 1		; - ���������� ������
.equ DISPLAY_ON = 2		; - �������� �������

; ��� ������� LCD8_MACRO_ENTRY_MODE_SET 
.equ ENTRY_MODE = 2	; ������������� ������� ENTRY MODE
.equ ENTRY_ID = 1
.equ ENTRY_S = 0


; ������������� ��������� SR
; (1<<SET_SR) - ������������ ��������
; (1<<SR) - ������������� �������� SR � 1
.MACRO LCD8_MACRO_SET_SR 
	LCD8_MACRO_OUT_COMMAND  @0
.ENDM

; ENTRY MODE
; (1<<ENTRY_MODE) - ������������ ��������
; (1<<ENTRY_ID)
; (1<<ENTRY_S)
.MACRO LCD8_MACRO_ENTRY_MODE_SET
	LCD8_MACRO_OUT_COMMAND  @0
.ENDM

; ������������� �������� �������
; (1<<SET_FUNCT) - ������������ ��������
; (1<<BIT_8) - ��������������� ���� ������������ 8 ������ ����
; (1<<EXT_FUNC) - ������������ ����� ���������� �������
; (1<<GRAPH_DISP_ON) - �������� ����������� �������
.MACRO LCD8_MACRO_SET_FUNCTION
	LCD8_MACRO_OUT_COMMAND   @0
.ENDM

; ������������� ������� ������� 
; (1<<SET_DISPLAY) - ������������ ��������
; (1<<BLINC_CURSOR) - ������ ��������
; (1<<CURSOR_ON) - ���������� ������
; (1<<DISPLAY_ON) - �������� �������
.MACRO LCD8_MACRO_SET_DISPLAY_STATUS  
	LCD8_MACRO_OUT_COMMAND @0
.ENDM

; ����������� ������ � ������ ���������� �������
.MACRO LCD8_MACRO_MOV_CURSOR ; 1 �������� ��� X,  2 �������� ��� Y
	ldi r16, @0
	ldi r17, @1
	rcall LCD12864_mov_cursor
.ENDM


; ����������� ������� ������
.MACRO LCD8_MACRO_DISPLAY_RIGHT 
	LCD8_MACRO_OUT_COMMAND 0b00011100
.ENDM


; 
.MACRO LCD8_MACRO_VERTICAL_SCROLL
	LCD8_MACRO_OUT_COMMAND 0b00000011
	
.ENDM



; ����������� ������� �����
.MACRO LCD8_MACRO_DISPLAY_LIFT 
	LCD8_MACRO_OUT_COMMAND 0b00011000
.ENDM

; ��������� �����
.MACRO LCD8_MACRO_CLEAR ; ��������� �����
	LCD8_MACRO_OUT_COMMAND 0b00000001
.ENDM

; ����������� ������ � ������� � ������
.MACRO LCD8_MACRO_HOME 
	LCD8_MACRO_OUT_COMMAND 0b00000010
.ENDM

; ����������� ������ ������
.MACRO LCD8_MACRO_CURSOR_RIGHT 
	LCD8_MACRO_OUT_COMMAND 0b00010100
.ENDM

; ����������� ������ �����
.MACRO LCD8_MACRO_CURSOR_LIFT 
	LCD8_MACRO_OUT_COMMAND 0b00010000
.ENDM

; ��������� ������� 
.MACRO LCD8_MACRO_OUT_COMMAND ; 1 �������� - �������
     ldi  Data,  @0
     rcall  LCD12864_CommandOut
.ENDM

; ��������� ������
.MACRO LCD8_MACRO_OUT_DATA    ; 1 �������� - ������
     ldi  Data,  @0
     rcall  LCD12864_DataOut
.ENDM

; ��������
.MACRO LCD8_MACRO_DELAY ; 1 �������� ���������� ��������, 2 ��������, ���������� ����������� � ��������
       ldi  Temp,  @0               
       ldi  Temp1, @1
     rcall  LCD12864_Delay
.ENDM

; ���������� ������ �� ������ ���������
.MACRO LCD8_MACRO_OUT_STRING ; 1 �������� ����� ������ �� ������ ���������, 2 �������� ���������� �������� 
	ldi ZL, low(@0*2)
	ldi ZH, high(@0*2)
	ldi temp1, @1
	rcall LCD12864_out_string
.ENDM

