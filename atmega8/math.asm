/*
 * math.asm
 *
 *  Created: 14.06.2016 13:40:41
 *   Author: Asus-PC
 */ 



.def            d8s      =r14           ;������� �����
.def            drem8s   =r15           ;�������
.def            dres8s   =r16           ;���������
.def            dd8s     =r16           ;�������
.def            dv8s     =r17           ;��������
.def            dcnt8s   =r18           ;������� �����



div8s:          mov     d8s,dd8s                ;��������� ������� � ������� �����
                eor     d8s,dv8s                ;xor �������� ����� � ��������
                sbrc    dv8s,7                  ;i���� MSB��������  ����������
                neg     dv8s                    ;�������� ���� ��������
                sbrc    dd8s,7                  ;i���� MSB �������� ����������
                neg     dd8s                    ;�������� ���� ��������
                sub     drem8s,drem8s           ;�������� ������� � �������
                ldi     dcnt8s,9                ;���������������� ������� �����

d8s_1:          rol     dd8s                    ;������� �������� �����
                dec     dcnt8s                  ;decrement counter
                brne    d8s_2                   ;���� ������� ����� ����� ����
                sbrc    d8s,7                   ;���� MSB �������� �����
                neg     dres8s                  ;�������� ���� ����������
                ret                             ;����� �� ������������

d8s_2:          rol     drem8s                  ;�������� �������
                sub     drem8u,dv8s             ;������� = ������� - ��������
                brcc    d8s_3                   ;���� ��������� �������������
                add     drem8u,dv8s             ;������������ �������
                clc                             ;�������� ������� ��� ������������ ����������

                rjmp    d8s_1                   ;�����

d8s_3:          sec                             ;���������� ������� ��� ������������ ����������
                rjmp    d8s_1          




;**********************************************************************

;4.����� ��������� div8u_� ������� 8-� ��������� ����� ����������� �����,
 
;����������������  � ����� ������ ����� ���� 

;**********************************************************************

;***** ������������� ���������


.def    drem8u  =r15;�������
.def    dres8u  =r16;���������
.def    dd8u    =r16;�������
.def    dv8u    =r17;��������
.def    dcnt8u  =r18;������� �����



div8u_c:        push r18
				sub     drem8u,drem8u   ;�������� ������� � �������
                ldi     dcnt8u,9        ;���������������� ������� �����
d8u_1:          rol     dd8u            ;�������/��������� �������� �����
                dec     dcnt8u          ;��������� �� ������� ������� �����
                brne    d8u_2           ;�������, ���� �� ����
				pop r18
                ret



d8u_2:          rol     drem8u          ;������� �������� �����
                sub     drem8u,dv8u     ;�������= ������� -  ��������
                brcc    d8u_3           ;���� ��������� < 0
                add     drem8u,dv8u     ;������������ �������
                clc                     ;�������� ������� ��� ������������ ����������

                rjmp    d8u_1           ;����� ���������� ������� ���
d8u_3:          sec                     ;������������ ����������

                rjmp    d8u_1           ;��������� �����