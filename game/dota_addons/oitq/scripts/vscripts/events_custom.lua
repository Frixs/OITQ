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