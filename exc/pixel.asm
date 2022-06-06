; Benutzung des VGA-Bildschirms
    			.model small
    			.486
    			.data
counter		DB 0Fh
			    .code
pixel		  PROC far
    			push es
    			push ds
    			push ax
    			push dx

    			mov ax, 0A000h  ; Segmentadresse VGA-Bildschirms
    			mov es, ax

    			mov ax, @DATA	; Datensegmentregister setzen
    			mov ds, ax

    			mov dx, 3CEh	; Modus 2 einstellen
    			mov al, 5
    			out dx, al
    			inc dx
    			mov al, 2
    			out dx, al

    			pop dx        ; y-Koordinate

    			mov bx, dx		; Berechnen der Byteadresse
    			imul bx, 80

    			mov dx, cx
    			shr dx, 3

    			add bx, dx    ; Ausrechnen richtiges Byte in richtiger Zeile

    			and cx, 7	  	; Bitmaske berechne und setzen, Bitpos. innerhalb des Bytes

    			mov dx, 3CEh
    			mov al, 8
    			out dx, al
    			mov al, 80h
    			shr al, cl
    			inc dx
    			out dx, al

    			mov ax, 2		; Cursor aus
    			int 33h

    			mov al, counter	; Schreiben Pixel
    			mov ah, es:[bx]
    			mov es:[bx], al

    			inc al
    			mov counter, al

    			mov ax, 1		; Cursor an
    			int 33h

    			pop ax
    			pop ds
    			pop es
    			ret
    			ENDP
Start:		mov ax, @DATA
			    mov ds, ax

    			mov ax, 12h		; Einstellen VGA-Modus
    			int 10h

    			mov cx, 1010b	; Mausprozedur eintragen
    			push cs
    			pop es
    			mov dx, OFFSET pixel
    			mov ax, 0Ch
    			int 33h

    			mov ax, 1		; Cursor an
    			int 33h

    			mov dx, 03C4h	; Freigabe Bitplanes
    			mov al, 2
    			out dx, al
    			inc dx        ; Datenport
    			mov al, 0Fh
    			out dx, al

EndlLoop: xor ax, ax
    			int 16h
    			cmp al, 1Bh
    			je Epilog
    			; Rumpf
    			jmp EndlLoop
Epilog:		xor ax,ax		; Reset Maus
    			int 33h
    			mov ax, 3		; Bildschirm löschen, Zeichenbildschirm
    			int 10h
    			mov ah, 4Ch
    			int 21h
    			.stack 100h
    			end Start
