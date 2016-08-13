function OnTakeDamage( keys )
    local caster   				= keys.caster
    local attacker   			= keys.attacker
    local ability   			= keys.ability
    local damage   				= keys.damage
    local reduction_prcnt		= keys.reduction
    local reduction				= math.floor( ( (damage / 100) * reduction_prcnt ) + 0.5 )
    local reflect_prcnt			= keys.reflect
    local reflect_damage		= math.floor( ( (damage / 100) * reflect_prcnt ) + 0.5 )
    local heroHealth			= caster:GetHealth()
    local heroPreHealth			= caster.frost_shield_preHealth

    -- set earned damage
    if heroPreHealth > (damage - reduction) then
    	caster:SetHealth( heroHealth + reduction )
    end

    -- deal damage to target (reflect)
	ApplyDamage({ victim = attacker, attacker = caster, damage = reflect_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function GetHealth( keys )
	keys.caster.frost_shield_preHealth = keys.caster:GetHealth()
end

function AttachParticles( keys )
	local caster 	= keys.caster
	local duration 	= keys.duration

	-- emit sound
	caster:EmitSound("DOTA_CustomItem.FrostShield.Loop")
	Timers:CreateTimer(duration, function()
		caster:StopSound("DOTA_CustomItem.FrostShield.Loop")
	end)
end