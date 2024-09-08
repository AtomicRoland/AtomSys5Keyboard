\ Acorn Atom as keyboard for System5
\ (C)Roland Leurs 2024
\ Version 1.0 September 2024
\ Main program


capslock = &E7
shiftlock = &E8

org &4000 - 22

.atmheader	equs "SYS5KEYB",0,0,0,0,0,0,0,0
            equw main
            equw main
            equw progend-main

.main   	jmp reset

include "keyboard.asm"          \ include keyboard routines

.reset                          \ start reset routine
            lda #&8A            \ Initialize the 8255 PPI
            sta &B003
            lda #&07
            sta &B002
            lda #&00            \ Load value for caps and shift lock
            sta capslock        \ set caps lock off
            sta shiftlock       \ set shift lock off
            ldx #&FF            \ initialize the cpu stack
            txs
            stx &B803           \ Set VIA A port to output
            stx &b801           \ Set all outputs to '1'
.mainloop
            jsr KFE94           \ read a key
            ; jsr &F802           \ print its value
            ; lda #32 : jsr &fff4 : jsr &fff4
            jmp mainloop        \ keep doing this

.progend

SAVE "sys5keyb.atm", atmheader, progend
SAVE "sys5keyb.bin", main, progend
