dasm09: M6809/H6309/OS9 disassembler V0.1 © 2000 Arto Salmi
; org $7600 
7600: 34 7E          PSHS U,Y,X,DP,B,A 
7602: 10 FF 7E 25    STS $7E25 
7606: 1A 10          ORCC #$10 
7608: 86 7E          LDA #$7E 
760A: 1F 8B          TFR A,DP 
760C: 8D 27          BSR sub0 
760E: FC 01 0D       LDD $010D 
7611: 10 83 76 98    CMPD #$7698 
7615: 27 11          BEQ label1 
7617: FD 77 0A       STD $770A 
761A: CC 76 98       LDD #$7698 
761D: FD 01 0D       STD $010D 
	;; enable hsync IRQ
7620: B6 FF 01       LDA $FF01 ; CoCo PIA0 A control 
7623: 8A 01          ORA #$01 
7625: B7 FF 01       STA $FF01 ; CoCo PIA0 A control 
label1:
	8E 7B 2F       LDX #$7B2F 
762B: 9F 32          STX <$32 
762D: 1C EF          ANDCC #$EF 
762F: 10 FE 7E 25    LDS $7E25 
7633: 35 FE          PULS PC,U,Y,X,DP,B,A 

	;; subroutine
sub0:
	17 00 D4       LBSR sub1 
7638: 8D 09          BSR init 
763A: 96 00          LDA <$00 
763C: 81 55          CMPA #$55 
763E: 27 02          BEQ label4 
7640: 8D 36          BSR sub3 
label4:
	39             RTS 

	;; Initialize hardware
init:
	7F FF 63       CLR $FF63 ; S12 PIA b control 
7646: 7F FF 61       CLR $FF61 ; S12 PIA a control 
7649: 86 FF          LDA #$FF 
764B: B7 FF 62       STA $FF62 ; S12 PIA b data 
764E: B7 FF 60       STA $FF60 ; S12 PIA a data 
7651: 86 04          LDA #$04 
7653: B7 FF 61       STA $FF61 ; S12 PIA a control 
7656: B7 FF 63       STA $FF63 ; S12 PIA b control 
7659: 96 3A          LDA <$3A  ; $7e3a
765B: 97 2C          STA <$2C  ; $7e2c
765D: 0F 44          CLR <$44  ; $7e44
	;; sound source cartridge
765F: B6 FF 03       LDA $FF03 ; CoCo PIA0 B control 
7662: 8A 08          ORA #$08 
7664: B7 FF 03       STA $FF03 ; CoCo PIA0 B control
7667: B6 FF 01       LDA $FF01 ; CoCo PIA0 A control 
766A: 84 F7          ANDA #$F7 
766C: B7 FF 01       STA $FF01 ; CoCo PIA0 A control 
	;; sound enable
766F: B6 FF 23       LDA $FF23 ; CoCo PIA1 B control
7672: 8A 08          ORA #$08 
7674: B7 FF 23       STA $FF23 ; CoCo PIA1 B control 
7677: 39             RTS 

	;; subroutine
sub3:
	17 02 36       LBSR sub4 
767B: CC 00 80       LDD #$0080 
767E: 17 04 12       LBSR sub5 
7681: CC 01 01       LDD #$0101 
7684: 17 04 0C       LBSR sub5 
7687: CC 0C 0B       LDD #$0C0B 
768A: 17 04 06       LBSR sub5 
768D: CC 06 80       LDD #$0680 
7690: 17 04 00       LBSR sub5 
7693: 86 55          LDA #$55 
7695: 97 00          STA <$00 
7697: 39             RTS 
7698: 1A 10          ORCC #$10 
769A: 86 7E          LDA #$7E 
769C: 1F 8B          TFR A,DP 
769E: 0D 3D          TST <$3D 
76A0: 10 26 00 38    LBNE $76DC 
76A4: 0D 01          TST <$01 
76A6: 27 1B          BEQ $76C3 
76A8: 0D 44          TST <$44 
76AA: 26 17          BNE $76C3 
76AC: 9E 32          LDX <$32 
76AE: 17 01 71       LBSR sub6 
76B1: 0D 01          TST <$01 
76B3: 27 0E          BEQ $76C3 
76B5: 0D 3D          TST <$3D 
76B7: 27 F3          BEQ $76AC 
76B9: 0D 44          TST <$44 
76BB: 26 06          BNE $76C3 
76BD: 0D 01          TST <$01 
76BF: 10 26 00 43    LBNE $7706 
76C3: 0F 3D          CLR <$3D 
76C5: 0F 01          CLR <$01 
76C7: FC 77 0A       LDD $770A 
76CA: FD 01 0D       STD $010D 
76CD: B6 FF 01       LDA $FF01 ; CoCo PIA0 A control 
76D0: 84 FE          ANDA #$FE 
76D2: B7 FF 01       STA $FF01 ; CoCo PIA0 A control 
76D5: F6 FF 00       LDB $FF00 ; CoCo PIA0 A data (keyboard row) 
76D8: F6 FF 02       LDB $FF02 ; CoCo PIA0 B data (keyboard col) 
76DB: 3B             RTI 
76DC: 0A 2C          DEC <$2C 
76DE: 26 26          BNE $7706 
76E0: 96 3A          LDA <$3A 
76E2: 97 2C          STA <$2C 
76E4: 0A 3B          DEC <$3B 
76E6: 26 1E          BNE $7706 
76E8: 0F 3D          CLR <$3D 
76EA: 0D 02          TST <$02 
76EC: 27 18          BEQ $7706 
76EE: 86 07          LDA #$07 
76F0: D6 14          LDB <$14 
76F2: 17 03 C5       LBSR sub7 
76F5: D6 15          LDB <$15 
76F7: 17 03 B6       LBSR sub8 
76FA: D6 16          LDB <$16 
76FC: 17 03 A7       LBSR sub9 
76FF: D6 17          LDB <$17 
7701: 17 03 98       LBSR sub10 
7704: 0F 02          CLR <$02 
7706: B6 FF 00       LDA $FF00 ; CoCo PIA0 A data (keyboard row) 
7709: 7E D7 BC       JMP $D7BC 

	;; subroutine
sub1:
	E6 81          LDB ,X++ 
770E: 5D             TSTB 
770F: 26 08          BNE $7719 
7711: 10 FE 7E 25    LDS $7E25 
7715: 1C EF          ANDCC #$EF 
7717: 35 FE          PULS PC,U,Y,X,DP,B,A 
7719: AE 84          LDX ,X 
771B: A6 84          LDA ,X 
771D: 81 49          CMPA #$49 
771F: 27 14          BEQ $7735 
7721: 0D 01          TST <$01 
7723: 26 04          BNE $7729 
7725: 0D 3D          TST <$3D 
7727: 27 0C          BEQ $7735 
7729: 1C EF          ANDCC #$EF 
772B: 0D 01          TST <$01 
772D: 26 FC          BNE $772B 
772F: 0D 3D          TST <$3D 
7731: 26 F8          BNE $772B 
7733: 1A 10          ORCC #$10 
7735: CE 7B 2F       LDU #$7B2F 
7738: 34 44          PSHS U,B 
773A: C6 FF          LDB #$FF 
773C: 6F C0          CLR ,U+ 
773E: 5A             DECB 
773F: 26 FB          BNE $773C 
7741: 35 44          PULS U,B 
7743: A6 80          LDA ,X+ 
7745: A7 C0          STA ,U+ 
7747: 5A             DECB 
7748: 26 F9          BNE $7743 
774A: 6F C4          CLR ,U 
774C: 33 5F          LEAU -1,U 
774E: DF 34          STU <$34 
7750: C6 01          LDB #$01 
7752: D7 01          STB <$01 
7754: 0F 3D          CLR <$3D 
7756: 0F 02          CLR <$02 
7758: 39             RTS 

	;; subroutine
sub13:
	A6 84          LDA ,X 
775B: 81 2C          CMPA #$2C 
775D: 27 0C          BEQ $776B 
775F: 81 3B          CMPA #$3B 
7761: 27 08          BEQ $776B 
7763: 81 3A          CMPA #$3A 
7765: 27 04          BEQ $776B 
7767: 81 20          CMPA #$20 
7769: 2E 08          BGT $7773 
776B: 30 01          LEAX 1,X 
776D: 9C 34          CMPX <$34 
776F: 23 E8          BLS sub13 
7771: 0F 01          CLR <$01 
7773: 39             RTS 
7774: 8D 10          BSR sub11 
7776: C1 0C          CMPB #$0C 
7778: 23 06          BLS $7780 
777A: D7 44          STB <$44 
777C: 17 03 6E       LBSR sub12 
777F: 39             RTS 
7780: 0F 44          CLR <$44 
7782: 5A             DECB 
7783: D7 2E          STB <$2E 
7785: 39             RTS

	;; subroutine
sub11:
	17 FF D0       LBSR sub13 
7789: CC 00 00       LDD #$0000 
778C: DD 30          STD <$30 
778E: A6 84          LDA ,X 
7790: 81 39          CMPA #$39 
7792: 22 09          BHI $779D 
7794: 81 30          CMPA #$30 
7796: 25 05          BCS $779D 
7798: 5C             INCB 
7799: 30 01          LEAX 1,X 
779B: 20 F1          BRA $778E 
779D: 34 10          PSHS X 
779F: D7 38          STB <$38 
77A1: 10 27 00 72    LBEQ $7817 
77A5: A6 82          LDA ,-X 
77A7: 80 30          SUBA #$30 
77A9: 97 31          STA <$31 
77AB: 0A 38          DEC <$38 
77AD: 27 64          BEQ $7813 
77AF: A6 82          LDA ,-X 
77B1: 80 30          SUBA #$30 
77B3: C6 0A          LDB #$0A 
77B5: 3D             MUL 
77B6: D3 30          ADDD <$30 
77B8: DD 30          STD <$30 
77BA: 0A 38          DEC <$38 
77BC: 27 55          BEQ $7813 
77BE: A6 82          LDA ,-X 
77C0: 80 30          SUBA #$30 
77C2: C6 64          LDB #$64 
77C4: 3D             MUL 
77C5: D3 30          ADDD <$30 
77C7: DD 30          STD <$30 
77C9: 0A 38          DEC <$38 
77CB: 27 46          BEQ $7813 
77CD: A6 82          LDA ,-X 
77CF: 80 30          SUBA #$30 
77D1: C6 FA          LDB #$FA 
77D3: 3D             MUL 
77D4: DD 36          STD <$36 
77D6: D3 36          ADDD <$36 
77D8: D3 36          ADDD <$36 
77DA: D3 36          ADDD <$36 
77DC: D3 30          ADDD <$30 
77DE: DD 30          STD <$30 
77E0: 0A 38          DEC <$38 
77E2: 27 2F          BEQ $7813 
77E4: A6 82          LDA ,-X 
77E6: 81 36          CMPA #$36 
77E8: 22 29          BHI $7813 
77EA: 25 0C          BCS $77F8 
77EC: 34 06          PSHS B,A 
77EE: DC 30          LDD <$30 
77F0: 10 83 15 9F    CMPD #$159F 
77F4: 35 06          PULS B,A 
77F6: 22 1B          BHI $7813 
77F8: 80 30          SUBA #$30 
77FA: C6 FA          LDB #$FA 
77FC: 3D             MUL 
77FD: DD 36          STD <$36 
77FF: CC 00 00       LDD #$0000 
7802: 34 10          PSHS X 
7804: 8E 00 28       LDX #$0028 
7807: D3 36          ADDD <$36 
7809: 30 1F          LEAX -1,X 
780B: 26 FA          BNE $7807 
780D: 35 10          PULS X 
780F: D3 30          ADDD <$30 
7811: DD 30          STD <$30 
7813: DC 30          LDD <$30 
7815: 35 90          PULS PC,X 
7817: 5C             INCB 
7818: D7 44          STB <$44 
781A: 17 02 D0       LBSR sub12 
781D: 35 10          PULS X 
781F: 30 01          LEAX 1,X 
7821: 39             RTS 

	;; subroutine
sub6:
	0F 44          CLR <$44 
7824: 17 FF 32       LBSR sub13 
7827: A6 80          LDA ,X+ 
7829: 8D 11          BSR sub14 
782B: 0D 44          TST <$44 
782D: 26 07          BNE $7836 
782F: 9F 32          STX <$32 
7831: 9C 34          CMPX <$34 
7833: 24 04          BCC $7839 
7835: 39             RTS 
7836: 17 02 B4       LBSR sub12 
7839: 0F 01          CLR <$01 
783B: 39             RTS 

	;; subroutine
sub14:
	81 47          CMPA #$47 ; G
783E: 22 08          BHI $7848 
7840: 81 41          CMPA #$41 	; A
7842: 25 04          BCS $7848 
7844: 17 01 9D       LBSR sub15 ; play note
7847: 39             RTS 
7848: 81 52          CMPA #$52 	; R
784A: 26 03          BNE $784F 
784C: 8D 63          BSR sub4 	; stop all sounds
784E: 39             RTS 
784F: 81 49          CMPA #$49 	; I
7851: 26 01          BNE $7854 
7853: 39             RTS 
7854: 81 54          CMPA #$54 	; T
7856: 26 03          BNE $785B 
7858: 8D 74          BSR sub16 
785A: 39             RTS 
785B: 81 50          CMPA #$50 	; P
785D: 26 04          BNE $7863 
785F: 17 00 86       LBSR sub17 
7862: 39             RTS 
7863: 81 56          CMPA #$56 	; V
7865: 26 04          BNE $786B 
7867: 17 00 8D       LBSR sub18 
786A: 39             RTS 
786B: 81 4E          CMPA #$4E 	; N
786D: 26 04          BNE $7873 
786F: 17 00 D1       LBSR sub19 
7872: 39             RTS 
7873: 81 5A          CMPA #$5A 	; Z
7875: 26 04          BNE $787B 
7877: 17 00 D8       LBSR sub20 
787A: 39             RTS 
787B: 81 58          CMPA #$58 	; X
787D: 26 04          BNE $7883 
787F: 17 01 29       LBSR sub21 
7882: 39             RTS 
7883: 81 57          CMPA #$57 	; W
7885: 26 04          BNE $788B 
7887: 17 01 24       LBSR $79AE 
788A: 39             RTS 
788B: 81 4F          CMPA #$4F 	; O
788D: 26 04          BNE $7893 
788F: 17 01 34       LBSR $79C6 
7892: 39             RTS 
7893: 81 53          CMPA #$53 	; S
7895: 26 04          BNE $789B 
7897: 17 01 CD       LBSR $7A67 
789A: 39             RTS 
789B: 81 4C          CMPA #$4C 	; L
789D: 26 07          BNE $78A6 
789F: 17 01 DB       LBSR $7A7D 
78A2: 17 01 87       LBSR $7A2C 
78A5: 39             RTS 
78A6: 81 51          CMPA #$51 	; Q
78A8: 26 04          BNE $78AE 
78AA: 17 01 2D       LBSR $79DA 
78AD: 39             RTS 
78AE: 0C 44          INC <$44 
78B0: 39             RTS 

	;; stop all aounds
sub4:
	86 07          LDA #$07 
78B3: C6 FF          LDB #$FF 
78B5: 17 01 DB       LBSR sub5 
78B8: CC FF FF       LDD #$FFFF 
78BB: DD 14          STD <$14 
78BD: DD 16          STD <$16 
78BF: CC 08 00       LDD #$0800 
78C2: 17 01 CE       LBSR sub5 
78C5: 4C             INCA 
78C6: 17 01 CA       LBSR sub5 
78C9: 4C             INCA 
78CA: 17 01 C6       LBSR sub5 
78CD: 39             RTS 

	;; subroutine
sub16:
	17 FE B5       LBSR sub11 
78D1: 54             LSRB 
78D2: D7 04          STB <$04 
78D4: 86 7F          LDA #$7F 
78D6: 5D             TSTB 
78D7: 27 0B          BEQ $78E4 
78D9: 5F             CLRB 
78DA: 5C             INCB 
78DB: 90 04          SUBA <$04 
78DD: 2E FB          BGT $78DA 
78DF: D7 3A          STB <$3A 
78E1: D7 2C          STB <$2C 
78E3: 39             RTS 
78E4: C6 FF          LDB #$FF 
78E6: 20 F7          BRA $78DF 

	;; subroutine
sub17:
	17 FE 9B       LBSR sub11 
78EB: D7 02          STB <$02 
78ED: 17 00 C1       LBSR $79B1 
78F0: CC 07 FF       LDD #$07FF 
78F3: 17 01 9D       LBSR sub5 
78F6: 39             RTS 

	;; subroutine
sub18:
	17 FE 7A       LBSR $7774 
78FA: 17 FE 89       LBSR sub11 
78FD: 96 2E          LDA <$2E 
78FF: CE 7E 08       LDU #$7E08 
7902: E7 C6          STB A,U 
7904: C1 0F          CMPB #$0F 
7906: 23 0C          BLS $7914 
7908: C0 10          SUBB #$10 
790A: 17 01 77       LBSR $7A84 
790D: 86 0D          LDA #$0D 
790F: 17 01 AA       LBSR $7ABC 
7912: C6 10          LDB #$10 
7914: 17 01 6D       LBSR $7A84 
7917: 8B 08          ADDA #$08 
7919: 17 01 A0       LBSR $7ABC 
791C: 80 08          SUBA #$08 
791E: C1 00          CMPB #$00 
7920: 27 01          BEQ $7923 
7922: 39             RTS 
7923: 4D             TSTA 
7924: 26 04          BNE $792A 
7926: C6 01          LDB #$01 
7928: 20 0A          BRA $7934 
792A: 81 01          CMPA #$01 
792C: 26 04          BNE $7932 
792E: C6 02          LDB #$02 
7930: 20 02          BRA $7934 
7932: C6 04          LDB #$04 
7934: 96 27          LDA <$27 
7936: CE 7E 14       LDU #$7E14 
7939: EA C6          ORB A,U 
793B: E7 C6          STB A,U 
793D: 86 07          LDA #$07 
793F: 17 01 7A       LBSR $7ABC 
7942: 39             RTS 

	;; subroutine
sub19:
	17 FE 2E       LBSR $7774 
7946: 17 FE 3D       LBSR sub11 
7949: 17 01 38       LBSR $7A84 
794C: 86 06          LDA #$06 
794E: 17 01 6B       LBSR $7ABC 
7951: 39             RTS 

	;; subroutine
sub20:
	17 FE 1F       LBSR $7774 
7955: 17 FE 01       LBSR sub13 
7958: A6 80          LDA ,X+ 
795A: 81 59          CMPA #$59 
795C: 27 29          BEQ $7987 
795E: 81 4E          CMPA #$4E 
7960: 27 25          BEQ $7987 
7962: 86 01          LDA #$01 
7964: 97 44          STA <$44 
7966: 39             RTS 
7967: 17 01 1A       LBSR $7A84 
796A: 81 00          CMPA #$00 
796C: 26 04          BNE $7972 
796E: C6 08          LDB #$08 
7970: 20 0A          BRA $797C 
7972: 81 01          CMPA #$01 
7974: 26 04          BNE $797A 
7976: C6 10          LDB #$10 
7978: 20 02          BRA $797C 
797A: C6 20          LDB #$20 
797C: 96 27          LDA <$27 
797E: CE 7E 14       LDU #$7E14 
7981: EA C6          ORB A,U 
7983: E7 C6          STB A,U 
7985: 20 1E          BRA $79A5 
7987: 17 00 FA       LBSR $7A84 
798A: 81 00          CMPA #$00 
798C: 26 04          BNE $7992 
798E: C6 F7          LDB #$F7 
7990: 20 0A          BRA $799C 
7992: 81 01          CMPA #$01 
7994: 26 04          BNE $799A 
7996: C6 EF          LDB #$EF 
7998: 20 02          BRA $799C 
799A: C6 DF          LDB #$DF 
799C: 96 27          LDA <$27 
799E: CE 7E 14       LDU #$7E14 
79A1: E4 C6          ANDB A,U 
79A3: E7 C6          STB A,U 
79A5: 86 07          LDA #$07 
79A7: 17 01 12       LBSR $7ABC 
79AA: 39             RTS 

	;; subroutine
sub21:
	0F 01          CLR <$01 
79AD: 39             RTS 
79AE: 17 FD D5       LBSR sub11 
79B1: C1 40          CMPB #$40 
79B3: 23 02          BLS $79B7 
79B5: C6 40          LDB #$40 
79B7: D7 04          STB <$04 
79B9: 4F             CLRA 
79BA: C6 40          LDB #$40 
79BC: 4C             INCA 
79BD: D0 04          SUBB <$04 
79BF: 2E FB          BGT $79BC 
79C1: 97 3B          STA <$3B 
79C3: 97 3D          STA <$3D 
79C5: 39             RTS 
79C6: 17 FD BD       LBSR sub11 
79C9: 5A             DECB 
79CA: C1 07          CMPB #$07 
79CC: 23 03          BLS $79D1 
79CE: 0C 44          INC <$44 
79D0: 39             RTS 
79D1: 58             ASLB 
79D2: CE 7E 7F       LDU #$7E7F 
79D5: EE C5          LDU B,U 
79D7: DF 20          STU <$20 
79D9: 39             RTS 
79DA: 17 FD 97       LBSR $7774 
79DD: 17 00 A4       LBSR $7A84 
79E0: 17 FF 40       LBSR $7923 
79E3: 39             RTS 

	;; play note
sub15:
	0F 05          CLR <$05 
79E6: 97 04          STA <$04 
79E8: 17 FD 6E       LBSR sub13 
79EB: A6 84          LDA ,X 
79ED: 81 30          CMPA #$30 	; 0
79EF: 2C 09          BGE $79FA 
79F1: 97 05          STA <$05 
79F3: 30 01          LEAX 1,X 
79F5: 17 FD 61       LBSR sub13 
79F8: A6 84          LDA ,X 
79FA: 81 39          CMPA #$39 	; 9
79FC: 23 04          BLS $7A02 
79FE: 0F 2E          CLR <$2E 
7A00: 20 03          BRA $7A05 
7A02: 17 FD 6F       LBSR $7774 
7A05: 96 04          LDA <$04 
7A07: 80 41          SUBA #$41 
7A09: CE 7E 18       LDU #$7E18 
7A0C: E6 C6          LDB A,U 
7A0E: 96 05          LDA <$05 
7A10: 27 10          BEQ $7A22 
7A12: 81 23          CMPA #$23 
7A14: 27 04          BEQ $7A1A 
7A16: 81 2B          CMPA #$2B 
7A18: 26 03          BNE $7A1D 
7A1A: 5C             INCB 
7A1B: 20 05          BRA $7A22 
7A1D: 81 2D          CMPA #$2D 
7A1F: 26 01          BNE $7A22 
7A21: 5A             DECB 
7A22: DE 20          LDU <$20 
7A24: 58             ASLB 
7A25: EC C5          LDD B,U 
7A27: DD 30          STD <$30 
7A29: 8D 01          BSR $7A2C 
7A2B: 39             RTS 
7A2C: 17 00 55       LBSR $7A84 
7A2F: 48             ASLA 
7A30: 17 00 89       LBSR $7ABC 
7A33: 4C             INCA 
7A34: D6 30          LDB <$30 
7A36: 17 00 83       LBSR $7ABC 
7A39: 4A             DECA 
7A3A: 26 04          BNE $7A40 
7A3C: C6 FE          LDB #$FE 
7A3E: 20 0A          BRA $7A4A 
7A40: 81 02          CMPA #$02 
7A42: 26 04          BNE $7A48 
7A44: C6 FD          LDB #$FD 
7A46: 20 02          BRA $7A4A 
7A48: C6 FB          LDB #$FB 
7A4A: 33 8D 03 C6    LEAU $03C6,PC 
7A4E: 96 27          LDA <$27 
7A50: E4 C6          ANDB A,U 
7A52: E7 C6          STB A,U 
7A54: 86 07          LDA #$07 
7A56: 17 00 63       LBSR $7ABC 
7A59: CE 7E 08       LDU #$7E08 
7A5C: 96 2E          LDA <$2E 
7A5E: E6 C6          LDB A,U 
7A60: 17 FE A1       LBSR $7904 
7A63: 39             RTS 
7A64: 0C 44          INC <$44 
7A66: 39             RTS 
7A67: 17 FD 0A       LBSR $7774 
7A6A: 17 FD 19       LBSR sub11 
7A6D: 17 00 14       LBSR $7A84 
7A70: 86 0B          LDA #$0B 
7A72: 17 00 47       LBSR $7ABC 
7A75: 86 0C          LDA #$0C 
7A77: D6 30          LDB <$30 
7A79: 17 00 40       LBSR $7ABC 
7A7C: 39             RTS 
7A7D: 17 FC F4       LBSR $7774 
7A80: 17 FD 03       LBSR sub11 
7A83: 39             RTS 
7A84: 0F 27          CLR <$27 
7A86: 96 2E          LDA <$2E 
7A88: 81 03          CMPA #$03 
7A8A: 25 06          BCS $7A92 
7A8C: 0C 27          INC <$27 
7A8E: 80 03          SUBA #$03 
7A90: 20 F6          BRA $7A88 
7A92: 39             RTS 

	;; subroutine
sub5:
	8D 25          BSR sub7 
7A95: 8D 19          BSR sub8 
7A97: 8D 0D          BSR sub9 
7A99: 8D 01          BSR sub10 
7A9B: 39             RTS 

	;; subroutine
sub10:
	34 02          PSHS A 
7A9E: 86 03          LDA #$03 
7AA0: 97 27          STA <$27 
7AA2: 35 02          PULS A 
7AA4: 20 16          BRA $7ABC 

	;; subroutine
sub9:
	34 02          PSHS A 
7AA8: 86 02          LDA #$02 
7AAA: 97 27          STA <$27 
7AAC: 35 02          PULS A 
7AAE: 20 0C          BRA $7ABC 

	;; subroutine
sub8:
	34 02          PSHS A 
7AB2: 86 01          LDA #$01 
7AB4: 97 27          STA <$27 
7AB6: 35 02          PULS A 
7AB8: 20 02          BRA $7ABC 

	;; subroutine
sub7:
	0F 27          CLR <$27 ; PSG #0

	;; write B to PSG register A, PSG # is in $7e27
7ABC: 34 06          PSHS B,A 
7ABE: 17 00 19       LBSR $7ADA 
7AC1: F7 FF 60       STB $FF60 ; S12 PIA a data 
7AC4: 86 02          LDA #$02 
7AC6: 8D 08          BSR $7AD0 
7AC8: B7 FF 62       STA $FF62 ; S12 PIA b data 
7ACB: 7F FF 62       CLR $FF62 ; S12 PIA b data 
7ACE: 35 86          PULS PC,B,A

	;; decode PSG number
7AD0: D6 27          LDB <$27 
7AD2: 27 05          BEQ $7AD9 
7AD4: 48             ASLA 
7AD5: 48             ASLA 
7AD6: 5A             DECB 
7AD7: 26 FB          BNE $7AD4 
7AD9: 39             RTS

	;; select PSG register A
7ADA: B7 FF 60       STA $FF60 ; S12 PIA a data 
7ADD: 86 03          LDA #$03 
7ADF: 34 04          PSHS B 
7AE1: 8D ED          BSR $7AD0 
7AE3: 35 04          PULS B 
7AE5: B7 FF 62       STA $FF62 ; S12 PIA b data 
7AE8: 4F             CLRA 
7AE9: B7 FF 62       STA $FF62 ; S12 PIA b data 
7AEC: 39             RTS 

	;; subroutine
sub12:
	34 7F          PSHS U,Y,X,DP,B,A,CC 
7AEF: 1A 10          ORCC #$10 
7AF1: 86 0D          LDA #$0D 
7AF3: 17 00 23       LBSR $7B19 
7AF6: 33 8D 03 6D    LEAU $036D,PC 
7AFA: A6 C0          LDA ,U+ 
7AFC: 27 05          BEQ $7B03 
7AFE: 17 00 18       LBSR $7B19 
7B01: 20 F7          BRA $7AFA 
7B03: DC 32          LDD <$32 
7B05: 83 7B 2E       SUBD #$7B2E 
7B08: 34 06          PSHS B,A 
7B0A: 5F             CLRB 
7B0B: 1E 9B          EXG B,DP 
7B0D: 35 06          PULS B,A 
7B0F: BD BD CC       JSR $BDCC 
7B12: 86 0D          LDA #$0D 
7B14: 17 00 02       LBSR $7B19 
7B17: 35 FF          PULS PC,U,Y,X,DP,B,A,CC 
7B19: 34 0C          PSHS DP,B 
7B1B: 5F             CLRB 
7B1C: 1E 9B          EXG B,DP 
7B1E: AD 9F A0 02    JSR [$A002] 
7B22: 35 8C          PULS PC,DP,B 
7B24: 34 0C          PSHS DP,B 
7B26: 5F             CLRB 
7B27: 1E 9B          EXG B,DP 
7B29: AD 9F A0 00    JSR [$A000] 
7B2D: 35 8C          PULS PC,DP,B 
Done
