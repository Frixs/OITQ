function OnSpellStart( keys )
	local caster  = keys.caster
	local ability = keys.ability
	local charges = ability:GetCurrentCharges()

	local stacks_max  = ability:GetLevelSpecialValueFor( "stacks_max", ability:GetLevel() - 1 )
	local duration 	  = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local new_charges = charges + 1

	if new_charges <= stacks_max then
		ability:SetCurrentCharges( new_charges )

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_scary_sense_speed", {duration = duration})
	end
end

function OnDestroy( keys )
	local caster  = keys.caster
	local ability = keys.ability
	local charges = ability:GetCurrentCharges()

	local stack_cooldown = ability:GetLevelSpecialValueFor( "stack_cooldown", ability:GetLevel() - 1 )
	local start_cooldown = ability:GetLevelSpecialValueFor( "start_cooldown", ability:GetLevel() - 1 )
	local cooldown = 0

	if charges == 1 and ability:IsCooldownReady() then
		cooldown = start_cooldown
	else
		cooldown = start_cooldown + ( stack_cooldown * (charges -1) )
	end
	ability:StartCooldown( cooldown )

	ability:SetCurrentCharges( (charges - 1) )
end