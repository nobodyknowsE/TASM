;Program gibt die eingegebenen Zeichen als große Buchstaben aus
;Erste Zeile eines Zeichens wird geschrieben, jetzt müssen Zeilenumbrüche und weitere Zeilen geschrieben werden
;Zeilenumbruch bei 160 - 16
;in einer Zeile können 10 Zeichen geschrieben weil 160:16 = 10

           .model small
           .486
ZchBSSeg  = 0B800h                    ;Videospeicher
ZchGenSeg = 0F000h                    ;Zeichengenerator
ZchGenOff = 0FA6Eh
escCode   = 1Bh
          .code
Beginn:   mov ax, 3                   ;Videomodus 3 (Zeichenbildschirm)
          int 10h                     ;Interrupt 10 =set video mode, AL = 3 = 80x25 Zeichenbildschirm

          mov ax, ZchBSSeg            ;Zeichenbildschirm(Videospeicher) über ax in es laden
          mov es, ax

          mov ax, ZchGenSeg           ;Zeichengenerator über ax in ds laden
          mov ds, ax

          xor di, di                  ;di <- 0, Offset für Zeichenbildschirm
          mov dh, 10                  ;Schleifenzähler für 10 Zeichen/Zeile
EndlLoop: xor ah, ah
          int 16h                     ;Interrupt 16 = wait for keypress and read, ASCII-char in AL

          cmp al, escCode             ;vergleiche, ob Zeichen = esc - in al liegt eingegebenes Zeichen
          jne ShftLoop                ;wenn Zeichen nicht = esc, weiter zu loopStat, jump wenn zero flag = 0
          jmp LoopEnd

          ;Schleifenrumpf
ShftLoop: xor bh, bh
          mov bl, al                  ;in al liegendes Zeichen in bl schieben
          shl bx, 3                   ;bx * 8, da Index in Zeichentabelle = ASCII-Wert*8
          mov ch, 8                   ;Schleifenzähler Spaltenloop

Spalte:   mov dl, [bx + ZchGenOff]    ;Tabelleneintrag(einzelne Zeile) an Stelle des Zeichens in dl laden
          mov cl, 8                   ;Schleifenzähler Zeile

Zeile:    shl dl, 1                   ;in dl liegt zu zeichnendes Zeichen, ins carry schieben
          jnc LeerZch                 ;wenn kein Übertrag, dann Leerzeichen zeichnen, weil Lücke in Buchstabe
          mov WORD PTR es:[di], 12DBh ;Zeichenbildschirm, Hexwert für Block -> Block zeichnen, High Byte von 12DBh = Farbe
          jmp End_if
LeerZch:  mov WORD PTR es:[di], 0F20h ;Leerzeichen zeichnen

End_if:   add di, 2                   ;Offset für Zeichenbildschirm um 2 erhöhen, damit Position auf Zeichenbildschirm verschoben wird
          dec cl                      ;Schleifenzähler dekrementieren
          jnz Zeile
          add di, 160-16              ;Zeilenumbruch***
          ;hier ist erste Zeile des Zeichens gezeichnet -> Zeilenumbruch + loop für weitere Zeilen
          add bx, 1                   ;zu bx 1 addieren, um in Zeichengeneratortabelle einen Eintrag nach unten zu kommen
          dec ch
          jnz Spalte
          dec dh
          jnz glZeile
          sub di, 144                 ;Zeichenbildschirm nach 10 Zeichen auf Startpos. setzen
          mov dh, 10                  ;Zähler für 10 Zeichen in Zeile auf 10 setzen
          cmp di, 3840                ;Vergleichen mit erstem Zeichen in 25.Zeile
          jne glFeld                  ;wenn Pos = 1.Zeihen 25.Zeile -> Sprung in erste Zeile
          xor di, di
glFeld:   jmp EndlLoop
glZeile:  sub di, 8*160               ;+nächste Zeile -> setzt Position für nächstes Zeichen neben vorangegangenes Zeichen
          add di, 16
          jmp EndlLoop
LoopEnd:  ;Ruecksprung ins DOS
          mov ax, 3
          int 10h

          mov ah, 4ch
          int 21h

          .stack 100h
          end Beginn
