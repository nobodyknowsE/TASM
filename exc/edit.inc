write PROC NEAR
  ; DATEI ERSTELLEN
  mov ah, 3Ch
  mov cx, 0                     ; Dateiattribut => write
  mov dx, OFFSET fileName
  int 21h

  mov handler, ax

  ; DATEI BESCHREIBEN
  mov ah, 40h
  mov bx, handler
  mov cx, 6                       ; Anzahl der zu schreibenden Bytes
  mov dx, OFFSET string
  int 21h

  ; DATEI SCHLIEßEN
  mov ah, 3Eh
  int 21h
write ENDP
