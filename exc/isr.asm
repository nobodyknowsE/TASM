; Programm zum  Testen eines Interrupts
; Ablauf:
; 1. alten Interruptvektor lesen und speichern
; 2. neuen Interruptvektor eintragen
; 3. alten Interruptvektor wiederherstellen

; Fragen:
; bei int 21.35h steht vektor nicht in es:dx, sondern es:bx
                .model small
                .486
                .data
oldIntSeg       DW ?
oldIntOff       DW ?                    ;Speichern des alten Interrupts
counter         DB 36                   ;2 Sekunden
flag            DB 0                    ;flag 0 = ton aus
                .code
ISRSummer:      push ax
                push ds

                mov ax, @DATA
                mov ds, ax

                dec counter
                jnz Ausgang
                mov ah, flag
                test ah, ah
                jz TonEin

                in al, 61h              ;Ton ausschalten
                and al, 0FCh            ;Bits 0 und 1 von Port 61h auf 0 setzen
                out 61h, al             ;FEHLER: Diese Zeile fehlte in ursprünglichem Programm!
                inc ah
                mov flag, ah
                jmp end_if

TonEin:         in al, 61h              ;Einschalten Ton
                or al, 11b              ;Bits 0 und 1 von Port 61h auf 1 setzen
                out 61h, al
                dec ah                  ;flag auf 0 setzen
                mov flag, ah
end_if:         mov al, 36
                mov counter, al

Ausgang:        pop ds
                pop ax
                iret

Start:          mov ax, @DATA
                mov ds, ax

                mov ax, 3                 ;Videomodus 3: Zeichenbildschirm
                int 10h

                mov al, 0B6h              ;Einstellen des Teilers für Frequenzberechnung
                out 41h, al               ;out immer nur al
                mov al, 16h               ;Lowbyte des Teilers
                out 42h, al
                mov al, 12h               ;Highbyte des Teilers
                out 42h, al

                ; einlesen Interruptvektor
                mov al, 1Ch               ;Auslesen Int Adresse 1Ch
                mov ah, 35h
                int 21h
                mov oldIntOff, dx         ;speichern
                mov oldIntSeg, es

                in al, 61h                ;Ton ausschalten
                and al, 0FCh
                out 61h, al

                ; eintragen neue ISR
                push ds                   ;sichern ds
                mov al, 1Ch               ;Eintragen neue ISR-Nr.
                push cs                   ; Codesegment in ds laden
                pop ds
                mov dx, OFFSET ISRSummer  ;Adresse der ISR in ds:dx
                mov ah, 25h               ;set Interruptvektor bei ds:dx
                int 21h                   ;neue ISR ist jetzt unter 1Ch gespeichert
                pop ds

EndlLoop:       xor ax, ax                ;Zeichen einlesen
                int 16h                   ;Programm wird gestoppt, bis Zeichen eingegeben wird => andere Interrupts nicht moeglich
                cmp  al, 1Bh              ;mit <esc> verlgeichen
                je Epilog
                jmp EndlLoop

Epilog:         in al, 61h                ;Ton ausschalten
                and al, 0FCh
                out 61h, al

                mov ax, oldIntSeg         ;Wiederherstellen alte ISR
                mov ds, ax
                mov dx, oldIntOff
                mov al, 1Ch
                mov ah, 25h               ;Code Interruptvektor
                int 21h
                mov ax, 3
                int 10h

                ;Ruecksprung ins DOS
                mov ah, 4Ch
                int 21h
                .stack 100h
                end Start
