function item_hazzard_goggles_on_spell_start( keys )	
	local caster = keys.caster
	local item_ability = keys.ability
	local current_charges = item_ability:GetCurrentCharges()
	for i=0,5 do
		local opposite_item = caster:GetItemInSlot( i )
		if opposite_item ~= nil then opposite_item = opposite_item:GetAbilityName() end
		if opposite_item == "item_cross_of_eternity" then
			opposite_item = caster:GetItemInSlot( i )
			break
		else
			opposite_item = nil
		end
	end
	local casterHealth = caster:GetHealth() -- stay current HP on same value after debuff HP
	local casterMaxHealth = caster:GetMaxHealth()
	if casterHealth > casterMaxHealth then casterHealth = casterMaxHealth end

	if current_charges < keys.max_charges then
		if caster:HasModifier("modifier_item_cross_of_eternity_charge_1") then
			if caster:HasModifier("modifier_item_cross_of_eternity_charge_2") then
				if caster:HasModifier("modifier_item_cross_of_eternity_charge_3") then
					caster:RemoveModifierByName("modifier_item_cross_of_eternity_charge_3")
					if opposite_item ~= nil then opposite_item:SetCurrentCharges(2) end
					caster:SetHealth( casterHealth ) -- stay current HP on same value after debuff HP
				else
					caster:RemoveModifierByName("modifier_item_cross_of_eternity_charge_2")
					if opposite_item ~= nil then opposite_item:SetCurrentCharges(1) end
					caster:SetHealth( casterHealth ) -- stay current HP on same value after debuff HP
				end
			else
				caster:RemoveModifierByName("modifier_item_cross_of_eternity_charge_1")
				if opposite_item ~= nil then opposite_item:SetCurrentCharges(0) end
				caster:SetHealth( casterHealth ) -- stay current HP on same value after debuff HP
			end
		else
			item_ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_hazzard_goggles_charge_"..(current_charges+1), {})
			caster:SetHealth( casterHealth ) -- stay current HP on same value after debuff HP
			item_ability:SetCurrentCharges(current_charges + 1)
		end
	end
end

function item_hazzard_goggles_on_death( keys )
	local caster 	   = keys.caster
	local item_ability = keys.ability
	if item_ability == nil then -- this is because of drop item and then pickup to inventory
		for i=0,5 do
			item_ability = caster:GetItemInSlot( i )
			if item_ability ~= nil then item_ability = item_ability:GetAbilityName() end
			if item_ability == "item_hazzard_goggles" then
				item_ability = caster:GetItemInSlot( i )
				break
			end
		end
	end
	if item_ability ~= nil then
		local current_charges = item_ability:GetCurrentCharges()
		item_ability:SetCurrentCharges(current_charges - 1)
	end
end

function modifier_item_hazzard_goggles_damage_cooldown_on_take_damage( keys )
	local attacker_name = keys.attacker:GetName()

	if attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer() then  --If the damage was dealt by neutrals or lane creeps, essentially.
		if keys.ability:GetCooldownTimeRemaining() < keys.damageCooldown then
			keys.ability:StartCooldown(keys.damageCooldown)
		end
	end
end

function item_hazzard_goggles_on_equip( keys )
	local caster = keys.caster
	local item_ability = keys.ability
    local itemName = item_ability:GetAbilityName()
    local hero = EntIndexToHScript( keys.caster_entindex )

	-- this item can be only 1 in inventory
	local itemSum = 0
    Timers:CreateTimer(0.1,function()
        -- Go through every item slot
        for itemSlot = 0, 5, 1 do 
            local Item = hero:GetItemInSlot( itemSlot )
            -- When we find the item we want to check
            if Item ~= nil and itemName == Item:GetName() then
                itemSum = itemSum + 1
                -- Check Restriction
                if itemSum > 1 then
                	DropItem(item_ability, hero)
                end
            end
        end
    end)

    -- set current charges to item
	if caster:HasModifier("modifier_item_hazzard_goggles_charge_1") then
		if caster:HasModifier("modifier_item_hazzard_goggles_charge_2") then
			if caster:HasModifier("modifier_item_hazzard_goggles_charge_3") then
				item_ability:SetCurrentCharges(3)
			else
				item_ability:SetCurrentCharges(2)
			end
		else
			item_ability:SetCurrentCharges(1)
		end
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