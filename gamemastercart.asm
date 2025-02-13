sscrst:	equ $ff7d
sscdat:	equ $ff7e

tones:	
	fdb 254,226,202,190,170,151,135
	fdb 127,135,151,170,190,202,226
	fdb 0

pre	macro
	lbsr busy
	lda #$af
	sta sscdat
	endm
	
post	macro
	lbsr busy
	lda #$ff
	sta sscdat
	endm
	
init:
	ifdef DEBUG
	ldy #screen
	lda #' '
	tfr a,b
loop@:
	std ,y++
	cmpy #screen+$0200
	bne loop@
	ldy #screen+32*15
	endif
	card_sound
	rts

reset:	
	lda #$9f
	sta gmc_ctl
	sta vola
	lda #$bf
	sta gmc_ctl
	sta volb
	lda #$df
	sta gmc_ctl
	sta volc
	lda #$ff
	sta gmc_ctl
	sta voln
	rts

control:	
	pshs d,y
	ifdef DEBUG
	stb a,y
	endif
	anda #$0f
	asla
	ldy br_table
	jmp [a,y]
br_table:
	fdb afine,acoarse,bfine,bcoarse,cfine,ccoarse,noise,enable
	fdb avol,bvol,cvol,efine,ecoarse,eshape,null,null
afine:
	lda atone
	sta gmc_ctl
	stb atone+1
	stb gmc_ctl
null:	
	puls d,y,pc
acoarse:
	lda atone
	anda #$f0
	sta atone
	orb atone
	stb gmc_ctl
	ldb atone+1
	stb gmc_ctl
	puls d,y,pc
bfine:
	lda btone
	sta gmc_ctl
	stb btone+1
	stb gmc_ctl
	puls d,y,pc
bcoarse:
	lda btone
	anda #$f0
	sta btone
	orb btone
	stb gmc_ctl
	ldb btone+1
	stb gmc_ctl
	puls d,y,pc
cfine:
	lda ctone
	sta gmc_ctl
	stb ctone+1
	stb gmc_ctl
	puls d,y,pc
ccoarse:
	lda ctone
	anda #$f0
	sta ctone
	orb ctone
	stb gmc_ctl
	ldb ctone+1
	stb gmc_ctl
	puls d,y,pc
noise:
	puls d,y,pc
enable:
	puls d,y,pc
avol:
	puls d,y,pc
bvol:
	puls d,y,pc
cvol:
	puls d,y,pc
efine:
	puls d,y,pc
ecoarse:
	puls d,y,pc
eshape:
	puls d,y,pc

atone:	fdb #$8000
btone:	fdb #$a000
ctone:	fdb #$c000
etone:	fdb #$e000
ainh:	fcb #$90
binh:	fcb #$b0
cinh:	fcb #$d0
einh:	fcb #$f0
	
