function OnSpellStart( keys )
	local caster 		= keys.caster
	local target_point  = keys.target_points[1]
	local ability 		= keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Modifiers
	local modifier_reveal_spirit = keys.modifier_reveal_spirit

	-- Ability variables
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local radius   = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Create the spirit and apply the spirit modifier
	local reveal_spirit = CreateUnitByName("npc_dummy_unit", target_point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, reveal_spirit, modifier_reveal_spirit, {duration = duration})

	-- Create vision on the spirit position
	ability:CreateVisibilityNode(target_point, radius, duration)
end

function Spirit_OnDestroy( keys )
	local target = keys.target

	if target:IsAlive() then
		target:ForceKill(true)
	end
end