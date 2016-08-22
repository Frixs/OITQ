-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  --PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
  --PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)


  -- precatche hero particles
  PrecacheResource("particle_folder", "particles/units/heroes/hero_juggernaut", context)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_bloodseeker", context)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_dark_seer", context)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_meepo", context)
  PrecacheResource("particle_folder", "particles/units/heroes/hero_bounty_hunter", context)

  PrecacheResource("model_folder", "particles/heroes/juggernaut", context)
  PrecacheResource("model", "particles/heroes/juggernaut/juggernaut.vmdl", context)
  PrecacheModel("models/heroes/juggernaut/juggernaut.vmdl", context)
  PrecacheResource("model_folder", "particles/heroes/bloodseeker", context)
  PrecacheResource("model", "particles/heroes/bloodseeker/bloodseeker.vmdl", context)
  PrecacheModel("models/heroes/bloodseeker/bloodseeker.vmdl", context)
  PrecacheResource("model_folder", "particles/heroes/dark_seer", context)
  PrecacheResource("model", "particles/heroes/dark_seer/dark_seer.vmdl", context)
  PrecacheModel("models/heroes/dark_seer/dark_seer.vmdl", context)
  PrecacheResource("model_folder", "particles/heroes/meepo", context)
  PrecacheResource("model", "particles/heroes/meepo/meepo.vmdl", context)
  PrecacheModel("models/heroes/meepo/meepo.vmdl", context)
  PrecacheResource("model_folder", "particles/heroes/bounty_hunter", context)
  PrecacheResource("model", "particles/heroes/bounty_hunter/bounty_hunter.vmdl", context)
  PrecacheModel("models/heroes/bounty_hunter/bounty_hunter.vmdl", context)
  -- precatche sound sets
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_juggernaut.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_bloodseeker.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_dark_seer.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_meepo.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_bounty_hunter.vsndevts", context)

  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_announcer_dlc_defensegrid.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/background_music_custom.vsndevts", context)

  -- precatche units
  PrecacheUnitByNameSync("npc_dota_pre_game_invul_global", context)

    -- Wearables
    _G.HATS = LoadKeyValues("scripts/kv/upgrades.kv")
    for k,slot_table in pairs(HATS) do
        for key,value in pairs(slot_table) do
            if type(value) ~= "table" then
                if string.match(value, "vmdl") then
                    PrecacheModel(value, context)
                end
            end
        end
    end  
    
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end