\ Acorn Atom as keyboard for System5
\ (C)Roland Leurs 2024
\ Version 2.0 Februari 2025
\ Main program


capslock = &E7
shiftlock = &E8
timer = &E9

org &4000 - 22

.atmheader	equs "SYS5KEYB",0,0,0,0,0,0,0,0
            equw main
            equw main
            equw progend-main

.main   	jmp reset

include "keyboard.asm"          \ include keyboard routines
include "led.asm"               \ include led routines

.reset                          \ start reset routine
            lda #&8A            \ Initialize the 8255 PPI
            sta &B003
            lda #&07
            sta &B002
            lda #&00            \ Load value for shift lock
            sta shiftlock       \ set shift lock off
            lda #&80            \ Load value for caps lock
            sta capslock        \ set caps lock on
            ldx #&FF            \ initialize the cpu stack
            txs
            stx &B803           \ Set VIA A port to output
            stx &B801           \ Set all outputs to '1'
            jsr ledinit         \ initialize keyboard leds

.reset_output
            lda &B801            \ Load output to System5
            ora #&80             \ Set "no key pressed" bit
            sta &B801            \ Write to System5
.mainloop   \ Wait until a key is pressed
            jsr KFE71           \ read a key
            bcs mainloop        \ jump if no key is pressed

.debounce   \ Do a bounce check

            jsr KFE71           \ Do another scan to eliminate a bouncing key
            bcs mainloop        \ Jump again if there's no keypress now

            \ Now start the timer. If the key is pressed for 500ms then
            \ the auto repeat starts.
            \ Here we have the keyboard scan code in the Y register

            lda #10             \ set timer loop counter
            sta timer
            jsr scan2ascii      \ convert scan code to ascii char and send it to System 5
.setup50    jsr timer50         \ initialize timer for 50ms
.wait500ms  jsr KFE71           \ do a keyboard scan
            bcs reset_output    \ the key is released, start over
            bit &B80D           \ load timer status
            bvc wait500ms       \ wait until timer expires
            dec timer           \ decrement timer loop counter
            bne setup50         \ if not waited for 500 ms then go for next 50ms period

            \ At this point the key was pressed for 500 ms. Now the auto repeat starts
            \ with a rate of 10 Hz
            lda #2              \ set timer loop counter
            sta timer
            lda &B801           \ clear keyboard strobe
            ora #&80
            sta &B801
.wait100ms  jsr timer50         \ initialize timer for 50ms
.auto_rept  jsr KFE71           \ in the mean while do a keyboard scan
            bcs mainloop        \ jmp to main loop if key is released
            bit &B80D           \ load timer status
            bvc auto_rept       \ wait until timer expires
            dec timer           \ decrement timer loop counter
            bne wait100ms       \ if not waited for 100 ms then go for next 100ms period

            \ At this point the key is still pressed and the strobe was high. Now
            \ give a new strobe pulse, reinitialize the timer and wait for another
            \ 100ms.
            lda &B801           \ Send new strobe
            and #&7F
            sta &B801
            lda #2              \ set timer loop counter
            sta timer
            bne wait500ms       \ and now continue in the first waiting loop, but with lower counter

.progend

SAVE "sys5keyb.atm", atmheader, progend
SAVE "sys5keyb.bin", main, progend
