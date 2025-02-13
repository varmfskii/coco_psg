DEBUG:	equ 1
	include "inc/coco.inc"
	include "inc/aypsg.inc"
	
	org $7000
	include "superspritefm.asm"
start:
	include "base_ay.asm"
	end start
