10 ONBRK GOTO180
20 GOSUB 200
30 V=0:FORR=0TO13:GOSUB250:NEXTR
40 R=7:V=255:GOSUB250
50 R=0:V=254:GOSUB250:'A
60 R=1:V=0:GOSUB250
70 R=8:V=15:GOSUB250
80 R=7:V=56:GOSUB250:GOSUB160
90 RESTORE
100 R=0
110 READ V
120 IFV=0THEN90
130 GOSUB250:GOSUB160
140 GOTO110
150 GOTO 90
160 FORX=1TO50:NEXTX:RETURN
170 GOTO 90
180 GOSUB290
190 END
200 'SUPERSPRITE INIT
210 POKE &HFF7F,&H30
220 H0=&HFF5C
230 H1=&HFF5D
240 RETURN
250 'SSR CONTROL
260 POKE H0,R
270 POKE H1,V
280 RETURN
290 'SSR RESET
300 R=7:V=63:GOSUB250
310 POKE &HFF7F,&H33
320 RETURN
330 DATA 254,226,202,190,170,151,135
340 DATA 127,135,151,170,190,202,226
350 DATA 0
