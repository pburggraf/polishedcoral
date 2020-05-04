map_attributes: MACRO
; label, map, border block, connections
CURRENT_MAP_WIDTH = \2_WIDTH
CURRENT_MAP_HEIGHT = \2_HEIGHT
\1_SecondMapHeader::
	db \3
	db \2_HEIGHT, \2_WIDTH
	db BANK(\1_BlockData)
	dw \1_BlockData
	db BANK(\1_MapScriptHeader)
	dw \1_MapScriptHeader
	db \4
ENDM

; Connections go in order: north, south, west, east
connection: MACRO
;\1: direction
;\2: map name
;\3: map id
;\4: offset of the target map relative to the current map
;    (x offset for east/west, y offset for north/south)

; Calculate tile offsets for source (current) and target maps
_src = 0
_tgt = (\4) + 3
if _tgt < 0
_src = -_tgt
_tgt = 0
endc

if "\1" == "north"
_blk = \3_WIDTH * (\3_HEIGHT + -3) + _src
_map = _tgt
_win = (\3_WIDTH + 6) * \3_HEIGHT + 1
_y = \3_HEIGHT * 2 - 1
_x = (\4) * -2
_len = CURRENT_MAP_WIDTH + 3 - (\4)
if _len > \3_WIDTH
_len = \3_WIDTH
endc

elif "\1" == "south"
_blk = _src
_map = (CURRENT_MAP_WIDTH + 6) * (CURRENT_MAP_HEIGHT + 3) + _tgt
_win = \3_WIDTH + 7
_y = 0
_x = (\4) * -2
_len = CURRENT_MAP_WIDTH + 3 - (\4)
if _len > \3_WIDTH
_len = \3_WIDTH
endc

elif "\1" == "west"
_blk = (\3_WIDTH * _src) + \3_WIDTH + -3
_map = (CURRENT_MAP_WIDTH + 6) * _tgt
_win = (\3_WIDTH + 6) * 2 + -6
_y = (\4) * -2
_x = \3_WIDTH * 2 - 1
_len = CURRENT_MAP_HEIGHT + 3 - (\4)
if _len > \3_HEIGHT
_len = \3_HEIGHT
endc

elif "\1" == "east"
_blk = (\3_WIDTH * _src)
_map = (CURRENT_MAP_WIDTH + 6) * _tgt + CURRENT_MAP_WIDTH + 3
_win = \3_WIDTH + 7
_y = (\4) * -2
_x = 0
_len = CURRENT_MAP_HEIGHT + 3 - (\4)
if _len > \3_HEIGHT
_len = \3_HEIGHT
endc

else
fail "Invalid direction for 'connection'."
endc

	map_id \3
	dw wDecompressScratch + _blk
	dw wOverworldMap + _map
	db _len - _src
	db \3_WIDTH
	db _y, _x
	dw wOverworldMap + _win
ENDM


	map_attributes SunsetBay, SUNSET_BAY, $71, EAST
	connection east, SunsetCape, SUNSET_CAPE, 2
	
	map_attributes SunsetCape, SUNSET_CAPE, 53, WEST
	connection west, SunsetBay, SUNSET_BAY, -2

	map_attributes Route1, ROUTE_1, $71, NORTH
	connection north, DaybreakVillage, DAYBREAK_VILLAGE, 5
	
	map_attributes DaybreakVillage, DAYBREAK_VILLAGE, $71, NORTH | SOUTH
	connection north, Route2, ROUTE_2, -6
	connection south, Route1, ROUTE_1, -5
	
	map_attributes Route2, ROUTE_2, 5, NORTH | SOUTH
	connection north, GlintCity, GLINT_CITY, -2
	connection south, DaybreakVillage, DAYBREAK_VILLAGE, 6

	map_attributes GlintCity, GLINT_CITY, $5, NORTH | SOUTH | EAST
	connection north, GlintGroveEntrance, GLINT_GROVE_ENTRANCE, 1
	connection south, Route2, ROUTE_2, 2
	connection east, Route3, ROUTE_3, 0
	
	map_attributes GlintGroveEntrance, GLINT_GROVE_ENTRANCE, 5, SOUTH
	connection south, GlintCity, GLINT_CITY, -1
	
	map_attributes Route3, ROUTE_3, 5, WEST ;SOUTH | WEST
;	connection south, Route12North, ROUTE_12_NORTH, 1
	connection west, GlintCity, GLINT_CITY, 0

	map_attributes Route3Starglow, ROUTE_3_STARGLOW, $5, SOUTH
	connection south, StarglowValley, STARGLOW_VALLEY, -3
	
	map_attributes StarglowValley, STARGLOW_VALLEY, 5, NORTH | EAST
	connection north, Route3Starglow, ROUTE_3_STARGLOW, 3
;	connection west, ROUTE_12, Route12, 4
	connection east, Route4, ROUTE_4, 6
	
	map_attributes Route4, ROUTE_4, 5, NORTH | SOUTH | WEST
	connection north, HuntersThicket, HUNTERS_THICKET, 2
	connection south, Route5, ROUTE_5, -3
	connection west, StarglowValley, STARGLOW_VALLEY, -6
	
	map_attributes HuntersThicket, HUNTERS_THICKET, $5, SOUTH
	connection south, Route4, ROUTE_4, -2
	
	map_attributes Route5, ROUTE_5, 7, NORTH
	connection north, Route4, ROUTE_4, 3
	
	map_attributes Route6, ROUTE_6, 7, NORTH ;| SOUTH
	connection north, Route7, ROUTE_7, -1
;	connection south, Route29, ROUTE_29, -11
	
	map_attributes Route7, ROUTE_7, 7, SOUTH | WEST
	connection south, Route6, ROUTE_6, 1
	connection west, LakeOnwa, LAKE_ONWA, -11
	
	map_attributes Route9, ROUTE_9, 5, NORTH | WEST
	connection north, FlickerStation, FLICKER_STATION, -13
	connection west, EventideVillage, EVENTIDE_VILLAGE, 5
	
	map_attributes Route10, ROUTE_10, 5, NORTH | EAST
	connection north, TwinkleTown, TWINKLE_TOWN, 4
	connection east, Route10East, ROUTE_10_EAST, -1
	
	map_attributes Route10East, ROUTE_10_EAST, 5, WEST
	connection west, Route10, ROUTE_10, 1

	map_attributes EventideVillage, EVENTIDE_VILLAGE, $d9, EAST
	connection east, Route9, ROUTE_9, -5

	map_attributes FlickerStation, FLICKER_STATION, 5, NORTH | SOUTH
	connection north, FlickerPassOutside, FLICKER_PASS_OUTSIDE, 21
	connection south, Route9, ROUTE_9, 13
	
	map_attributes FlickerPassOutside, FLICKER_PASS_OUTSIDE, 113, SOUTH
	connection south, FlickerStation, FLICKER_STATION, -21
	
	map_attributes LakeOnwa, LAKE_ONWA, 7, NORTH | EAST
	connection north, Route1, ROUTE_1, 0
	connection east, Route7, ROUTE_7, 11
	
	map_attributes SunbeamIsland, SUNBEAM_ISLAND, $35, WEST
	connection west, SunbeamBeach, SUNBEAM_BEACH, 0
	
	map_attributes SunbeamBeach, SUNBEAM_BEACH, $35, EAST
	connection east, SunbeamIsland, SUNBEAM_ISLAND, 0
	
	map_attributes EventideForest, EVENTIDE_FOREST, $7, NORTH
	connection north, SpookyForest1, SPOOKY_FOREST_1, 5
	
	map_attributes SpookyForest1, SPOOKY_FOREST_1, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForest2, SPOOKY_FOREST_2, 0
	connection south, EventideForest, EVENTIDE_FOREST, -5
	connection west, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection east, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	
	map_attributes SpookyForest2, SPOOKY_FOREST_2, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection south, SpookyForest1, SPOOKY_FOREST_1, 0
	connection west, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection east, SpookyForest3, SPOOKY_FOREST_3, 0
	
	map_attributes SpookyForest3, SPOOKY_FOREST_3, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection south, SpookyForest4, SPOOKY_FOREST_4, 0
	connection west, SpookyForest2, SPOOKY_FOREST_2, 0
	connection east, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	
	map_attributes SpookyForest4, SPOOKY_FOREST_4, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForest3, SPOOKY_FOREST_3, 0
	connection south, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection west, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection east, SpookyForest5, SPOOKY_FOREST_5, 0
	
	map_attributes SpookyForest5, SPOOKY_FOREST_5, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForest6, SPOOKY_FOREST_6, 0
	connection south, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection west, SpookyForest4, SPOOKY_FOREST_4, 0
	connection east, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	
	map_attributes SpookyForest6, SPOOKY_FOREST_6, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForest7, SPOOKY_FOREST_7, 0
	connection south, SpookyForest5, SPOOKY_FOREST_5, 0
	connection west, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection east, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	
	map_attributes SpookyForest7, SPOOKY_FOREST_7, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection south, SpookyForest6, SPOOKY_FOREST_6, 0
	connection west, SpookyForest8, SPOOKY_FOREST_8, 0
	connection east, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	
	map_attributes SpookyForest8, SPOOKY_FOREST_8, 92, NORTH | SOUTH | WEST | EAST
	connection north, OldManorExterior, OLD_MANOR_EXTERIOR, -4
	connection south, SpookyForestBlank, SPOOKY_FOREST_BLANK, 0
	connection west, SpookyForest9, SPOOKY_FOREST_9, 0
	connection east, SpookyForest7, SPOOKY_FOREST_7, 0
	
	map_attributes SpookyForest9, SPOOKY_FOREST_9, 92, EAST
	connection east, SpookyForest8, SPOOKY_FOREST_8, 0
	
	map_attributes SpookyForestBlank, SPOOKY_FOREST_BLANK, 92, 0
	
	map_attributes SpookyForestEscort, SPOOKY_FOREST_ESCORT, 92, NORTH | SOUTH | WEST | EAST
	connection north, SpookyForestEscort, SPOOKY_FOREST_ESCORT, 0
	connection south, SpookyForestEscort, SPOOKY_FOREST_ESCORT, 0
	connection west, SpookyForestEscort, SPOOKY_FOREST_ESCORT, 0
	connection east, SpookyForestEscort, SPOOKY_FOREST_ESCORT, 0
	
	map_attributes OldManorExterior, OLD_MANOR_EXTERIOR, 92, SOUTH
	connection south, SpookyForest8, SPOOKY_FOREST_8, 4
	
	map_attributes TwinkleTown, TWINKLE_TOWN, 5, SOUTH
	connection south, Route10, ROUTE_10, -4
	
	map_attributes LusterCityResidential, LUSTER_CITY_RESIDENTIAL, 113, EAST
	connection east, LusterCityShopping, LUSTER_CITY_SHOPPING, 0
	
	map_attributes LusterCityShopping, LUSTER_CITY_SHOPPING, 113, WEST | EAST
	connection west, LusterCityResidential, LUSTER_CITY_RESIDENTIAL, 0
	connection east, LusterCityBusiness, LUSTER_CITY_BUSINESS, 6
	
	map_attributes LusterCityBusiness, LUSTER_CITY_BUSINESS, 113, WEST
	connection west, LusterCityShopping, LUSTER_CITY_SHOPPING, -6
	
	map_attributes DaybreakGrotto1, DAYBREAK_GROTTO_1, $9, 0
	map_attributes DaybreakGrotto2, DAYBREAK_GROTTO_2, $9, 0
	map_attributes GlintGrove, GLINT_GROVE, $20, 0
	map_attributes GlintGroveDeep, GLINT_GROVE_DEEP, $20, 0
	map_attributes StarglowCavern1F, STARGLOW_CAVERN_1F, $9, 0
	map_attributes StarglowCavern2F, STARGLOW_CAVERN_2F, $9, 0
	map_attributes MtOnwa1F, MT_ONWA_1F, $09, 0
	map_attributes MtOnwa2F, MT_ONWA_2F, $09, 0
	map_attributes MtOnwaB1F, MT_ONWA_B1F, $09, 0
	map_attributes MtOnwaB2F, MT_ONWA_B2F, $09, 0
	map_attributes MtOnwaB3F, MT_ONWA_B3F, $09, 0
	map_attributes MtOnwaCliff, MT_ONWA_CLIFF, $00, 0
	map_attributes MtOnwaLowerCliff, MT_ONWA_LOWER_CLIFF, $00, 0
	map_attributes FlickerPass1F, FLICKER_PASS_1F, $9, 0
	map_attributes FlickerPass2F, FLICKER_PASS_2F, $9, 0
	map_attributes LusterSewersB1FFlooded, LUSTER_SEWERS_B1F_FLOODED, 0, 0
	map_attributes LusterSewersB1FEmpty, LUSTER_SEWERS_B1F_EMPTY, 0, 0
	map_attributes LusterSewersB2FFlooded, LUSTER_SEWERS_B2F_FLOODED, 0, 0
	map_attributes LusterSewersB2FEmpty, LUSTER_SEWERS_B2F_EMPTY, 0, 0
	map_attributes LusterSewersValveRoom, LUSTER_SEWERS_VALVE_ROOM, 0, 0
	
	map_attributes SunsetPokeCenter, SUNSET_POKECENTER, $0, 0
	map_attributes SunsetLighthouse, SUNSET_LIGHTHOUSE, $0, 0
	map_attributes PlayerHouse1F, PLAYER_HOUSE_1F, $0, 0
	map_attributes PlayerHouse2F, PLAYER_HOUSE_2F, $0, 0
	map_attributes SunsetWaterGrassHouse, SUNSET_WATER_GRASS_HOUSE, $0, 0
	map_attributes SunsetGengarHouse, SUNSET_GENGAR_HOUSE, $0, 0
	map_attributes SunsetLegendsHouse, SUNSET_LEGENDS_HOUSE, $0, 0
	map_attributes SunsetCaptainsHouse, SUNSET_CAPTAINS_HOUSE, $0, 0
	map_attributes SunsetCafe, SUNSET_CAFE, $0, 0
	map_attributes DaybreakPokemonTrainerSchool, DAYBREAK_POKEMON_TRAINER_SCHOOL, $0, 0
	map_attributes DaybreakMarcusHouse, DAYBREAK_MARCUS_HOUSE, $0, 0
	map_attributes DaybreakPokeCenter, DAYBREAK_POKECENTER, $0, 0
	map_attributes DaybreakAlexHouse, DAYBREAK_ALEX_HOUSE, $0, 0
	map_attributes GlintPokeCenter, GLINT_POKECENTER, $0, 0
	map_attributes GlintEvoHouse, GLINT_EVO_HOUSE, $0, 0
	map_attributes GlintRivalHouse, GLINT_RIVAL_HOUSE, $0, 0
	map_attributes GlintApartmentLeft1F, GLINT_APARTMENT_LEFT_1F, $0, 0
	map_attributes GlintApartmentLeft2F, GLINT_APARTMENT_LEFT_2F, $0, 0
	map_attributes GlintApartmentRight1F, GLINT_APARTMENT_RIGHT_1F, $0, 0
	map_attributes GlintApartmentRight2F, GLINT_APARTMENT_RIGHT_2F, $0, 0
	map_attributes GlintMart, GLINT_MART, $0, 0
	map_attributes GlintGym, GLINT_GYM, $0, 0
	map_attributes StarglowTogepiHouse, STARGLOW_TOGEPI_HOUSE, $0, 0
	map_attributes StarglowNoPokemonHouse, STARGLOW_NO_POKEMON_HOUSE, $0, 0
	map_attributes StarglowGrandpaHouse, STARGLOW_GRANDPA_HOUSE, $0, 0
	map_attributes StarglowFishingGuruHouse, STARGLOW_FISHING_GURU_HOUSE, $0, 0
	map_attributes StarglowPokeCenter, STARGLOW_POKECENTER, $0, 0
	map_attributes StarglowMart, STARGLOW_MART, $0, 0
	map_attributes StarglowGym, STARGLOW_GYM, $0, 0
	map_attributes LakeOnwaBoatHouseRight, LAKE_ONWA_BOAT_HOUSE_RIGHT, $0, 0
	map_attributes LakeOnwaNameRaterHouse, LAKE_ONWA_NAME_RATER_HOUSE, $0, 0
	map_attributes LakeOnwaBoatHouseLeft, LAKE_ONWA_BOAT_HOUSE_LEFT, $0, 0
	map_attributes LakeOnwaItemHouse, LAKE_ONWA_ITEM_HOUSE, $0, 0
	map_attributes LakeOnwaPokeCenter, LAKE_ONWA_POKECENTER, $0, 0
	map_attributes SunbeamPokeCenter, SUNBEAM_POKECENTER, $0, 0
	map_attributes SunbeamMart, SUNBEAM_MART, $0, 0
	map_attributes SunbeamBoatHouse, SUNBEAM_BOAT_HOUSE, $0, 0
	map_attributes SunbeamSurfShop, SUNBEAM_SURF_SHOP, $0, 0
	map_attributes SunbeamBikiniContest, SUNBEAM_BIKINI_CONTEST, $0, 0
	map_attributes SunbeamDodrioHouse, SUNBEAM_DODRIO_HOUSE, $0, 0
	map_attributes SunbeamOldCouplesHouse, SUNBEAM_OLD_COUPLES_HOUSE, $0, 0
	map_attributes SunbeamBlueWaterHouse, SUNBEAM_BLUE_WATER_HOUSE, $0, 0
	map_attributes SunbeamTradeHouse, SUNBEAM_TRADE_HOUSE, $0, 0
	map_attributes SprucesLab, SPRUCES_LAB, $0, 0
	map_attributes SunbeamReserve, SUNBEAM_RESERVE, $35, 0
	map_attributes SunbeamJungle, SUNBEAM_JUNGLE, $07, 0
	map_attributes SunbeamJungleCave, SUNBEAM_JUNGLE_CAVE, $09, 0
	map_attributes SpookhouseLivingRoom, SPOOKHOUSE_LIVING_ROOM, $00, 0
	map_attributes SpookhouseDiningRoom, SPOOKHOUSE_DINING_ROOM, $00, 0
	map_attributes SpookhouseBedroom, SPOOKHOUSE_BEDROOM, $00, 0
	map_attributes SpookhouseHallway1, SPOOKHOUSE_HALLWAY_1, $00, 0
	map_attributes SpookhouseHallway2, SPOOKHOUSE_HALLWAY_2, $00, 0
	map_attributes SpookhouseHallway3, SPOOKHOUSE_HALLWAY_3, $00, 0
	map_attributes SpookhouseTVRoom, SPOOKHOUSE_TV_ROOM, $00, 0
	map_attributes EventideHouse1, EVENTIDE_HOUSE_1, 0, 0
	map_attributes EventideHouse2, EVENTIDE_HOUSE_2, 0, 0
	map_attributes EventideBikeShop, EVENTIDE_BIKE_SHOP, 0, 0
	map_attributes EventidePokeCenter, EVENTIDE_POKECENTER, 0, 0
	map_attributes EventideMart, EVENTIDE_MART, 0, 0
	map_attributes EventideGym, EVENTIDE_GYM, 0, 0
	map_attributes DodrioRanchHouse, DODRIO_RANCH_HOUSE, $00, 0
	map_attributes DodrioRanchBarn, DODRIO_RANCH_BARN, $00, 0
	map_attributes DodrioRanchRaceTrack, DODRIO_RANCH_RACETRACK, 5, 0
	map_attributes FlickerSoundSpeechHouse, FLICKER_SOUND_SPEECH_HOUSE, 0, 0
	map_attributes FlickerNameSpeechHouse, FLICKER_NAME_SPEECH_HOUSE, 0, 0
	map_attributes FlickerPokeCenter, FLICKER_POKECENTER, 0, 0
	map_attributes FlickerMart, FLICKER_MART, 0, 0
	map_attributes FlickerTrainStation, FLICKER_TRAIN_STATION, 0, 0
	map_attributes FlickerTrainCutscene, FLICKER_TRAIN_CUTSCENE, 0, 0
	map_attributes Route10Tent, ROUTE_10_TENT, 0, 0
	map_attributes TwinkleHouse1, TWINKLE_HOUSE_1, 0, 0
	map_attributes TwinkleHouse2, TWINKLE_HOUSE_2, 0, 0
	map_attributes TwinkleHouse3, TWINKLE_HOUSE_3, 0, 0
	map_attributes TwinklePokeCenter, TWINKLE_POKECENTER, 0, 0
	map_attributes TwinkleMart, TWINKLE_MART, 0, 0
	map_attributes EastTrainCabin1, EAST_TRAIN_CABIN_1, 0, 0
	map_attributes EastTrainCabin2, EAST_TRAIN_CABIN_2, 0, 0
	map_attributes EastTrainCabin3, EAST_TRAIN_CABIN_3, 0, 0
	map_attributes EastTrainCaboose, EAST_TRAIN_CABOOSE, 0, 0
	
	map_attributes Route5Deep, ROUTE_5_DEEP, $7, 0
	map_attributes Route1Gate, ROUTE_1_GATE, $0, 0
	map_attributes Route5Gate, ROUTE_5_GATE, $0, 0
	map_attributes Route4EventideGate, ROUTE_4_EVENTIDE_GATE, $0, 0
	map_attributes EventideVillageGate, EVENTIDE_VILLAGE_GATE, $0, 0
