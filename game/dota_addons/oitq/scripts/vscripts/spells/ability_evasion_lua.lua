function evasion_onCreated( keys )
    local caster   = keys.caster

	caster:SetBaseMagicalResistanceValue( 100 )
    caster.evasion_particle = ParticleManager:CreateParticle("particles/spells/evade_character_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

end

function evasion_onDestroy( keys )
    local caster   = keys.caster

	caster:SetBaseMagicalResistanceValue( 0 )
	ParticleManager:DestroyParticle(caster.evasion_particle,true)
end