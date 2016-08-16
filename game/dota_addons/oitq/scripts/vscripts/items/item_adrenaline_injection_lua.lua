function item_adrenaline_injection_on_spell_start( keys )
	local caster  = keys.caster
	local ability = keys.ability
	local charges = ability:GetCurrentCharges()
	local new_charges = charges - 1
	local damage_stacks  = ability:GetLevelSpecialValueFor( "damage_absorb", ability:GetLevel() - 1 )
	
	-- Set health on spell start
	keys.caster.adrenaline_injection_preHealth = caster:GetHealth()

	-- Applies the damage absorb buff
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_adrenaline_injection", {})
	caster:SetModifierStackCount("modifier_item_adrenaline_injection", ability, damage_stacks)

	-- Set charges
	if new_charges <= 0 then
		caster:RemoveItem(ability)
		return
	else  --new_charges > 0 
		ability:SetCurrentCharges(new_charges)
	end
end

function item_adrenaline_injection_on_take_damage( keys )
	local attacker_name = keys.attacker:GetName()
	
	if attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer() then  --If the damage was dealt by neutrals or lane creeps, essentially.
		if keys.ability:GetCooldownTimeRemaining() < keys.damageCooldown then
			keys.ability:StartCooldown(keys.damageCooldown)
		end
	end
end

function modifier_item_adrenaline_injection_on_take_damage( keys )
	local caster   = keys.caster
	local ability  = keys. ability
	local modifier = "modifier_item_adrenaline_injection"
	local damage   = keys.damage
	local stacks   = caster:GetModifierStackCount(modifier, ability)
	local absorb_damage = keys.absorb_damage
	local heroPreHealth = caster.adrenaline_injection_preHealth

	-- Ensures the caster is affected by the modifier
	if caster:HasModifier(modifier) then
	    -- set earned damage
	    if heroPreHealth > (damage - absorb_damage) and (damage - absorb_damage) > 0 then
	    	caster:SetHealth( (heroPreHealth - (damage - absorb_damage)) )
	    elseif (damage - absorb_damage) < 0 then
	    	caster:SetHealth( heroPreHealth )
	    end
		
		-- Removes damage stacks from the damage absorb modifier
		stacks = stacks - damage
		if stacks < 0 then stacks = 0 end
		caster:SetModifierStackCount(modifier, ability, stacks)
		stacks = caster:GetModifierStackCount(modifier, ability)
	
		-- If all stacks are gone, we remove the modifier
		if stacks == 0 then
			caster:RemoveModifierByName(modifier)
		end
		
		-- Play the absorb sound on the caster
		EmitSoundOn(keys.sound, caster)
	else
		-- Destroys the damage absorb particle when the modifier is destroyed
		ParticleManager:DestroyParticle(ability.particle, true)
	end
end

function OnEquip( keys )
	local ability = keys.ability
	if ability ~= nil then
		ability:StartCooldown(keys.Cooldown)
	end
end