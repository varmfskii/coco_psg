DEBUG:	equ 1
	include "inc/coco.inc"
	include "inc/aypsg.inc"
	
	org $7000
	include "symphony12.asm"
start:
	include "base_ay.asm"
	end start
