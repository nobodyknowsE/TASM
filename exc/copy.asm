; Programm schreibt bisher festgelegten String in existierende Datei
; next step: String aus anderer Datei holen

                .model small
                .486
                .data
fileNameWrite   db "pupsi.txt", 0
fileNameRead    db "string.txt", 0
handler         dw ?
                .code

                mov ax, @DATA
                mov ds, ax

                ; OPEN
                mov ah, 3Dh
                mov al, 10b
                mov dx, OFFSET fileNameRead
                int 21h

                mov handler, ax

                ; READ
                mov ah, 3Fh
                mov bx, handler
                mov cx, 5
                mov dx, OFFSET fileNameRead
                int 21h

                mov si, dx  ; Pointer speichern

                ; CLOSE
                mov ah, 3Eh
                int 21h

                ;***AB HIER STRING IN FILE SCHREIBEN***

                ; OPEN
                mov ah, 3Dh
                mov al, 10b
                mov dx, OFFSET fileNameWrite
                int 21h

                mov handler, ax

                ; WRITE
                mov ah, 40h
                mov bx, handler
                mov cx, 5
                mov dx, si
                int 21h

                ; CLOSE
                mov ah, 3Eh
                int 21h

                ; PROGRAMM BEENDEN
                mov ah, 4Ch
                int 21h
                .stack 100h
                end
