\ Acorn Atom as keyboard for System5
\ (C)Roland Leurs 2024
\ Version 1.0 December 2024
\ LED status routine

\ LED's have negative logic. So bit clear means led on
\ bit 0: sys/run
\ bit 1: caps lock
\ bit 2: shift lock

.ledinit
    lda #&07        \ set up B-port of VIA
    sta &B802
    lda #&04        \ default setting is caps on and shift off
    sta &B800
    rts

.ledstatus
    lda #&FE        \ sys/run led on
    bit capslock    \ check caps lock status
    bpl ledstatus_no_caps
    and #&FD        \ caps lock led on
.ledstatus_no_caps
    bit shiftlock   \ check shift lock status
    bpl ledstatus_no_shift
    and #&FB        \ shift lock led on
.ledstatus_no_shift
    sta &B800       \ write to VIA port
    rts             \ return

