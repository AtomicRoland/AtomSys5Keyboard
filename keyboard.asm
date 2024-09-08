\ Acorn Atom as keyboard for System5
\ (C)Roland Leurs 2024
\ Version 1.0 September 2024
\ Keyboard scan routine

\ Short wait routine
.KFB8A
 ldx #6         \ load counter
.KFB83
 jsr wait       \ wait 50ms
 dex            \ decrement counter
 bne KFB83      \ jump if nap isn't done
 rts            \ return

\ Keyboard scan routine
.KFE71
LDY #&3B        :\ FE71= A0 3B        ;
CLC             :\ FE73= 18          .
LDA #&20        :\ FE74= A9 20       )
.KFE76
LDX #&0A        :\ FE76= A2 0A       ".
.KFE78
BIT &B001       :\ FE78= 2C 01 B0    ,.0
BEQ KFE85       :\ FE7B= F0 08       p.
INC &B000       :\ FE7D= EE 00 B0    n.0
DEY             :\ FE80= 88          .
DEX             :\ FE81= CA          J
BNE KFE78       :\ FE82= D0 F4       Pt
LSR A           :\ FE84= 4A          J
.KFE85
PHP             :\ FE85= 08          .
PHA             :\ FE86= 48          H
LDA &B000       :\ FE87= AD 00 B0    -.0
AND #&F0        :\ FE8A= 29 F0       )p
STA &B000       :\ FE8C= 8D 00 B0    ..0
PLA             :\ FE8F= 68          h
PLP             :\ FE90= 28          (
BNE KFE76       :\ FE91= D0 E3       Pc
RTS             :\ FE93= 60          `


.KFE94
.KFE9A
bit &B002       \ check if REPT is pressed
bvc KFEA4       \ yes, skip routine to wait for key release
jsr KFE71       \ Perform a keyboard scan
bcc KFE9A       \ If a key is pressed then wait because it's the previous key scan

.KFEA4
jsr KFB8A       \ Take a short nap

.KFEA7
jsr KFE71       \ Perform another scan
bcc debounce    \ Jump if possible key is pressed
lda &B801       \ Load output to System5
ora #&80        \ Set "no key pressed" bit
sta &B801       \ Write to System5

.debounce
jsr KFE71       \ Do another scan to eliminate a bouncing key
bcs KFEA7       \ Jump again if there's no keypress now

\ Here we have the keyboard scan code in the Y register

cpy #5          \ Test the caps lock key
beq setcapslock \ Set caps lock value
tya             \ 
cmp #&21        \ Test for the A key
bmi not_alpha   \ Jump if lower
cmp #&3B        \ Test for the Z key
bpl not_alpha   \ Jump if higher
eor capslock    \ Mask with caps lock status
.not_alpha
bit &B001       \ test shift status
bmi not_shift   \ jump if shift is not pressed
eor #&80        \ Shift the character
.not_shift
eor shiftlock   \ Mask with shift lock status
tay             \ Copy A to index Y register
lda ascii,y     \ Read the ASCII value of the key
bit &B001       \ Test for control key
bvs not_ctrl    \ jump if control key is not pressed
and #&1F        \ If control key is pressed, clear the three upper bits
.not_ctrl
sta &b801       \ write to via output (i.e. send to System5)
rts             \ Return with ascii value in A

.setcapslock
lda &B001       \ Load shift key status
bpl setshiftlock
lda capslock    \ Load current caps lock status
eor #&80        \ Toggle status bit
sta capslock    \ Store caps lock status
jmp KFE94       \ Continue scanning

.setshiftlock
lda shiftlock   \ Load current shift lock status
eor #&80        \ Toggle status bit
sta shiftlock   \ Store shift lock status
jmp KFE94       \ Continue scanning

.wait           \ wait routine, using VIA timer 1
; VIA_T1CL = &B804 ; timer 1 counter low
; VIA_T1CH = &B805 ; timer 1 counter high
; VIA_ACL  = &B80B ; Auxiliary Control register
; VIA_IER  = &B80E ; Interrupt Enable Register
; VIA_IFR  = &B80D ; Interrupt Flag Register

lda #<50000     \ load low value for counter
sta &B804
lda #>50000     \ load high value for counter
sta &B805
lda #&00        \ set VIA ACL
sta &B80B
.wait4zero      \ waits until timer expires
bit &B80D       \ load timer status
bvc wait4zero   \ wait until timer expires
rts             \ return


.ascii \ table

\    &00,&01,&02,&03,&04,&05,&06,&07,&08,&09,&0A,&0B,&0C,&0D,&0E,&0F
equb &20,&5B,&5C,&5D,&5E,&00,&08,&0A,&00,&00,&00,&00,&00,&0D,&00,&7F \ &00
equb &30,&31,&32,&33,&34,&35,&36,&37,&38,&39,&3A,&3B,&2C,&2D,&2E,&2F \ &10
equb &40,&41,&42,&43,&44,&45,&46,&47,&48,&49,&4A,&4B,&4C,&4D,&4E,&4F \ &20
equb &50,&51,&52,&53,&54,&55,&56,&57,&58,&59,&5A,&1B,&00,&00,&00,&00 \ &30
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &40
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &50
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &60
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &70
equb &20,&7B,&7C,&7D,&7E,&00,&09,&0B,&00,&00,&00,&00,&00,&0D,&00,&7F \ &80
equb &40,&21,&22,&23,&24,&25,&26,&27,&28,&29,&2A,&2B,&3C,&3D,&3E,&3F \ &90
equb &60,&61,&62,&63,&64,&65,&66,&67,&68,&69,&6A,&6B,&6C,&6D,&6E,&6F \ &A0
equb &70,&71,&72,&73,&74,&75,&76,&77,&78,&79,&7A,&00,&00,&00,&00,&00 \ &B0
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &C0
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &D0
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &E0
equb &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00 \ &F0