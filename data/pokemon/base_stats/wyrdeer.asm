	db  73,  95,  62,  85,  85,  65
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, PSYCHIC ; type
	db 45 ; catch rate
	db 165 ; base exp
	db NO_ITEM ; item 1
	db NO_ITEM ; item 2
	dn FEMALE_50, 20 ; gender, step cycles to hatch
	dn 5, 5 ; frontpic dimensions
	db INTIMIDATE ; ability 1
	db FRISK ; ability 2
	db SAP_SIPPER ; hidden ability
	db SLOW ; growth rate
	dn FIELD, FIELD ; egg groups

	; ev_yield
	ev_yield   0,   1,   0,   0,   0,   0
	;         hp, atk, def, spd, sat, sdf

	; tmhm
	tmhm FAKE_OUT, RAIN_DANCE, CURSE, SUNNY_DAY, WORK_UP_GROWTH, ROCK_CLIMB
	; end
