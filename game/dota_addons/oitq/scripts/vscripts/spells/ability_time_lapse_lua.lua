function OnDestroy( keys )
	local caster 		  			 	   = keys.caster
	local ability 		  			 	   = keys.ability
	local ability_level 			 	   = ability:GetLevel() - 1
	local ability_cooldown			 	   = ability:GetCooldownTimeRemaining()
	local debuff_duration 			 	   = ability:GetLevelSpecialValueFor("debuff_duration", ability_level)
	local debuff_additional_cooldown       = ability:GetLevelSpecialValueFor("debuff_additional_cooldown", ability_level)

	-- apply debuff if caster didn't use any ability or item
	if not caster:HasModifier("modifier_ability_time_lapse_debuff_controller") then
		-- apply debuff
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_time_lapse_debuff", {duration = debuff_duration})

		-- reset cooldown + debuff additional cooldown
		ability:StartCooldown( (ability_cooldown + debuff_additional_cooldown) )

		-- appearance
		caster:EmitSound("DOTA_CustomAbility.TimeLapse.End")
		caster.EndParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_f.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	end
	
	-- remove debuff controller
	caster:RemoveModifierByName("modifier_ability_time_lapse_debuff_controller")
end