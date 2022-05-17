; Maus-Unterprogramm
; Er mag keine Leerzeilen
            .model small
            .486
BildSegReg  = 0B800h
escKey      = 1Bh
            .data
CursorPos   DB '(', ' ', 'x', ' ', ',', ' ', 'y', ' ', ')'
            .code
            ; Unterprogramm schreibt bei Mausklick an entsprechende Stelle farbigen Block
conv        PROC NEAR
conv        ENDP
MausProc    PROC far
            push ds
            push es
            mov ax, @Data
            mov ds, ax
            mov ax, BildSegReg
            mov es, ax
            shr dx, 3                   ; dx /a 8, in dx liegt y-Koordinate in Pixeln, um Pixel in Zeichen umzuwandeln
            mov di, 160                 ; imul geht nur mit Registern, deshalb Faktor 160 in di
            imul di, dx                 ; y-Koordinate als Zeichen in dx mit 160 multiplizieren
            ;mov ax, dx                  ; *Y-Zeichenkoordinate in ax schreiben, um sie dort zu konvertieren
            ;call conv                   ; *Ab hier sollte konvertierte Y-Koordinate in dx stehen
            shr cx, 3
            shl cx, 1                   ; cx * 2 nicht dasselbe wie shr cx, 2
            add di, cx                  ; x-Koordinate wird zu y-Zeichenkoordinate addiert
            ;mov ax, cx                  ; *
            ;call conv                   ; *Ab hier sollte konvertierte Y-Koordinate in bx stehen (cx wird als Schleifenzähler benötigt)
            mov ax, 2                   ; Cursor aus
            int 33h
            mov si, OFFSET CursorPos
            mov cx, 9                   ; Schleifenzähler für Stringausgabe
            mov ah, 0Ch                 ; Farbe wird gesetzt
write:      mov al, [si]
            stosw                       ; schreibt Inhalt aus ax als String an Pos. es:di auf Zeichenbildschirm (repe sorgt für Schleife mit cx Wiederholungen)
            inc si
            dec cx
            jnz write
            mov ax, 1                   ; Cursor an
            int 33h
            pop es
            pop ds
            ret
MausProc    ENDP
Start:      mov ax, 3                   ; Videomodus
            int 10h
            mov cx, 000101010b          ; Maske für Auslöser => linke Taste gedrückt, rechte Taste gedrückt, mittlere Taste
            push cs                     ; Codesegmentregister auf Stack
            pop es                      ; Adresse v. Codesegment in es speichern
            mov dx, OFFSET MausProc     ; Offset-Adresse der Mausprozedur im Codesegment wir in dx geladen (nur Offset notwendig, da wir uns hier noch in CS befinden)
            mov ax, 0Ch                 ; Modus Mausprozedureingabe auswählen
            int 33h                     ; Mausroutine an Adresse von es:dx aufrufen
            mov ax, 1                   ; Modus Cursor an auswählen
            int 33h
EndlLoop:   xor ah, ah                  ; Test auf <esc>
            int 16h
            cmp al, escKey              ; Vergleiche mit Escape (1Bh)
            jz Epilog
            jmp EndlLoop
            ; Epilog
Epilog:     xor ax, ax                  ; Reset Maus-Unterprogramm (Modus 0 bei ax = 0)
            int 33h
            mov ax, 3                   ; Videomodus 3 => Zeichenbildschirm löschen
            int 10h
            ; Rücksprung ins DOS
            mov ah, 4Ch
            int 21h
            .stack 100h
            end Start
