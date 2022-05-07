            .MODEL SMALL
            .386
            .DATA
TASTEEIN    equ 10                  ;Fkt. Tastatureingabe
BILDAUSG    equ 9                   ;Fkt. Bildschirmausgabe
DOSINT      equ 21h                 ;MS-DOS Interrupt-Nummer

MAXSIZE     equ 30                  ;max. Zeichenanzahl im Eingabepuffer
CR          equ 13                  ;ASCII Carriage Return
LF          equ 10                  ;ASCII Line Feed
LEER        equ ' '                 ;ASCII SPACE
EDB         equ '$'                 ;Zeichen für Ende der Botschaft

ANZAHL      equ 20                  ;Anzahl der Textausgaben

PUFSIZE     db MAXSIZE              ;max. Zeichenanzahl
ACTSIZE     db ?                    ;DOS hinterlegt aktuelle Zahl der Eingabezeichen
PUFTXT      db MAXSIZE dup (" ")    ;Eingabepuffer wird mit 30 Leerzeicheninitialisiert
ENDPUF      db CR, LF, EDB          ;Diese Angaben werden für Ausgabe des Eingabetextes benötigt
BGRTXT      db 'Guten Tag'         ;Begrüßungstext
            .CODE
            mov dx, OFFSET BGRTXT   ;Adresse des ersten Zeichen in dx laden
            mov ah, BILDAUSG
            int DOSINT
            ;Lesen der Antwort
            mov dx, OFFSET PUFSIZE  ;Adresse des Speicherplatzes, der die Größe des Eingabepuffers angibt, nach dx laden
            mov ah, TASTEEIN
            int DOSINT
            ;Löschen des CR-Zeichens im Eingabepuffer
            mov al, ACTSIZE         ;AL: aktuelle Zeichenanzahl
            xor ah, ah              ;AH Löschen
            mov si, ax
            mov [si+PUFTXT], LEER   ;ASCII-Code Leerzeichen an letzte Position in Eingabepuffer schreiben
            ;Ausgabe des Textes
            mov cx, ANZAHL          ;Schleifenzähler
Ausgabe:    mov dx, OFFSET PUFTXT
            mov ah, BILDAUSG
            int DOSINT
            dec cx
            jnz Ausgabe
            ;Rücksprung ins DOS
            mov ah, 4Ch
            int 21h
            .stack 100h
            END
