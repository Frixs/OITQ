function set_stacks( event )
	local caster = event.caster
	if caster == nil then return end
	
	-- initial shuriken after respawn
	if caster:HasModifier("modifier_shuriken_shots") then
		caster:SetModifierStackCount("modifier_shuriken_shots", caster, 1)
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

function ShurikenOnHit( keys )
	local caster 			= keys.caster
	local target 			= keys.target
	local ability 			= keys.ability
	local ability_level 	= ability:GetLevel() - 1
	local radius 			= keys.bounce_range
	local damage 			= keys.damage_value
	local max_bounces 		= keys.max_bounces
	local channel_time      = keys.channel_time
	local AbilityDamageType = ability:GetAbilityDamageType()
	local particle_shuriken = keys.particle_shuriken

	-- if caster has fork ability
	if caster:HasModifier("modifier_ability_fork_spell") and not target:HasModifier("modifier_ability_fork_target_lock") then
		-- caster is Enchanter with Fork spell
		-- get all units in a target radius
		local units_in_radius = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)
		DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 50, radius, true, 3)

		local enemy_count = 0
        if #units_in_radius > 0 then
            for _,unit in pairs(units_in_radius) do
            	-- only a certain number of bounces can be launched
            	if enemy_count >= max_bounces then break end
                if target ~= unit and unit ~= nil then
                	local unitAbsOrigin = unit:GetAbsOrigin()
                	enemy_count = enemy_count + 1
                	-- Apply target lock modifier buff to prevent unlimited bounces | shield against bounce for 3 sec.
                	ability:ApplyDataDrivenModifier(caster, unit, "modifier_ability_fork_target_lock", {duration = 3})
                	
                	-- set linear projectile
                	local channel_time_numb  = RandomFloat( 1, (channel_time * 10) ) -- random launch time from target
				    local speed				 = ability:GetLevelSpecialValueFor("toss_speed", ability_level)
				    local toss_distance_max	 = ability:GetLevelSpecialValueFor("toss_distance_max", ability_level)
				    local toss_radius_min    = ability:GetLevelSpecialValueFor("radius_min", ability_level)
				    local toss_radius_max    = ability:GetLevelSpecialValueFor("radius_max", ability_level)
				    local direction_shuriken = ( unitAbsOrigin - target:GetAbsOrigin() ):Normalized()

				    -- SET channeled speed
				    local speed_add = (channel_time_numb - 1) * 20 -- speciální hodnota pro získání požadované maximální výsledné hodnoty
				    speed = speed + speed_add
			    
                	-- create linear projectile
				    local shuriken_projectile = {
				        Ability             = ability,
				        EffectName          = particle_shuriken,
				        vSpawnOrigin        = target:GetAbsOrigin(),
				        fDistance           = toss_distance_max,
				        fStartRadius        = toss_radius_max,
				        fEndRadius          = toss_radius_min,
				        Source              = target,
				        bHasFrontalCone     = false,
				        bReplaceExisting    = false,
				        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
				    --  iUnitTargetFlags    = ,
				        iUnitTargetType     = DOTA_UNIT_TARGET_HERO,
				    --  fExpireTime         = ,
				        bDeleteOnHit        = true,
				        vVelocity           = direction_shuriken * speed,
				        bProvidesVision     = false,
				    --  iVisionRadius       = ,
				    --  iVisionTeamNumber   = caster:GetTeamNumber(),
				    }

				    -- launch linear projectile
				    ProjectileManager:CreateLinearProjectile(shuriken_projectile)
                end
            end
        end
    elseif target:HasModifier("modifier_ability_fork_target_lock") then
    	-- remove shield against bounce immediately
    	target:RemoveModifierByName("modifier_ability_fork_target_lock")
	end
	
	-- deal damage to target
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType})
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