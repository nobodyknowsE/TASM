            .MODEL SMALL
            .386
            .DATA
BILDAUSG    equ 09h               ;MS-DOS-Funktion: Bildschirmausgabe
ENDPROCESS  equ 4Ch               ;MS-DOS-Funktion: Programm beenden
DOSINT      equ 21h               ;MS-DOS-Funktionsaufruf
HALLO       db 'Textausgabe in Assembler'
            db 0Dh, 0Ah, '$'
            .CODE
            mov cx, 5h            ;cx als Schleifenzaehler wird mit 5 initialisiert
Ausgabe:    dec cx                ;dekrementiert Schleifenzaehler, setzt zero-Flag
            mov dx, OFFSET HALLO  ;dc zeigt auf Anfang des Textes
            mov ah, BILDAUSG      ;Funktion 'Bildschirmausgabe' waehlen
            int DOSINT            ;DOS-Funktion ausfuehren
            jnz Ausgabe           ;springt zu Ausgabe, falls Schleifenzaehler nicht 0 ist (zero-Flag)
            mov al, 00            ;Programm-Exitcode setzen
            mov ah, ENDPROCESS    ;Funktion 'Programmende' waehlen
            int DOSINT            ;DOS-Funktion ausfuehren

            mov ah, 4Ch
            int 21h
            .stack 100h
            END
