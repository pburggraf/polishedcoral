LusterMallPokeCenter_MapScriptHeader:
	db 0 ; scene scripts

	db 0 ; callbacks

	db 2 ; warp events
	warp_def 7, 4, 5, LUSTER_MALL
	warp_def 7, 5, 6, LUSTER_MALL

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	pc_nurse_event  4, 1
	pc_chansey_event  5, 1
