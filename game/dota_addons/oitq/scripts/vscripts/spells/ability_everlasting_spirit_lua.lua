function ApplyResistances( keys )
    local caster   = keys.caster

	caster:SetBaseMagicalResistanceValue( 100 )
	caster:SetPhysicalArmorBaseValue( 1000 )
end

function RemoveResistances( keys )
    local caster   = keys.caster

	caster:SetBaseMagicalResistanceValue( 0 )
	caster:SetPhysicalArmorBaseValue( 0 )
end

function GetHealth( keys )
	keys.caster.everlasting_spirit_preHealth = keys.caster:GetHealth()
end

function OnTakeDamage( keys )
    local caster   				= keys.caster
    local ability   			= keys.ability
    local damage   				= keys.damage
    local minimal_earned_damage = keys.min_damage
    local effect_duration		= keys.effect_duration
    local heroHealth			= caster:GetHealth()
    local heroPreHealth			= caster.everlasting_spirit_preHealth

    -- set earned damage
    if heroPreHealth < damage then damage = heroPreHealth end
    if damage <= minimal_earned_damage then damage = minimal_earned_damage end
    caster:SetHealth( (heroHealth + damage - minimal_earned_damage) )

    -- particles
    ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_explode_points_butterfly.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_butterfly/templar_assassin_trap_ring_inner_start_butterfly.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_pulverize_shock.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

    -- apply modifier
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_everlasting_spirit_invul", {duration = effect_duration})
end