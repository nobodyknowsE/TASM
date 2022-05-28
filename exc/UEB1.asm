;Das erste Assemblerprogram
					.model small
					.386 ; Befehlssatz für 386 Prozessor
					.data ; Datensegment wird eingeleitet
vec1			DW 10 DUP(?) ; nich intitialisiertes Feld von 10 Wörtern
vec2			DW 10 DUP(?) ; DW = Data Word
					.code ; Ab hier Assemblercode
Beginn:		mov ax, @DATA ; Zeile 8 und 9 => Datensegmentregister intitialisieren, Adresse des Datensegments wird nach ax geschoben, Laden des Datensegmentregisters
					mov ds, ax ;Multiplikation immer mit ax-Register
					mov si, OFFSET vec1 + 20 ;20 weil 2 Woerter pro Element in Vektor, Zeiger auf das Ende des Arrays
					mov di, OFFSET vec2 + 20
					mov cx, 10 ;i = cx
loop1:		sub si, 2 ; immer 2 subtrahieren, weil in Wörtern (2 Byte) gezählt wird
					sub di, 2
					mov [si], cx ;An Adresse si Inhalt des Registers cx, Dekremnt der Zeiger
					mov [di], cx
					dec cx ;i--
					jnz loop1
					; si, di stehen auf dem Anfang des arrays
					xor bx,bx ; bx = 0
					mov cx, 10
loop2:		mov ax, [si]
					imul WORD PTR [di]; dx,ax <- ax * [di] (Quelle, WORD-Befehl)
					add bx, ax
					add si, 2 ;Inkrement des Zeigers vecx[i]
					add di, 2 ;2 weil 2 Wortadressen
					dec cx
					jnz loop2
					; Rücksprung ins DOS
					mov ah, 4ch
					int 21h
					.stack 100h
					end Beginn
