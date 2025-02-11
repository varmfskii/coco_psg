DEBUG:	equ 1
	include "inc/coco.inc"
	include "inc/aypsg.inc"
	
	org $7000
	include "supersprite.asm"
start:
	include "base.asm"
	end start
