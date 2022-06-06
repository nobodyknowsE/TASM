draw PROC NEAR
            ; draw upper line
            xor di, di
            mov cx, 80
            mov ax, 03C4h
            repe stosw

            ; draw middle line
            xor di, di
            mov di, 3520
            mov cx, 80
            mov ax, 03C4h
            repe stosw

            ; draw lower line
            xor di, di
            mov di, 3840
            mov cx, 80
            mov ax, 03C4h
            repe stosw

            ret
draw ENDP
