-- In this file you can set up all the properties and settings for your game mode.


RANDOM_SPAWN = false 					-- Should the heroes spawn in random locations in current arena
ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 55.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 30.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
REMATCH_VOTING_TIME = 20.0              -- How long should we let people vote to rematch?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

CustomNetTables:SetTableValue( "gameinfo", "game_times", { hero_selection = HERO_SELECTION_TIME,
														   pregame = PRE_GAME_TIME,
														   post_game = POST_GAME_TIME,
														 } )

GOLD_PER_TICK = 0                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = -1           -- How far out should we allow the camera to go?  Use -1 for the default (1134) while still allowing for panorama camera distance changes

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
                                            -- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 30         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 7                           -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
    if     i == 1 then XP_PER_LEVEL_TABLE[i] = 0
    elseif i == 2 then XP_PER_LEVEL_TABLE[i] = 10
    elseif i == 3 then XP_PER_LEVEL_TABLE[i] = 40
    elseif i == 4 then XP_PER_LEVEL_TABLE[i] = 70
    elseif i == 5 then XP_PER_LEVEL_TABLE[i] = 110
    elseif i == 6 then XP_PER_LEVEL_TABLE[i] = 160
    else               XP_PER_LEVEL_TABLE[i] = 220
    end
  --XP_PER_LEVEL_TABLE[i] = (i-1) * 100
end
-- save Level table to NET TABLES for panorama
CustomNetTables:SetTableValue( "gameinfo", "xp_level_table", { XPlevel_1 = XP_PER_LEVEL_TABLE[1],
															   XPlevel_2 = XP_PER_LEVEL_TABLE[2],
															   XPlevel_3 = XP_PER_LEVEL_TABLE[3],
															   XPlevel_4 = XP_PER_LEVEL_TABLE[4],
															   XPlevel_5 = XP_PER_LEVEL_TABLE[5],
															   XPlevel_6 = XP_PER_LEVEL_TABLE[6],
															   XPlevel_7 = XP_PER_LEVEL_TABLE[7],
															 } )

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = false              -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = true        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = true               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = "npc_dota_hero_wisp"                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_wisp").  Use nil to allow players to pick their own hero.

ADDITIONAL_STARTING_RESPAWN_TIME = 7    -- This time + FIXED_RESPAWN_TIME = Spent time in LOBBY ROOM, after that relocate to ARENA. !!! IMPORTANT to change this (this + FIXED_RESPAWN_TIME) in panorama/scripts/custom_game/events_custom.js
FIXED_RESPAWN_TIME = 3                  -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20               -- What should we use for the minimum attack speed?

GAME_END_DELAY = -1                     -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)
VICTORY_MESSAGE_DURATION = 3            -- How long should we wait after the victory message displays to show the End Screen?  Use 
STARTING_GOLD = 50                      -- How much starting gold should we give to each player?
DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Shuold we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
SKIP_TEAM_SETUP = false                 -- Should we skip the team setup entirely?
ENABLE_AUTO_LAUNCH = true               -- Should we automatically have the game complete team setup after AUTO_LAUNCH_DELAY seconds?
AUTO_LAUNCH_DELAY = 30                  -- How long should the default team selection launch timer be?  The default for custom games is 30.  Setting to 0 will skip team selection.
LOCK_TEAM_SETUP = false                 -- Should we lock the teams initially?  Note that the host can still unlock the teams 
MINIMUM_VOTES_TO_REMATCH = 4			-- minimum votes to rematch

INVENTORY_SAFE_SLOTS = 2				-- safe slots in a player inventory
INVENTORY_DROP_SUM = 1					-- number of items which will be dropped after death

CustomNetTables:SetTableValue( "gameinfo", "special_values", { minimumVotes = MINIMUM_VOTES_TO_REMATCH,
															   rematchVotingTime = REMATCH_VOTING_TIME,
															} )

-- NOTE: You always need at least 2 non-bounty type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = false
ENABLED_RUNES[DOTA_RUNE_HASTE] = false
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = false
ENABLED_RUNES[DOTA_RUNE_ARCANE] = false


MAX_NUMBER_OF_TEAMS = 10                -- How many potential teams can be in this game mode?
USE_CUSTOM_TEAM_COLORS = true           -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true          -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple


USE_AUTOMATIC_PLAYERS_PER_TEAM = true   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?

CUSTOM_TEAM_PLAYER_COUNT = {}           -- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 1

-- ARENA NAMES
------------------
ARENA_NAMES = {}
ARENA_NAMES[0] = "Oasis Attack"

-- SPAWN LOCATIONS
------------------
SPAWN_LOCATIONS = {}
-- Oasis Attack
SPAWN_LOCATIONS[0] = {}
	SPAWN_LOCATIONS[0][0]  = Vector( 1000, -1225, 129 )   -- camp-right
	SPAWN_LOCATIONS[0][1]  = Vector( -575, -2650, 129 )  -- camp-center
	SPAWN_LOCATIONS[0][2]  = Vector( 1780, -40, 17 )     -- water under mid island - stairs
	SPAWN_LOCATIONS[0][3]  = Vector( 4800, 170, 130 )    -- desert
	SPAWN_LOCATIONS[0][4]  = Vector( -3445, -660, 129 )  -- cliff-camp-bottom
	SPAWN_LOCATIONS[0][5]  = Vector( -2280, 1590, 17 )   -- cliffs
	SPAWN_LOCATIONS[0][6]  = Vector( -1630, 3740, 129 )  -- cliff-camp-top
	SPAWN_LOCATIONS[0][7]  = Vector( 820, 3265, 129 )    -- camp on mid island
	SPAWN_LOCATIONS[0][8]  = Vector( 1750, 5120, 257 )   -- camp-enemy-top
	SPAWN_LOCATIONS[0][9]  = Vector( 3512, 4100, 129 )   -- small desert-shop
	SPAWN_LOCATIONS[0][10] = Vector( 2985, 2512, 129 )   -- small desert-bottom
	SPAWN_LOCATIONS[0][11] = Vector( 4440, 2782, 257 )   -- desert cliff-right
	SPAWN_LOCATIONS[0][12] = Vector( 3414, 1025, 257 )   -- desert cliff-left

-- MAP BGM
------------------
MAP_BGM = {}
-- Oasis Attack
MAP_BGM[0] = {}
	MAP_BGM[0][0] = "Game.Progress.BGM.OasisAttack.0"
	MAP_BGM[0][1] = "Game.Progress.BGM.OasisAttack.1"
	MAP_BGM[0][2] = "Game.Progress.BGM.OasisAttack.2"
	MAP_BGM[0][3] = "Game.Progress.BGM.OasisAttack.3"
	MAP_BGM[0][4] = "Game.Progress.BGM.OasisAttack.4"
