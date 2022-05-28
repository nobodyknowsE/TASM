; Programm schreibt bisher festgelegten String in existierende Datei
; next step: String aus anderer Datei holen

                .model small
                .486
                .data
fileName        db "hello.txt", 0
string          db "12345"
handler         dw ?
                .code
                INCLUDE exc\edit.inc

                mov ax, @DATA
                mov ds, ax

                call write                        ; PROC in edit.inc

                ; PROGRAMM BEENDEN
                mov ah, 4Ch
                int 21h
                .stack 100h
                end
