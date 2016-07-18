function set_stacks( event )
	if IsServer() then
	    local caster			= event.caster

		if caster == nil then
		  return
		end
	    
		if caster:HasModifier("modifier_shuriken_shots") then
			caster:SetModifierStackCount("modifier_shuriken_shots", caster, 1)
		end
	end
end

function channel_time( event )
	if IsServer() then
	    local caster			= event.caster

		if caster == nil then
		  return
		end

	    local time = caster:GetIntAttr("shuriken_channeled_time")

	    if time == nil then
	    	time = 0
	    end

	    time = time + 1
	    caster:SetIntAttr( "shuriken_channeled_time", time )
	    --print(time)
	    
	    -- zruší channelování, pokud nemá shurikeny
	    local charges = caster:GetModifierStackCount("modifier_shuriken_shots", caster)
	    if charges <= 0 then
	    	caster:Stop()
	    end

	    return nil
	end
end

function shuriken_projectile( event )
	if IsServer() then
	    local caster 			= event.caster
	    local ability 			= event.ability

		if caster == nil or ability == nil then
		  return
		end

	    local ability_level 	= ability:GetLevel() - 1
	    local particle_shuriken = event.particle_shuriken
	    local sound_shuriken 	= event.sound_shuriken
	    local target 			= event.target_points[1]
	    local channeled_time 	= caster:GetIntAttr("shuriken_channeled_time")
	    caster:SetIntAttr( "shuriken_channeled_time", 0 ) -- nastavení zpátky na 0, po použití skillu

	    if caster:HasModifier("modifier_shuriken_shots") then
		    local charges = caster:GetModifierStackCount("modifier_shuriken_shots", caster)

		    if charges > 0 then
			    local speed				= ability:GetLevelSpecialValueFor("toss_speed", ability_level)
			    local toss_radius_min   = ability:GetLevelSpecialValueFor("radius_min", ability_level)
			    local toss_radius_max   = ability:GetLevelSpecialValueFor("radius_max", ability_level)
			    local toss_distance	  	= ability:GetLevelSpecialValueFor("toss_distance", ability_level)

			    local direction_shuriken = ( target - caster:GetAbsOrigin() ):Normalized()

			    -- SET channeled distance
			    local toss_distance_add = (channeled_time - 1) * 60 -- speciální hodnota pro získání požadované maximální výsledné hodnoty
			    toss_distance = toss_distance + toss_distance_add
			    -- SET channeled speed
			    local speed_add = (channeled_time - 1) * 20 -- speciální hodnota pro získání požadované maximální výsledné hodnoty
			    speed = speed + speed_add

		    	-- Play sound
			    caster:EmitSound(sound_shuriken)

			    local shuriken_projectile = {
			        Ability             = ability,
			        EffectName          = particle_shuriken,
			        vSpawnOrigin        = caster:GetAbsOrigin(),
			        fDistance           = toss_distance,
			        fStartRadius        = toss_radius_max,
			        fEndRadius          = toss_radius_min,
			        Source              = caster,
			        bHasFrontalCone     = false,
			        bReplaceExisting    = false,
			        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
			    --  iUnitTargetFlags    = ,
			        iUnitTargetType     = DOTA_UNIT_TARGET_HERO,
			    --  fExpireTime         = ,
			        bDeleteOnHit        = false,
			        vVelocity           = direction_shuriken * speed,
			        bProvidesVision     = false,
			    --  iVisionRadius       = ,
			    --  iVisionTeamNumber   = caster:GetTeamNumber(),
			    }

			    ProjectileManager:CreateLinearProjectile(shuriken_projectile)
			    
			    -- po výstřelu - odebere jeden stack
			    caster:SetModifierStackCount("modifier_shuriken_shots", caster, charges - 1)
			end
		end
	end
end

--[[

			"LinearProjectile"
			{
			    "Target"      		"POINT"
			    "EffectName"  		"particles/spells/shuriken_spell.vpcf"
			    "MoveSpeed"   		"%toss_speed"
			    "StartRadius"   	"125"
			    "StartPosition" 	"attach_attack1"
			    "EndRadius"     	"50"
			    "FixedDistance" 	"%toss_distance"
			    "TargetTeams"   	"DOTA_UNIT_TARGET_TEAM_ENEMY"
			    "TargetTypes"   	"DOTA_UNIT_TARGET_BASIC | DOTA_UNIT_TARGET_HERO"
			    "TargetFlags"   	"DOTA_UNIT_TARGET_FLAG_NONE"
			    "HasFrontalCone"    "0"
			}
]]