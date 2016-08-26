function OnSpellStart( keys )
	local caster  		= keys.caster
	local target 		= keys.target
	local target_points = keys.target_points[1]
	local ability 		= keys.ability
	local particle_toss = keys.particle_toss


	if target == nil then
		local distance 	 	 = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
		local toss_speed 	 = ability:GetLevelSpecialValueFor( "toss_speed", ability:GetLevel() - 1 )
		local direction_toss = ( target_points - caster:GetAbsOrigin() ):Normalized()

		local projectile = {
			Ability             = ability,
			EffectName          = particle_toss,
			vSpawnOrigin        = caster:GetAbsOrigin(),
			fDistance           = distance,
			fStartRadius        = 80,
			fEndRadius          = 80,
			Source              = caster,
			bHasFrontalCone     = false,
			bReplaceExisting    = false,
			iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
			--  iUnitTargetFlags    = ,
			iUnitTargetType     = DOTA_UNIT_TARGET_HERO,
			--  fExpireTime         = ,
			bDeleteOnHit        = false,
			vVelocity           = direction_toss * toss_speed,
			bProvidesVision     = false,
			--  iVisionRadius       = ,
			--  iVisionTeamNumber   = caster:GetTeamNumber(),
		}

		ProjectileManager:CreateLinearProjectile(projectile)

		caster:EmitSound("DOTA_CustomItem.Tomahawk.Cast")
	else
		GridNav:DestroyTreesAroundPoint( target_points, 50, false )
		caster:EmitSound("DOTA_CustomItem.Tomahawk.Cut")
	end
end

function OnProjectileEnd( keys )
	local caster  		= keys.caster
	local ability 		= keys.ability

	-- remove mine
	Timers:CreateTimer(0.1, function()
		caster:RemoveItem(ability)
	end)
end