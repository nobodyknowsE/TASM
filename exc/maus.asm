; Maus-Unterprogramm
; Er mag keine Leerzeilen
            .model small
            .486
BildSegReg  = 0B800h
escKey      = 1Bh
            .data
ten         DB 10
CursorPos   DB '(', ' ', 'x', ' ', ',', ' ', 'y', ' ', ')'
OldPos      DW ?
            .code
conv        PROC NEAR
            mov [si-1], 20h                 ;Zeichen vor Koordinate loeschen, da dieses sonst bei verschiedenen Koordinaten gleichbleibt

shift:      div ten
            or ah, 30h                      ;ASCII-Korrektur
            mov [si], ah                    ;ASCII-Zeichen wird an richtiger Stelle von CursorPos ersetzt
            sub si, 1
            xor ah, ah
            test al, al
            jnz shift

            ret
conv        ENDP

MausProc    PROC far
            push ds
            push es

            mov ax, @Data
            mov ds, ax

            mov ax, BildSegReg
            mov es, ax

            push cx                        ;cx mit x-Koordinate sichern
            mov di, [OldPos]
            mov ax, 20h                    ;Zeichen auf alter Position durch Leerzeichen ersetzen
            mov cx, 9
rep         stos word ptr [di]
            pop cx                         ;x-Koordinate in cx laden

            shr dx, 3                      ; dx / 8, in dx liegt y-Koordinate in Pixeln, um Pixel in Zeichen umzuwandeln
            mov ax, dx                     ; *Y-Zeichenkoordinate in ax schreiben, um sie dort zu konvertieren
            mov si, OFFSET CursorPos + 6
            call conv                      ; *Ab hier sollte konvertierte Y-Koordinate in dx stehen

            mov di, 160                    ; imul geht nur mit Registern, deshalb Faktor 160 in di
            imul di, dx                    ; y-Koordinate als Zeichen in dx mit 160 multiplizieren, um in richtige Zeile zu kommen

            shr cx, 3
            mov ax, cx
            mov si, OFFSET CursorPos + 2
            call conv

            shl cx, 1                      ; cx * 2, nicht dasselbe wie shr cx, 2, cx * 2 da in cx Bytekoordinate ist, brauchen aber Wortkoordinate
            add di, cx                     ; x-Koordinate wird zu y-Zeichenkoordinate addiert, di zeigt jetzt auf Zeichenposition
            mov OldPos, di                 ; Position fuer Loeschen merken

            mov ax, 2                      ; Cursor aus
            int 33h

            mov si, OFFSET CursorPos
            mov cx, 9                      ; Schleifenzähler für Stringausgabe
            mov ah, 0Ch                    ; Farbe wird gesetzt

write:      mov al, [si]
            stosw                          ; schreibt Inhalt aus ax als String an Pos. es:di auf Zeichenbildschirm (repe sorgt für Schleife mit cx Wiederholungen)
            inc si
            dec cx
            jnz write

            mov ax, 1                      ; Cursor an
            int 33h

            pop es
            pop ds
            ret
MausProc    ENDP

Start:      mov ax, 3                      ; Videomodus
            int 10h

            mov cx, 101010b             ; Maske für Auslöser => linke Taste gedrückt, rechte Taste gedrückt, mittlere Taste

            push cs                        ; Codesegmentregister auf Stack
            pop es                         ; Adresse v. Codesegment in es speichern
            mov dx, OFFSET MausProc        ; Offset-Adresse der Mausprozedur im Codesegment wir in dx geladen (nur Offset notwendig, da wir uns hier noch in CS befinden)
            mov ax, 0Ch                    ; Modus Mausprozedureingabe auswählen
            int 33h                        ; Mausroutine an Adresse von es:dx aufrufen

            mov ax, 1                      ; Modus Cursor an auswählen
            int 33h

EndlLoop:   xor ah, ah                     ; Test auf <esc>
            int 16h
            cmp al, escKey                 ; Vergleiche mit Escape (1Bh)
            jz Epilog
            jmp EndlLoop

Epilog:     xor ax, ax                     ; Reset Maus-Unterprogramm (Modus 0 bei ax = 0)
            int 33h

            mov ax, 3                      ; Videomodus 3 => Zeichenbildschirm löschen
            int 10h
            ; Rücksprung ins DOS
            mov ah, 4Ch
            int 21h
            .stack 100h
            end Start
