DEBUG:	equ 1
	include "inc/coco.inc"
	include "inc/sn76489.inc"
	
	org $7000
	include "gamemastercart.asm"
start:
	include "basesn.asm"
	end start
