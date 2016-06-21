/******************************************************************************************************************
LCD дисплей на контроллере ST7920

Для использования последовательного (SPI) режима передачи данных установите дерективу SERIAL
Для использования 8 битной передачи данных удалите дерективу SERIAL

										Описание функций
LCD12864_DataOut    - отправляет данные на дисплей, данные должны находится в регистре Data
LCD12864_CommandOut - отправляет команду на дисплей, команда должна находится в регистре Data
LCD12864_out_string - Отправляет строку из Flash памяти программы, имеет 2 параметра, 
					  1 - это указатель на строку который должен хранится в регистре Z
					  2 - это количество передаваемых символов, должен находится в регистре  Temp1
LCD12864_mov_cursor - Устанавливает положения курсора на дисплее, и имеет 2 параметра координаты X и Y
					  1 - это X координата, передается в регистре r16
					  2 - это Y координата, передается в регистре r17
							


										Описание макросов
LCD8_MACRO_SET_SR - Устанавливает параметры SR
				   (1<<SET_SR) - Обязательный параметр
				   (1<<SR) - Устанавливает значение SR в 1

LCD8_MACRO_ENTRY_MODE_SET - ENTRY MODE
							(1<<ENTRY_MODE) - Обязательный параметр
							(1<<ENTRY_ID)
							(1<<ENTRY_S)		
			
LCD8_MACRO_SET_FUNCTION - 	Устанавливает свойства функций
							(1<<SET_FUNCT) - Обязательный параметр
							(1<<BIT_8) - Устанавливается если используется 8 битная шина
							(1<<EXT_FUNC) - Использовать набор расширеных функций
							(1<<GRAPH_DISP_ON) - Включает графический дисплей		
							
LCD8_MACRO_SET_DISPLAY_STATUS - Устанавливает статуст дисплея  
								(1<<SET_DISPLAY) - Обязательный параметр
								(1<<BLINC_CURSOR) - Мигать курсорам
								(1<<CURSOR_ON) - Показывать курсор
								(1<<DISPLAY_ON) - Включить дисплей
								

LCD8_MACRO_MOV_CURSOR - Переместить курсор в нужную координату дисплэя 
							   1 Параметр это X
							   2 параметр это Y	
							   
LCD8_MACRO_DISPLAY_RIGHT - Переместить дисплей вправо	

LCD8_MACRO_DISPLAY_LIFT - Переместить дисплей влево				

LCD8_MACRO_CLEAR - Отчистить экран	

LCD8_MACRO_HOME - Переместить курсор и дисплэй в начало	

LCD8_MACRO_CURSOR_RIGHT - Переместить курсор вправо

LCD8_MACRO_CURSOR_LIFT  - Переместить курсор влево 

LCD8_MACRO_OUT_COMMAND - Отправить команду 
						1 параметр - команда 
						
LCD8_MACRO_OUT_DATA - Отправить данные 
					  1 параметр - данные	
					  
LCD8_MACRO_DELAY - Задержка в микросекундах
				   1 параметр количество задержек
				   2 параметр, количество микросекунд в задержки
				   

LCD8_MACRO_OUT_STRING - Записывает строку из памяти программы
						1 параметр метка строки из памяти программы
						2 параметр количества символов 				   					  																					  
******************************************************************************************************************/

.equ DDRx = DDRC
.equ PCom = PORTC ; Порт управлени в 8 бит режиме, и регистр передачи данных и управления в последовательном режиме
.equ PW = PORTB	  ; Порт данных в 8 битном режиме, в последовательном режиме не используется
.def Temp = R16	  ; Временый региятр
.def Temp1 = R17  ; Временный регистр
.def Data = R18   ; Регистр используется для записи данных в порт

.equ SERIAL = 0 ; Если установленна то работает по последовательному порту,
				; Что бы сделать паралельный порт 8 бит удалите эту дериктиву

; Управляющие порты для 8 битной передачи данных
.equ RS = 2
.equ E = 0
.equ RW = 1

; Управляющие порты для последовательной передачи данных
.equ SID = 1 ; RW
.equ CS = 2  ; RS - Не используется!!!
.equ SCLK = 0; E

; Для функции LCD8_MACRO_SET_SR
.equ SET_SR = 1			; - Идентификатор установки SR
.equ SR = 0				; - Параметр SR

; Для функции LCD8_MACRO_SET_FUNCTION
.equ SET_FUNCT = 5		; Идентификатор установки функции 
.equ BIT_8 = 4			;- Устанавливается если используется 8 битная шина
.equ EXT_FUNC = 2		; - Использовать набор расширеных функций
.equ GRAPH_DISP_ON = 1  ; - Включает графический дисплей


; Для функции LCD8_MACRO_SET_DISPLAY_STATUS
.equ SET_DISPLAY = 3	; - Идентификатор функции работы с дисплеем
.equ BLINC_CURSOR = 0	; - Мигать курсорам 
.equ CURSOR_ON = 1		; - Показывать курсор
.equ DISPLAY_ON = 2		; - Включить дисплей

; Для функции LCD8_MACRO_ENTRY_MODE_SET 
.equ ENTRY_MODE = 2	; Идентификатор функции ENTRY MODE
.equ ENTRY_ID = 1
.equ ENTRY_S = 0


; Устанавливает параметры SR
; (1<<SET_SR) - Обязательный параметр
; (1<<SR) - Устанавливает значение SR в 1
.MACRO LCD8_MACRO_SET_SR 
	LCD8_MACRO_OUT_COMMAND  @0
.ENDM

; ENTRY MODE
; (1<<ENTRY_MODE) - Обязательный параметр
; (1<<ENTRY_ID)
; (1<<ENTRY_S)
.MACRO LCD8_MACRO_ENTRY_MODE_SET
	LCD8_MACRO_OUT_COMMAND  @0
.ENDM

; Устанавливает свойства функций
; (1<<SET_FUNCT) - Обязательный параметр
; (1<<BIT_8) - Устанавливается если используется 8 битная шина
; (1<<EXT_FUNC) - Использовать набор расширеных функций
; (1<<GRAPH_DISP_ON) - Включает графический дисплей
.MACRO LCD8_MACRO_SET_FUNCTION
	LCD8_MACRO_OUT_COMMAND   @0
.ENDM

; Устанавливает статуст дисплея 
; (1<<SET_DISPLAY) - Обязательный параметр
; (1<<BLINC_CURSOR) - Мигать курсорам
; (1<<CURSOR_ON) - Показывать курсор
; (1<<DISPLAY_ON) - Включить дисплей
.MACRO LCD8_MACRO_SET_DISPLAY_STATUS  
	LCD8_MACRO_OUT_COMMAND @0
.ENDM

; Переместить курсор в нужную координату дисплэя
.MACRO LCD8_MACRO_MOV_CURSOR ; 1 Параметр это X,  2 параметр это Y
	ldi r16, @0
	ldi r17, @1
	rcall LCD12864_mov_cursor
.ENDM


; Переместить дисплей вправо
.MACRO LCD8_MACRO_DISPLAY_RIGHT 
	LCD8_MACRO_OUT_COMMAND 0b00011100
.ENDM


; 
.MACRO LCD8_MACRO_VERTICAL_SCROLL
	LCD8_MACRO_OUT_COMMAND 0b00000011
	
.ENDM



; Переместить дисплей влево
.MACRO LCD8_MACRO_DISPLAY_LIFT 
	LCD8_MACRO_OUT_COMMAND 0b00011000
.ENDM

; Отчистить экран
.MACRO LCD8_MACRO_CLEAR ; Отчистить экран
	LCD8_MACRO_OUT_COMMAND 0b00000001
.ENDM

; Переместить курсор и дисплэй в начало
.MACRO LCD8_MACRO_HOME 
	LCD8_MACRO_OUT_COMMAND 0b00000010
.ENDM

; Переместить курсов вправо
.MACRO LCD8_MACRO_CURSOR_RIGHT 
	LCD8_MACRO_OUT_COMMAND 0b00010100
.ENDM

; Переместить курсор влево
.MACRO LCD8_MACRO_CURSOR_LIFT 
	LCD8_MACRO_OUT_COMMAND 0b00010000
.ENDM

; Отправить команду 
.MACRO LCD8_MACRO_OUT_COMMAND ; 1 параметр - команда
     ldi  Data,  @0
     rcall  LCD12864_CommandOut
.ENDM

; Отправить данные
.MACRO LCD8_MACRO_OUT_DATA    ; 1 параметр - данные
     ldi  Data,  @0
     rcall  LCD12864_DataOut
.ENDM

; Задержка
.MACRO LCD8_MACRO_DELAY ; 1 параметр количество задержек, 2 параметр, количество микросекунд в задержки
       ldi  Temp,  @0               
       ldi  Temp1, @1
     rcall  LCD12864_Delay
.ENDM

; Записывает строку из памяти программы
.MACRO LCD8_MACRO_OUT_STRING ; 1 параметр метка строки из памяти программы, 2 параметр количества символов 
	ldi ZL, low(@0*2)
	ldi ZH, high(@0*2)
	ldi temp1, @1
	rcall LCD12864_out_string
.ENDM

