TeachDratiniExtremeSpeed: ; 0x8b170
	call GetLastPartyMonMoveset
	ld hl, .Moveset
	jp GiveSpecialMoveset

.Moveset:
	db EXTREMESPEED
	db THUNDER_WAVE
	db AQUA_JET
	db DRAGON_RAGE
	db 0

TeachMagikarpDragonRage:
	call GetLastPartyMonMoveset
	ld hl, .Moveset
	jp GiveSpecialMoveset

.Moveset:
	db TRANSFORM_SKETCH_MIMIC_SPLASH
	db DRAGON_RAGE
	db 0

TeachDoduoExtremeSpeed: ; 0x8b170
	call GetLastPartyMonMoveset
	ld hl, .Moveset
	jp GiveSpecialMoveset

.Moveset:
	db EXTREMESPEED
	db RAGE
	db GROWL
	db PECK
	db 0
	
GetLastPartyMon: ; 0x8b1ce
	ld bc, wPartyCount
	ld a, [bc]
	ld hl, MON_SPECIES

	ld de, wPartyMon1
	add hl, de
	and a
	jr z, .EmptyParty
	dec a
	ret z
	ld de, PARTYMON_STRUCT_LENGTH
.loop
	add hl, de
	dec a
	jr nz, .loop
	ret

.EmptyParty:
	scf
	ret
; 8b1e1

GetLastPartyMonMoveset:
	call GetLastPartyMon
	ld de, MON_MOVES
	add hl, de
	push hl
	pop de
	ret

GiveSpecialMoveset:
.GiveMoves:
	ld a, [hl]
	and a ; is the move 00?
	ret z ; if so, we're done here

	push hl
	push de
	ld [de], a ; give the Pokémon the new move

	; get the PP of the new move
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	rst AddNTimes
	ld a, BANK(Moves)
	call GetFarByte

	; get the address of the move's PP and update the PP
	ld hl, MON_PP - MON_MOVES
	add hl, de
	ld [hl], a

	pop de
	pop hl
	inc de
	inc hl
	jr .GiveMoves

SetLastPartyMonBall:
	call GetLastPartyMon
	ld de, MON_CAUGHTBALL
	add hl, de
	ld a, [wScriptVar]
	ld c, a
	ld a, [hl]
	and $ff - CAUGHTBALL_MASK
	or c
	ld [hl], a
	ret
