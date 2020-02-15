INCLUDE "hardware.inc"

SECTION "Header", rom0[$100]

EntryPoint:
    di
    jp Start 

REPT $150 - $104
    db 0
ENDR

SECTION "Game Code", rom0

Start:
.waitVBlank
    ld a, [rLY]
    cp a, 144
    jr c, .waitVBlank

    xor a; ld a, 0
    ld [rLCDC], a

    ld hl, $9000; copy font inside VRAM (starts at $8000, apparently, but we copy at the end)
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles

.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, .copyFont

    ld hl, $9901; print sentence on top screen
    ld de, HelloWorldStr; load destination address

.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a;check for end char
    jr nz, .copyString

    ld a, %11100100
    ld [rBGP], a

    xor a; ld a, 0
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a
    ld a, %10000001
    ld [rLCDC], a

TileLoop:


.lockup; infinite loop
    jr .lockup

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"

FontTilesEnd:

SECTION "Hello World string", ROM0

HelloWorldStr:
    db "Hello Retro World", 0

SECTION "Tiles", ROM0

Tile:; Start of tile array.
    DB $FF,$FF,$81,$81,$A5,$81,$81,$80
    DB $81,$84,$81,$18,$81,$00,$7E,$00
TileEnd: