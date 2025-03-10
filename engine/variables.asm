_GetVarAction:: ; 80648 (20:4648)
	ld a, c
	cp NUM_VARS
	jr c, .valid
	xor a
.valid
	ld c, a
	ld b, 0
	ld hl, .VarActionTable
	add hl, bc
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, [hl]
	ld a, b
	and RETVAR_EXECUTE
	jp nz, _de_
	ld a, b
	and RETVAR_ADDR_DE
	ret nz
	ld a, [de]
.loadstringbuffer2 ; 8066c (20:466c)
	ld de, wStringBuffer2
	ld [de], a
	ret
; 80671 (20:4671)

.VarActionTable: ; 80671
; $00: copy [de] to wStringBuffer2
; $40: return address in de
; $80: call function
	dwb wStringBuffer2,                 RETVAR_STRBUF2
	dwb wPartyCount,                    RETVAR_STRBUF2
	dwb .BattleResult,                  RETVAR_EXECUTE
	dwb wBattleType,                    RETVAR_ADDR_DE
	dwb wTimeOfDay,                     RETVAR_STRBUF2
	dwb .CountCaughtMons,               RETVAR_EXECUTE
	dwb .CountSeenMons,                 RETVAR_EXECUTE
	dwb .CountBadges,                   RETVAR_EXECUTE
	dwb wPlayerState,                   RETVAR_ADDR_DE
	dwb .wPlayerFacing,                 RETVAR_EXECUTE
	dwb hHours,                         RETVAR_STRBUF2
	dwb .DayOfWeek,                     RETVAR_EXECUTE
	dwb wMapGroup,                      RETVAR_STRBUF2
	dwb wMapNumber,                     RETVAR_STRBUF2
	dwb .UnownCaught,                   RETVAR_EXECUTE
	dwb wPermission,                    RETVAR_STRBUF2
	dwb .BoxFreeSpace,                  RETVAR_EXECUTE
	dwb wBugContestMinsRemaining,       RETVAR_STRBUF2
	dwb wXCoord,                        RETVAR_STRBUF2
	dwb wYCoord,                        RETVAR_STRBUF2
	dwb wSpecialPhoneCallID,            RETVAR_STRBUF2
	dwb wNrOfBeatenBattleTowerTrainers, RETVAR_STRBUF2
	dwb wKurtApricornQuantity,          RETVAR_STRBUF2
	dwb wCurrentCaller,                 RETVAR_ADDR_DE
	dwb wBlueCardBalance,               RETVAR_ADDR_DE
	dwb wBuenasPassword,                RETVAR_ADDR_DE
	dwb wKenjiBreakTimer,               RETVAR_STRBUF2
	dwb wBattlePoints,                  RETVAR_ADDR_DE
	dwb .CountPokemonJournals,          RETVAR_EXECUTE
	dwb .CountTrainerStars,             RETVAR_EXECUTE
	dwb wPlayerGender,                  RETVAR_ADDR_DE
	dwb wPlayerPalette,					RETVAR_ADDR_DE
	dwb wScriptVar,						RETVAR_ADDR_DE
	dwb wMonJustCaught,					RETVAR_ADDR_DE
	dwb wRanchRaceSeconds,   		    RETVAR_STRBUF2
	dwb NULL,                           RETVAR_STRBUF2
; 806c5

.CountCaughtMons: ; 806c5
; Caught mons.
	ld hl, wPokedexCaught
	ld b, wEndPokedexCaught - wPokedexCaught
	call CountSetBits
	ld a, [wd265]
	jp .loadstringbuffer2
; 806d3

.CountSeenMons: ; 806d3
; Seen mons.
	ld hl, wPokedexSeen
	ld b, wEndPokedexSeen - wPokedexSeen
	call CountSetBits
	ld a, [wd265]
	jp .loadstringbuffer2
; 806e1

.CountBadges: ; 806e1
; Number of owned badges.
	ld hl, wBadges
	ld b, wBadgesEnd - wBadges
	call CountSetBits
	ld a, [wd265]
	jp .loadstringbuffer2
; 806ef

.wPlayerFacing: ; 806ef
; The direction the player is facing.
	ld a, [wPlayerDirection]
	and $c
	rrca
	rrca
	jp .loadstringbuffer2
; 806f9

.DayOfWeek: ; 806f9
; The day of the week.
	call GetWeekday
	jp .loadstringbuffer2
; 806ff

.UnownCaught: ; 806ff
; Number of unique Unown caught.
	call .count
	ld a, b
	jp .loadstringbuffer2

.count
	ld hl, wUnownDex
	ld b, 0
.loop
	ld a, [hli]
	and a
	ret z
	inc b
	ld a, b
	cp NUM_UNOWN
	jr c, .loop
	ret
; 80715

.BoxFreeSpace: ; 80715
; Remaining slots in the current box.
	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld hl, sBoxCount
	ld a, MONS_PER_BOX
	sub [hl]
	ld b, a
	call CloseSRAM
	ld a, b
	jp .loadstringbuffer2
; 80728

.BattleResult: ; 80728
	ld a, [wBattleResult]
	and $3f
	jp .loadstringbuffer2
; 80730

.CountPokemonJournals:
;	ld hl, wPokemonJournals
;	ld b, wPokemonJournalsEnd - wPokemonJournals
;	call CountSetBits
;	ld a, [wd265]
	jp .loadstringbuffer2

.CountTrainerStars:
	ld b, 0
;	; star for beating the Elite Four
;	eventflagcheck EVENT_BEAT_ELITE_FOUR
;	jr z, .nostar1
;	inc b
;.nostar1
;	; star for beating Leaf
;	eventflagcheck EVENT_BEAT_LEAF
;	jr z, .nostar2
;	inc b
;.nostar2
;	; star for completing the Pokédex
;	push bc
;	ld hl, wPokedexCaught
;	ld b, wEndPokedexCaught - wPokedexCaught
;	call CountSetBits
;	pop bc
;	cp NUM_POKEMON
;	jr c, .nostar3
;	inc b
;.nostar3
;	; star for reading all Pokémon Journals
;	push bc
;	ld hl, wPokemonJournals
;	ld b, wPokemonJournalsEnd - wPokemonJournals
;	call CountSetBits
;	pop bc
;	cp NUM_POKEMON_JOURNALS
;	jr c, .nostar4
;	inc b
;.nostar4
	ld a, b
	jp .loadstringbuffer2
