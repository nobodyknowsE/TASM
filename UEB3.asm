;bisher steht Grundgeruest für Endlosschleife, die durch esc abgebrochen wird
            .model small
            .486
escCode    = 1Bh
            .code

EndlLoop:   xor ah, ah
            int 16h

            cmp al, escCode
            jne ***irgendwas***
            jmp LoopEnd
LoopEnd:    ;Ruecksprung ins DOS
            mov ah, 4ch
            int 21h
            .stack 100h
            end
