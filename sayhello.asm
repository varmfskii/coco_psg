	org $7000
SSC:	equ $ff7e
PIA0:	equ $ff00
PIA1:	equ $ff20
	
start:
	pshs dp
	lda #$ff
	pshs a
	puls dp
	setdp $ff
	;; reset ssc
	lda #1
	sta SSC-1
	clr SSC-1
	;; set coco sound multiplexer to cartridge input
	lda PIA0+1
	anda #$f7
	sta PIA0+1
	lda PIA0+3
	ora #$08
	sta PIA0+3
	;; enable sound multiplexer
	lda PIA1+3
	ora #$08
 	sta PIA1+3

	;; string loop
	ldu #string
loop:
	bsr ssc_ready
	lda ,u+
	sta SSC
	cmpa #13
	bne loop
	puls dp,pc

ssc_ready:	
	lda SSC
	anda #$80
	beq ssc_ready
	rts
	
string:
	fcc "HELLO COLOR COMPUTER "
	fcb 13
	end start
	
