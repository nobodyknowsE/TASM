; Hauptprogramm des Editors

                  .model small
                  .486
DispSegReg        = 0B800h
escKey            = 1Bh
                  .data
fileNameWrite     db "write.txt", 0
fileNameRead      db "read.txt", 0
displayString     db 2048 DUP(?)
handler           dw ?

                  .code
                  INCLUDE ed\file.inc
                  INCLUDE ed\draw.inc
                  INCLUDE ed\write.inc
                  INCLUDE ed\delete.inc

Start:            mov ax, @data
                  mov ds, ax
                  mov ax, DispSegReg             ; Display in es
                  mov es, ax
                  mov ax, 3                      ; Videomodus 3
                  int 10h

                  call draw                      ; Zeichenbildschirmdekor zeichnen

                  mov si, OFFSET displayString   ; si muss vor Proc Read gesetzt werden, da dort si verändert wird, um richtige Pos. in Str zu erhalten

                  ;DATEI LESEN + STRING BESCHREIBEN
                  mov ax, OFFSET displayString
                  mov bx, OFFSET fileNameRead
                  push ax                        ; Parameteruebergabe
                  push bx
                  call Read
                  add sp, 4                      ; Stack bereinigen

                  ;STRING AUF BILDSCHIRM AUSGEBEN
                  dec cx                         ; Schleifenzaehler wird in Proc Read gesetzt und muss um 1 dekrementiert werden wegen Index 0
                  call writeOnDisplay

                  mov cx, bx                     ; Counter fuer in Datei zu schreibende Bytes
                  dec cx                         ; Schleifenzaehler wird in Proc Read gesetzt und muss um 1 dekrementiert werden wegen Index 0

EndlLoop:         xor ah, ah
                  int 16h

                  cmp al, escKey
                  jz Epilog

                  cmp al, 08h                    ; Hexwert für Backspace
                  jz deleteChar

	                mov ah, 0Eh				             ; schreibt Zeichen an Cursorposition im Teletype modus
		              int 10h

                  ; CHAR VON BILDSCHIRM IN displayString SPEICHERN
                  mov [si], al
                  inc si
                  inc cx

                  jmp EndlLoop

deleteChar:       call delete
                  jmp EndlLoop

Epilog:           ; BEI ABBRUCH DES PROGRAMMS STRING VON BILDSCHIRM IN DATEI SCHREIBEN
                  mov ax, OFFSET displayString
                  mov bx, OFFSET fileNameWrite
                  push ax
                  push bx
                  call Write

                  mov ax, 3                       ; Display loeschen
                  int 10h
                  mov ah, 4Ch
                  int 21h
                  .stack 100h
                  end Start
