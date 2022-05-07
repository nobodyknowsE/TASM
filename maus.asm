; Maus-Unterprogramm
; Er mag keine Leerzeilen
            .model small
            .486
            .data
Count       DB 0Fh
            .code
            ; Unterprogramm schreibt bei Mausklick an entsprechende Stelle farbigen Block
MausProc    PROC far
            push ds
            push es
            mov ax, @Data
            mov ds, ax
            mov ax, 0B800h  ; Bildschirmsegmentregister | als Konsante!!!
            mov es, ax
            shr dx, 3       ; dx / 8
            mov di, 160
            imul di, dx
            shr cx, 3
            shl cx, 1       ; cx * 2 nicht dasselbe wie shr cx, 2
            add di, cx
            mov ax, 2       ; Cursor aus
            int 33h
            mov ah, Count
            mov al, 0DBh
            inc ah
            mov Count, ah
            stosw
            mov ax, 1       ; Cursor an
            int 33h
            pop es
            pop ds
            ret
MausProc    ENDP
Start:      mov ax, 3     ; Videomodus
            int 10h
            mov cx, 000101010b
            push cs
            pop es        ; Adresse v. Codesegment in es speichern
            mov dx, OFFSET MausProc
            mov ax, 0Ch
            int 33h
            mov ax, 1       ; Cursor an
            int 33h
EndlLoop:   xor ah, ah    ; Test auf <esc>
            int 16h
            cmp al, 1Bh   ; Vergleiche mit Escape (1Bh) | als Konstante deklarieren !!!
            jz Epilog
            jmp EndlLoop
            ; Epilog
Epilog:     xor ax, ax    ; Reset Maus-Unterprogramm
            int 33h
            mov ax, 3
            int 10h
            mov ah, 4Ch   ; Rücksprung ins DOS
            int 21h
            .stack 100h
            end Start
