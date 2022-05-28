            .MODEL TINY
            .CODE
            ORG 100h

BILDAUSG    equ 09h ;MS-DOS-Funktion: Bildschirmausgabe
ENDPROCESS  equ 4Ch ;MS-DOS-Funktion: Programm beenden
DOSINT      equ 21h ;MS-DOS-Funktionsaufruf

PrgAnfang:  jmp Ausgabe

HALLO       db 'Dies ist eine Textausgabe in Assembler'
            db 0Dh, 0Ah, '$'

Ausgabe:    mov bx, cs
            mov ds, bx

            mov dx, OFFSET HALLO ;dc zeigt auf Anfang des Textes
            mov ah, BILDAUSG ;Funktion 'Bildschirmausgabe' waehlen
            int DOSINT ;DOS-Funktion ausfuehren

            mov al, 00 ;Programm-Exitcode setzen
            mov ah, ENDPROCESS ;Funktion 'Programmende' waehlen
            int DOSINT ;DOS-Funktion ausfuehren, int 21 functions are called with the function number in AH

            END PrgAnfang
