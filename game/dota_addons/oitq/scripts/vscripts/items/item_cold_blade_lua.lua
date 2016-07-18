function modifier_item_cold_blade_on_attack_landed( keys )
	if keys.target.GetInvulnCount == nil and keys.ability:IsCooldownReady() then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_item_cold_blade_cold_attack", {duration = keys.ColdDuration})
		keys.ability:StartCooldown(keys.Cooldown)
	end
end