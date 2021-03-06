---------------------------------------------------------------------------
-- OnDropItem
---------------------------------------------------------------------------
function OnDropItem( eventSourceIndex, args )
    if IsServer() then
        local hero = EntIndexToHScript( args['hero'] )

        -- This timer is needed because OnEquip triggers before the item actually being in inventory
        Timers:CreateTimer(0.1,function()
            -- Go through every item slot
            for itemSlot = 0, 5, 1 do
                local Item = hero:GetItemInSlot( itemSlot )

                -- When we find the item we want to check
                if Item ~= nil then
                    if args['itemName'] == Item:GetName() and Item:IsDroppable() == true then
                        DropItem(Item, hero)
                    end
                end
            end
        end)
    end
end

function DropItem( item, hero )
    -- Error Sound
    EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())

    -- Create a new empty item
    local newItem = CreateItem( item:GetName(), nil, nil )
    newItem:SetPurchaseTime( 0 )

    -- This is needed if you are working with items with charges, uncomment it if so.
    -- newItem:SetCurrentCharges( goldToDrop )

    -- Make a new item and launch it near the hero
    local spawnPoint = Vector( 0, 0, 0 )
    spawnPoint = hero:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( spawnPoint, newItem )
    newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )

    --finally, remove the item
    hero:RemoveItem(item)
end

---------------------------------------------------------------------------
-- OnEmitSound_announcer
---------------------------------------------------------------------------
function OnEmitSound_announcer( eventSourceIndex, args )
    if IsServer() then
        EmitAnnouncerSound( args['soundName'] )
    end
end

---------------------------------------------------------------------------
-- OnEmitSound_global
---------------------------------------------------------------------------
function OnEmitSound_global( eventSourceIndex, args )
    if IsServer() then
        EmitGlobalSound( args['soundName'] )
    end
end

---------------------------------------------------------------------------
-- SendCustomMsg
---------------------------------------------------------------------------
function SendCustomMsg( eventSourceIndex, args )
    if IsServer() then
        GameRules:SendCustomMessage(args['textMessage'], 0, args['forWhom'])
    end
end

---------------------------------------------------------------------------
-- HeroReplace
---------------------------------------------------------------------------
function HeroReplace( eventSourceIndex, args )
    local playerID = args['playerID']
    local oldHero  = PlayerResource:GetSelectedHeroEntity(playerID)
    PlayerResource:ReplaceHeroWith(playerID, args['heroName'], STARTING_GOLD, 0)
    UTIL_Remove(oldHero)
end

---------------------------------------------------------------------------
-- IsGamePausedStatus
---------------------------------------------------------------------------
function IsGamePausedStatus( eventSourceIndex, args )
    local GameStatus = false
    if GameRules:IsGamePaused() then
        GameStatus = true
    end

    CustomGameEventManager:Send_ServerToAllClients( "HeroSelectionPauseInfo", { pause = GameStatus } )
end

---------------------------------------------------------------------------
-- SetPlayerVote
---------------------------------------------------------------------------
function SetPlayerVote( eventSourceIndex, args )
    local votes = CustomNetTables:GetTableValue( "gameinfo", "votes" )
    if votes then
        votes[args['playerID']] = args['voteStatus']
        CustomNetTables:SetTableValue( "gameinfo", "votes", votes )
    else
        local newVote = {}
        newVote[args['playerID']] = args['voteStatus']
        CustomNetTables:SetTableValue( "gameinfo", "votes", newVote )
    end
end



--//--\\--//--\\--
CustomGameEventManager:RegisterListener( "OnDropItemInfo", OnDropItem )
CustomGameEventManager:RegisterListener( "is_game_paused", IsGamePausedStatus )
CustomGameEventManager:RegisterListener( "selectHero", HeroReplace )
CustomGameEventManager:RegisterListener( "SetPlayerVote", SetPlayerVote )
--\\--//--\\--//--



---------------------------------------------------------------------------
-- ApplyWearablesToHeroes
---------------------------------------------------------------------------
function ApplyWearablesToHeroes( heroEntity )
    if heroEntity:GetClassname() == "npc_dota_hero_juggernaut" then
        SwapWearable( heroEntity, "models/heroes/juggernaut/jugg_mask.vmdl",        "models/items/juggernaut/thousand_faces_mask/thousand_faces_mask.vmdl" )
        SwapWearable( heroEntity, "models/heroes/juggernaut/jugg_bracers.vmdl",     "models/items/juggernaut/thousand_faces_wraps/thousand_faces_wraps.vmdl" )
        SwapWearable( heroEntity, "models/heroes/juggernaut/jugg_cape.vmdl",        "models/items/juggernaut/thousand_faces_vest/thousand_faces_vest.vmdl" )
        SwapWearable( heroEntity, "models/heroes/juggernaut/juggernaut_pants.vmdl", "models/items/juggernaut/thousand_faces_hakama/thousand_faces_hakama.vmdl" )
        SwapWearableInSlot( heroEntity, "models/items/juggernaut/highplains_sword_long.vmdl", "weapon" )
    --[[
        --CosmeticLib:EquipHeroSet( heroEntity, 20151 )
        CosmeticLib:ReplaceWithItemID( heroEntity, 6, 4425 ) -- mask
        CosmeticLib:ReplaceWithItemID( heroEntity, 8, 4411 ) -- vest
        CosmeticLib:ReplaceWithItemID( heroEntity, 9, 4395 ) -- wraps
        CosmeticLib:ReplaceWithItemID( heroEntity, 62, 4401 ) -- legs
    ]]
    elseif heroEntity:GetClassname() == "npc_dota_hero_bloodseeker" then
        SwapWearable( heroEntity, "models/heroes/blood_seeker/bracer.vmdl", "models/items/blood_seeker/blood_seeker_executioner_gauntlets/blood_seeker_executioner_gauntlets.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/cape.vmdl",   "models/items/blood_seeker/blood_seeker_executioner_collar/blood_seeker_executioner_collar.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/helmet.vmdl", "models/items/blood_seeker/blood_seeker_executioner_hood/blood_seeker_executioner_hood.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/belt.vmdl",   "models/items/blood_seeker/blood_seeker_executioner_skirt/blood_seeker_executioner_skirt.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/neck.vmdl",   "models/items/blood_seeker/blood_seeker_executioner_mantle/blood_seeker_executioner_mantle.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/weapon.vmdl", "models/items/blood_seeker/hunt_of_the_weeping_beast_weapon/hunt_of_the_weeping_beast_weapon.vmdl" )
        SwapWearable( heroEntity, "models/heroes/blood_seeker/weapon_offhand.vmdl", "models/items/blood_seeker/furyblade_offhand_model/furyblade_offhand_model.vmdl" )
    --[[
        CosmeticLib:ReplaceWithItemID( heroEntity, 74, 5307 ) -- Bracers
        CosmeticLib:ReplaceWithItemID( heroEntity, 257, 5308 ) -- Skirt
        CosmeticLib:ReplaceWithItemID( heroEntity, 71, 4431 ) -- Offhand Blade
        CosmeticLib:ReplaceWithItemID( heroEntity, 70, 5306 ) -- Headdress
        CosmeticLib:ReplaceWithItemID( heroEntity, 73, 5300 ) -- Cape
        CosmeticLib:ReplaceWithItemID( heroEntity, 72, 5298 ) -- Necklace
        CosmeticLib:ReplaceWithItemID( heroEntity, 69, 9311 ) -- Blade
    ]]
    elseif heroEntity:GetClassname() == "npc_dota_hero_dark_seer" then
        SwapWearable( heroEntity, "models/heroes/dark_seer/dark_seer_arm.vmdl",   "models/items/dark_seer/master_strategist_arms/master_strategist_arms.vmdl" )
        SwapWearable( heroEntity, "models/heroes/dark_seer/dark_seer_back.vmdl",  "models/items/dark_seer/gombangdae_back/gombangdae_back.vmdl" )
        SwapWearable( heroEntity, "models/heroes/dark_seer/dark_seer_head.vmdl",  "models/items/dark_seer/forgotten_tactician_head/forgotten_tactician_head.vmdl" )
        SwapWearable( heroEntity, "models/heroes/dark_seer/dark_seer_neck.vmdl",  "models/items/dark_seer/master_strategist_shoulder/master_strategist_shoulder.vmdl" )
        SwapWearable( heroEntity, "models/heroes/dark_seer/dark_seer_waist.vmdl", "models/items/dark_seer/master_strategist_belt/master_strategist_belt.vmdl" )
    --[[
        CosmeticLib:ReplaceWithItemID( heroEntity, 348, 6235 ) -- Back
        CosmeticLib:ReplaceWithItemID( heroEntity, 351, 8214 ) -- Loin Cloth
        CosmeticLib:ReplaceWithItemID( heroEntity, 352, 8215 ) -- Neck Armor
        CosmeticLib:ReplaceWithItemID( heroEntity, 350, 8213 ) -- Bracers
        CosmeticLib:ReplaceWithItemID( heroEntity, 349, 8765 ) -- Head
    ]]
    elseif heroEntity:GetClassname() == "npc_dota_hero_meepo" then
        SwapWearable( heroEntity, "models/heroes/meepo/hood.vmdl",      "models/items/meepo/crystal_scavenger_head/crystal_scavenger_head.vmdl" )
        SwapWearable( heroEntity, "models/heroes/meepo/pack.vmdl",      "models/items/meepo/crystal_scavenger_back/crystal_scavenger_back.vmdl" )
        SwapWearable( heroEntity, "models/heroes/meepo/bracers.vmdl",   "models/items/meepo/riftshadow_roamer_gloves/riftshadow_roamer_gloves.vmdl" )
        SwapWearable( heroEntity, "models/heroes/meepo/shoulders.vmdl", "models/items/meepo/crystal_scavenger_shoulders/crystal_scavenger_shoulders.vmdl" )
        SwapWearableInSlot( heroEntity, "models/heroes/meepo/meepo_weapon.vmdl", "weapon" )
    --[[
        CosmeticLib:ReplaceWithItemID( heroEntity, 296, 6563 ) -- hood
        CosmeticLib:ReplaceWithItemID( heroEntity, 297, 6562 ) -- back
        CosmeticLib:ReplaceWithItemID( heroEntity, 299, 4434 ) -- bracers
        CosmeticLib:ReplaceWithItemID( heroEntity, 298, 4421 ) -- shoulderpads
    ]]
    elseif heroEntity:GetClassname() == "npc_dota_hero_bounty_hunter" then
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_backpack.vmdl", "models/items/bounty_hunter/twinblades_back/twinblades_back.vmdl" )
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_bandana.vmdl",  "models/items/bounty_hunter/twinblades_head/twinblades_head.vmdl" )
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_pads.vmdl",     "models/items/bounty_hunter/twinblades_armor/twinblades_armor.vmdl" )
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_bweapon.vmdl",  "models/items/bounty_hunter/twinblades_shoulder/twinblades_shoulder.vmdl" )
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_lweapon.vmdl",  "models/items/bounty_hunter/twinblades_offhand/twinblades_offhand.vmdl" )
        SwapWearable( heroEntity, "models/heroes/bounty_hunter/bounty_hunter_rweapon.vmdl",  "models/items/bounty_hunter/twinblades_weapon/twinblades_weapon.vmdl" )
    --[[
        CosmeticLib:ReplaceWithItemID( heroEntity, 55, 6525 ) -- bandana
        CosmeticLib:ReplaceWithItemID( heroEntity, 564, 6562 ) -- arms
        CosmeticLib:ReplaceWithItemID( heroEntity, 50, 6528 ) -- weapon
        CosmeticLib:ReplaceWithItemID( heroEntity, 51, 6543 ) -- offhand
        CosmeticLib:ReplaceWithItemID( heroEntity, 54, 6529 ) -- shoulder
        CosmeticLib:ReplaceWithItemID( heroEntity, 52, 6527 ) -- back
        CosmeticLib:ReplaceWithItemID( heroEntity, 53, 6537 ) -- armor
    ]]
    end
end

---------------------------------------------------------------------------
-- InitialAbilityLvUp
---------------------------------------------------------------------------
function InitialAbilityLvUp( heroEntity )
    -- set unlearnable skills to Lv1
    local ability_lvup = heroEntity:FindAbilityByName("shuriken_spell")
    if ability_lvup then
        ability_lvup:SetLevel(1)
        heroEntity:SetModifierStackCount("modifier_shuriken_shots", heroEntity, 1)
    end
    local ability_lvup = heroEntity:FindAbilityByName("dash_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
    local ability_lvup = heroEntity:FindAbilityByName("anger_aura_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
    local ability_lvup = heroEntity:FindAbilityByName("fork_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
    local ability_lvup = heroEntity:FindAbilityByName("ground_pound_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
    local ability_lvup = heroEntity:FindAbilityByName("vanishing_act_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
    local ability_lvup = heroEntity:FindAbilityByName("ice_block_spell")
    if ability_lvup then ability_lvup:SetLevel(1) end
end

---------------------------------------------------------------------------
-- Votes & Rematch
---------------------------------------------------------------------------
function ResetVotes()
    local votes = CustomNetTables:GetTableValue( "gameinfo", "votes" )
    if votes then
        local resetValues = {}
        CustomNetTables:SetTableValue( "gameinfo", "votes", resetValues )
    end
end

function RematchVotingCountdown()
    local currentTime = CustomNetTables:GetTableValue( "gameinfo", "rematch_voting_time" )

    Timers:CreateTimer(1.0, function()
        local newTime = currentTime['voting_time'] - 1
        CustomNetTables:SetTableValue( "gameinfo", "rematch_voting_time", { voting_time = newTime } )

        -- endup countdown
        if currentTime['voting_time'] >= 0 then
            RematchVotingCountdown()
            return
        else
            -- on the end of the countdown
            local votes = CustomNetTables:GetTableValue( "gameinfo", "votes" )
            if votes then
                local YesVotes = 0
                for key,value in pairs(votes) do
                    if value == 2 then
                        YesVotes = YesVotes + 1
                    end
                end

                if YesVotes >= MINIMUM_VOTES_TO_REMATCH then
                    -- rematch after delay
                    Timers:CreateTimer(1.0, function()
                        SendToConsole("stopsound")
                        GameRules:ResetToHeroSelection()
                    end)
                end
            end
        end
    end)
end

---------------------------------------------------------------------------
-- DropInventory
---------------------------------------------------------------------------
function DropInventory( hero )
    -- This timer is needed because OnEquip triggers before the item actually being in inventory
    Timers:CreateTimer(0.1,function()
        local droppedItem = {}
        droppedItem[0] = false
        droppedItem[1] = false
        droppedItem[2] = false
        droppedItem[3] = false
        droppedItem[4] = false
        droppedItem[5] = false

        -- get number of droppable items
        local itemToDrop = 0
        for y = INVENTORY_SAFE_SLOTS, 5, 1 do
            if hero:GetItemInSlot( y ) then
                itemToDrop = itemToDrop + 1
            end
        end

        if itemToDrop > INVENTORY_DROP_SUM then
            -- define slots to drop
            for z = 1, INVENTORY_DROP_SUM, 1 do
                local slot = DropInventRand(hero, droppedItem)
                --print("*"..slot.."*")
                droppedItem[slot] = true
            end
        else
            -- drop all remaining items
            for z = INVENTORY_SAFE_SLOTS, 5, 1 do
                local item = hero:GetItemInSlot( z )
                if item then
                    if item:IsDroppable() == true then
                        droppedItem[z] = true
                    end
                end
            end
        end

        -- Go through dangerous item slots (2 slots are safe)
        for itemSlot = INVENTORY_SAFE_SLOTS, 5, 1 do
            if droppedItem[itemSlot] then
                local Item = hero:GetItemInSlot( itemSlot )
                if Item ~= nil then
                    DropItem(Item, hero)
                end
            end
        end
    end)
end

function DropInventRand( hero, droppedItem )
    local key = RandomInt( INVENTORY_SAFE_SLOTS, 5 )
    local item = hero:GetItemInSlot( key )

    --print("===")
    --print(key)
    --print(item)
    --print("===")
    if droppedItem[key] or item == nil then
        --print("v1")
        return DropInventRand( hero, droppedItem )
    elseif item:IsDroppable() == false then
        --print("v2")
        return DropInventRand( hero, droppedItem )
    else
        --print("v3")
        return key
    end
end

---------------------------------------------------------------------------
-- OnPlayerDeathLoot
---------------------------------------------------------------------------
function OnPlayerDeathLoot( hero )
    local lootKV = LoadKeyValues("scripts/kv/loot.kv")

    local dropped = false
    -- common
    randomNumber = RandomInt( 1, lootKV['percentageLevel'] )
    if randomNumber < 0 and dropped == false then  -- 0.0% chance (common) -- OFF
        --ChooseRandomItem( hero, "common", lootKV )
        --dropped = true
    else
        -- uncommon
        randomNumber = RandomInt( 1, lootKV['percentageLevel'] )
        if randomNumber < 30 and dropped == false then  -- 3.0% chance (uncommon)
            ChooseRandomItem( hero, "uncommon", lootKV )
            dropped = true
        else
            -- rare
            randomNumber = RandomInt( 1, lootKV['percentageLevel'] )
            if randomNumber < 20 and dropped == false then  -- 2.0% chance (rare)
                ChooseRandomItem( hero, "rare", lootKV )
                dropped = true
            else
                -- epic
                randomNumber = RandomInt( 1, lootKV['percentageLevel'] )
                if randomNumber < 10 and dropped == false then  -- 1.0% chance (epic)
                    ChooseRandomItem( hero, "epic", lootKV )
                    dropped = true
                else
                    -- artifact
                    randomNumber = RandomInt( 1, lootKV['percentageLevel'] )
                    if randomNumber < 5 and dropped == false then  -- 0.5% chance (artifact)
                        ChooseRandomItem( hero, "artifact", lootKV )
                    end
                end
            end
        end
    end
end

function ChooseRandomItem( hero, rarity, lootKV )
    local itemCount = 0
    for Key, Value in pairs( lootKV[rarity]['items'] ) do
      itemCount = itemCount + 1
    end

    -- choose item from pack
    randomItem = RandomInt( 0, (itemCount - 1) )
    -- launch height
    local flMaxHeight = RandomFloat( 300, 450 )

    -- create item & launch
    LaunchWorldItemFromUnit( lootKV[rarity]['items'][tostring(randomItem)], flMaxHeight, 0.5, hero )
end

---------------------------------------------------------------------------
-- LaunchWorldItemFromUnit
---------------------------------------------------------------------------
function LaunchWorldItemFromUnit( sItemName, flLaunchHeight, flDuration, hUnit )
    -- This timer is needed because OnEquip triggers before the item actually being in inventory
    Timers:CreateTimer(0.1,function()
        -- Create a new empty item
        local newItem = CreateItem( sItemName, nil, nil )
        newItem:SetPurchaseTime( 0 )

        -- Make a new item and launch it near the hero
        local spawnPoint = Vector( 0, 0, 0 )
        spawnPoint = hUnit:GetAbsOrigin()
        local drop = CreateItemOnPositionSync( spawnPoint, newItem )
        local launchVector = spawnPoint + RandomVector( RandomFloat( 300, 500 ) )
        newItem:LaunchLoot( false, flLaunchHeight, flDuration, launchVector )

        Timers:CreateTimer(0.6,function()
            -- particles
            local particleLoot = ParticleManager:CreateParticle("particles/econ/items/meepo/meepo_diggers_divining_rod/meepo_divining_rod_poof_end_rays_burst.vpcf", PATTACH_ABSORIGIN, hUnit)
            ParticleManager:SetParticleControl(particleLoot, 0 , launchVector)
        end)
    end)
end

---------------------------------------------------------------------------
-- Ability: Sudden Death
---------------------------------------------------------------------------
function OnDeathFullLoot( keys )
    local hero = keys.caster

    -- This timer is needed because OnEquip triggers before the item actually being in inventory
    Timers:CreateTimer(0.1,function()
        -- Go through every item slot
        for itemSlot = 0, 5, 1 do
            local Item = hero:GetItemInSlot( itemSlot )

            if Item ~= nil then
                if Item:IsDroppable() == true then
                    DropItem(Item, hero)
                end
            end
        end
    end)
end