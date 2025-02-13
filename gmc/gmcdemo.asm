	org $7000
start:	
;5 REM DEMONSTRATION OF THE SN76489A ON THE GAME MASTER CARTRIDGE
;7 REM COPIED AND MODIFIED FROM ELECTRONICS AUSTRALIA, AUGUST 1983
;9 REM ARTICLE, "MAKE MUSIC WITH YOUR COMPUTER" BY PETER VERNON
;10 CLS
loop:	lbsr cls
;20 GOSUB 1000:REM TURN OFF ALL SOUND
	lbsr sound_off
;21 X=&HFF00
;22 REM SET COCO SOUND MULTIPLEXER TO CARTRIDGE INPUT
;23 POKE X+1,52:POKE X+3,63
	lda #$34
	sta $ff01
	lda #$3f
	sta $ff03
;24 REM ENABLE SOUND MULTIPLEXER
;25 POKE X+35,60
	lda #$3c
	sta $ff23
;30 N=&HFF41
gmc:	equ $ff41
	lbsr bell
	lbsr sound_off
	lbsr phaser
	lbsr sound_off
	lbsr birds
	lbsr sound_off
	lbsr explosion
	lbsr sound_off
	rts
;40 PRINT "BELL (1), PHASER (2), BIRDS (3), OR EXPLOSION (4)"
;50 INPUT "SELECT 1, 2, 3, OR 4";A
	ldx #prompt1
	lbsr getinput
;60 ON A GOSUB 90,220,320,440
	lble loop
	cmpa #4
	lbgt loop
	deca
	asla
	ldx #table
	jsr [a,x]
;70 GOTO 10
	rts
	lbra loop
;80 :
table:	fdb bell,phaser,birds,explosion
prompt1:
	fcc "BELL (1), PHASER (2), BIRDS (3), OR EXPLOSION (4)"
	fcb 13
	fcc "SELECT 1, 2, 3, OR 4? "
	fcb 13,0

bell_txt:
	fcc "BELL SOUND"
	fcb 13,0
;90 PRINT "BELL SOUND"
bell:	
	ldx #bell_txt
	lbsr print
;100 POKE N,136:REM SET VOICE 1 TO 679HZ
	lda #$88
	sta gmc
	nop
	nop
;110 POKE N,11
	lda #$0b
	sta gmc
	nop
	nop
;120 POKE N,164:REM SET VOICE 2 TO 694HZ
	lda #$a4
	sta gmc
	nop
	nop
;130 POKE N,11
	lda #$0b
	sta gmc
	nop
	nop
;140 FOR B=0 TO 3:REM NUMBER OF CHIMES
	ldx #3
l1@:	
;150 FOR I=145 TO 159:REM LOOP THROUGH ATTENUATION STEPS
	lda #$91
	ldb #$b1
l2@:	
;160 POKE N,I:POKE N,I+32
	sta gmc
	nop
	nop
	stb gmc
	nop
	nop
;170 FOR D=0 TO 40:NEXT D:REM LENGTH OF A CHIME
delay:	equ $2000
	ldy #delay
l3@:	
	leay -1,y
	bne l3@
;180 NEXT I
	inca
	incb
	cmpa #$9f
	ble l2@
;190 NEXT B
	leax -1,x
	bne l1@
;200 RETURN
	rts
	
;210 :
phaser_txt:
	fcc "PHASER SOUND"
	fcb 13,0
;220 PRINT "PHASER SOUND"
phaser:
	ldx #phaser_txt
	lbsr print
;230 POKE N,231:POKE N,240
	lda #$e7
	sta gmc
	nop
	nop
	lda #$f0
	sta gmc
	nop
	nop
;240 FOR L=0 TO 15
	clrb
l1@:
;250 FOR A=193 TO 205
	lda #$c1
l2@:
;260 POKE N,A:POKE N,L
	sta gmc
	nop
	nop
	stb gmc
	nop
	nop
delay2:	equ $0300
	ldx #delay2
l3@:
	leax -1,x
	bne l3@
;270 NEXT A
	inca
	cmpa #$cc
	ble l2@
;280 POKE N,(240+L)
	tfr b,a
	adda #$f0
	sta gmc
	nop
	nop
	ldx #delay2
l4@:
	leax -1,x
	bne l4@
;290 NEXT L
	incb
	cmpb #15
	ble l1@
;300 RETURN
	rts

;310 :
bird_txt:
	fcc "BIRDSONG"
	fcb 13,0
;320 PRINT "BIRDSONG":T=0
birds:	
	ldx #bird_txt
	lbsr print
;330 S=INT(RND(10)):REM RANDOM CHIRP LENGTH
	ldx #0
l1@:
;340 POKE N,144
	lda #$90
	sta gmc
	nop
	nop
;350 FOR I=0 TO 10
	lda #$80
l2@:
;360 POKE N,(128+I)
	sta gmc
	nop
	nop
;370 POKE N,1
	ldb #1
	stb gmc
	nop
	nop
;380 FOR D=0 TO S:NEXT D
	ldx #$0200
l3@:
	leax -1,x
	bne l3@
;390 NEXT I
	inca
	cmpa #$8a
	ble l2@
;400 T=T+S
	leay 5,y
;410 IF T=>200 THEN RETURN
	cmpy #200
	ble l1@
	rts
;420 GOTO 330

;430 :
explosion_txt:
	fcc "EXPLOSION SOUND"
	fcb 13,0
;440 PRINT "EXPLOSION SOUND"
explosion:	
	ldx #explosion_txt
	lbsr print
;450 POKE N,230:REM SET HIGH PITCHED WHITE NOISE
	lda #$e6
	sta gmc
	nop
	nop
;460 FOR I=240 TO 255:REM LOOP THROUGH ATTENUATION VALUES
	lda #$f0
l1@:
;470 POKE N,I
	sta gmc
	nop
	nop
;480 FOR D=0 TO 75:NEXT D:REM LENGTH OF SOUND LEVEL
	ldx #delay
l2@:
	leax -1,x
	bne l2@
;490 NEXT I
	inca
	bne l1@
;500 RETURN
	rts
;1010 N=&HFF41

sound_off:	
;1020 POKE N,159
	lda #$9f
	sta gmc
	nop
	nop
;1030 POKE N,191
	lda #$bf
	sta gmc
	nop
	nop
;1040 POKE N,223
	lda #$df
	sta gmc
	nop
	nop
;1050 POKE N,255
	lda #$ff
	sta gmc
	nop
	nop
;1060 RETURN
	rts

getinput:
	lbsr print
	lda #2
	rts

print:
	lda ,x+
	beq exit@
	jsr [$a002]
	bra print
exit@:
	rts

cls:
	rts
	end start
