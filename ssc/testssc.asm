;*********************************************************************
;* Title: testssc.asm
;*********************************************************************
;* Author: R. Allen Murphey
;*
;* Description: Speech/Sound Cartridge Driver
;*
;* Documentation:
;* $FF7D RESET POKE 1, THEN POKE 0
;* $FF7E READ STATUS - WRITE DATA FOR COMMAND AF=WRITE TO PSG
;* SP0256-AL2 "NARRATOR"
;* GI AY-3-891X PROGRAMMABLE SOUND GENERATOR
;* AY-3-8910    PC6001    CHANNEL    OPERATION
;* R1/R0        R1/R0     A          Tone Generator Control 1-4095
;* R3/R2        R3/R2     B          Tone Generator Control 1-4095
;* R5/R4        R5/R4     C          Tone Generator Control 1-4095
;* R6           R6        -          Noise Generator Control 1-31
;* R7           R7        -          Mixer Control / I/O Enable
;*                                   IOA|IOB|NOISEC|NOISEB|NOISEA|TONEC|TONE|TONEA
;* R10          R8        A          Amplitude Control
;*                                   x|x|x|M|L3|L2|L1|L0
;* R11          R9        B          Amplitude Control
;*                                   x|x|x|M|L3|L2|L1|L0
;* R12          R10       C          Amplitude Control
;*                                   x|x|x|M|L3|L2|L1|L0
;* R14/R13      R12/R11   -          Envelope Period Control 1-65535
;* R15          R13       -          Envelope Shape / Cycle Control
;*                                   x|x|x|x|CONT|ATT|ALT|HOLD
;*
;* Include Files: none
;*
;* Assembler: lwasm from lwtools 4.21+
;* On Linux:
;* lwasm -9 -b --list=testssc.txt -o TESTSSC.BIN testssc.asm
;* decb dskini TESTSSC.DSK
;*      OR
;* decb kill TESTSSC.DSK,TESTSSC.BIN
;* decb copy TESTSSC.BIN TESTSSC.DSK,TESTSSC.BIN -2
;*
;* On a CoCo: LOADM"TESTSSC":EXEC
;*
;* Revision History:
;* Rev #     Date      Who     Comments
;* -----  -----------  ------  ---------------------------------------
;* 01     2023         RAM     Added 44 loop write delay after testing
;* 00     2020         RAM     Initial note table
;*********************************************************************

PIA0AC:     equ   $FF01
PIA0BC:     equ   $FF03
PIA1BC:     equ   $FF23

SSCPORTA:   equ   $FF7D
SSCPORTB:   equ   $FF7E

SSCTONAL:   equ   $00
SSCTONAH:   equ   $01
SSCTONBL:   equ   $02
SSCTONBH:   equ   $03
SSCTONCL:   equ   $04
SSCTONCH:   equ   $05
SSCNOISE:   equ   $06
SSCMIXER:   equ   $07
SSCVOLA:    equ   $08
SSCVOLB:    equ   $09
SSCVOLC:    equ   $0A
SSCENVLO:   equ   $0B
SSCENVHI:   equ   $0C
SSCENVSH:   equ   $0D
SSCIOA:     equ   $0E
SSCIOB:     equ   $0F

            org   $7000


SSCTEST:                      ; SETUP
                              ; switch MPI to slot 1
            lda   $FF7F
            anda  #$F0
            sta   $FF7F

SSCRESET:
                              ; Send PIC Reset
            lbsr  WDELAY      ;
            lda   #1          ;
            sta   SSCPORTA    ;
            lbsr  WDELAY      ;
            clra              ;
            sta   SSCPORTA    ;

                              ; enable CART sound on MUX
            lda   PIA0AC      ; Read current PIA register settings
            anda  #%11110111  ; Force bit 3 MUX SEL 1 off for cart
            sta   PIA0AC      ; Write modified PIA register back out
                              ;
            lda   PIA0BC      ; Read current PIA register setting
            ora   #%00001000  ; Force bit 3 MUX SEL 2 on for cart
            sta   PIA0BC      ; Write modified PIA register back out
                              ;
            lda   PIA1BC      ; Read current PIA register settings
            ora   #%00001000  ; Force bit 3 SNDEN on to enable sound
            sta   PIA1BC      ; Write modified PIA register back out

                              ; MAIN
                              ;
            bsr   WDELAY      ;
            lda   #$AF        ; SSC Command for direct PSG register access
            sta   SSCPORTB    ;

            clrb
            ldy   #SSCNOTES
PLAYSSC:
            bsr   WDELAY      ; write delay
            lda   #SSCTONAH   ; SSC Tone A Upper 4 bits
            sta   SSCPORTB    ; write to SSC to latch register 1
                              ;
            bsr   WDELAY      ; write delay
            lda   b,y         ; load upper 4 bits of note
            sta   SSCPORTB    ; write to SSC register 1
                              ;
            bsr   WDELAY
            lda   #SSCTONAL   ; SSC Tone A Lower 8 bits register 1
            sta   SSCPORTB    ; write to SSH to latch register 1
                              ;
            bsr   WDELAY      ; write delay
            incb              ; move to next value in note table
            lda   b,y         ; load it from table
            sta   SSCPORTB    ; write the lower eight bits of note
                              ;
            bsr   WDELAY      ; write delay
            lda   #SSCMIXER   ; SSC IO port and mixer settings Register 7
            sta   SSCPORTB    ; write to register latch
                              ;
            bsr   WDELAY      ; write delay
            lda   #%11111110  ; Enable Tone A with bit zero 0
            sta   SSCPORTB    ; write mixer out
                              ;
            bsr   WDELAY      ; write delay
            lda   #SSCVOLA    ; SSC Level of Channel A Register 8
            sta   SSCPORTB    ; write Channel A volume register to SSC
                              ;
            bsr   WDELAY      ; write delay
            lda   #%00001111  ; 0% attention (volume full)
            sta   SSCPORTB    ; write attenuation message to SSC
            bsr   BDELAY      ; big delay while note sounds
                              ;
            incb              ; move to next item in table
            cmpb  #24         ; have we read all 12 x 12bit notes?
            bne   PLAYSSC     ; no keep playing notes
                              
                              ; TEARDOWN
            bsr   WDELAY      ; write delay
            lda   #SSCVOLA    ; Register 8 Level of Channel A
            sta   SSCPORTB    ; write Channel A volume register to SSC
                              ;
            bsr   WDELAY      ; write delay
            lda   #%00000000  ; volume off
            sta   SSCPORTB    ; turn off volume
                              ; ALL OFF
            bsr   WDELAY      ; write delay
            lda   #$CF        ; SSC Command to stop ALL sound
            sta   SSCPORTB    ; turn off all sound
            rts               ; return
BDELAY:
            ldx   #$4000      ; countdown $4000 times
BDELAY2:
            leax  -1,X        ; let X=X-1
            bne   BDELAY2     ; if X > 0 goto BDELAY2
            rts               ; return
WDELAY:
            lda   SSCPORTB    ; read port B
            bpl   WDELAY      ; if bit 7 (status) = 0 keep waiting
            ;ldx   #22         ; 0.897MHz needs 22 loops extra delay
            ldx   #44         ; 1.789MHz needs 44 loops extra delay
            jsr   BDELAY2     ; wait a bit after PIC raises bit 7 flag       
            rts               ; return

SSCNOTES:                     ; Tone Periods at 1.789MHz clock
            fcb   $01,$AC     ; C4  261.626 Hz Middle C
            fcb   $01,$94     ; C#4 277.183 Hz
            fcb   $01,$7D     ; D4  293.665 Hz
            fcb   $01,$68     ; D#4 311.127 Hz
            fcb   $01,$53     ; E4  329.628 Hz
            fcb   $01,$40     ; F4  349.228 Hz
            fcb   $01,$2E     ; F#4 369.994 Hz
            fcb   $01,$1D     ; G4  391.995 Hz
            fcb   $01,$0D     ; G#4 415.305 Hz
            fcb   $00,$FE     ; A4  440.000 Hz
            fcb   $00,$F0     ; A#4 466.164 Hz
            fcb   $00,$E2     ; B4  493.883 Hz

            END   SSCTEST

;*********************************************************************
; End of testssc.asm
;*********************************************************************
