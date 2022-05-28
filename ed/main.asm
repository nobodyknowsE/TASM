; Hauptprogramm des Editors
; bisher: Programm gibt merhzeiligen Text auf Bildschirm aus
; next step: Angabe der zu lesenden Bytes in Read Proc dynamisch machen

                  .model small
                  .486
DispSegReg        = 0B800h
escKey            = 1Bh
                  .data
fileNameRead      db "str.txt", 0
string            db ?
handler           dw ?

                  .code
                  INCLUDE ed\file.inc

Start:            mov ax, @data
                  mov ds, ax

                  mov ax, DispSegReg                         ; Display in es
                  mov es, ax

                  mov ax, 3                                  ; Videomodus 3
                  int 10h

                  ;DATEI LESEN + STRING BESCHREIBEN
                  mov ax, OFFSET string
                  mov bx, OFFSET fileNameRead

                  push ax
                  push bx
                  push bp

                  call Read

                  pop bp

                  ;STRING AUF BILDSCHIRM AUSGEBEN
                  mov si, OFFSET string
                  mov ah, 0Ch
                  mov di, 0

write:            mov al, [si]
                  stosw
                  inc si
                  dec cx                                        ; Schleifenzaehler wird in PROC Read gesetzt
                  jnz write

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
