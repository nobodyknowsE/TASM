; 1. Datei erstellen
; 2. Datei oeffnen
; 3. Datei beschreiben
; 4. Datei schließen

                .model small
                .486
                .data
fileName        db "hello.txt", 0
string          db "Hallo!"
handler         dw ?
                .code
                INCLUDE edit.inc

                mov ax, @DATA
                mov ds, ax

                call write                        ; PROC in edit.inc

                ; PROGRAMM BEENDEN
                mov ah, 4Ch
                int 21h
                .stack 100h
                end
