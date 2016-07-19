function OnDestroy( keys )
	local caster 		  = keys.caster
	local ability 		  = keys.ability
	local debuff_duration = keys.DebuffDuration

	-- apply debuff if caster didn't use any ability or item
	if not caster:HasModifier("modifier_ability_time_lapse_debuff_controller") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_time_lapse_debuff", {duration = debuff_duration})
	end
	
	-- remove debuff controller
	caster:RemoveModifierByName("modifier_ability_time_lapse_debuff_controller")
end