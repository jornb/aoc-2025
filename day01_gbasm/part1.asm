INCLUDE "hardware.inc"
INCLUDE "charmap.inc"

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a


    ld bc, 17  ; example value
    ld de, 56  ; example value
    call mul_bc_de_to_hl ; call multiplication routine
    ; Result is now in HL

    ld hl, Input
    call ascii_decode_u16_input
    ; Result is now in DE

	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
CopyTilemap:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTilemap

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

Done:
	jp Done




; HL = BC * DE
; Modifies AF, BC, DE, HL
mul_bc_de_to_hl:
    ld hl, 0            ; clear HL (accumulator for the 16-bit product)
    ld a, 16            ; loop counter: process 16 bits of DE
MulLoop:
    bit 0, e            ; test LSB of E
    jr z, NoAdd         ; if LSB=0 skip addition
    add hl, bc          ; HL += BC when current bit of DE is 1
NoAdd:
    sla c               ; shift C left, MSB->carry (lower byte of BC << 1)
    rl b                ; rotate B left through carry (completes BC <<= 1)
    srl e               ; shift E right, LSB->carry (lower byte of DE >>= 1)
    rr d                ; rotate D right through carry (completes DE >>= 1)
    dec a               ; decrement bit counter
    jr nz, MulLoop      ; repeat for all 16 bits
    ret                 ; return with product in HL

; A = A * B
; Modifies A, BC, D
mul_a_b_to_a:
    ld c, a            ; copy multiplicand to C
    ld a, 0            ; Initialize accumulator to 0
    ld d, 8            ; initialize 8-bit loop counter
mul_a_b_to_a__MulLoop8:
    bit 0, b           ; test LSB of B
    jr z, mul_a_b_to_a__NoAdd8       ; if LSB=0 skip addition
    add a, c           ; A += C when current bit of B is 1
mul_a_b_to_a__NoAdd8:
    sla c              ; shift C left (C <<= 1)
    srl b              ; shift B right (B >>= 1)
    dec d              ; use D as loop counter
    jr nz, mul_a_b_to_a__MulLoop8    ; repeat for all 8 bits
    ret                ; return with product in A

; A += A * B
; Modifies A, BC, D
addmul_a_b_to_a:
    ld c, a            ; copy multiplicand to C
    ld d, 8            ; initialize 8-bit loop counter
addmul_a_b_to_a__MulLoop8:
    bit 0, b           ; test LSB of B
    jr z, addmul_a_b_to_a__NoAdd8       ; if LSB=0 skip addition
    add a, c           ; A += C when current bit of B is 1
addmul_a_b_to_a__NoAdd8:
    sla c              ; shift C left (C <<= 1)
    srl b              ; shift B right (B >>= 1)
    dec d              ; use D as loop counter
    jr nz, addmul_a_b_to_a__MulLoop8    ; repeat for all 8 bits
    ret                ; return with product in A


; Decodes an ASCII string containing a number, e.g. "1234", ended by a newline 0x0A.
; Input: HL = pointer to first character of ASCII string
; The result is stored in DE as a 16-bit unsigned integer.
; Modifies A, B, C, D, E, HL (HL pointer is preserved)
ascii_decode_u16_input:
    ld d, 0        ; Clear result
    ld e, 0
ascii_decode_u16_input__DecodeLoop:
    ld a, [hl+]     ; Load next character

    cp $0A         ; Check for newline (end of input)
    jr z, ascii_decode_u16_input__DecodeDone

    ; Scope save
    push hl

    ; A = digit, [0, 9]
    sub $30

    ; Multiply DE by 10 using shifts: DE*10 = DE*8 + DE*2
    ld b, d ; BC = DE
    ld c, e ;

    ; BC = DE * 8  (shift left 3)
    sla c
    rl b
    sla c
    rl b
    sla c
    rl b

    ; DE = DE * 2  (shift left 1)
    sla e
    rl d

    ; HL = DE*2 + DE*8 = DE*10
    ld l, e
    ld h, d
    add hl, bc

    ; move product back into DE and restore HL pointer
    ld d, h
    ld e, l

    ; Scope restore
    pop hl

    ; DE += digit (A)
    add a, e
    ld e, a
    jr nc, ascii_decode_u16_input__NoCarry
    inc d
ascii_decode_u16_input__NoCarry:
    jp ascii_decode_u16_input__DecodeLoop

ascii_decode_u16_input__DecodeDone:
    ret




SECTION "Tile data", ROM0

Tiles:
	incbin "hello.tiledata.bin"
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
    db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $00, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db "ABCDEFGHIJKLMNOPQRST", 0,0,0,0,0,0,0,0,0,0,0,0
    db "UVWXYZ              ", 0,0,0,0,0,0,0,0,0,0,0,0
    db "abcdefghijklmnopqrst", 0,0,0,0,0,0,0,0,0,0,0,0
    db "uvwxyz              ", 0,0,0,0,0,0,0,0,0,0,0,0
    db "0123456789+-*/()[]\{\}", 0,0,0,0,0,0,0,0,0,0,0,0
	ds 32*32 - 7*32, 0; Fill the remaining 32x32 tilemap
TilemapEnd:

Input:
    incbin "input.bin"
InputEnd:
