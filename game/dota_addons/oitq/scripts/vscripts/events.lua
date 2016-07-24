-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  local newState = GameRules:State_Get()

  if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then                     --[[GAME IN PROGRESS]]
    -- destroy pregame aura buff
    GameRules.npc_dota_pre_game_invul_global:ForceKill(false)
  elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then                         --[[PRE GAME]]
    -- create pregame aura buff
    GameRules.npc_dota_pre_game_invul_global = CreateUnitByName("npc_dota_pre_game_invul_global", Vector(0,0,0),false,nil,nil,DOTA_TEAM_NEUTRALS)
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then                   --[[HERO SELECTION]]
    -- increment next round into CNT
    local round_info = CustomNetTables:GetTableValue( "gameinfo", "round_info" )
    local currentRound = 1
    if not round_info then
      CustomNetTables:SetTableValue( "gameinfo", "round_info", { roundNumb = currentRound } )
    else
      CustomNetTables:SetTableValue( "gameinfo", "round_info", { roundNumb = (round_info.roundNumb + 1) } )
      currentRound = round_info.roundNumb + 1
    end
    -- increment required score
    KILLS_TO_END_GAME_FOR_TEAM = KILLS_TO_END_GAME_FOR_TEAM * currentRound
    -- reset winner of the previous round
    GameRules:SetSafeToLeave( false )
    GameRules:SetGameWinner( DOTA_TEAM_NOTEAM )
    -- select a random ARENA
    CURRENT_PLAYED_ARENA = RandomInt( 0, table.getn(ARENA_NAMES) ) -- getn count table values, start in 0
  elseif newState == DOTA_GAMERULES_STATE_POST_GAME then                        --[[POST GAME]]
      Timers:CreateTimer(5.0, function()
          GameRules:ResetToHeroSelection()
      end)
  end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)

  local npc = EntIndexToHScript(keys.entindex)
  SPAWNED_UNIT = npc -- global variable for function FilterGold
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end

  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility(keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

--------------------------------------------------------------------------------
-- Event: OnPlayerPickHero -- A player picked a hero
--------------------------------------------------------------------------------
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
  local playerTeam = player:GetTeam()

  -- attach wearables to each hero
  ApplyWearablesToHeroes( heroEntity )

  -- turn off the first ability point on Lv1
  if heroEntity:GetLevel() == 1 then
    heroEntity:SetAbilityPoints(0)
  end

  -- set unlearnable skills to Lv1
  InitialAbilityLvUp( heroEntity )

  -- set starting gold amount
  local currentGold = heroEntity:GetGold()
  if currentGold > STARTING_GOLD then
    heroEntity:SpendGold( (currentGold - STARTING_GOLD), DOTA_ModifyGold_Unspecified )
  elseif currentGold < STARTING_GOLD then
    PlayerResource:ModifyGold( player:GetPlayerID(), (STARTING_GOLD - currentGold), true, DOTA_ModifyGold_Unspecified )
  end

  -- Create OR Reset score per round
  local teamScore = CustomNetTables:GetTableValue( "gameinfo", "teamScore" )
  if not teamScore then
    teamScore = {}
  end
  teamScore[tostring(playerTeam)] = 0
  CustomNetTables:SetTableValue( "gameinfo", "teamScore", teamScore )

  -- Emit sounds
  EmitAnnouncerSoundForPlayer("announcer_dlc_defensegrid_announcer_battle_prepare", player:GetPlayerID())

  -- Welcome message
  GameRules:SendCustomMessage("Welcome to <font color='#FF6000'>One in the Quiver (REMASTER)</font>!", playerTeam, 0)
  GameRules:SendCustomMessage("Ported by <font color='#FF8F22'>Frixs</font>", playerTeam, 0)
  GameRules:SendCustomMessage("Version: " .. BAREBONES_VERSION, playerTeam, 0)
  GameRules:SendCustomMessage("Please report bugs and leave feedback in our workshop page.", playerTeam, 0)
  GameRules:SendCustomMessage("<br>Have fun!", playerTeam, 0)

  -- CALL function: OnEveryonePicked
  if (GameRules.PLAYERS_PICKED_HERO==GameRules.PLAYER_COUNT) then
    GameMode:OnEveryonePicked()
  end

  -- Set respawn time to additional starting time for the first relocate from lobby to arena
  heroEntity:SetTimeUntilRespawn( ADDITIONAL_STARTING_RESPAWN_TIME )
  -- get random respawn position
  local random_spawn_point = RandomInt( 0, table.getn(SPAWN_LOCATIONS[CURRENT_PLAYED_ARENA]) )
  -- set respawn position according to respawn locations table
  if RANDOM_SPAWN then heroEntity:SetRespawnPosition( SPAWN_LOCATIONS[CURRENT_PLAYED_ARENA][random_spawn_point] ) end
  -- respawn unit according to respawn time
  heroEntity:RespawnUnit()
  -- return the correct respawn time after relocating (you are relocated after setting a new respawn time)
  Timers:CreateTimer(ADDITIONAL_STARTING_RESPAWN_TIME, function() heroEntity:SetTimeUntilRespawn(FIXED_RESPAWN_TIME) end)
  -- send selected map name to chat
  Timers:CreateTimer((ADDITIONAL_STARTING_RESPAWN_TIME + FIXED_RESPAWN_TIME), function()
      GameRules:SendCustomMessage("Selected map: <font color='#FFB422'>"..ARENA_NAMES[CURRENT_PLAYED_ARENA].."</font>",0,0)
      -- relocate camera to target to current arena | +0.1sec delay for relocating
      Timers:CreateTimer(0.1, function()
          CustomGameEventManager:Send_ServerToPlayer( player, "initCameraRelocate", nil )
      end)
  end)

end

--------------------------------------------------------------------------------
-- Event: OnEveryonePicked -- All players picked a hero
--------------------------------------------------------------------------------
function GameMode:OnEveryonePicked()

end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

--------------------------------------------------------------------------------
-- Event: OnEntityKilled -- An entity died
--------------------------------------------------------------------------------
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
  --[[ MY ADDITIONALS ]]
  if killedUnit:IsRealHero() then
    -- set respawn location in the correct location
    -- get random respawn position
    local random_spawn_point = RandomInt( 0, table.getn(SPAWN_LOCATIONS[CURRENT_PLAYED_ARENA]) )
    -- set respawn position according to respawn locations table
    if RANDOM_SPAWN then killedUnit:SetRespawnPosition( SPAWN_LOCATIONS[CURRENT_PLAYED_ARENA][random_spawn_point] ) end

    -- if player controlled hero killed player controlled hero
    if killerEntity:IsRealHero() then
      -- při zabití nepřítele - dodat jeden shuriken (speciální schopnosti i více)
      local ability_shuriken = killerEntity:FindAbilityByName("shuriken_spell")
      if ability_shuriken then
        local shurikens_to_add = 1

        if killedUnit:HasModifier("modifier_shuriken_ground_pound_bonus") then
          shurikens_to_add = 2
        end

        local stacks = killerEntity:GetModifierStackCount("modifier_shuriken_shots", killerEntity)
        killerEntity:SetModifierStackCount("modifier_shuriken_shots", killerEntity, stacks + shurikens_to_add)
      end

      -- increment team score
      local teamScore = CustomNetTables:GetTableValue( "gameinfo", "teamScore" )
      local player = killerEntity:GetOwner()
      local playerTeam = tostring(player:GetTeam())
      teamScore[playerTeam] = teamScore[playerTeam] + 1
      CustomNetTables:SetTableValue( "gameinfo", "teamScore", teamScore )

      -- gain experience + custom message
      if killedUnit ~= killerEntity then
        -- Add experience to killerEntity and call custom message
        killerEntity:AddExperience( 10, 0, false, false ) --XP per KILL enemy hero
        GameRules:SendCustomMessage("%s1 killed <font color='#FFFFFF'>"..PlayerResource:GetPlayerName(killedUnit:GetPlayerID()).."</font>", 0, 0)
      end
    end

    -- Kill feed message and popup based on what the gold filter modified earlier
    if SPAWNED_UNIT and killedUnit ~= killerEntity then
      local killGold   = SPAWNED_UNIT.KillGold
      local assistGold = SPAWNED_UNIT.AssistGold
      local gold       = killGold + assistGold
      local killerID   = killerEntity:GetPlayerID()
      --GameRules:SendCustomMessage("%s1 killed a hero for <font color='#F0BA36'>"..gold.."</font> gold!", 0, 0)
        
      SPAWNED_UNIT.KillGold = nil
      SPAWNED_UNIT.AssistGold = nil

      -- Fake Hero gold popup
      EmitSoundOnLocationForAllies(killedUnit:GetAbsOrigin(), "Gold.Coins", killerEntity)
      local digits = #tostring(gold) + 1
      local particleName = "particles/msg_fx/msg_goldbounty.vpcf" --"particles/msg_fx/msg_gold.vpcf"
      local particle = ParticleManager:CreateParticleForTeam(particleName, PATTACH_OVERHEAD_FOLLOW, killedUnit, DOTA_TEAM_GOODGUYS)
      ParticleManager:SetParticleControl(particle, 0, killedUnit:GetAbsOrigin())
      ParticleManager:SetParticleControl(particle, 1, Vector(0, tonumber(gold), 0))
      ParticleManager:SetParticleControl(particle, 2, Vector(2.0, digits, 0))
      ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))

      print(killerEntity:GetUnitName().." recieved a total of "..gold.." gold for killing "..killedUnit:GetUnitName())

      PlayerResource:ModifyGold(killerID, gold, true, DOTA_ModifyGold_Unspecified)
    end
  end
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end

--------------------------------------------------------------------------------
-- Event: FilterGold -- Function to set gold per kill
--------------------------------------------------------------------------------
function GameMode:FilterGold(filterTable)
    local gold = filterTable["gold"]
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]

    -- Special handling of hero kill gold (both bounty and assist gold goes through here first)
    if reason == DOTA_ModifyGold_HeroKill then
        local playerName = PlayerResource:GetPlayerName(playerID)
        if playerName == "" then playerName = "Player "..playerID end

        -- The Assist Gold is given first, then the Kill gold
        if not SPAWNED_UNIT.AssistGold then
            filterTable["gold"] = 0
            SPAWNED_UNIT.AssistGold = filterTable["gold"]
            print(playerName.." recieved "..filterTable["gold"].." gold (bonus: "..filterTable["gold"]-gold..") due to a Hero Assist")
        elseif not SPAWNED_UNIT.KillGold then
            filterTable["gold"] = 50
            SPAWNED_UNIT.KillGold = filterTable["gold"]
            print(playerName.." recieved "..filterTable["gold"].." gold (bonus: "..filterTable["gold"]-gold..") due to a Hero Kill")
        end

        return false --Denies the wrong popup gold, which is faked on OnEntityKilled
    end

    return true
end

GOLD_REASONS = {
    [0] = "DOTA_ModifyGold_Unspecified",  
    [1] = "DOTA_ModifyGold_Death",  
    [2] = "DOTA_ModifyGold_Buyback",
    [3] = "DOTA_ModifyGold_PurchaseConsumable",
    [4] = "DOTA_ModifyGold_PurchaseItem",
    [5] = "DOTA_ModifyGold_AbandonedRedistribute",
    [6] = "DOTA_ModifyGold_SellItem",
    [7] = "DOTA_ModifyGold_AbilityCost",
    [8] = "DOTA_ModifyGold_CheatCommand",
    [9] = "DOTA_ModifyGold_SelectionPenalty",
    [10] = "DOTA_ModifyGold_GameTick",
    [11] = "DOTA_ModifyGold_Building",
    [12] = "DOTA_ModifyGold_HeroKill",
    [13] = "DOTA_ModifyGold_CreepKill",
    [14] = "DOTA_ModifyGold_RoshanKill",
    [15] = "DOTA_ModifyGold_CourierKill",
    [16] = "DOTA_ModifyGold_SharedGold",
}