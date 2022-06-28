delete  PROC NEAR
        push cx
        ; CURSORPOS LESEN
        mov ah, 3
        int 10h
        ; CURSORPOS UM 1 VERMINDERN
        dec dl
        ; CURSOR NEU SETZEN
        mov ah, 2
        int 10h
        ; LEERZEICHEN SCHREIBEN
        mov ax, 0F20h
        mov ah, 0Eh
        int 10h

        mov ah, 3
        int 10h
        dec dl
        mov ah, 2
        int 10h

        pop cx

        ; LEERZEICHEN IN displayString SCHREIBEN
        dec si
        dec cx
        mov [si], 0F20h

        ret
delete ENDP
