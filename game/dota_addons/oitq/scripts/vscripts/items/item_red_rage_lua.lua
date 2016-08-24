function OnDealDamage( keys )
	local caster  = keys.caster
	local target  = keys.unit
	local ability = keys.ability

	local modifier_debuff = keys.modifier_debuff
	local modifier_root   = keys.modifier_root
	local duration 	  	  = ability:GetLevelSpecialValueFor( "root_duration", ability:GetLevel() - 1 )

	if target:HasModifier(modifier_debuff) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_root, {duration = duration})
	end
end