; Asseblerprogramm zum Umgang mit Dateien
			         .model small
			         .486
			         .data
textBuffer     DB 1024 DUP(?)		; Puffer für den Text
dateiname	     DB 'Datei.txt',0	; Dateiname
handle		     DW ?
			         .code
store		       PROC near
              ; si Anzahl der Bytes
        			push ax
        			push bx
        			push cx
        			push dx

              ; WRITE
        			mov ah, 40h
        			mov bx, handle
        			mov cx, si
        			mov dx, OFFSET textBuffer
        			int 21h


        			pop dx
        			pop cx
        			pop bx
        			pop ax
        			ret
        			ENDP
Start:		    mov ax, @DATA
        			mov ds, ax

        			mov ax, 0B800h
        			mov es, ax

        			mov ax, 3
        			int 10h

              ; CREATE
        			mov ah, 3Ch
        			mov dx, OFFSET dateiname
        			mov al, 1
        			xor cx, cx
        			int 21h

        			mov handle, ax

        			mov bx, OFFSET textBuffer	; Zeiger in textBuffer

        			xor si,si
        			xor di, di			; Zeiger CRT

EndlessLoop:  xor ax, ax
        			int 16h
        			cmp al, 1Bh
        			je Epilog

        			mov [bx], al
        			inc bx
        			inc si
        			cmp si, 1024
        			jne notStore
        			call store
        			xor si,si
        			mov bx, OFFSET textBuffer

notStore:	    mov ah, 0Fh
			        stosw				; es:[di] <- ax, di+2
			        ; Bildschirm voll -> Rücksetzen di
			        jmp EndlessLoop

Epilog: 	    call store

			        mov ah, 3Eh
        			mov bx, handle
        			int 21h

        			mov ax, 3
        			int 10h

        			mov ah, 4Ch
        			int 21h
        			.stack 100h
        			end Start
