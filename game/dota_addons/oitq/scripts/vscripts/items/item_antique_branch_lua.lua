function OnTakeDamage( keys )
	local attacker_name = keys.attacker:GetName()

	if attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer() then  --If the damage was dealt by neutrals or lane creeps, essentially.
		if keys.ability:GetCooldownTimeRemaining() < keys.damageCooldown then
			keys.ability:StartCooldown(keys.damageCooldown)
		end
	end
end

function OnSpellStart( keys )
	local caster 		= keys.caster
	local target_point  = keys.target_points[1]
	local delay			= keys.delay

	local startPosition = caster:GetAbsOrigin()

	Timers:CreateTimer(delay, function()
		if caster:IsAlive() then
			ParticleManager:CreateParticle("particles/items/antique_branch/antique_branch_start.vpcf", PATTACH_ABSORIGIN, caster)

			caster:SetAbsOrigin( target_point )
			caster:EmitSound("DOTA_CustomItem.AntiqueBranch.Blink")

			Timers:CreateTimer(0.1, function()
				ParticleManager:CreateParticle("particles/items/antique_branch/antique_branch_end.vpcf", PATTACH_ABSORIGIN, caster)
			end)
		end
	end)
end