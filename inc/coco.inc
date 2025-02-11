	ifndef coco_inc
coco_inc: equ 1
irqvec: equ $010c
screen: equ $0400
pia0:	equ $ff00
pia1:	equ $ff20
mpi:	equ $ff7f

cart_snd macro
	;; sound mux to cart
	lda pia0+1
	anda #%11110111
	sta pia0+1
	lda pia0+3
	ora #%00001000
	sta pia0+3
	;; enable sound
	lda pia1+3
	ora #%00001000
	sta pia1+3
	endm
	endif