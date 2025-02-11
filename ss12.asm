	include "inc/coco.inc"
	include "inc/aypsg.inc"
	
siz:	equ 13
scn:	equ 2
crs:	equ 4
fin:	equ 5
amp:	equ 6
srg:	equ 7
sdt:	equ 8
dly:	equ 9
scr:	equ 10
cpl:	equ 12

psg1:	equ $03
psg2:	equ $0c
psg3:	equ $30
psg4:	equ $c0
dat:	equ $aa	
reg:	equ $ff
dat_a:	equ $ff60
ctl_a:	equ $ff61
dat_b:	equ $ff62
ctl_b:	equ $ff63
	
	org $7000
	;; base=CPU freq (0.894665/1.789770)
	;; freq=base/16/tone
tones:	
	fdb 127,113,101,95,85,76,67
	fdb 64,67,76,85,95,101,113
	fdb 0
voice:
	fdb control
	fdb screen+8*32+9
	fcb ay_a_coarse
	fcb ay_a_fine
	fcb ay_a_amp
	fcb reg&psg1
	fcb dat&psg1
	rmb 4
	
init:
	clra
	sta ctl_a
	sta ctl_b
	lda #$ff
	sta dat_a
	sta dat_b
	lda #$04
	sta ctl_a
	sta ctl_b
	clra
	sta dat_a
	sta dat_b
	lda #$3d
	sta $ff03
	lda #$3f
	sta $ff23
	ldy #screen
	lda #' '
	tfr a,b
loop@:
	std ,y++
	cmpy #screen+$0200
	bne loop@
	;; ldy #screen+15*32
	rts

reset:
	lda #8
	ldb #%00111111
	jsr [,x]
	rts

control:
	pshs d,y
	ldy scn,x
	stb a,y
	sta dat_a
	lda srg,x
	sta dat_b
	clr dat_b
	stb dat_a
	lda sdt,x
	sta dat_b
	clr dat_b
	puls y,d,pc
	
start:
	bsr init
	ldx #voice
	ldy scr,x
	
	;; reset registers to 0
	clra
	clrb
loop@:	
	jsr [,x]
	inca
	cmpa #14
	bne loop@

	lda #ay_enable		; disable audio
	ldb #%00111111
	jsr [,x]
	lda amp,x		; voice a max volume
	ldb #15
	jsr [,x]
	lda #ay_enable		; enable voices a, b, and c
	ldb #%00111000
	jsr [,x]

	;; iterate through notes
	clra
repeat@:	
	ldu #tones
loop@:	
	ldd ,u++
	beq exit@
	bsr note
	bra loop@
exit@:
	ldd tones
	bsr note
	lda #ay_enable		; mute audio
	ldb #%00111111
	jsr [,x]
	lbra reset

	;; play note on voice a
note:
	pshs d
	std screen+14*32+16
	lda crs,x
	ldb ,s
	jsr [,x]
	lda fin,x
	ldb 1,s
	jsr [,x]
	bsr wait
	puls d,pc

	;; wait 500 ms
wait:
	pshs d
	lda #30
	sta screen+14*32
loop@:
	ldb pia0+2		; acknowledge interrupt
	sync
	deca
	sta screen+14*32
	bne loop@
	puls d
	rts

	end start
