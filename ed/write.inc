writeOnDisplay PROC NEAR
              mov si, OFFSET string
              mov ah, 07h
              mov di, 160

writeString:  mov al, [si]
              stosw
              inc si
              dec cx                                        ; Schleifenzaehler wird in PROC Read gesetzt
              jnz writeString

              ret
writeOnDisplay ENDP