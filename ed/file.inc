;Create PROC NEAR
;Create ENDP

Read PROC NEAR
          push bp
          mov  bp, sp                          ; auf Stack liegen jetzt: String, fileNameRead, bp, Ruecksprungadresse

          @@fileNameRead    equ [bp + 4]
          @@string          equ [bp + 6]

          ;OPEN
          mov ah, 3Dh
          mov al, 10b
          mov dx, OFFSET @@fileNameRead
          int 21h

          mov handler, ax

          ;READ
          mov ah, 3Fh
          mov bx, handler
          mov cx, 2048
          mov dx, OFFSET @@string
          int 21h

          mov cx, ax                           ; ax = Anzahl gelesener Bytes, cx = Schleifenzaehler nach PROC
          add si, ax
          push ax                              ; Anzahl der Bytes für Counter sichern

      	  ;CALCULATE CURSORPOS
      	  mov bl, 80                           ; gebraucht als Divident für nachfolgende Rechnung
      	  div bl		                           ; ax / bl (Anzahl Bytes / Zeichen pro Zeile) = in al Quotient, in ah Rest
      	  mov dh, al                           ; dh = Zeile
      	  inc dh	                             ; notwendig, da 1. Zeile in unserem Editor nicht beschrieben wird
      	  mov dl, ah                           ; dl = Spalte

      	  xor ax, ax
      	  xor bx, bx
      	  mov ah, 2					                   ; setzt Cursorpos
      	  int 10h

          ;CLOSE
          mov ah, 3Eh
          int 21h

          pop bx                               ; Anzahl der Bytes für Counter in main EndlLoop
          pop bp
          ret

Read ENDP

Write PROC NEAR
           push bp
           mov  bp, sp                         ; auf Stack liegen jetzt: fileNameWrite, String, bp, Ruecksprungadresse

           @@fileNameWrite    equ [bp + 4]
           @@string           equ [bp + 6]

           ;OPEN
           mov ah, 3Dh
           mov al, 01b
           mov dx, OFFSET @@fileNameWrite
           int 21h

           mov handler, ax

           ;WRITE                              ; in cx müsste noch Anzahl der gelesenen Bytes stehen
           mov ah, 40h
           mov bx, handler
           mov dx, OFFSET @@string
           int 21h

          ;CLOSE
          mov ah, 3Eh
          int 21h

          pop bp
          ret
Write ENDP
