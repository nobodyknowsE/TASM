; Hauptprogramm des Editors
; bisher: Programm gibt merhzeiligen Text auf Bildschirm aus
; next step: Angabe der zu lesenden Bytes in Read Proc dynamisch machen

                  .model small
                  .486
DispSegReg        = 0B800h
escKey            = 1Bh
                  .data
fileNameWrite     db "write.txt", 0
fileNameRead      db "read.txt", 0
string            db 2048 DUP(?)                             ; Datei max. 2048 Byte
handler           dw ?

                  .code
                  INCLUDE ed\file.inc
                  INCLUDE ed\draw.inc
                  INCLUDE ed\write.inc

Start:            mov ax, @data
                  mov ds, ax
                  mov ax, DispSegReg                         ; Display in es
                  mov es, ax
                  mov ax, 3                                  ; Videomodus 3
                  int 10h

                  call draw                                  ; Zeichenbildschirmdekor zeichnen

                  ;DATEI LESEN + STRING BESCHREIBEN
                  mov ax, OFFSET string
                  mov bx, OFFSET fileNameRead
                  push ax                                    ; Parameteruebergabe
                  push bx
                  call Read

                  ; STRING IN DATEI SCHREIBEN
                  mov ax, OFFSET string
                  mov bx, OFFSET fileNameWrite
                  push ax
                  push bx
                  call Write

                  ;STRING AUF BILDSCHIRM AUSGEBEN
                  call writeOnDisplay

EndlLoop:         xor ah, ah
                  int 16h
                  cmp al, escKey
                  jz Epilog
                  jmp EndlLoop

Epilog:           mov ax, 3                                  ; Display loeschen
                  int 10h
                  mov ah, 4Ch
                  int 21h
                  .stack 100h
                  end Start
