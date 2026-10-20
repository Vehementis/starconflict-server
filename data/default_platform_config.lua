-- -*- coding: utf-8 -*-

local x3fw = 3	---- x3 FIRST WI

local store_vesselExpExtractionCost = 0.001

local event_custom			= "2023-04-16T00:00:00Z"-- It is necessary to change the start and end times in multiples of an hour, otherwise the imaginary quest may behave unpredictably.
local creditsEventStart		= "2023-06-09T05:00:00Z"
local creditsEventEnd		= "2023-09-14T00:00:00Z"

-- BattlePass Event Activation
	-- battlePassStart - string, event start time in the format YYYY-MM-DDThh:mm:ssZ (ISO 8601)
	-- battlePassEndTable - table, active stages in the format: { {stage, stageEndTime}, {stage, stageEndTime}, ...},
	-- where stage - number, stage number (counting from 1), stageEndTime - string, stage end time in the format YYYY-MM-DDThh:mm:ssZ (ISO 8601);
	--	stageEndTime can be an empty string, in which case the stage is considered to have no end time and will remain active until it is removed from the list
	-- Attention: data about a player’s progress is stored only for one event; if the start time of the event changes, they are lost (it is considered that this is already a different event) (this does not apply to premium purchased through Dlc, which is stored for all events)
	local battlePassStart		= "2023-06-09T05:00:00Z"
	local battlePassEndTable	= { {1,"2023-09-14T00:00:00Z"}, {2,"2023-09-14T00:00:00Z"}, {3,"2023-09-14T00:00:00Z"}} -- Make sure that the end dates/times of the 1st and 2nd stages of one BP are the same!!! Added 3rd stage (from summer 2023)

-- list of prohibited equipment (ships and modules) in leagues
 local leagueForbiddenDefs =
{
	"Weapon_Minigun_NY_T3",
	"Weapon_Minigun_NY_T4",
	"Weapon_Minigun_NY_T5",
	"Weapon_SmartRocketLauncher_NY_T3",
	"Weapon_SmartRocketLauncher_NY_T4",
	"Weapon_SmartRocketLauncher_NY_T5",
	"Weapon_SuppressingGun_NY_T3",
	"Weapon_SuppressingGun_NY_T4",
	"Weapon_SuppressingGun_NY_T5",
	"FireStealingPot",
	"BushidoCall",
	"DronDamageMod",
	"EnemyInfoCheck",
	"CloakingDevice_Uniq_T3",
	"FrigateDrone_T3_LessShldHeal",
	"WolfRun",
	"SaveBack",  
	'Module_Glass_PlasmaWeb',
	'Module_Glass_PhaseShield',
	'Module_Glass_EnergyShieldCommander',
	'Module_Glass_FrigateDrone',
	'Module_Glass_CloakingDevice',
	'Module_Glass_MicroWarp',
	'Module_Glass_TimeBoost',
}

-- list of prohibited defs for adaptive bot presets
local botPresetForbiddenDefs =
{
	"Weapon_PlasmaWebLaser_T5_Mk1",
	"Weapon_PlasmaWebLaser_T5_Rare",
	"Weapon_PlasmaWebLaser_T5_Mk3",
	"Weapon_PlasmaWebLaser_T5_Epic",
	"Weapon_PlasmaWebLaser_T5_Rel",
  
	"Ship_Race5_M_T5_Apeiron",
}

local numAdaptivePresets = 32

--
function ConfigureShard()

	-- Allows automatic creation of an internal account upon first login. (type: boolean)
	cvars.auth_allowInternalAutoCreate	= 1
	
	-- Level of access to sandbox functions. (type: integer)
	cvars.sm_sandboxAccess				= 4

	-- Minimum anti-bot counter value for sending mail. (type: integer; range: 0..100)
	cvars.shard_minAntibotCounterForMailSending = 50

	-- List of admRole via ;, for which an infinite premium applies. (type: string)
	cvars.auth_infinitePremiumForRoles	= "gm;support"

	-- Unit size that does not require premium to queue. (type: integer)
	cvars.squad_maxNonPremiumSize		= 12

	
	-- Allows you to buy store items even if they have the cant_be_bought flag. (type: boolean)
	cvars.store_allowAllItemsForBying	= 0

	-- Enables logging of ship quests. (type: boolean)
	cvars.shipQuests_dbgLog				= 0

	-- Starting amount of gold for a new account. (type: integer)
	cvars.gold_on_start					= 30000
	-- Starting premium time/value for a new account. (type: integer)
	cvars.premium_on_start				= 1000
	-- The starting number of credits for a new account. (type: integer)
	cvars.credits_on_start				= 0

	-- The coefficient of contribution of one regular ship to the prestige of an account. The final prestige is calculated as: regular ships * store_prestigePerVssl + premium ships * store_prestigePerPremVssl. (type: fractional number)
	cvars.store_prestigePerVssl 		= 0.01
	-- The coefficient of contribution of one premium ship to the prestige of the account. The higher the value, the more premium ships increase prestige. (type: fractional number)
	cvars.store_prestigePerPremVssl 	= 0.01

    -- The cost of extracting ship experience. (type: fractional number)
    cvars.store_vesselExpExtractionCost = store_vesselExpExtractionCost
    if cvars.store_vesselExpExtractionCost >= 0.006 then
    	-- Visual bonus/indicator of the cost of extracting ship experience. (type: fractional number)
    	cvars.store_vesselExpExtractionCostVisualBonus = 0
   	else
    	-- Visual bonus/indicator of the cost of extracting ship experience. (type: fractional number)
    	cvars.store_vesselExpExtractionCostVisualBonus = 1
    end

	-- Ship price multiplier in the store. Multiplies all types of ship prices: credits, premium, tokens and event price. (type: fractional number; range: 0.001f..100.0f)
	cvars.store_vesselPriceMod		= 1
	-- Price multiplier for modules in the store. Multiplies credits, premium, tokens and event price for module type items. (type: fractional number; range: 0.001f..100.0f)
	cvars.store_modulePriceMod		= 1
	-- Ammunition price multiplier in the store. Multiplies credits, premium, tokens and event price for munition type items. (type: fractional number; range: 0.001f..100.0f)
	cvars.store_munitionPriceMod	= 1

	-- Treat a single player as a one-person squad when matchmaking.
	cvars.mm_squad1AsSquad			= 0

	-- The total limit of the total adjustment of MMV from efficiency, KPM, victories and other factors.
	cvars.mm_totalMMVMdCap			= 2

	-- Parameter of the MMV formula for efficiency rating: Base - threshold, Step - step, Cap - maximum.
	cvars.mm_effRatingMMVMdBase 	= 0
	-- Parameter of the MMV formula for efficiency rating: Base - threshold, Step - step, Cap - maximum.
	cvars.mm_effRatingMMVMdStep 	= 25
	-- Parameter of the MMV formula for efficiency rating: Base - threshold, Step - step, Cap - maximum.
	cvars.mm_effRatingMMVMdCap 		= 50
  	-- Parameter of the MMV formula by KPM: Base - threshold, Step - step, Cap - maximum.
  	--
  	cvars.mm_kpmMMVBase 		= 0
	-- Parameter of the MMV formula by KPM: Base - threshold, Step - step, Cap - maximum.
	cvars.mm_kpmMMVStep 		= 0.0325
	-- Parameter of the MMV formula by KPM: Base - threshold, Step - step, Cap - maximum.
	cvars.mm_kpmMMVCap 			= 50

	-- MMV formula parameter based on win-loss ratio; MinBattles enables the correction only after the required number of battles.
	-- Clamp (winLose - mm_winLoseMMVBase)/mm_winLoseMMVStep ; 0 ; mm_winLoseMMVCap )
	cvars.mm_winLoseMMVMinBattles	= 2000
	-- Parameter of the MMV formula based on the ratio of wins and losses.
	cvars.mm_winLoseMMVBase 		= 0.75
	-- Parameter of the MMV formula based on the ratio of wins and losses.
	cvars.mm_winLoseMMVStep 		= 0.012
	-- Parameter of the MMV formula based on the ratio of wins and losses.
	cvars.mm_winLoseMMVCap 			= 50

	-- Table of MMV values ​​by ranks/matchmaking groups.
	cvars.mm_mmvMdBattles 		= "200,200,200,200,200,200,200,100,0,0,0,0,0,0,0,0,0,0"
	-- Table of MMV values ​​by ranks/matchmaking groups.
	cvars.mm_mmvMdPenalty 		= "30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30"
    -- The lower limit of the final MMV by ship rank, which begins to take effect after the battle threshold from mm_mmvMdBattles.
    -- Prevents penalties and other negative adjustments from lowering the MMV below the specified value.
    -- Specified by a list of numbers: the first number for the 1st rank, the second for the 2nd, etc.; the number of values ​​must match mm_mmvMdBattles.
    cvars.mm_mmvMin 			= "30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30"
  	-- The upper limit of the final MMV for players with a unique PC fingerprint, as long as they have fewer battles than the threshold from mm_mmvMdBattles.
  	-- Limits how highly matchmaking can rank a new player based on his stats.
  	-- Specified by a list of numbers by rank; if the list is full, its length must match mm_mmvMdBattles.
  	cvars.mm_mmvMdUniqFingerprintClamp = "30,30,30,30,30,30,30,80,80,80,80,80,80,80,80,80,80,80"

	-- Waiting time for keep-alive from the client after connecting; if there is no response, the client is disconnected.
	cvars.sm_initialKeepAliveTime = 120

	-- The interval at which the shard server checks pending administrative tasks in the storage and starts working on them.
	-- The lower the value, the faster tasks will begin to execute, but the more often the storage will be polled.
	-- Specified in seconds; allowed range: 0.01..5.
	cvars.ctm_taskRecoveryInterval	= 5

	-- WINGS
  	-- The maximum size of a regular squad that is not yet considered a wing group.
  	-- If this limit is exceeded when inviting players, you need to create a wing group.
  	cvars.squad_maxNonWingSize 		= 4
  	-- The maximum size of a wing group when inviting players to a squad.
  	-- Once this limit is reached, new members cannot be added to wing.
  	cvars.squad_maxWingSize    		= 12
  	-- The minimum size of a wing group to enter the matchmaker's sector queue.
  	-- Units smaller than this size will not be accepted into modes that require sector-wing.
  	cvars.mm_sectorMinWingSize 		= 5
  	-- The maximum size of a wing group for a matchmaker's sector queues.
  	-- Units larger than this size will not be accepted into modes that require sector-wing.
  	cvars.mm_sectorMaxWingSize 		= 8
  	-- The minimum size of a wing group to enter a matchmaker's raid queue.
  	-- Units smaller than this size will not be able to join the raid queue.
  	cvars.mm_raidMinWingSize		= 10

	-- Group composition filter for raid queues: sets who can join the raid - single players, regular squads and/or wing groups.
	-- 0 - all types of squads: solo, regular squads and wing.
	-- 1 - solo only; Any units and wings are not allowed into the raid queue.
	-- 2 - solo and regular units; wing groups are not allowed.
	-- 3 - regular units and wing; Solo players are not allowed.
	-- 4 - wing only; solo and regular units are not allowed.
	-- For modes with wing, the minimum size from mm_raidMinWingSize additionally applies.
	cvars.mm_raidSquadFilter = 0

	-- Enables PvE raids in matchmaker.
	cvars.mm_enablePveRaids			= 1
  
  	-- Allowable difference in ranks in a squad for non-arcade modes.
  	cvars.mm_notArcadeSquadRankDiff = 17

	-- The interval in days after which the player is again given loot auras for raid missions.
	-- Verification and issuance occur upon the player’s first login that day.
	-- A value of 1 means daily issuance; 3 - once every three days.
	cvars.raid_lootAuraInterval 	= 1

	-- Start time of the event with credits. (type: string)
	cvars.store_creditsEventStart		= creditsEventStart
	-- End time of the event with credits. (type: string)
	cvars.store_creditsEventEnd			= creditsEventEnd

	-- Trade
  	-- Maximum amount of one transaction/letter. (type: integer)
  	cvars.store_maxTransactionSum 	= 20000
	-- Minimum anti-bot counter value for sending mail. (type: integer; range: 0..100)
	cvars.shard_minAntibotCounterForMailSending = 50

	-- Includes a detailed decision log when a player or squad tries to join the matchmaker's queue.
	-- 0 - log is disabled, any number greater than 0 - log is enabled.
	cvars.mm_decisionLog		= 0
	
  	-- Limit of identical unique modules per ship; is set separately for regular and premium ships.
  	-- Balanse rule
  	cvars.store_maxUniqueModules = 3
  	-- Limit of identical unique modules per ship; is set separately for regular and premium ships.
  	-- #0098493: Make it possible to install experimental modules on premium. and DLC ships in quantity 1 piece
  	cvars.store_maxUniqueModulesOnPremium = 2
	
	-- List of offerIds of offers that need to be enabled on the shard server.
	-- Identifiers are taken from the offers.xml file in the same folder: look for the offerId attribute of the desired offer.
	-- Format: numbers separated by commas, spaces or tabs; an empty line disables all offers.
	cvars.sv_offerEnable = "6,7,17,18,19"
	
	-- Maximum amount of one transaction/letter. (type: integer)
	cvars.store_maxTransactionSum 	= 20000
	
	-- brawl
	-- SC-112207
	local brawlSchedule =
	{
		-- The schedule is set for 28 days.
		-- (the reference point is the first Monday of 2018)
		-- Brawl gameplays: "football", "gtdm", "hunger_games", "one_against_all", "sentinel", "capture_the_base", "atdm", "zombie", "close_distance", "autogen_dm", "three_teams_dm", "april_control"

		-- intervals do not have to be written in sorted order
		-- the last interval of the day can be with a transition to another day - {23,1} ("except for the transition from Sunday to Monday of the next week" - not relevant-)
		-- intervals within one day should not overlap
		-- days should not be duplicated

		--[[{ days = { 1,  8, 15, 22 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "football"		},
		{ days = { 2, 7, 9, 16, 23 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "one_against_all"	},
		{ days = { 3, 10, 14, 17, 24 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "gtdm"	},
		{ days = { 4, 11, 18, 21, 25 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "hunger_games"	},
		{ days = { 5, 12, 19, 26, 28 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "sentinel"		},
		{ days = { 6, 13, 20, 27 },	time_intervals = { {2,3}, {10,11}, {14,15}, {17,18}, {21,22} }, gameplay = "capture_the_base"	},]]

		{ days = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28 },	time_intervals = { {1,2}, {9,10}, {15,16}, {17,18}, {19,20}, {21,22} }, gameplay = "three_teams_dm"	},
		
	}
	_G.BrawlManager_SetupSchedule( brawlSchedule )
	
	-- Maximum chance to receive a bonus set when purchasing a set; the chance is multiplied by a coefficient (prestige / maxPrestige). (type: fractional number; range: 0.0f..1.0f)
	cvars.store_bonusBundleChancePercentageMax = 0.2
  
  	-- Premium time awarded for account rank. (type: integer)
  	-- premium (in seconds, default - day)
  	cvars.premiumTimeForAccountRank = 1 * 24 * 60 * 60
  
	-- Daily limit of token credits that a player can earn per day.
	-- #106983
	cvars.sv_tokenCreditsDailyLimit = 1000

	-- list of prohibited equipment (ships and modules) in leagues
	Shard_SetupLeagueForbiddenEquipment( leagueForbiddenDefs )
	
	_G.Shard_SetupBattlePassActivation( battlePassStart, battlePassEndTable )

	-- The time from which the battle pass level unlock button appears. (type: string)
	cvars.store_battlePassUnlockLvlBtnStart = "2023-07-14T00:00:00Z"

	-- Adaptive bot presets.
	-- BFL role increase factor. (type: fractional number)
	-- bfl - battle time for life time
	-- Tsvar to increase the statistics of presets SC-115316
	cvars.sm_bflRoleInc = 0.5
	-- BFL role reduction factor. (type: fractional number)
	-- tsvar to reduce preset statistics
	cvars.sm_bflRoleDec = 0.05
	-- The number of adaptive presets saved in the database. 0 - clears data. (type: integer; range: 0..1000)
	cvars.sm_numAdaptivePresetsToSaveDB = numAdaptivePresets
end


--
function InstantiateQueueTemplate( template, minMMRank, maxMMRank, minMMSquadRank, maxMMSquadRank, minMMValue, maxMMValue, addMods ) --  minDestrRank, maxDestrRank,
	local instance = sys.new( template )

	if ( instance.query.mmRank[ "$gte" ] ~= nil ) then
		instance.query.mmRank[ "$gte" ] = minMMRank
	end

	if ( instance.query.mmRank[ "$lte" ] ~= nil ) then
		instance.query.mmRank[ "$lte" ] = maxMMRank
	end
	
	if ( instance.query.mmSquadRank ~= nil ) then
		if ( instance.query.mmSquadRank[ "$gte" ] ~= nil ) then
			instance.query.mmSquadRank[ "$gte" ] = minMMSquadRank
		end	

		if ( instance.query.mmSquadRank[ "$lte" ] ~= nil ) then
			instance.query.mmSquadRank[ "$lte" ] = maxMMSquadRank
		end
	end

	if ( instance.query.mmValue[ "$gte" ] ~= nil ) then
		instance.query.mmValue[ "$gte" ] = minMMValue
	end

	if ( instance.query.mmValue[ "$lt" ] ~= nil ) then
		instance.query.mmValue[ "$lt" ] = maxMMValue
	end

	if( addMods ~= nil ) then
		sys.mergeTable( instance, addMods )
	end
	
	return instance
end

--
function ConfigureMatchmaker()

	-- Full map list
	-- s1338_pandora_dreadnwreck
	-- s1420_ceres3_northmsite

	-- s1338_devilsjaw
	-- s1340_thar_aliendebris13
	-- s1340_aliendestsatation
	-- s8256_thar_barrierdebris

	-- s1338_pandora_anomaly
	-- s1340_thar_gasgiant
	-- s1420_ceres3_asteroidcity
	-- s8256_thar_barrierdebris

	-- s1340_thar_gasgiant
	-- s8256_thar_barrierdebris
	-- s8256_thar_threshold
	-- s1340_aliendestsatation


	-- Type of adaptive bot presets.
	local bpt_none = 0
	local bpt_mirror = 1
	local bpt_adaptive = 2
	local bpt_mirror_and_save = 3

	-- MM queue setup
	local queuesConfigLo = {

		-- TRAINING QUEUES
		{
			maxPlayers = 10,
			minPlayers = 1,
			regionLocalizedTimeInQueue = 30,
			maxTimeInQueue = 45,
			levelsDesc = {
				s1338_pandora_dreadnwreck = {},
				s1338_pandora_anomaly = {},
				s1420_ceres3_northmsite = {},
			},
			query = { ["mmParams.practice"] = 1 },
			special = { gameMode = 5, botsCount = 0 },
		},

		-- PVE QUEUE
		{
			maxPlayers = 4,
			minPlayers = 1,
			regionLocalizedTimeInQueue = 10,
			maxTimeInQueue = 10,
			levelsDesc = {},
			query = { ["mmParams.pve"] = 1 },
			special = { pve = 1, gameMode = 7, botsCount = 3 },
		}
	}

 -- ARCADE & PvE QUEUES

	-- low on-line
	local arcadeQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 4,
		minPlayers = 1,
		maxExpandTime = 30,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		maxSquadTimeInQueue = 0x7FFFFFFF,
		levelsDesc = {
			s1338_devilsjaw = {4,9,11},
			s1420_ceres3_northmsite = {4,9,11},
			s1420_ceres3_asteroidcity = {4,9,11},
			s8256_thar_barrierdebris = {4,9,11},
			s1338_pandora_dreadnwreck = {4,9,11},
		},
		query = { ["mmParams.arcade"] = 1, mmRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmSquadRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmValue = { ["$gte"] = 0, ["$lt"] = 100 } },
		special = { arcade = 1 },
	}

	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:4; s1340_thar_aliendebris13:4; s8256_thar_threshold:4"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 0, 20, { special = { queueFlags = { newbie = 1, }, }, maxPlayers = 16 } ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:4,9,10; s1340_aliendestsatation:4,10; s1340_thar_gasgiant:4,9; s1420_ceres3_northmsite:4,9,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 19, 24 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1420_ceres3_asteroidcity:4,9,10,11; s1420_ceres3_northmsite:4,11; s8256_thar_barrierdebris:4,9,11; s8256_thar_threshold:4,9,10; s1347_livestation:4,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 24, 31 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,9,11; s1338_pandora_dreadnwreck:3,9,10,11; s1420_ceres3_asteroidcity:4,10; s1420_ceres3_northmsite:3,9,11; s8256_thar_lavastone:4,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 31, 39 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,10; s1338_pandora_dreadnwreck:3,4,9,11; s1340_aliendestsatation:3; s1340_thar_aliendebris13:3,4,9,10; s8256_thar_threshold:3,4,9"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 39, 51 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,9; s1340_aliendestsatation:3,4,9,10; s1340_thar_gasgiant:3,4; s1420_ceres3_northmsite:9; s8256_thar_lavastone:3,10,11; s8256_thar_threshold:3,11"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 17, 1, 15, 51, 99 ) )

	local coopQueueTemplate = {
		maxPlayers = 12,
		optimalPlayers = 4,
		minPlayers = 1,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_devilsjaw = {4,9,11},
			s1420_ceres3_northmsite = {4,9,11},
			s1420_ceres3_asteroidcity = {4,9,11},
			s8256_thar_barrierdebris = {4,9,11},
			s1338_pandora_dreadnwreck = {4,9,11},
		},
		query = { ["mmParams.coop_vs_ai"] = 1, mmRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmValue = { ["$gte"] = 0, ["$lt"] = 100 } },
		special = { coop_vs_ai = 1 },
	}

	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:4; s1340_thar_aliendebris13:4; s8256_thar_threshold:4"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 0, 21, { special = { queueFlags = { newbie = 1, }, coop_vs_ai = 1 }, maxPlayers = 8 } ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:4,9,10; s1340_aliendestsatation:4,10; s1340_thar_gasgiant:4,9; s1420_ceres3_northmsite:4,9,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 19, 24 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1420_ceres3_asteroidcity:4,9,10,11; s1420_ceres3_northmsite:4,11; s8256_thar_barrierdebris:4,9,11; s8256_thar_threshold:4,9,10; s1347_livestation:4,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 24, 31 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,9,11; s1338_pandora_dreadnwreck:3,9,10,11; s1420_ceres3_asteroidcity:4,10; s1420_ceres3_northmsite:3,9,11; s8256_thar_lavastone:4,10"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 31, 39 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,10; s1338_pandora_dreadnwreck:3,4,9,11; s1340_aliendestsatation:3; s1340_thar_aliendebris13:3,4,9,10; s8256_thar_threshold:3,4,9"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 39, 51 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,9; s1340_aliendestsatation:3,4,9,10; s1340_thar_gasgiant:3,4; s1420_ceres3_northmsite:9; s8256_thar_lavastone:3,10,11; s8256_thar_threshold:3,11"
	table.insert( queuesConfigLo, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 51, 99 ) )


	-- BRAWL--

	local footballQueueTemplate = {
		maxPlayers = 6,
		optimalPlayers = 6,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			football = { 21 },
		},
		query = { ["mmParams.football"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, footballQueueTemplate )

	local gtdmQueueTemplate = {
		maxPlayers = 2,
		optimalPlayers = 2,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			da_prototype = { 13 },
		},
		query = { ["mmParams.gtdm"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, gtdmQueueTemplate )
	
	local atdmQueueTemplate = {
		maxPlayers = 8,
		optimalPlayers = 8,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			paper_airplanes = { 26 },
		},
		query = { ["mmParams.atdm"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, atdmQueueTemplate )


	local sentinelQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 8,
		minPlayers = 4,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1420_ceres3_asteroidcity = {9},
		},
		query = { ["mmParams.sentinel"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, sentinelQueueTemplate )

	local captureTheBaseQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 8,
		minPlayers = 4,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_devilsjaw = { 3 },
		},
		query = { ["mmParams.capture_the_base"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, captureTheBaseQueueTemplate )


	local hangerGamesQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 6,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_hg_pandora_anomaly = { 24 },
		},
		query = { ["mmParams.hunger_games"] = 1 },
		special = { hunger_games = 1 },
	}

	table.insert( queuesConfigLo, hangerGamesQueueTemplate )

	local oneAgainstAllQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 3,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_hg_pandora_anomaly = { 25 },
		},
		query = { ["mmParams.one_against_all"] = 1 },
		special = { one_against_all = 1, botsCount = 7 },
	}

	table.insert( queuesConfigLo, oneAgainstAllQueueTemplate )

	local aprilTeamDeathMatchQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 8,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			paper_airplanes = { 26 },
		},
		query = { ["mmParams.atdm"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, aprilTeamDeathMatchQueueTemplate )


	local zombieQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 10,
		minPlayers = 5,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			da_deathstar = { 27 },
		},
		query = { ["mmParams.zombie"] = 1 },
		special = { zombie = 1 },
	}

	table.insert( queuesConfigLo, zombieQueueTemplate )

	local closeDistanceQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 8,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			allidium_yard = { 28 },
		},
		query = { ["mmParams.close_distance"] = 1 },
		special = { close_distance = 1 },
	}

	table.insert( queuesConfigLo, closeDistanceQueueTemplate )

	local autogenDmGamesQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 6,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_pandora_anomaly = { 29 },
		},
		query = { ["mmParams.autogen_dm"] = 1 },
		special = { hunger_games = 1 },
	}

	table.insert( queuesConfigLo, autogenDmGamesQueueTemplate )


	local threeTeamsDeathMatchTemplate = {
		maxPlayers = 24,
		optimalPlayers = 6,
		minPlayers = 3,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1340_thar_alienruins = { 30 },
		},
		query = { ["mmParams.three_teams_dm"] = 1 },
		special = { three_teams_dm = 1 },
	}

	table.insert( queuesConfigLo, threeTeamsDeathMatchTemplate )


	local aprilControlQueueTemplate = {
		maxPlayers = 8,
		optimalPlayers = 8,
		minPlayers = 2,
		maxExpandTime = 0,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			paper_airplanes = { 31 },
		},
		query = { ["mmParams.april_control"] = 1 },
		special = { brawl = 1 },
	}

	table.insert( queuesConfigLo, aprilControlQueueTemplate )

	-- high on-line

	-- MM queue setup
	local queuesConfig = {

		-- TRAINING QUEUES
		{
			maxPlayers = 10,
			minPlayers = 1,
			regionLocalizedTimeInQueue = 30,
			maxTimeInQueue = 45,
			levelsDesc = {
				s1338_pandora_dreadnwreck = {},
				s1338_pandora_anomaly = {},
				s1420_ceres3_northmsite = {},
			},
			query = { ["mmParams.practice"] = 1 },
			special = { gameMode = 5, botsCount = 0 },
		},

		-- PVE QUEUE
		{
			maxPlayers = 4,
			minPlayers = 1,
			regionLocalizedTimeInQueue = 10,
			maxTimeInQueue = 10,
			levelsDesc = {},
			query = { ["mmParams.pve"] = 1 },
			special = { pve = 1, gameMode = 7, botsCount = 3 },
		}
	}

	local arcadeQueueTemplate = {
		maxPlayers = 24,
		optimalPlayers = 4,
		minPlayers = 1,
		maxExpandTime = 30,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		maxSquadTimeInQueue = 0x7FFFFFFF,
		levelsDesc = {
			s1338_devilsjaw = {9},
			-- s1420_ceres3_northmsite = {4,9,11},
			-- s1420_ceres3_asteroidcity = {4,9,11},
			-- s8256_thar_barrierdebris = {4,9,11},
			-- s1338_pandora_dreadnwreck = {4,9,11},
		},
		query = { ["mmParams.arcade"] = 1, mmRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmSquadRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmValue = { ["$gte"] = 0, ["$lt"] = 100 } },
		special = { arcade = 1 },
	}

	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:4; s1340_thar_aliendebris13:4; s8256_thar_threshold:4"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 0, 21, { special = { queueFlags = { newbie = 1, }, }, maxPlayers = 16 } ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:4,9,10; s1340_aliendestsatation:4,10; s1340_thar_gasgiant:4,9; s1420_ceres3_northmsite:4,9,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 20, 24 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1420_ceres3_asteroidcity:4,9,10,11; s1420_ceres3_northmsite:4,11; s8256_thar_barrierdebris:4,9,11; s8256_thar_threshold:4,9,10; s1347_livestation:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 23, 28 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1340_aliendestsatation:9,11; s1340_thar_aliendebris13:3,4,10; s1340_thar_gasgiant:3,9,11; s8256_thar_barrierdebris:4,10; s8256_thar_lavastone:3,4,9,10,11"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 26, 31 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,9,11; s1338_pandora_dreadnwreck:3,9,10,11; s1420_ceres3_asteroidcity:4,10; s1420_ceres3_northmsite:3,9,11; s8256_thar_lavastone:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 30, 35 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:3,10,11; s1338_pandora_anomaly:3,4,9,11; s1420_ceres3_northmsite:3,4,9; s8256_thar_threshold:3,4,9; s1347_livestation:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 33, 38 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:3,9,10; s1340_thar_gasgiant:3,9,10; s1420_ceres3_asteroidcity:3,4,9; s8256_thar_barrierdebris:3,4,11; s8256_thar_threshold:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 37, 42 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,10; s1338_pandora_dreadnwreck:3,4,9,11; s1340_aliendestsatation:3; s1340_thar_aliendebris13:3,4,9,10; s8256_thar_threshold:3,4,9"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 40, 45 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,10; s1340_thar_gasgiant:3,9,11; s1420_ceres3_asteroidcity:3,10; s8256_thar_lavastone:3,4,9; s1347_livestation:4"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 44, 51 ) )
	--
	--arcadeQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,9; s1340_aliendestsatation:3,4,9,10; s1340_thar_gasgiant:3,4; s1420_ceres3_northmsite:9; s8256_thar_lavastone:3,10,11; s8256_thar_threshold:3,11"
	table.insert( queuesConfig, InstantiateQueueTemplate( arcadeQueueTemplate, 1, 15, 1, 15, 51, 99 ) )

	local coopQueueTemplate = {
		maxPlayers = 12,
		optimalPlayers = 4,
		minPlayers = 1,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {
			s1338_devilsjaw = {4,9,11},
			s1420_ceres3_northmsite = {4,9,11},
			s1420_ceres3_asteroidcity = {4,9,11},
			s8256_thar_barrierdebris = {4,9,11},
			s1338_pandora_dreadnwreck = {4,9,11},
		},
		query = { ["mmParams.coop_vs_ai"] = 1, mmRank = { ["$gte"] = 1, ["$lte"] = 17 }, mmValue = { ["$gte"] = 0, ["$lt"] = 100 } },
		special = { coop_vs_ai = 1 },
	}

	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:4; s1340_thar_aliendebris13:4; s8256_thar_threshold:4"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 0, 21, { special = { queueFlags = { newbie = 1, }, }, maxPlayers = 8 } ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:4,9,10; s1340_aliendestsatation:4,10; s1340_thar_gasgiant:4,9; s1420_ceres3_northmsite:4,9,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 20, 24 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1420_ceres3_asteroidcity:4,9,10,11; s1420_ceres3_northmsite:4,11; s8256_thar_barrierdebris:4,9,11; s8256_thar_threshold:4,9,10; s1347_livestation:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 23, 28 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1340_aliendestsatation:9,11; s1340_thar_aliendebris13:3,4,10; s1340_thar_gasgiant:3,9,11; s8256_thar_barrierdebris:4,10; s8256_thar_lavastone:3,4,9,10,11"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 26, 31 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,9,11; s1338_pandora_dreadnwreck:3,9,10,11; s1420_ceres3_asteroidcity:4,10; s1420_ceres3_northmsite:3,9,11; s8256_thar_lavastone:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 30, 35 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:3,10,11; s1338_pandora_anomaly:3,4,9,11; s1420_ceres3_northmsite:3,4,9; s8256_thar_threshold:3,4,9; s1347_livestation:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 33, 38 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_dreadnwreck:3,9,10; s1340_thar_gasgiant:3,9,10; s1420_ceres3_asteroidcity:3,4,9; s8256_thar_barrierdebris:3,4,11; s8256_thar_threshold:4,10"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 37, 42 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_pandora_anomaly:3,4,10; s1338_pandora_dreadnwreck:3,4,9,11; s1340_aliendestsatation:3; s1340_thar_aliendebris13:3,4,9,10; s8256_thar_threshold:3,4,9"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 40, 45 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,10; s1340_thar_gasgiant:3,9,11; s1420_ceres3_asteroidcity:3,10; s8256_thar_lavastone:3,4,9; s1347_livestation:4"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 44, 51 ) )
	--
	--coopQueueTemplate.levelsDesc = "s1338_devilsjaw:3,4,9; s1340_aliendestsatation:3,4,9,10; s1340_thar_gasgiant:3,4; s1420_ceres3_northmsite:9; s8256_thar_lavastone:3,10,11; s8256_thar_threshold:3,11"
	table.insert( queuesConfig, InstantiateQueueTemplate( coopQueueTemplate, 1, 15, 1, 15, 51, 99 ) )


    -- SECTOR BATTLE QUEUES
    local sectorQueue = {
        maxPlayers = 20,
        regionLocalizedTimeInQueue = 1, -- default value is 120, override it by something small
        special = {
			universe = 1,
			minSizeWing = 5,
			minSizeTeam = 4,
			withBots = true,
			botPresetType = bpt_none,
			botPresetByTier = {"BotsBZS_T3","BotsBZS_T3","BotsBZS_T3","BotsBZS_T4","BotsBZS_T5"},
			queueFlags = { universe = 1, rank = 15, },
		},
        squadFilter = 0,
        qid = 501,
        levelsDesc = { dreadnoughtbattle_map_01 = { 14 }, dreadnoughtbattle_map_02 = { 14 }, dreadnoughtbattle_map_03 = { 14 }, dreadnoughtbattle_map_04 = { 14 }, dreadnoughtbattle_map_05 = { 14 }, dreadnoughtbattle_map_06 = { 14 } },
        query = { ["mmParams.universe"] = 1, ["mmParams.universe_bfs"] = 1},
    }

    table.insert( queuesConfig, sectorQueue )
    table.insert( queuesConfigLo, sectorQueue )

    -- SECTOR BATTLE QUEUES LEAGUES #0108276
    local leagueQueue = {
        maxPlayers = 12,
        regionLocalizedTimeInQueue = 1, -- default value is 120, override it by something small
        special = { universe = 1, minSizeWing = 3, minSizeTeam = 1, withBots = false, botPresetByTier = {"BotsBZS_T3","BotsBZS_T3","BotsBZS_T3","BotsBZS_T4","BotsBZS_T5"}, queueFlags = { universe = 1, rank = 15, }, },
        squadFilter = 0,
        qid = 502,
        levelsDesc = {
            s8256_thar_barrierdebris = {3},
            s1338_devilsjaw = {3},
            s1338_pandora_dreadnwreck = {3},
            s1340_thar_aliendebris13 = {3},
            s1340_thar_gasgiant = {3},
            s1420_ceres3_asteroidcity = {3},
            s1338_pandora_anomaly = {3},
            s8256_thar_concourse = {3},
            s8256_thar_lavastone = {3},
            desttown = {3}
        },
        query = { ["mmParams.universe"] = 1, ["mmParams.universe_arena"] = 1},
    }

    table.insert( queuesConfig, leagueQueue )
    table.insert( queuesConfigLo, leagueQueue )


	-- pve raid #0046436

	local raidQueue = {
		maxPlayers = 12,
		optimalPlayers = 12,
		minPlayers = 1,
		regionLocalizedTimeInQueue = 10,
		maxTimeInQueue = 10,
		levelsDesc = {},
		special = { pve_raid = 1, gameMode = 7, botsCount = 11 },
		query = { ["mmParams.pve_raid"] = 1 },
		--squadFilter = 4, -- wings only, now use cvar in shard mm_raidSquadFilter
	}

	table.insert( queuesConfig, raidQueue )
	table.insert( queuesConfigLo, raidQueue )

	--
	MatchMaker_ReconfigureQueues( queuesConfig )

	-- low online queues
	MatchMaker_ReconfigureQueues( queuesConfigLo, true )
	-- Switch to low online mode if online is less than this value. (type: integer)
	cvars.mm_lowOnlineLo = 250
	-- Exit low online mode if online is not less than this value. (type: integer)
	cvars.mm_lowOnlineHi = 300

	-- Number of bots. (type: integer; range: 0..31)
	-- Base number of bots; can be overridden in a specific queue.
	cvars.mm_botsCount = 16

	-- Basic game mode for a new gaming session; can be overridden in a specific queue.
	-- Possible values ​​(not all work):
	-- 0 - none
	-- 1 - space battle
	-- 2 - capture the flag
	-- 3 - capture the base
	-- 4 - control
	-- 5 - practice
	-- 6 - tutorial
	-- 7 - PvE mission
	-- 8 - free space
	-- 9 - sentinel
	-- 10 - king of the hill
	-- 11 - bomb the base
	-- 12 - TDM
	-- 13 - GTDM
	-- 14 - clanship
	-- 15 - capture the frag
	-- 16 - last man standing
	-- 17 - transport escort
	-- 18 - open space
	-- 19 - mission script
	-- 20 - PvP mission
	-- 21 - football
	-- 22 - battle royale
	-- 23 - capture the base 2
	-- 24 - hunger games
	-- 25 - one against all
	-- 26 - ATDM
	-- 27 - zombie
	-- 28 - close distance
	-- 29 - autogen DM
	-- 30 - three teams DM
	-- 31 - april control
	cvars.mm_defaultGameplay		= 3

	-- The larger the value, the smoother and slower the average queue time changes. (type: integer; range: 2..10000)
	-- 10 for dev/test, >100 for live
	cvars.mm_timeInQueueAveragingCf	= 200

	-- Multipliers of experience given by rank, list separated by commas. (type: string)
	-- reward multiplication rates
	cvars.rate_exp					= "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
	-- Multipliers of issued loans by rank, list separated by commas. (type: string)
	cvars.rate_cred					= "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"

	-- Decision-log detail inside the matchmaker. This is a bitmask: to include multiple categories, add their numbers together.
	-- 0 - disabled; 1 - basic PvP solutions; 2 - PvP join-in-progress; 4 - PvP candidates.
	-- 8 - coop; 16 - coop join-in-progress; 32 - PvE; 64 - universe; 128 - brawl; 256 - brawl candidates.
	-- 512 - hunger games; 1024 - one against all; 2048 - zombie; 4096 - three teams; 8192 - close distance; 16384 - general solutions.
	-- Example: 33 will enable the base PvP log and the PvE log (1 + 32). All categories: 32767.
	cvars.mm_decisionLog			= 0
	-- Method for outputting decision-log matchmaker.
	-- 0 - accumulate log lines and output them in one block to the info log after the parsing of records is completed.
	-- 1 - write each message directly to the debug log; convenient for online debugging, but can produce a lot of entries.
	cvars.mm_decisionDbg			= 0

	local reward_mult = {
		-- day = 0; Monday starts at 0
		[ 0 ] =
		{
			{ hourBegin = 0, hourEnd = 1, rateExp = "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1", rateCred = "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1", },
			{ hourBegin = 0, hourEnd = 3, rateExp = "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1", rateCred = "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1", },
			{ hourBegin = 2, hourEnd = 5, goldReward = 50 },
		},
		
		[ 6 ] =
		{
			{ hourBegin = 10, hourEnd = 13, goldReward = 100 },
		},
	}

	MatchMaker_SetRewardRates( reward_mult )
	
	
	-- pve mission schedule for player selection
	local pveSchedule =
	{
		rotatingLevels =
		{
			"pve_frozen_station",
			--"pve_jericho_base",
			--"pve_wave_nalnifan_gate_lumen",
			--"pve_wave_planet_war",
		--	"s1347_geostation",
		--	"s1515_piratebay",
			"s1550_pve_asteroid_building",
			"s1550_pve_bigship_building",
			"s1550_pve_bigship_building_2",
			"s1550_pve_capture_repairbase",
			"pve_desttown",
			"pve_stealth",
		},
		
		maxRotatingLevels	= 12,
		rotationTime		= 2 * 60 * 60,	--[sec]

		permanentLevels =
		{
			"pve_transit_emp_rock_frontier",
		},
	}
	MatchMaker_SetPveSchedule( pveSchedule )
	
end


function ConfigureAdventureServer()

  -- Enables/disables saving adventure-giver offers to the database. (type: boolean)
  -- at 1 - sentences are saved, at 0 - not saved
  cvars.adventure_saveGiverOffers = 0

end


--
function ConfigureScriptsServer()
	-- Whether the zone instance should communicate with the script server. (type: boolean)
	cvars.sv_enableCommunticationWithSS = 1

	-- Disables checking the format of Lua data (for example, playerLuaData zone) when converting and saving it to the database.
	-- 1 - data is recorded without checking the diagram; works only on non-live builds (test/debug).
	--cvars.dbg_disableLuaDataFormatChecking = 1
	
	--we pass the default settings to SS, for example “there is a “green war” event at the “hard” level”
	if ScriptsServer and ScriptsServer.ConfigureGlobalEvents then
						-- Green:
						--7 pre event
						--2nd possession
						--1 invasion
						--6 timer for invasion GREEN_PRE_EXPANSION
						--places of green capitals
--"ruinsbig_expanse_empty_tube_l_ow" 213 -- Abandoned complex - behind Jericho
--"wreck_emp_rock_02_r_ow" 11 -- Destroyed laboratory - empire - federation
--"miners_fed_rock_01_l_ow" 224 -- Northern mining station Federation Jericho

		ScriptsServer:ConfigureGlobalEvents( 
			{ 
			--Pre-event option

--[[ 				forceEvents = { -- 
					{
						-- ai.ZoneInstanceEvents.GREEN_PRE_EVENT
eventDefName = 7, -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
--disableCreate = true, -- don't create an event if it doesn't exist
--removeEvent = true, -- if there is an event, remove the event
eventLocation = 11, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
						newEventState = 1000,
						--newEventState = -100501, -- TIMEOUT_EVENT		= -100501, 
						--newEventState = 500,
--eventParams = { }, -- which parameters to overwrite
					},
					{
						eventDefName = 7, --
						newEventState = 1000,
eventLocation = 213, -- to which location
					},
					{
						eventDefName = 7, --
						newEventState = 1000,
eventLocation = 224, -- to which location
					},
				}, ]]

--Option "to start"
--[[
				forceEvents = { -- 
					{
						-- ai.ZoneInstanceEvents.GREEN_OWNERSHIP
eventDefName = 2, -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
--disableCreate = true, -- don't create an event if it doesn't exist
--removeEvent = true, -- if there is an event, remove the event
eventLocation = 11, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
						newEventState = 1000,
						--newEventState = -100501, -- TIMEOUT_EVENT		= -100501, 
						--newEventState = 500,
--eventParams = { }, -- which parameters to overwrite
					},
					{
						eventDefName = 2, --
						newEventState = 1000,
eventLocation = 213, -- to which location
					},
					{
						eventDefName = 2, --
						newEventState = 1000,
eventLocation = 224, -- to which location
					},
				},
]]
--Option "to start" with counterattacks (not ready for November) --!!!
--[[
				forceEvents = { -- 
					{
						-- ai.ZoneInstanceEvents.GREEN_OWNERSHIP
eventDefName = 2, -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
--disableCreate = true, -- don't create an event if it doesn't exist
--removeEvent = true, -- if there is an event, remove the event
eventLocation = 11, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
						newEventState = 1000,
						--newEventState = -100501, -- TIMEOUT_EVENT		= -100501, 
						--newEventState = 500,
--eventParams = { }, -- which parameters to overwrite
					},
					{
						eventDefName = 2, --
						newEventState = 1000,
eventLocation = 213, -- to which location
					},
					{
						eventDefName = 2, --
						newEventState = 1000,
eventLocation = 224, -- to which location
					},
					
					{
eventDefName = 8,--8=counterattack control -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
						--removeEvent 	= true,
eventLocation = 1, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
eventParams = { -- which parameters to overwrite
						},
					},
				},
--]]
			
-- my debug
				--[[
				forceEvents = { -- 
					{
						-- ai.ZoneInstanceEvents.GREEN_PRE_EVENT
eventDefName = 7, -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
--disableCreate = true, -- don't create an event if it doesn't exist
--removeEvent = true, -- if there is an event, remove the event
eventLocation = 11, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
						--newEventState = -100501, -- TIMEOUT_EVENT		= -100501, 
						--newEventState = 500,
eventParams = { -- which parameters to overwrite
							},
					},
					{
eventDefName = 2, -- --2 possession Abandoned complex -- outside Jericho
						newEventState = 1000,
eventLocation = 213, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
					},
					{
eventDefName = 1, -- 1 invasion -- Northern Mining Station Federation Jericho
eventLocation = 224, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
					},
--104 -- Wasteland -- empire - federation near 11
-- preparing for invasion 6 GREEN_PRE_EXPANSION Wasteland
					{
eventDefName = 6, -- preparing for invasion 6 GREEN_PRE_EXPANSION -- Northern mining station Jericho Federation
eventLocation = 104, -- to which location
newEventState = 60*60*3, -- 3 hours
					},

					{
eventDefName = 8,--8=counterattack control -- event def -- if not, it will be created, if there is, then the mentioned numbers are modified
						--removeEvent 	= true,
eventLocation = 1, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
eventParams = { -- which parameters to overwrite
						},
					},

					{ --  234
eventDefName = 9, -- the empire is preparing to invade
newEventState = 60*60*3, -- 3 hours
						eventLocation = 234,	--
					},
					
{ -- the empire invades
eventDefName = 12, -- --2 possession Abandoned complex -- outside Jericho
						newEventState = 400, 
eventLocation = 212, -- to which location (25 catchment-pvp between federation - empire) 231 - starting
					},
				},
				]]
			})
		--sys.log("test out2")
		-- ScriptsServer:ConfigureGlobalEvents( { forceEvents = { { eventDefName = 4, eventLocation = 247, newEventState = 998, } } })
		ScriptsServer:SetTimerScale( 1 ) 
		--ScriptsServer:OnSetTimerScale( 60 * 60 ) --60 * 60 1 second= 1 hour || Not all options support acceleration.
	end
end


--
function ConfigureDediServer()
	-- Limits FPS to this value; 0—restriction disabled. (type: fractional number)
	cvars.cl_maxFps = 18

	-- Debugging connection to an already ongoing battle. (type: boolean)
	cvars.sv_dbgJoinInProgress			= 0
	-- Logging combat events to a log file; each level includes all previous ones.
	-- 0 - disabled; 1 - kills/deaths/rewards; 2 - +use of modules, missiles and auras.
	-- 3 - +all damage; 4 - +coefficients of gameplay aura parameters.
	cvars.cl_combatLog					= 0
	-- Database protocol logging: 1 - short, 2 - full. (type: integer)
	-- to catch some nasty stuff
	cvars.db_logMessages				= 0
	-- Overrides the game's respawn time penalty for death setting. (type: fractional number)
	-- to use gameplaysettings values
	cvars.sv_respawnTimePenalty			= -1
	-- Time in seconds after which a player kicks for AFK if he did not send control inputs or they did not change.
	-- A high value (eg 3600) actually disables AFK kick. (type: fractional number)
	cvars.sv_afkCheckDuration			= 120
	-- Enables/disables post-battle loot. (type: boolean)
	--
	cvars.sv_lootEnabled				= 1
	-- Chances are you won't find anything. (type: fractional number; range: 0.0f..1.0f)
	cvars.sv_lootFailChance				= 0.0
	-- Scan time in seconds. (type: fractional number)
	cvars.sv_lootScanTime				= 1
	-- Duration of the loot collection stage. (type: fractional number)
	cvars.sv_lootDuration				= 120

	-- SC-112454 seed chips
	cvars.sv_autogenModulesEnabled 		= 1
	-- Where to show seed chips: 1 - only in the game, 2 - in the game and in the hangar.
	-- 1 - in the game, 2 - in the game and in the hangar. (type: integer)
	cvars.sv_dbgAutogenDefs 			= 2

	-- The coefficient of the usual salvage conversion of a found loot item into tokens.
	-- The refund is calculated from the tokenPrice of the item: tokensRefund = tokenPrice * sv_salvageTokenConversion. (type: fractional number)
	cvars.sv_salvageTokenConversion		= 0.2
	-- Premium salvage conversion rate of a found loot item into tokens.
	-- The premium option requires payment in premium currency and returns tokens using the formula: tokensRefund = tokenPrice * sv_salvagePremiumTokenConversion. (type: fractional number)
	cvars.sv_salvagePremiumTokenConversion	= 0.6
	-- Premium salvage cost coefficient for a found loot item.
	-- The price of the premium option is calculated from the regular price of the item: premiumPrice = price * sv_salvagePremiumPriceConversion. (type: fractional number)
	cvars.sv_salvagePremiumPriceConversion = 0.0008

	-- Reward coefficient for BFS battle wing vs wing. (type: fractional number; range: 1.0f..10.0f)
	cvars.sv_universeWingVsWingRewardCf = 2.0
	-- Forced mode of ship control. (type: integer; range: -1..5)
	-- Values: -1 — do not force; 0 — FOLLOWING; 1 - COMBINED; 2 - LOCAL_TURRET; 3 - REMOTE_TURRET; 4 - LANDED; 5 - WOW.
	cvars.ship_controlForceMode			= -1
	-- A special mode for rotating the UFO ship along the X axis.
	-- UFO ship controls
	cvars.ship_ufoRotateX = 1
	-- Enables/disables game achievements. (type: boolean)
	cvars.sv_achievementEnabled			= 1
	-- Minimum interval for sending player progress to the achievement server, in seconds. (type: fractional number)
	cvars.sv_achievProgressTimer		= 3

	-- Includes the Cosmonautics Day event. (type: boolean)
	-- EVENTS
	cvars.event_cosmonauticsDay	 		= 0
	-- Includes the Game Anniversary event. (type: boolean)
	cvars.event_gameAnniversary			= 0
	-- Includes the February 23rd event. (type: boolean)
	cvars.event_february23				= 0
	-- Includes the March 8th event. (type: boolean)
	cvars.event_march8					= 0
	-- Includes an event with the bot prefix. (type: boolean)
	cvars.event_botPrefix				= 0
	-- Enables the Claws event. (type: boolean)
	cvars.event_claws					= 0
	-- Includes the Knowledge Day event. (type: boolean)
	cvars.event_knowledgeDay			= 0
	-- Includes the Halloween event. (type: integer)
	cvars.event_halloween				= 0
    -- Enables PvP invasion event. (type: boolean)
    cvars.event_invasionPVP				= 0
	-- Includes the Valentine's Day event. (type: boolean)
	cvars.event_valentinesDay 			= 0
	-- Enables AI logic for ships. (type: boolean)
	--DEBUG
	cvars.ship_aiThink					= 1
	-- Free synergy reward coefficient. (type: fractional number)
	cvars.sv_freeSynergyRewardCf		= 0.05
	-- Free synergy reward coefficient for a premium ship. (type: fractional number)
	cvars.sv_freeSynergyRewardCfPremiumVessel	= 0.2
	-- Additional synergy experience coefficient for kill/assist with gold munition. (type: fractional number)
	cvars.sv_goldMunitionExpRewardCf	= 1.0

	-- Time budget for Lua GC incremental work, in microseconds. (type: integer)
	cvars.script_gcWorkBudget			= 1

  	-- Experience multiplier for the first PvE victory of the day. (type: fractional number)
	-- x3 FIRST WIN
  	cvars.sv_dailyWinPveExpRewardCf	 	= x3fw
	-- Experience multiplier for the first PvP victory of the day. (type: fractional number)
	cvars.sv_dailyWinPvpExpRewardCf		= x3fw
  	-- Experience multiplier for the first co-op victory of the day. (type: fractional number)
  	cvars.sv_dailyWinCoopExpRewardCf	= x3fw
  	-- Experience multiplier for the first brawl victory of the day. (type: fractional number)
  	cvars.sv_dailyWinBrawlExpRewardCf 	= x3fw

  	-- Chance of issuing an event-label (marking a ship as an event agent for the player) for PvP battles.
  	-- Specified by rank as a list of 18 fractional numbers from 0 to 1; the first number is for rank 1, the second is for rank 2, etc. (type: string)
  	cvars.sv_pvpLabelChances			= "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
    -- Same as sv_pvpLabelChances, but for PvE missions and raids. (type: string)
    cvars.sv_pveLabelChances			= "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"

 	-- The number of attempts to select a rare loot table with floating odds. (type: integer)
 	-- rare_limit
 	cvars.sv_rarePicksNumberWithFloatingChances = 100
    -- The number of attempts to select an epic loot table with floating odds. (type: integer)
    -- epic_limit
    cvars.sv_epicPicksNumberWithFloatingChances = 150
    -- Base chance to select rare loot table. (type: fractional number)
    cvars.sv_overlootedRarePickChance = 0.2
    -- Base chance to select epic loot table. (type: fractional number)
    cvars.sv_overlootedEpicPickChance = 0.05
    -- Base chance to select a common loot table. (type: fractional number)
    -- common_default_weight
    cvars.sv_lootCommonPickChance = 0.95
  	-- Limits the rare and epic loot tables to only ships of the maximum level. (type: boolean)
  	-- max rank ships for loot
  	cvars.sv_lootMaxLevelRestriction = 0

	-- Multiplier A in the selection weight formula of the rare/epic loot table. (type: fractional number)
	cvars.sv_lootRuleCfA = 0.25
	-- Base weight B (free member) in the weight formula of the rare/epic loot table. (type: fractional number)
	cvars.sv_lootRuleCfB = 0.25
	-- Shift offset: adjusts the attempts threshold from which the rare/epic floating chance begins to grow. (type: fractional number)
	-- Formula: weight = max(0, sv_lootRuleCfA * (attempts - (it + sv_lootRuleCfOffset)) + sv_lootRuleCfB).
	-- attempts - number of attempts without rare/epic; it is the threshold from iter in the loot rule for the current issue.
	cvars.sv_lootRuleCfOffset = -1

	-- Path to save the replay dedicated server. (type: string)
	cvars.sv_autorecordReplaysTo = ""
	
	-- Start time of the custom event. (type: string)
	-- "It is necessary to change the start and end times in multiples of an hour, otherwise the imaginary quest may behave
	cvars.event_custom 			= event_custom
	
	
	DedicatedServcerServices_SetLootRules(
	{
	-- ranks
	[1] = { common = { lt = "CommonRanks_1_3_v3", iter = { 0 } }, rare = { lt = "RareT1", iter = { 3,5,12,12,12,12,12,12,12,30,50 } }, epic = { lt = "RareT1", iter = { 100000, 100000 } } },
	[2] = { common = { lt = "CommonRanks_1_3_v3", iter = { 0 } }, rare = { lt = "RareT1", iter = { 4,3,11,11,11,11,11,11,11,30,50 } }, epic = { lt = "RareT1", iter = { 100000, 100000 } } },
	[3] = { common = { lt = "CommonRanks_1_3_v3", iter = { 0 } }, rare = { lt = "RareT1", iter = { 5,4,10,10,10,10,10,10,10,30,50 } }, epic = { lt = "RareT1", iter = { 100000, 100000 } } },
	[4] = { common = { lt = "CommonRanks_4_6_v3", iter = { 0 } }, rare = { lt = "RareT2", iter = { 6,12,12,14,12,14,12,14,12,30,50 } }, epic = { lt = "RareT2", iter = { 100000, 100000 } } },
	[5] = { common = { lt = "CommonRanks_4_6_v3", iter = { 0 } }, rare = { lt = "RareT2", iter = { 7,11,13,12,15,12,14,12,13,30,50 } }, epic = { lt = "RareT2", iter = { 100000, 100000 } } },
	[6] = { common = { lt = "CommonRanks_4_6_v3", iter = { 0 } }, rare = { lt = "RareT2", iter = { 8,10,12,15,12,12,15,12,12,30,50 } }, epic = { lt = "RareT2", iter = { 100000, 100000 } } },
	[7] = { common = { lt = "CommonRanks_7_8_v3", iter = { 0 } }, rare = { lt = "RareT3Mono", iter = { 9,14,14,15,14,14,14,15,25,40,50 } }, epic = { lt = "RareT3", iter = { 100000, 100000 } } },
	[8] = { common = { lt = "CommonRanks_7_8_v3", iter = { 0 } }, rare = { lt = "RareT3Mono", iter = { 10,15,14,15,15,14,15,15,26,40,50 } }, epic = { lt = "NeodiumDrop", iter = { 5,7,10,12,18,24,36,36,36,36 } } },
	[9] = { common = { lt = "CommonRanks_9_10_v3", iter = { 0 } }, rare = { lt = "RareT3Mono", iter = { 11,14,15,14,14,15,14,18,29,40,50 } }, epic = { lt = "RareT3", iter = { 100000, 100000 } } },
	[10] = { common = { lt = "CommonRanks_9_10_v3", iter = { 0 } }, rare = { lt = "RareT4Mono", iter = { 12,18,16,18,16,18,16,18,20,40,50 } }, epic = { lt = "RareT4", iter = { 100000, 100000 } } },
	[11] = { common = { lt = "CommonRanks_11_12_v3", iter = { 0 } }, rare = { lt = "RareT4Mono", iter = { 13,17,17,18,17,18,17,18,20,40,50 } }, epic = { lt = "LezortiumDrop", iter = { 7,8,11,13,15,28,35,37,37,37 } } },
	[12] = { common = { lt = "CommonRanks_11_12_v3", iter = { 0 } }, rare = { lt = "RareT4Mono", iter = { 14,16,18,16,18,17,18,19,20,40,50 } }, epic = { lt = "RareT4", iter = { 100000, 100000 } } },
	[13] = { common = { lt = "CommonRanks_13_15_v3", iter = { 0 } }, rare = { lt = "RareT5Mono", iter = { 12,19,20,21,20,20,21,20,30,40,50 } }, epic = { lt = "RareT5", iter = { 100000, 100000 } } },
	[14] = { common = { lt = "CommonRanks_13_15_v3", iter = { 0 } }, rare = { lt = "RareT5Mono", iter = { 13,20,21,20,20,22,20,23,32,40,50 } }, epic = { lt = "RareT5", iter = { 100000, 100000 } } },
	[15] = { common = { lt = "CommonRanks_13_15_v3", iter = { 0 } }, rare = { lt = "RareT5Mono", iter = { 14,21,20,20,21,20,21,20,35,40,50 } }, epic = { lt = "RareT5", iter = { 100000, 100000 } } },
	}
	)

	-- list of prohibited equipment (ships and modules) in leagues; uncomment and fill in if necessary
	--DedicatedServerServices_SetupLeagueForbiddenEquipment( leagueForbiddenDefs )

	-- list of prohibited defs for adaptive bot presets
	_G.DedicatedServerServices_SetupBotPresetForbidden( botPresetForbiddenDefs )

	-- Should players be kicked out of battle if there are more bots than players?
	cvars.sv_kickExcessiveBotsEnabled = 1

	-- The number of best players whose ships are saved for adaptive presets; -1 - all players and all ships. (type: integer; range: -1..MAX_PLAYERS)
	-- number of saving the best players SC-115316
	cvars.sv_numBestPlayerToSave = 2
	-- Minimum ship efficiency for saving adaptive presets to the database. (type: integer)
	-- minimum number of points to save the best player's ship preset
	cvars.sv_minEfficiencyVesselToSave = 1500
	-- Limit of records of adaptive presets in the database for mode, rank and role; 0 clears the database.
	cvars.sv_numAdaptivePresetsInDB = numAdaptivePresets
	-- Limit from 0 to 100 for reading from the database of adaptive presets for the rank and role of the game mode. (type: integer; range: 0..100)
	-- how many unique presets does Dedik request from the database?
	cvars.sv_numUniqueAdaptivePresets = 20
	-- The range of ranks is from 0 to MAX_SHIP_RANK for reading from the adaptive presets database. (type: integer; range: 0..MAX_SHIP_RANK)
	-- the difference between the requested ranks of presets from the database and the maximum rank of the queue (if the maximum rank is 12, then with a color of 3, the minimum rank will be 9)
	cvars.sv_rangeRankAdaptivePresets = 3
	
	-- Reward multiplier for the case when the player left previous games. (type: fractional number; range: 0.0f..1.0f)
	-- reward coefficient. Default is 1 (no penalty).
	cvars.sv_leaveFineRewardCoef = 0.8
  	-- Maximum reduction in the combat exit counter. (type: integer; range: 0..INT_MAX)
  	-- the maximum value by which the Liv counter can be reduced when a player receives a penalty (Liv counter is greater than one. Default is 3. Integer.
  	cvars.sv_leaveCounterMaxDecay = 4
  	-- Reduce leaveCounter if the player did not receive a penalty. (type: fractional number; range: 0.0f..FLT_MAX)
  	-- the value by which the counter is reduced when the player does not receive a penalty (the counter is less than one). Default is 0.1.
  	cvars.sv_leaveCounterDecayWithoutFine = 0.9
  	-- Adds this value to leaveCounter if the player left the game normally. (type: fractional number)
  	-- the value by which the counter is increased when leaving the battle normally (clicked on the “Left the battle” button). Default is 0.5.
  	cvars.sv_normalLeaveCounterAdd = 0
  	-- Adds this value to leaveCounter if the player left the game abnormally. (type: fractional number)
  	-- the value by which the counter is increased in the event of an abnormal output (the client has fallen, the network has disappeared). Default is 0.
  	cvars.sv_abnormalLeaveCounterAdd = 0
  
  	-- Adds this value to leaverReputation if the player has been leftr-banned. (type: fractional number; range: 0.0f..100.0f)
  	-- [0, 100], default 1. This value is added to leaverReputation when a player gets banned.
  	cvars.sv_leaverReputationAdd = 1
	-- Minimum battle-ban time with a penalty for leaving, in seconds. (type: fractional number; range: 0.0f..1800.0f)
	-- [0, 1800], default 300. Time for which a player is banned from entering battle, in seconds.
	cvars.sv_leaverBanTime = 0
	-- Reduced leaverReputation if the player does not leave the game. (type: fractional number; range: 0.0f..FLT_MAX)
	-- default 0.01. leaverReputation is reduced by this amount when the player does not pour.
	cvars.sv_leaverReputationDecay = 0.9
end

--
function ConfigureDediServerFlags( queueFlags )

	-- SC-112454 seed chips
	cvars.sv_autogenModulesEnabled 		= 1
	-- Where to show seed chips: 1 - only in the game, 2 - in the game and in the hangar.
	-- 1 - in the game, 2 - in the game and in the hangar. (type: integer)
	cvars.sv_dbgAutogenDefs 			= 2


	if queueFlags.newbie ~= nil and queueFlags.newbie then
		-- Overrides the game's respawn time penalty for death setting. (type: fractional number)
		cvars.sv_respawnTimePenalty = 0
	end

	if queueFlags.rank ~= nil then
		-- Match combat rank; is transferred to the battle parameters and affects ranking restrictions.
		cvars.sv_mmBattleRank = queueFlags.rank
	end
end


--
function ConfigureZoneInstance()
	-- restart cloud after changing these cvars

	-- Limits FPS to this value; 0—restriction disabled. (type: fractional number)
	cvars.cl_maxFps = 18
	
	-- Enables AI logic for ships. (type: boolean)
	cvars.ship_aiThink					= 1
	-- Logging combat events to a log file; each level includes all previous ones.
	-- 0 - disabled; 1 - kills/deaths/rewards; 2 - +use of modules, missiles and auras.
	-- 3 - +all damage; 4 - +coefficients of gameplay aura parameters.
	cvars.cl_combatLog					= 0
	-- Weapon damage coefficient. (type: fractional number; range: 0.0f..FLT_MAX)
	cvars.sv_shipWeaponDamageCoef		 = 1

	-- Minimum time to respawn an event object. (type: fractional number)
	cvars.sv_eventObjectRespawnTimeMin = 60
	-- Maximum respawn time of an event object. (type: fractional number)
	-- set a range for randomly selecting the delay for the first and subsequent creations of an object.
	cvars.sv_eventObjectRespawnTimeMax = 420
	-- Event object shutdown time. (type: string)
	-- the time after which the event object is no longer created.
	cvars.sv_eventObjectEndTime = "2026-04-10T05:00:00Z"

  	-- Enables the Claws event. (type: boolean)
		-- April 1
  	cvars.event_claws 					= 0

	-- Conversion rate of selected loot into clan resource. (type: fractional number)
	-- 0.1 rate of conversion of the number of loot lifts to corporate iridium
	cvars.sv_pickedLootRateToClanResource = 0.1
	-- Time to update the selected loot. (type: fractional number)
	-- interval of sending iridium to the corpus in seconds.
	cvars.sv_pickedLootUpdateTime 		= 6 * 3600

	-- Disables Lua data format checking when converting and saving to the database. 1 - data is recorded without checking the diagram; only for non-live builds.
	--cvars.dbg_disableLuaDataFormatChecking = 1
	
	-- Portal timer to a station in outer space.
	cvars.sv_spaceStationPortalTimer = 3
	
	-- SC-112454 seed chips
	cvars.sv_autogenModulesEnabled 		= 1
	-- Where to show seed chips: 1 - only in the game, 2 - in the game and in the hangar.
	-- 1 - in the game, 2 - in the game and in the hangar. (type: integer)
	cvars.sv_dbgAutogenDefs 			= 2
	
	-- Whether the zone instance should communicate with the script server. (type: boolean)
	cvars.sv_enableCommunticationWithSS = 1

	-- Rank difference intervals for damage scaling, comma separated list. (type: string)
	-- how much Rplayer - Rmob
	cvars.sv_ranksDiff 		= "-5, -2, 0, 2, 5, 10"
	-- Damage scaling factors in OW by rank difference, list separated by commas. (type: string)
	-- figures "in ranges" of the previous table
	cvars.sv_ranksDiffCoeff = "-0.5, 0.2, 0.5, 0.6, 0.7, 0.8, 1"

	-- Whether to show scaling options. (type: boolean)
	cvars.dbg_logRankDiffScaling = 0

	-- Log squad information: 1 - spawn, 2 - movement, 3 - battle, 5 - everything. (type: integer)
	cvars.ai_logSquads 					= 5
	
	-- Distance between the player and the despawn point. (type: fractional number)
	cvars.ai_convoyDefendRadius 		= 300
	-- Loot crate scanning time in outer space.
	cvars.sv_lootCrateScanTime 			= 1
	-- The maximum distance an AI squad can move away from the starting point when pursuing an enemy. (type: fractional number)
	cvars.ai_kiteDistance 				= 5000

  	-- Experience multiplier for the first PvE victory of the day. (type: fractional number)
	-- x3 FIRST WIN
  	cvars.sv_dailyWinPveExpRewardCf	 	= x3fw
	-- Experience multiplier for the first PvP victory of the day. (type: fractional number)
	cvars.sv_dailyWinPvpExpRewardCf		= x3fw
  	-- Experience multiplier for the first co-op victory of the day. (type: fractional number)
  	cvars.sv_dailyWinCoopExpRewardCf	= x3fw
    -- Experience multiplier for the first brawl victory of the day. (type: fractional number)
    cvars.sv_dailyWinBrawlExpRewardCf 	= x3fw

	-- The player receives the aggressor status after this amount of damage to a non-player target. (type: fractional number)
	cvars.sv_aggressorMinNPCDamage		= 3000
	-- The maximum value of the aggressor flag timer. (type: fractional number)
	cvars.sv_aggressorTimer				= 30

	-- The cost of resurrecting a player in credits.
	cvars.sv_resurrectionCreditsPrice   = 100000

	-- After this time, the zone instance will be closed if there are no clients in it, in seconds. (type: fractional number)
	cvars.sv_instanceLifeTime			= 720
	
	-- Free synergy reward coefficient. (type: fractional number)
 	-- OW synergy
	cvars.sv_freeSynergyRewardCf					= 0.05
	-- Free synergy reward coefficient for a premium ship. (type: fractional number)
	cvars.sv_freeSynergyRewardCfPremiumVessel		= 0.20

	-- Replacement of mastery ship for free space, list by rank separated by commas. (type: string)
	cvars.sv_freeSpaceExpMastery	= "1.95,1.95,1.95,1.95,1.95,1.95,1.95,2.35,2.575,3.04,3.4,3.64,3.915,4.045,4.1,4.1,4.1,4.1"
    -- Multiplier of experience given by rank, comma separated list. (type: string)
    cvars.sv_expRate				= "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
  	-- Allows the issuance of experience to a ship for combat operations in Free Space.
  	-- 0 - for no one, 1 - only for premium players, 2 - for all players. Additionally, experience is limited by zone rank and sv_freeSpaceExpCap. (type: integer)
  	cvars.sv_freeSpaceExpRewards		= 2

  	-- Give out experience for damage in Free Space. (type: boolean)
	-- Fast Synergy Gain
  	cvars.sv_expForDamageFreeSpace = 0

	-- Def-name of loot crate, which is used by the random loot system in Free Space.
	-- The specified def must be an entity of type LootCrate and have the isRare attribute; otherwise random loot in the zone will be disabled with an error in the logs. (type: string)
	cvars.sv_randomLootDef 				= "LootCrate_Craft_paradise_Weapon20"

	-- Time in seconds after which a player kicks for AFK if he did not send control inputs or they did not change.
	-- A high value (eg 3600) actually disables AFK kick. (type: fractional number)
	cvars.sv_afkCheckDuration			= 3600

	-- Enables the "Invasion with beacons" event. (type: boolean)
	-- #57052
	cvars.event_invasionWithBeacons	 	= 0

	-- Chances of issuing labels to ships by rank; the line contains 18 values.
	cvars.sv_owLabelChances				= "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"

	-- A special mode for rotating the UFO ship along the X axis.
	-- UFO ship controls
	cvars.ship_ufoRotateX = 1
	
	DedicatedServerServices_SetIterativeLoot({
    [ 'wreck_generic_rock_03_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_4_ranks_2_3", dropCounter = 1}, },
    [ 'ruinsdread_emp_rock_captured_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_16_ranks_3_4", dropCounter = 1}, },
    [ 'asteroids_wild_rock_02_c_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_28_ranks_4_4", dropCounter = 1}, },
    [ 'wreck_generic_rock_01_u_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_40_ranks_4_5", dropCounter = 1}, },
    [ 'transit_emp_rock_frontier_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_52_ranks_5_5", dropCounter = 1}, },
    [ 'shipyard_emp_empty_blackwood_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_64_ranks_5_6", dropCounter = 1}, },
    [ 'service_emp_rock_01_u_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_76_ranks_6_6", dropCounter = 1}, },
    [ 'wreck_emp_rock_02_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_88_ranks_6_6", dropCounter = 1}, },
    [ 'ruinsbig_emp_rock_wardenhub_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_100_ranks_6_7", dropCounter = 1}, },
    [ 'ruinssmall_emp_lava_expedition_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_112_ranks_7_7", dropCounter = 1}, },
    [ 'anomalyhot_wild_lava_pandora_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_124_ranks_7_7", dropCounter = 1}, },
    [ 'ruinsalien_precursor_stone_devilsjaw_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_136_ranks_7_8", dropCounter = 1}, },
    [ 'hub_emp_rock_northstar_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_148_ranks_8_8", dropCounter = 1}, },
    [ 'factory_emp_rock_planetwar_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_160_ranks_8_8", dropCounter = 1}, },
    [ 'factory_emp_iridium_alpha_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_172_ranks_8_8", dropCounter = 1}, },
    [ 'ruinssmall_fed_rock_storage_u_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_184_ranks_8_9", dropCounter = 1}, },
    [ 'miningstation_emp_rock_velorum_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_196_ranks_9_9", dropCounter = 1}, },
    [ 'shipyard_fed_rock_waterharvest_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_208_ranks_9_9", dropCounter = 1}, },
    [ 'transit_fed_rock_frontier_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_220_ranks_9_9", dropCounter = 1}, },
    [ 'asteroids_wild_rock_07_c_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_232_ranks_9_10", dropCounter = 1}, },
    [ 'asteroids_wild_rock_04_c_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_244_ranks_10_10", dropCounter = 1}, },
    [ 'ruinsdread_emp_ice_icebelt_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_256_ranks_10_10", dropCounter = 1}, },
    [ 'hangar_fed_rock_colony_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_268_ranks_10_11", dropCounter = 1}, },
    [ 'survey_fed_ice_olimp_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_280_ranks_11_11", dropCounter = 1}, },
    [ 'miners_fed_rock_01_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_292_ranks_11_11", dropCounter = 1}, },
    [ 'ruinssmall_jer_rock_storage_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_304_ranks_12_12", dropCounter = 1}, },
    [ 'ruins_jer_rock_station_u_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_316_ranks_12_12", dropCounter = 1}, },
    [ 'hub_jer_rock_terramorph_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_328_ranks_12_12", dropCounter = 1}, },
    [ 'asteroids_wild_rock_08_c_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_340_ranks_12_13", dropCounter = 1}, },
    [ 'asteroids_wild_rock_09_c_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_352_ranks_13_13", dropCounter = 1}, },
    [ 'mininggas_jer_rock_01_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_364_ranks_13_13", dropCounter = 1}, },
    [ 'survey_jer_rock_pallada_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_376_ranks_13_14", dropCounter = 1}, },
    [ 'storage_jer_rock_pallada_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_388_ranks_14_14", dropCounter = 1}, },
    [ 'ruinsalien_precursor_iridium_spheres_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_400_ranks_14_14", dropCounter = 1}, },
    [ 'ruinsalien_precursor_rock_lavastone_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_412_ranks_14_15", dropCounter = 1}, },
    [ 'ruinsalien_precursor_rock_barrier_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_424_ranks_15_15", dropCounter = 1}, },
    [ 'ruinsalien_precursor_rock_tower_r_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_436_ranks_15_15", dropCounter = 1}, },
    [ 'ruinsalien_crystal_empty_temple_l_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_448_ranks_15_15", dropCounter = 1}, },
    [ 'mininghub_jer_rock_frontier_e_ow' ] = { [ 1 ] = { lootCrate = "LootCrate_Loot_460_ranks_15_17", dropCounter = 1}, },
    })

  	-- Damage coefficient against friendly faction entities. (type: fractional number; range: 0.0f..1.0f)
	 ---SC-113076 pirate event
  	-- coefficient of damage to friendly factions in MP, this parameter affects damage, the rest only affect the ratio
  	cvars.sv_frendlyFactionDamageCoef			= 0.25
	
	-- The player becomes an enemy of the faction after this amount of damage to a non-player faction target. (type: fractional number)
	-- the value of the damage counter, after which the faction becomes an enemy to the player
	cvars.sv_enemyMinFactionNPCDamage			= 6
	-- The time for which a player’s relationship with a faction deteriorates after damage to its NPC.
	-- time in seconds during which the faction will be an enemy to the player
	cvars.sv_factionBadRelationshipTime			= 45
	
	-- Maximum amount of damage for a faction relationship group; does not affect actual damage to entities. (type: fractional number)
	-- maximum player damage counter value
	cvars.sv_enemyMaxFactionNPCDamage			= 100
	-- Maximum damage per second for a faction relationship group; does not affect actual damage to entities. (type: fractional number)
	-- limiting the damage counter accumulated per second
	cvars.sv_enemyMaxFactionNPCDamagePerSec		= 1
	-- The rate of reduction of accumulated damage for faction NPCs for calculating hostility.
	-- decrease damage counter per second
	cvars.sv_factionNPCDamageDecay				= 0.2

	-- Path to save the replay dedicated server. (type: string)
	cvars.sv_autorecordReplaysTo = ""
end


--
function ConfigureGRD()
	-- If set, adds bonus gold to the winners of the battle. (type: integer)
	cvars.reward_bonusGoldForWinner		= 0
	-- If set, adds bonus gold to the losers of the battle. (type: integer)
	cvars.reward_bonusGoldForLooser		= 0

	-- The event period is “gold for the first and fifth win” in the format 2013-04-12T12:00:00Z;2013-04-13T12:00:00Z. (type: string)
	-- event 'gold for first and fifth win'
	cvars.reward_eventGoldTimePeriod = "2025-09-02T12:00:00Z;2025-09-11T06:00:00Z"
	-- The size of the event reward “gold for the first and fifth win” in the format is 500;0;0;0;5000. (type: string)
	cvars.reward_eventGoldTimeValue	= "0;0;0;0;50;0;0;0;0;100;0;0;0;0;150;0;0;0;0;200"

	-- Includes scheduler. (type: integer)
	cvars.cron_enabled					= 1

	-- Start time of the event with credits. (type: string)
	cvars.store_creditsEventStart		= creditsEventStart
	-- End time of the event with credits. (type: string)
	cvars.store_creditsEventEnd			= creditsEventEnd
  
	-- Daily limit of token credits that a player can earn per day.
	cvars.sv_tokenCreditsDailyLimit = 1000
  
	-- Maximum value of leaveCounter. (type: fractional number; range: 0.0f..FLT_MAX)
    -- SC-113769
	cvars.reward_leaveCounterMax = 12
end


--
function ConfigureLoadBalancer()
	-- Enabling it denies access to the server. (type: integer)
	cvars.lb_disallowAccess				= 0

	-- Maximum number of players per shard. (type: integer)
	cvars.lb_limitPlayersOnShardTo		= 800

	-- The average queuing time does not fall below this value. (type: fractional number)
	cvars.lb_avgTimeMinClamp			= 10
	-- When calculating the average time, the number of last players in the queue is taken into account. (type: integer)
	cvars.lb_avgTimeAveragingCf			= 10

	-- Load Balancer Option: Limits latency and queue length on shard.
	cvars.lb_minNextPlayerDelay			= 0.05
	-- Load Balancer Option: Limits latency and queue length on shard.
	cvars.lb_maxTaskQLenOnShard			= 500
  
    -- x3 FIRST WIN
  	LoadBalancer_SetGreetingMessageCVars( { sv_dailyWinPveExpRewardCf = x3fw, sv_dailyWinPvpExpRewardCf = x3fw, sv_dailyWinCoopExpRewardCf = x3fw,
		sv_dailyWinBrawlExpRewardCf = x3fw, mss_playerBoughtVesselAdLoBrace = -4, mss_playerBoughtVesselAdHiBrace = 4, mss_playerBoughtVesselAdCooldown = 20,
		cl_showBiomorphsKilledCounter = 0, clan_shipPartsCanBuild = 4, clan_shipUpgradeCanBuild = 3, clan_shipBuildHighRanks  = 3, event_claws = 0,
		event_halloween = 0, } )
end


--
function ConfigureChatServer()
	-- Duration of the offender's ban. (type: integer)
	cvars.antispam_autobanSec					= 60

	-- Awareness threshold, when exceeded, the player is automatically banned from the chat.
	-- Awareness is a cumulative indicator of the level of spam: it increases if the player writes often and repeats, and gradually decreases over time during breaks. (type: integer)
	cvars.antispam_autobanAwareness				= 500

	-- Awareness threshold for notifying the user that spam has stopped. (type: integer)
	cvars.antispam_notifyAwareness				= 450

	-- Enables sending of extended notification. (type: integer)
	cvars.antispam_notifyExtended				= 0

	-- Decreases by this value per second. (type: fractional number)
	cvars.antispam_awarenessDecay				= 10

	-- Numerator A in the formula for awareness growth by message frequency: growth = A / dt.
	-- dt - time in seconds since the last message (minimum 0.5 sec); A larger A means awareness grows faster with frequent messages. (type: fractional number)
	cvars.antispam_awarenessIntervalNumerator	= 40

	-- Coefficient K in the formula for increasing awareness by message similarity: increase = K * similarity ^ P. (type: fractional number)
	-- The increase is accrued with each new message.
	-- similarity - the proportion of the text of the current message that matches the previous ones: the sum of the lengths of matching substrings
	-- (longer than 2 characters) from previous messages, divided by the length of the current message.
	cvars.antispam_awarenessSimilarityMul		= 1
	-- Degree P in the formula for increasing awareness by message similarity: increase = K * similarity ^ P. (type: fractional number)
	cvars.antispam_awarenessSimilarityPow		= 1

    -- Duration of the offender's ban. (type: integer)
	-- Trade Chat
    cvars.antispam_trade_autobanSec	= 60
    -- Awareness is a cumulative indicator of the level of spam: it increases if the player writes often and repeats, and gradually decreases over time during breaks.
    -- The same autobahn threshold, but for the trade channel. (type: integer)
    cvars.antispam_trade_autobanAwareness	= 200
    -- Awareness threshold for notifying the user that spam has stopped. (type: integer)
    cvars.antispam_trade_notifyAwareness	= 150
    -- Enables sending of extended notification. (type: integer)
    cvars.antispam_trade_notifyExtended	= 0
    -- Decreases by this value per second. (type: fractional number)
    cvars.antispam_trade_awarenessDecay	= 10
    -- Numerator A in the awareness gain formula: gain = A / dt (dt in seconds, min 0.5).
    -- Larger A - awareness grows faster with frequent messages; same parameter as antispam_awarenessIntervalNumerator. (type: fractional number)
    cvars.antispam_trade_awarenessIntervalNumerator	= 100
    -- Coefficient K in the formula for increasing awareness by message similarity: increase = K * similarity ^ P.
    -- The same parameter as antispam_awarenessSimilarityMul, but for trade chat. (type: fractional number)
    cvars.antispam_trade_awarenessSimilarityMul	= 1
    -- Degree P in the formula for increasing awareness by message similarity: increase = K * similarity ^ P.
    -- The same parameter as antispam_awarenessSimilarityPow, but for trade chat. (type: fractional number)
    cvars.antispam_trade_awarenessSimilarityPow	= 1
end


--
function ConfigureUniverse()

	-- ID of the Universe being used. (type: integer; range: 1..65535)
	cvars.universe_unid = 2
  	-- Start time of the New Year's event. (type: string)
  	-- NY2016 params
  	cvars.universe_newYearStartTime	= "2018-12-17T00:00:00Z"
  	-- Empire kill counter growth rate. (type: fractional number)
  	cvars.universe_empireKillsCF		= 0
  	-- Federation kill counter growth rate. (type: fractional number)
  	cvars.universe_federationKillsCF	= 0
  	-- Jericho's kill counter growth rate. (type: fractional number)
  	cvars.universe_jerichoKillsCF		= 0
	-- The share of the zone reward that goes to the current owner; the remaining share is distributed among rivals. (type: fractional number 0..1)
	cvars.universe_factorOwnerInReward = 0.4
  	-- The share of accumulated influence of the zone owner, which is written off at the beginning of the conflict. (type: fractional number 0..1)
  	cvars.universe_decayOwner = 0.25
	-- The share of the accumulated influence of rivals that is written off at the beginning of the conflict. (type: fractional number 0..1)
	cvars.universe_decayRival = 0.1
	-- Coefficient A in the owner's penalty formula following a conflict: opponent's contribution = influence / (A * place + B), place is counted from 0. (type: fractional number)
	-- 1/3, 1/5, 1/7...
	cvars.universe_takeOwnerCoeffA = 2
	-- Coefficient B in the owner's penalty formula following a conflict: opponent's contribution = influence / (A * place + B), place is counted from 0. (type: fractional number)
	cvars.universe_takeOwnerCoeffB = 3
	-- The share of accumulated influence that is written off after a conflict without new influence during the conflict. (type: fractional number 0..1)
	-- SC-111290
	cvars.universe_decayIdle  = 0.5

	-- Global war parameters: adjust the formulas for calculating military experience and damage to a corporation.
	-- Basic event formula: raw = kill_multiplier * target_multiplier; raw is then converted into experience and damage using separate coefficients.
  	-- Multiplier for participants who helped kill the target but did not deliver the final blow. The final killer receives a multiplier of 1. (type: fractional number 0..1)
	cvars.war_coeffAssist				 = 0.2
	-- The A coefficient for the enemy target in the target multiplier formula is: multiplier = A * target_rank + B. (type: fractional number)
	cvars.war_coeffRivalA				 = 1
	-- The B coefficient for the enemy target in the target multiplier formula is: multiplier = A * target_rank + B. (type: fractional number)
	cvars.war_coeffRivalB				 = 2
	-- Target multiplier if the victim is not at war with the attacker's corporation. (type: fractional number)
	cvars.war_coeffNeutral				 = 0.1
	-- Target multiplier for bot substitute instead of real player. (type: fractional number)
	cvars.war_coeffBot					 = 0.05
	-- The coefficient for converting raw event points into the player’s military rank progress. (type: fractional number)
	cvars.war_damageRawRateToMilitaryExp = 10
	-- The coefficient for converting raw event points into corporation damage on the global map. (type: fractional number)
	cvars.war_damageRawRateToDamage		 = 100
  	-- Share of periodic reduction in the base cost of war; applied as a multiplier of 1 - value. (type: fractional number 0..1)
  	cvars.war_decayCostBase				 = 0.1
	
	-- Allows an external service to manage zone logic: when zone logic is disabled, the server itself does not start/end conflicts and does not accept contributions. (type: boolean)
	-- SC-112644
	cvars.universe_allowExternalControl  = 1

	-- A share of the bonus to the clan’s influence in the zone if the clan’s race coincides with the dominant race of the star system; multiplier = 1 + value. (type: fractional number 0..1)
	cvars.universe_raceFactorStellar	= 0.1
	-- A share of the bonus to the influence of a clan in a zone if the clan’s race matches the race of the zone itself; multiplier = 1 + value. (type: fractional number 0..1)
	cvars.universe_raceFactorZone		= 0.1

end


--
function ConfigureQuestServer()

	-- Enables/disables quests. (type: boolean)
	cvars.quests_enable				= 1
  	-- Start time of the New Year's event. (type: string)
  	cvars.event_newYear				= "2030-12-17T00:00:00Z"
  	-- The maximum number of UIDs to load in a database read operation. (type: integer; range: 1..1024)
  	cvars.quests_readWaveMaxUids 	= 100
    -- Bit mask for logging debug messages of quests: by adding the values, the necessary categories are included.
    -- 1 - caching; 2 - availability of quests; 4 - user state; 8 - selection of quests; 16 - quest progress. 31 - all categories. (type: integer)
    cvars.quests_dbgLog				= 31
  	-- Includes summer event. (type: integer)
  	cvars.event_summer 				= 0
  	-- Includes a summer ship event. (type: integer)
  	cvars.event_summerShip 			= 0
  	-- Includes the Halloween event. (type: integer)
  	cvars.event_halloween	 		= 0

  	-- Start time of the custom event. (type: string)
  	-- It is necessary to change the start and end times in multiples of an hour, otherwise the imaginary quest may behave unpredictably.
  	cvars.event_custom 					= event_custom

	-- Coefficients of the decreasing reward formula for imaginary quests:
	-- quantity = floor((A - 1) * (1 - tanh(B * (walkthroughs - 1))) + 1), where “walkthroughs” is the number of times the player has already completed this quest.
  	-- Coefficient A: the initial value of the reward on the first playthrough; as the number of completions increases, the reward decreases to 1. (SC-109926; type: fractional number)
	cvars.quests_imaginaryRewardCoeffA = 25
	-- Coefficient B: the rate at which the reward decreases as the number of completions increases; larger B - the reward falls faster. (SC-109926; type: fractional)
	cvars.quests_imaginaryRewardCoeffB = 0.17

  	-- Start time of the event with credits. (type: string)
  	cvars.store_creditsEventStart 	= creditsEventStart
	-- End time of the event with credits. (type: string)
	cvars.store_creditsEventEnd 	= creditsEventEnd

	_G.QuestServer_SetupBattlePassActivation( battlePassStart, battlePassEndTable )

end


--
function ConfigureAchievementServer()

	-- Enables server-side processing of achievements.
	cvars.achievements_enable	= 1
  	-- The maximum number of UIDs to load in a database read operation. (type: integer; range: 1..256)
  	cvars.achievements_readWaveMaxUids	= 100
	-- Debug logging level/flag. (type: boolean)
	-- additional logging
	cvars.achievements_dbgLogEnable = 0

end


--
function ConfigureLobbyServer()

	-- Includes a custom game server.
	cvars.lobby_enabled			= 1
	-- Rewards for custom games are multiplied by this value. (type: fractional number)
	cvars.lobby_rewardRates		= 1
  	-- Minimum/maximum players to run PvE-lobby.
  	cvars.lobby_reqPlayersPvEMin = 1
	-- Minimum/maximum players to run PvE-lobby.
	cvars.lobby_reqPlayersPvEMax = 4
    -- Limit of identical unique modules per ship; is set separately for regular and premium ships.
    -- #85547
    cvars.store_maxUniqueModules = 3
  	-- Limit of identical unique modules per ship; is set separately for regular and premium ships.
  	-- #0098493: Make it possible to install experimental modules on premium. and DLC ships in quantity 1 piece
  	cvars.store_maxUniqueModulesOnPremium = 2
	
	-- list of prohibited equipment (ships and modules) in leagues
	Lobby_SetupLeagueForbiddenEquipment( leagueForbiddenDefs )
	
end

--
function ConfigureLeaderboardServer()

	local LET_PLAYER		= 0
	local LET_CLAN			= 1
	local LET_CLAN_MEMBER	= 2
	local LET_RACE			= 3

	local LEA_RESET			= 0
	local LEA_DELETE		= 1
	local LEA_NOOP			= 2

	local LRT_CREDITS		= 0
	local LRT_LB_EVENT		= 1

	local LUT_INCREMENT			= 0
	local LUT_SET				= 1
	local LUT_SET_IF_GREATER	= 2
	local LUT_SET_IF_LESSER		= 3

	local LET_LEAGUE_TEAM	= 4

	local nov_28_2013		= "1385596800000"
	local feb_18_2016		= "1455753600000"

	local oneWeek			= 60 * 24 * 7
	local threeMonths		= 60 * 24 * 90


	local lbrds = {}
	local routes = {}

    -- REWARDS
    -- local goldCreditsForTop100	= { params = { stringId = "UWinBro", goldCredits = 1000 }, type = LRT_CREDITS, posFilter = 100 }
    -- local clanEffTopEvent = { params = { event = "clan_weekly_top", v = 1 }, type = LRT_LB_EVENT, posFilter = 10 }

    -- PLAYERS' LEADERBOARDS PERMANENT
    -- Player Prestige
    table.insert( lbrds, { name = "player_prestige", entityType = LET_PLAYER } )
    table.insert( routes, { event = "prestige", target = "player_prestige", update = LUT_SET } )
    -- Total pvp player efficiency +
    table.insert( lbrds, { name = "player_pvp_effectiveness", entityType = LET_PLAYER, decayInterval = 60 * 24, decayPower = 0.1 } )
    table.insert( routes, { event = "pvp_eff", target = "player_pvp_effectiveness", update = LUT_INCREMENT } )
    -- Total pve player efficiency +
    table.insert( lbrds, { name = "player_pve_effectiveness", entityType = LET_PLAYER, decayInterval = 60 * 24, decayPower = 0.1 } )
    table.insert( routes, { event = "pve_eff", target = "player_pve_effectiveness", update = LUT_INCREMENT } )
    -- Total number of departures
    table.insert( lbrds, { name = "player_battles", entityType = LET_PLAYER } )
    table.insert( routes, { event = "gover", target = "player_battles" } )
    -- Total number of wins
    table.insert( lbrds, { name = "player_wins", entityType = LET_PLAYER } )
    table.insert( routes, { event = "gwin", target = "player_wins" })
    -- Total number of kills
    table.insert( lbrds, { name = "player_kills", entityType = LET_PLAYER } )
    table.insert( routes, { event = "kills", target = "player_kills" } )
    -- Amount of positive karma in the open world
    table.insert( lbrds, { name = "player_karma_good", entityType = LET_PLAYER } )
    table.insert( routes, { event = "karma", target = "player_karma_good", update = LUT_SET } )
    -- Amount of negative karma in the open world
    table.insert( lbrds, { name = "player_karma_bad", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "karma", target = "player_karma_bad", update = LUT_SET } )
    -- Total number of goals in football
    table.insert( lbrds, { name = "player_goals", entityType = LET_PLAYER } )
    table.insert( routes, { event = "goals", target = "player_goals", update = LUT_INCREMENT } )
    -- Total number of kills in the hunger games
    table.insert( lbrds, { name = "player_hunger", entityType = LET_PLAYER } )
    table.insert( routes, { event = "hunger_games_kills", target = "player_hunger", update = LUT_INCREMENT } )
    -- The total number of influence points earned by the player
    table.insert( lbrds, { name = "player_pressure", entityType = LET_PLAYER } )
    table.insert( routes, { event = "pressure", target = "player_pressure", update = LUT_INCREMENT } )
    -- Raid completion speed (time_mission_name)
    table.insert( lbrds, { name = "player_time_pve_raid", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "time_pve_raid", target = "player_time_pve_raid", update = LUT_SET_IF_LESSER } )
    table.insert( lbrds, { name = "player_time_pve_raid_waterharvest_t3", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "time_pve_raid_waterharvest_t3", target = "player_time_pve_raid_waterharvest_t3", update = LUT_SET_IF_LESSER } )
    table.insert( lbrds, { name = "player_time_pve_raid_waterharvest_t4", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "time_pve_raid_waterharvest_t4", target = "player_time_pve_raid_waterharvest_t4", update = LUT_SET_IF_LESSER } )
    table.insert( lbrds, { name = "player_time_pve_raid_waterharvest_t5", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "time_pve_raid_waterharvest_t5", target = "player_time_pve_raid_waterharvest_t5", update = LUT_SET_IF_LESSER } )
    table.insert( lbrds, { name = "player_time_pve_planetoidraid", entityType = LET_PLAYER, dir = 1 } )
    table.insert( routes, { event = "time_pve_planetoidraid", target = "player_time_pve_planetoidraid", update = LUT_SET_IF_LESSER } )
    -- Passing unlim missions
    -- table.insert( lbrds, { name = "unlim_pve_time_planet_war_waves_T1_25", expiresAt = "1553472000000", expAction = LEA_NOOP, entityType = LET_PLAYER, dir = 1 } ) -- expires Monday, 25 March 2019, 0:00:00 GMT
    -- table.insert( routes, { event = "unlim_pve_time_planet_war_waves_T1_25", target = "unlim_pve_time_planet_war_waves_T1_25", update = LUT_SET_IF_LESSER } )
    table.insert( lbrds, { name = "unlim_pve_level_planet_war_waves_T1", entityType = LET_PLAYER } )
    table.insert( routes, { event = "unlim_pve_level_planet_war_waves_T1", target = "unlim_pve_level_planet_war_waves_T1", update = LUT_SET_IF_GREATER } )
    -- Clan wars: militaryRank
    -- table.insert( lbrds, { name = "player_militaryRank", entityType = LET_PLAYER } )
    -- table.insert( routes, { event = "militaryRank", target = "player_militaryRank", update = LUT_SET } )
    -- Clan wars: damage
    -- table.insert( lbrds, { name = "player_warDamage", entityType = LET_PLAYER } )
    -- table.insert( routes, { event = "warDamage", target = "player_warDamage", update = LUT_INCREMENT } )
    -- Number of kills per battle +
    -- table.insert( lbrds, { name = "player_kills_per_battle", entityType = LET_PLAYER } )
    -- table.insert( routes, { event = "kills", target = "player_kills_per_battle", update = LUT_SET_IF_GREATER } )
    -- Number of achievement points
    -- table.insert( lbrds, { name = "player_achievements", entityType = LET_PLAYER } )
    -- table.insert( routes, { event = "achievements", target = "player_achievements", update = LUT_SET } )
    -- Kill Rating
    -- table.insert( lbrds, { name = "player_akari_r", entityType = LET_PLAYER } )
    -- table.insert( routes, { event = "akari_r", target = "player_akari_r", update = LUT_SET } )
	-- Reached wave in wave pve
	table.insert( lbrds, { name = "player_wavePve_wave", entityType = LET_PLAYER } )
	table.insert( routes, { event = "player_wavePve_wave", target = "player_wavePve_wave", update = LUT_SET_IF_GREATER } )

    -- PLAYER LEADERBOARDS PER WEEK with reward
    -- Total number of murders per week
    local r_player_kills_1	= { params = { stringId = "LeaderboardTop1", tokenCredits = 400 }, type = LRT_CREDITS, posMin = 1, posMax = 1 }
    local r_player_kills_2	= { params = { stringId = "LeaderboardTop2", tokenCredits = 200 }, type = LRT_CREDITS, posMin = 2, posMax = 2 }
    local r_player_kills_3	= { params = { stringId = "LeaderboardTop3", tokenCredits = 100 }, type = LRT_CREDITS, posMin = 3, posMax = 3 }
    table.insert( lbrds, { name = "player_kills_weekly", entityType = LET_PLAYER , expiresAt = nov_28_2013, renewalInterval = oneWeek, rewards = { r_player_kills_1, r_player_kills_2, r_player_kills_3 } } )
    table.insert( routes, { event = "kills_ht", target = "player_kills_weekly", update = LUT_INCREMENT } )
    -- Maximum pvp player efficiency per week
    local r_player_pvp_eff_max_1	= { params = { stringId = "LeaderboardTop1", tokenCredits = 400 }, type = LRT_CREDITS, posMin = 1, posMax = 1 }
    local r_player_pvp_eff_max_2	= { params = { stringId = "LeaderboardTop2", tokenCredits = 200 }, type = LRT_CREDITS, posMin = 2, posMax = 2 }
    local r_player_pvp_eff_max_3	= { params = { stringId = "LeaderboardTop3", tokenCredits = 100 }, type = LRT_CREDITS, posMin = 3, posMax = 3 }
    table.insert( lbrds, { name = "player_pvp_eff_max_weekly", entityType = LET_PLAYER , expiresAt = nov_28_2013, renewalInterval = oneWeek, rewards = { r_player_pvp_eff_max_1, r_player_pvp_eff_max_2, r_player_pvp_eff_max_3 } } )
    table.insert( routes, { event = "pvp_eff_ht", target = "player_pvp_eff_max_weekly", update = LUT_SET_IF_GREATER } )
    -- Maximum pve player efficiency per week
    local r_player_pve_eff_max_1	= { params = { stringId = "LeaderboardTop1", tokenCredits = 400 }, type = LRT_CREDITS, posMin = 1, posMax = 1 }
    local r_player_pve_eff_max_2	= { params = { stringId = "LeaderboardTop2", tokenCredits = 200 }, type = LRT_CREDITS, posMin = 2, posMax = 2 }
    local r_player_pve_eff_max_3	= { params = { stringId = "LeaderboardTop3", tokenCredits = 100 }, type = LRT_CREDITS, posMin = 3, posMax = 3 }
    table.insert( lbrds, { name = "player_pve_eff_max_weekly", entityType = LET_PLAYER , expiresAt = nov_28_2013, renewalInterval = oneWeek, rewards = { r_player_pve_eff_max_1, r_player_pve_eff_max_2, r_player_pve_eff_max_3 } } )
    table.insert( routes, { event = "pve_eff", target = "player_pve_eff_max_weekly", update = LUT_SET_IF_GREATER } )
    -- Number of PvE playthroughs per week
    local r_player_pve_win_1	= { params = { stringId = "LeaderboardTop1", tokenCredits = 400 }, type = LRT_CREDITS, posMin = 1, posMax = 1 }
    local r_player_pve_win_2	= { params = { stringId = "LeaderboardTop2", tokenCredits = 200 }, type = LRT_CREDITS, posMin = 2, posMax = 2 }
    local r_player_pve_win_3	= { params = { stringId = "LeaderboardTop3", tokenCredits = 100 }, type = LRT_CREDITS, posMin = 3, posMax = 3 }
    table.insert( lbrds, { name = "player_pve_win_weekly", entityType = LET_PLAYER , expiresAt = nov_28_2013, renewalInterval = oneWeek, rewards = { r_player_pve_win_1, r_player_pve_win_2, r_player_pve_win_3 } } )
    table.insert( routes, { event = "pvegwin", target = "player_pve_win_weekly", update = LUT_INCREMENT } )
    -- New player rating for the week
    local r_player_eff_win_1	= { params = { stringId = "LeaderboardTop1eff", tid = 31 }, type = LRT_CREDITS, posMin = 1, posMax = 3 }
    local r_player_eff_win_2	= { params = { stringId = "LeaderboardTop2eff", tid = 32 }, type = LRT_CREDITS, posMin = 4, posMax = 20 }
    local r_player_eff_win_3	= { params = { stringId = "LeaderboardTop3eff", tid = 33 }, type = LRT_CREDITS, posMin = 21, posMax = 50 }
    table.insert( lbrds, { name = "player_eff_rating_weekly", entityType = LET_PLAYER , expiresAt = nov_28_2013, renewalInterval = oneWeek, rewards = { r_player_eff_win_1, r_player_eff_win_2, r_player_eff_win_3 } } )
    table.insert( routes, { event = "eff_rating", target = "player_eff_rating_weekly", update = LUT_SET } )

    -- LEADERBOARDS OF CLAN PLAYERS
    -- Total pvp efficiency of a player in a clan
    table.insert( lbrds, { name = "cm_pvp_effectiveness", entityType = LET_CLAN_MEMBER, decayInterval = 60 * 24, decayPower = 0.1 } )
    table.insert( routes, { event = "pvp_eff", target = "cm_pvp_effectiveness", update = LUT_INCREMENT } )
    -- Total pve efficiency of a player in a clan
    table.insert( lbrds, { name = "cm_pve_effectiveness", entityType = LET_CLAN_MEMBER, decayInterval = 60 * 24, decayPower = 0.1 } )
    table.insert( routes, { event = "pve_eff", target = "cm_pve_effectiveness", update = LUT_INCREMENT } )
    -- The total number of influence points earned by a clan member
    table.insert( lbrds, { name = "cm_pressure", entityType = LET_CLAN_MEMBER } )
    table.insert( routes, { event = "pressure", target = "cm_pressure", update = LUT_INCREMENT } )
    -- Clan wars: militaryRank
    table.insert( lbrds, { name = "cm_military_rank", entityType = LET_CLAN_MEMBER } )
    table.insert( routes, { event = "militaryRank", target = "cm_military_rank", update = LUT_SET } )
    -- Clan wars: damage
    table.insert( lbrds, { name = "cm_war_damage", entityType = LET_CLAN_MEMBER } )
    table.insert( routes, { event = "warDamage", target = "cm_war_damage", update = LUT_INCREMENT } )
    -- Clan wars: losses
    table.insert( lbrds, { name = "cm_war_losses", entityType = LET_CLAN_MEMBER } )
    table.insert( routes, { event = "warLosses", target = "cm_war_losses", update = LUT_INCREMENT } )
    -- Number of achievement points
    -- table.insert( lbrds, { name = "cm_achievements", entityType = LET_CLAN_MEMBER } )
    -- table.insert( routes, { event = "achievements", target = "cm_achievements", update = LUT_SET } )

    -- CLAN LEADERBOARDS
    -- The total number of clan points earned in pvp decreases by 1% every hour
    table.insert( lbrds, { name = "CLS_PVP_RATING", entityType = LET_CLAN, decayInterval = 60, decayPower = 0.01 } )
    table.insert( routes, { event = "pvp_b", target = "CLS_PVP_RATING", update = LUT_INCREMENT } )
    -- The total pve efficiency of the clan decreases by 1% every hour
    table.insert( lbrds, { name = "CLS_PVE_RATING", entityType = LET_CLAN, decayInterval = 60, decayPower = 0.01 } )
    table.insert( routes, { event = "pve_eff", target = "CLS_PVE_RATING", update = LUT_INCREMENT } )
    -- Clan wars: damage
    table.insert( lbrds, { name = "CLS_WAR_DAMAGE", entityType = LET_CLAN } )
    table.insert( routes, { event = "warDamage", target = "CLS_WAR_DAMAGE", update = LUT_INCREMENT } )
    -- Total number of location captures
    table.insert( lbrds, { name = "CLS_ZONE_CAPTURE", entityType = LET_CLAN } )
    table.insert( routes, { event = "zoneCapture", target = "CLS_ZONE_CAPTURE", update = LUT_INCREMENT } )
    -- Clan wars: current rating
    table.insert( lbrds, { name = "CLS_WAR_RATING", entityType = LET_CLAN } )
    table.insert( routes, { event = "warRating", target = "CLS_WAR_RATING", update = LUT_SET } )
    -- Clan wars: maximum rating achieved
    table.insert( lbrds, { name = "CLS_WAR_RATING_MAX", entityType = LET_CLAN } )
    table.insert( routes, { event = "warRating", target = "CLS_WAR_RATING_MAX", update = LUT_SET_IF_GREATER } )
    -- The total number of influence points earned by the clan
    -- table.insert( lbrds, { name = "CLS_PRESSURE", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "pressure", target = "CLS_PRESSURE", update = LUT_INCREMENT } )
    -- ELO corporate rating
    -- table.insert( lbrds, { name = "CLS_ELO", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "unWElo", target = "CLS_ELO", update = LUT_SET } )
    -- ARENA
    -- table.insert( lbrds, { name = "league_rating", entityType = LET_LEAGUE_TEAM } )
    -- table.insert( routes, { event = "league_rating", target = "league_rating", update = LUT_SET } )
    -- Total amount of irridium ever delivered to the corporation
    -- table.insert( lbrds, { name = "CLS_IRIDIUM", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "cbt_iridium", target = "CLS_IRIDIUM", update = LUT_INCREMENT } )
    -- The total number of influence points ever received by the clan
    -- table.insert( lbrds, { name = "CLS_INFLUENCE", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "clanInf", target = "CLS_INFLUENCE", update = LUT_INCREMENT } )
    -- Total number of sectors ever controlled by a clan
    -- table.insert( lbrds, { name = "CLS_GALAXIES", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "gal_cap", target = "CLS_GALAXIES", update = LUT_INCREMENT } )
    -- Number of people in the clan
    -- table.insert( lbrds, { name = "CLS_MEMBERS", entityType = LET_CLAN } )
    -- table.insert( routes, { event = "cSize", target = "CLS_MEMBERS", update = LUT_SET } )

    --local r_leagues_8top_1 = { params = { stringId = "LeaderboardTopLgs1", tid = 201 }, type = LRT_CREDITS, posMin = 1, posMax = 8 }
    --table.insert( lbrds, { name = "league_rating", entityType = LET_LEAGUE_TEAM, expiresAt = feb_18_2016, expAction = LEA_RESET, renewalInterval = threeMonths, rewards = { r_leagues_8top_1, } } )
    --table.insert( routes, { event = "league_rating", target = "league_rating", update = LUT_SET } )
    --table.insert( lbrds, { name = "major_league_rating", entityType = LET_MAJOR_LEAGUE_TEAM, expiresAt = feb_18_2016, expAction = LEA_RESET, renewalInterval = threeMonths, rewards = { r_leagues_8top_1, } } )
    --table.insert( routes, { event = "major_league_rating", target = "major_league_rating", update = LUT_SET } )

    --[[
    table.insert( lbrds, { name = "player_race_influence:0" })
    table.insert( lbrds, { name = "player_race_influence:1" })
    table.insert( lbrds, { name = "player_race_influence:2" })
    table.insert( lbrds, { name = "race_openspace_points", entityType = LET_RACE })
    table.insert( lbrds, { name = "race_arcade_points", entityType = LET_RACE })
    table.insert( lbrds, { name = "race_universe_points", entityType = LET_RACE })

    table.insert( routes, { event = "ri0", target = "player_race_influence:0" })
    table.insert( routes, { event = "ri1", target = "player_race_influence:1" })
    table.insert( routes, { event = "ri2", target = "player_race_influence:2" })
    table.insert( routes, { event = "osP", target = "race_openspace_points" }) -----
    table.insert( routes, { event = "arP", target = "race_arcade_points" })
    table.insert( routes, { event = "unP", target = "race_universe_points" })
    ]]
	table.insert( lbrds, { name = "event_green_war_empire", entityType = LET_PLAYER } )
	table.insert( routes, { event = "green_war_empire", target = "event_green_war_empire", update = LUT_SET } )
	table.insert( lbrds, { name = "event_green_war_federation", entityType = LET_PLAYER } )
	table.insert( routes, { event = "green_war_federation", target = "event_green_war_federation", update = LUT_SET } )
	table.insert( lbrds, { name = "event_green_war_jericho", entityType = LET_PLAYER } )
	table.insert( routes, { event = "green_war_jericho", target = "event_green_war_jericho", update = LUT_SET } )
	table.insert( lbrds, { name = "event_green_war_total", entityType = LET_PLAYER } )
	table.insert( routes, { event = "green_war_total", target = "event_green_war_total", update = LUT_SET } )
	
	-- TEMPORARY LEADERBOARDS
    -- April Brawl rating
	table.insert( lbrds, { name = "player_april_win", entityType = LET_PLAYER } )
    table.insert( routes, { event = "atdmgwin", target = "player_april_win", update = LUT_INCREMENT } )
	
	table.insert( lbrds, { name = "player_cd_win", entityType = LET_PLAYER } )
    table.insert( routes, { event = "close_distance_kills", target = "player_cd_win", update = LUT_INCREMENT } )
	
	local marathon_expires = "1652659200000" -- https://www.epochconverter.com/ Timestamp in milliseconds!!
	
	table.insert( lbrds, { name = "player_kills_marathon", entityType = LET_PLAYER, expiresAt = marathon_expires, expAction = LEA_NOOP } )
    table.insert( routes, { event = "kills", target = "player_kills_marathon", update = LUT_INCREMENT } )

    Leaderboards_Configure( lbrds )
    Leaderboards_Routes( routes )

    -- Includes a debug dump of each incoming leaderboard event in the log. (type: integer)
    -- cvars.leaderboard_logEvents = 1
end



function ConfigureZoneCoordinator()

	-- Enables blocking of zones according to a raid schedule: ZoneCoordinator passes the flag to launched ZoneInstances and to already running instances.
	-- Inside FreeSpace, a raid zone is selected according to the current schedule, and transitions/jumps to this zone are prohibited. (type: integer)
	cvars.zc_enableZoneBlocks	= 0
	
end


function ConfigureTournament()

	-- Offset of tournament team name numbers in the UI: the client adds this value to the name number and takes the string single_tournament_name_N.
	-- Allows you to shift the set of displayed team names without changing their actual teamId. (type: integer)
	cvars.tournament_idOffset	= 0
    -- Tournament levels/maps. (type: string)
    -- ;s1338_pandora_anomaly is buggy
    cvars.tournament_levels 	=  "s1338_devilsjaw;s1338_pandora_dreadnwreck;s1340_thar_aliendebris13;s1420_ceres3_asteroidcity;s1420_ceres3_northmsite;s8256_thar_barrierdebris;s8256_thar_lavastone;s8256_thar_threshold;desttown"
  	-- Tournament combat rank; copied to sv_mmBattleRank. (type: integer; range: 0..ai::MAX_SHIP_RANK)
  	cvars.tournament_battleRank = 17
    -- Tournament game mode. (type: integer; range: ai::GT_SPACE_BATTLE..ai::GT_MISSION_SCRIPT - 1)
    cvars.tournament_gamemode 	= 12
    -- Maximum team size for a tournament. (type: integer; range: 1..MAX_TOURNAMENT_TEAM_SIZE)
    cvars.tournament_teamSize 	= 8
    -- Interval between game creations in milliseconds. (type: integer; range: 50..10000)
    cvars.tournament_gameInterval	= 2000
	
end


function ConfigureClanServer()

	-- The number of main parts of a clan ship available for construction. (type: integer)
	-- (0,1,2,3,4) stages of dreadnought construction
	cvars.clan_shipPartsCanBuild 	= 4
	-- The maximum number of upgrades for clan ship modules available for construction. (type: integer)
	-- (0,1,2,3) stages of dreadnought upgrades (T3,T4,T5)
	cvars.clan_shipUpgradeCanBuild	= 3
	-- The number of high-ranking clan members required to build a clan ship. (type: integer)
	-- number of people in the clan of rank 9
	cvars.clan_shipBuildHighRanks 	= 3
	-- The minimum amount of resource from the zone to be recorded in the clan history. (type: integer)
	-- If less toffees came from the zone, do not spam the corp log.
	cvars.clans_historyMinResourceAddByZone = 10
    -- Reward for victory in the war. (type: string)
    cvars.clan_warWinRewardAura = 'Bundle_ClanWar_Win'
	
end


function ConfigureAdventureServer()


end


function ConfigureHub()

	RegionWeightProportion = {
		ru = { ru = 0.7, eu = 0.2, us = 0.1 },
		eu = { ru = 0.2, eu = 0.7, us = 0.1 },
		us = { ru = 0.1, eu = 0.2, us = 0.7 },
	}
	
end


-- actual configuring
-- CloudService_GetServiceTypeStr is absent on dedicated server-- 'service_type' is now a global set up before config execution
--local service_type =_G.CloudService_GetServiceTypeStr()
if( service_type == "ST_SHARD" ) then
	ConfigureShard()
elseif( service_type == "ST_MATCHMAKER" ) then
	ConfigureMatchmaker()
elseif( service_type == "ST_SCRIPTS_SERVER" ) then
	ConfigureScriptsServer()
elseif( service_type == "ST_DEDICATED_SERVER" ) then
	ConfigureDediServer()
elseif( service_type == "ST_ZONE_INSTANCE" ) then
	ConfigureZoneInstance()
elseif( service_type == "ST_GAME_REWARD_DISPENCER" ) then
	ConfigureGRD()
elseif( service_type == "ST_LOAD_BALANCER" ) then
	ConfigureLoadBalancer()
elseif( service_type == "ST_CHAT_SERVER" ) then
	ConfigureChatServer()
elseif( service_type == "ST_UNIVERSE" ) then
	ConfigureUniverse()
elseif( service_type == "ST_QUEST_SERVER" ) then
	ConfigureQuestServer()
elseif( service_type == "ST_ACHIEVEMENT_SERVER" ) then
	ConfigureAchievementServer()
elseif( service_type == "ST_LOBBY_SERVER" ) then
	ConfigureLobbyServer()
elseif( service_type == "ST_LEADERBOARD_SERVER" ) then
	ConfigureLeaderboardServer()
elseif( service_type == "ST_ZONE_COORDINATOR" ) then
	ConfigureZoneCoordinator()
elseif( service_type == "ST_TOURNAMENT" ) then
	ConfigureTournament()
elseif( service_type == "ST_CLAN_SERVER" ) then
	ConfigureClanServer()
elseif( service_type == "ST_ADVENTURE_SERVER" ) then
	ConfigureAdventureServer()
elseif( service_type == "ST_HUB" ) then
	ConfigureHub()
--else
--	sys.log( "UNKNOWN _G.service_type" )
end
