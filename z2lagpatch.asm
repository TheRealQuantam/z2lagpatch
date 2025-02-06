; For use with snarfblasm

; This patch optimizes the E001 function which reads a byte from the compressed overworld map. Evidently at one point the map was loaded directly from ROM and later changed to copy the map to SRAM then read from there. However the bank switches before and after reading each byte were left in, drastically increasing CPU usage. Removing these saves about 7% of the CPU at peak.

.patch $1e011
.base $e001

	jmp + ; Was jsr RestoreBank
	
+:

.patch $1e025
.base $e015

	rts ; Was pha; jsr SwitchBank0; pla; rts

; This patch optimizes the F27D function which creates a bit mask of which sprites of a metasprite are offscreen. It's called 15-20 times per frame and can take over 15% of the CPU at peak. The section that's optimized has the following pseudocode:

; for (Y = 3; Y >= 0; Y--)
; 	*(word *)$e = 3b[X]:4d[X] + f274[Y] // 0, 8, $10, $18
;	if (*(word *)$e - *72a:*72c) >> 8
;		c8[*0] |= f270[Y] // 8, 4, 2, 1

; This patch optimizes this by taking advantage of the fact that once the relationship of the object to the screen borders is known the bit mask can be generated all at once. This reduces CPU usage by about 9% under peak load.

.patch $1f28f ; $35 bytes available
.base $f27f
	
	; $a bytes
	; Calculate delta = x + $18 - screen_x
	ldy $3b, x
	lda $4d, x
	clc
	adc #$18
	bcc +

	iny

+: ; $14 bytes
	sec
	sbc $72c
	sta $e
	tya
	sbc $72a
	
	bcc NoOverlap ; < 0
	
	lsr a
	bne NoOverlap ; >= $200
	
	lda $e

	jmp Part2
	
OverlapMaskLo:
	.byte $e, $c, $8, 0
	
OverlapMaskHi:
	.byte 1, 3, 7
	
NoOverlap: ; 3 bytes
	lda #$f
	
Part3: ; 7 bytes
	ldy $0
	sta $00c8, y
	
	bpl $f2b4
	
	
.patch $1ff5c ; $24 bytes available
.base $ff4c

Part2: ; 2 bytes
	bcs AtLeast100
	
Below100: ; 6 bytes
	; OverlapMaskLo[min(delta, $18) / 8]
	cmp #$18
	bcc +
	
	lda #$18
	
+: ; 9 bytes
	lsr a
	lsr a
	lsr a
	tay
	lda OverlapMaskLo, y
	
	bpl Done
	
AtLeast100: ; $d bytes
	cmp #$18
	bcs NoOverlap2
	
	; OverlapMaskHi[(delta - 0x100) / 8]
	lsr a
	lsr a
	lsr a
	tay
	lda OverlapMaskHi, y
	
	bpl Done
	
NoOverlap2:
	lda #$f
	
Done:
	jmp Part3