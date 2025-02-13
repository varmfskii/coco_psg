5 REM DEMONSTRATION OF THE SN76489A ON THE GAME MASTER CARTRIDGE
7 REM COPIED AND MODIFIED FROM ELECTRONICS AUSTRALIA, AUGUST 1983
9 REM ARTICLE, "MAKE MUSIC WITH YOUR COMPUTER" BY PETER VERNON
10 CLS
20 GOSUB 1000:REM TURN OFF ALL SOUND
21 X=&HFF00
22 REM SET COCO SOUND MULTIPLEXER TO CARTRIDGE INPUT
23 POKE X+1,52:POKE X+3,63
24 REM ENABLE SOUND MULTIPLEXER
25 POKE X+35,60
30 N=&HFF41
40 PRINT "BELL (1), PHASER (2), BIRDS (3), OR EXPLOSION (4)"
50 INPUT "SELECT 1, 2, 3, OR 4";A
60 ON A GOSUB 90,220,320,440
70 GOTO 10
80 :
90 PRINT "BELL SOUND"
100 POKE N,136:REM SET VOICE 1 TO 679HZ
110 POKE N,11
120 POKE N,164:REM SET VOICE 2 TO 694HZ
130 POKE N,11
140 FOR B=0 TO 3:REM NUMBER OF CHIMES
150 FOR I=145 TO 159:REM LOOP THROUGH ATTENUATION STEPS
160 POKE N,I:POKE N,I+32
170 FOR D=0 TO 40:NEXT D:REM LENGTH OF A CHIME
180 NEXT I
190 NEXT B
200 RETURN
210 :
220 PRINT "PHASER SOUND"
230 POKE N,231:POKE N,240
240 FOR L=0 TO 15
250 FOR A=193 TO 205
260 POKE N,A:POKE N,L
270 NEXT A
280 POKE N,(240+L)
290 NEXT L
300 RETURN
310 :
320 PRINT "BIRDSONG":T=0
330 S=INT(RND(10)):REM RANDOM CHIRP LENGTH
340 POKE N,144
350 FOR I=0 TO 10
360 POKE N,(128+I)
370 POKE N,1
380 FOR D=0 TO S:NEXT D
390 NEXT I
400 T=T+S
410 IF T=>200 THEN RETURN
420 GOTO 330
430 :
440 PRINT "EXPLOSION SOUND"
450 POKE N,230:REM SET HIGH PITCHED WHITE NOISE
460 FOR I=240 TO 255:REM LOOP THROUGH ATTENUATION VALUES
470 POKE N,I
480 FOR D=0 TO 75:NEXT D:REM LENGTH OF SOUND LEVEL
490 NEXT I
500 RETURN
1000 REM TURN OFF ALL SOUND
1010 N=&HFF41
1020 POKE N,159
1030 POKE N,191
1040 POKE N,223
1050 POKE N,255
1060 RETURN
