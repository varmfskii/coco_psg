	bsr init

	;; reset registers to 0
	pre
	clra
	clrb
loop@:	
	bsr control
	inca
	cmpa #14
	bne loop@

	lda #ay_enable		; disable audio
	ldb #%00111111
	bsr control
	lda #ay_a_amp		; voice a max volume
	ldb #15
	bsr control
	lda #ay_enable		; enable voices a, b, and c
	ldb #%00111000
	bsr control
	post

	;; iterate through notes
	clra
repeat@:	
	ldx #tones
loop@:	
	ldd ,x++
	beq exit@
	bsr notea
	bra loop@
exit@:
	ldd tones
	bsr notea
	pre
	lda #ay_enable		; mute audio
	ldb #%00111111
	bsr control
	post
	lbra reset

	;; play note on voice a
notea:
	ifdef DEBUG
	std screen+14*32+16
	endif
	pshs d
	pre
	lda #ay_a_coarse
	ldb ,s
	lbsr control
	lda #ay_a_fine
	ldb 1,s
	lbsr control
	post	
	bsr wait
	puls d,pc

	;; play note on voice b
noteb:
	ifdef DEBUG
	std screen+14*32+20
	endif
	pshs d
	pre
	lda #ay_b_coarse
	ldb ,s
	lbsr control
	lda #ay_b_fine
	ldb 1,s
	lbsr control
	post
	bsr wait
	puls d,pc

	;; wait 500 ms
wait:
	pshs d
	lda #30
	ifdef DEBUG
	sta screen+14*32
	endif
loop@:
	ldb pia0+2		; acknowledge interrupt
	sync
	deca
	ifdef DEBUG
	sta screen+14*32
	endif
	bne loop@
	puls d
	rts

	;; play note on voice c
notec:
	ifdef DEBUG
	std screen+14*32+24
	endif
	pshs d
	pre
	lda #ay_c_coarse
	ldb ,s
	lbsr control
	lda #ay_c_fine
	ldb 1,s
	lbsr control
	post
	bsr wait
	puls d,pc
	
