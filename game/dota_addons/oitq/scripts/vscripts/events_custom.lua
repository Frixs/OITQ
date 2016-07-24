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
                    if args['itemName'] == Item:GetName() then
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

function OnEmitSound_global( eventSourceIndex, args )
    if IsServer() then
        EmitAnnouncerSound( args['soundName'] )
    end
end

function SendCustomMsg( eventSourceIndex, args )
    if IsServer() then
        GameRules:SendCustomMessage(args['textMessage'], 0, args['forWhom'])
    end
end

--//--\\--//--\\--
CustomGameEventManager:RegisterListener( "OnDropItemInfo", OnDropItem )
CustomGameEventManager:RegisterListener( "OnEmitSound_countdown", OnEmitSound_global )
CustomGameEventManager:RegisterListener( "SendGameStart", SendCustomMsg )
--\\--//--\\--//--

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