function item_thunderstorm_totem_on_cast( keys )
	local caster 	   = keys.caster
	local ability 	   = keys.ability
	local target_point = keys.target_points[1]
	local casterAbsOri = caster:GetAbsOrigin()
	local duration 	   = keys.Duration
	-- if caster drops item during work
	if not ability then return end
	-- set totem position between caster & storm | caster + 10%
	target_point.x = ((target_point.x) - (casterAbsOri.x)) / 10
	target_point.x = casterAbsOri.x + target_point.x
	target_point.y = ((target_point.y) - (casterAbsOri.y)) / 10
	target_point.y = casterAbsOri.y + target_point.y
	target_point.z = ((target_point.z) - (casterAbsOri.z)) / 10
	target_point.z = casterAbsOri.z + target_point.z
	-- create totem dummy
	local dummy 	   = CreateUnitByName("npc_dummy_unit_totem", Vector(target_point.x, target_point.y, target_point.z), false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_item_thunderstorm_totem_aura_settings", {duration = (duration + 1)})
	ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_item_thunderstorm_totem_animation_totem_spawn", {duration = (duration - 1)})
	-- cast animations + emit sound
	dummy.SmokeParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_death_smoke.vpcf", PATTACH_ABSORIGIN, dummy)
	dummy.LightningParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant_ambient_arc_body_b.vpcf", PATTACH_ABSORIGIN, dummy)
	Timers:CreateTimer(0.15, function() dummy:EmitSound("DOTA_CustomItem.ThunderstormTotem.Cast") end)

	-- Timer to activate endup animation
	Timers:CreateTimer(duration, function()
		dummy.FlashParticle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_ABSORIGIN, dummy)
		ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_item_thunderstorm_totem_animation_totem_die", {duration = duration})
	end)
	-- Timer to remove the dummy
	-- +1 sec. because of finishing animations
	Timers:CreateTimer((duration + 1), function() dummy:RemoveSelf() end)
end

function item_thunderstorm_totem_on_start( keys )
	-- Variables
	local caster 	   = keys.caster
	local ability 	   = keys.ability
	local target_point = keys.target_points[1]

	-- if caster drops item during work
	if not ability then return end

	-- Special Variables
	local duration 		= ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() - 1))

	-- Dummy
	local dummy_modifier = keys.dummy_aura
	local dummy 		 = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = duration})
	ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_item_thunderstorm_totem_storm", {duration = duration})
	ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_item_thunderstorm_totem_darkness_aura", {duration = duration})

	-- Vision
	AddFOWViewer(caster:GetTeamNumber(), target_point, vision_radius, duration, false)

	-- Start emit loop sound
	dummy:EmitSound("DOTA_CustomItem.ThunderstormTotem.Loop")

	-- Timer to endup sound loop
	Timers:CreateTimer((duration - 0.5), function()
		dummy:StopSound("DOTA_CustomItem.ThunderstormTotem.Loop")
		dummy:EmitSound("DOTA_CustomItem.ThunderstormTotem.End")
	end)
	-- Timer to remove the dummy
	-- +2 sec. because of finishing animations
	Timers:CreateTimer((duration + 2), function() dummy:RemoveSelf() end)
end

function player_aura_reset_stacks( keys )
	local caster = keys.caster
	-- this is because of using before
	caster:SetIntAttr("item_thunderstorm_totem_fork_damage", 0)
end

function item_thunderstorm_totem_aura( keys )
	local caster 		= keys.caster
	local owner 		= caster:GetOwner()
	local target 		= keys.target
	local ability 		= keys.ability
	-- if caster drops item during work
	if not ability then return end
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local aura_modifier 		= keys.aura_modifier
	local duration 				= ability:GetLevelSpecialValueFor("aura_duration", ability_level)
	local damage 				= ability:GetLevelSpecialValueFor("damage", ability_level)
	local AbilityDamageType 	= ability:GetAbilityDamageType()

	-- deal damage to targets
	ApplyDamage({ victim = target, attacker = owner, damage = damage, damage_type = AbilityDamageType})

	-- player gets buff
	ability:ApplyDataDrivenModifier(target, target, aura_modifier, {duration = duration})
	-- set amount of successful strikes on target
	local stacks = target:GetModifierStackCount(aura_modifier, target)
	target:SetModifierStackCount(aura_modifier, target, (stacks + 1))
end

function StormParticle( keys )
	local caster  		  = keys.caster
	local target  		  = keys.target
	local ability 		  = keys.ability
	-- if caster drops item during work
	if not ability then return end
	local duration 		  = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local particleName	  = "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
	local casterAbsOrigin = caster:GetAbsOrigin()
	-- Dummy striker
	local dummy_striker  = CreateUnitByName("npc_dummy_unit_2", casterAbsOrigin, false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, dummy_striker, "modifier_item_thunderstorm_totem_aura_settings", {duration = (duration + 2)})
	-- set new AbsOrigin
	casterAbsOrigin.x = RandomFloat( (casterAbsOrigin.x - 400), (casterAbsOrigin.x + 400) )
	casterAbsOrigin.y = RandomFloat( (casterAbsOrigin.y - 400), (casterAbsOrigin.y + 400) )
	casterAbsOrigin.z = RandomFloat( (casterAbsOrigin.z + 100), (casterAbsOrigin.z + 250) )
	local casterAbsOriginNew = Vector(casterAbsOrigin.x, casterAbsOrigin.y, casterAbsOrigin.z)
		--print(casterAbsOrigin.x.." "..casterAbsOrigin.y.." "..casterAbsOrigin.z)

	-- apply new lightning position - condition because of multiple targets in the same time
		--print(caster:GetIntAttr("item_thunderstorm_totem_lightning_pos_x"))
	if caster:GetIntAttr("item_thunderstorm_totem_lightning_pos_x") ~= 0 then
		casterAbsOriginNew = Vector(caster:GetIntAttr( "item_thunderstorm_totem_lightning_pos_x"), caster:GetIntAttr( "item_thunderstorm_totem_lightning_pos_y"), caster:GetIntAttr( "item_thunderstorm_totem_lightning_pos_z"))
	else
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_x", casterAbsOrigin.x )
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_y", casterAbsOrigin.y )
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_z", casterAbsOrigin.z )
	end
	dummy_striker:SetAbsOrigin(casterAbsOriginNew)

	caster.StormParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, dummy_striker)
	ParticleManager:SetParticleControlEnt(caster.StormParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	-- Timer to remove the dummy and his positions after each hit
	Timers:CreateTimer(0.9, function()
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_x", 0 )
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_y", 0 )
		caster:SetIntAttr( "item_thunderstorm_totem_lightning_pos_z", 0 )
		dummy_striker:RemoveSelf()
	end)
end

function item_thunderstorm_totem_player_aura_on_attack_landed( keys )
	local caster 				= keys.caster
	local target 				= keys.target
	local ability 				= keys.ability
	-- if caster drops item during work
	if not ability then return end
	local level            	 	= ability:GetLevel() - 1
	local aura_modifier 		= keys.aura_modifier
	local aura_debuff_modifier 	= keys.aura_debuff_modifier
	local radius               	= ability:GetLevelSpecialValueFor("radius_fork", level )
	local damage            	= ability:GetLevelSpecialValueFor("bonus_damage_per_tick", level )
	local jump_delay          	= ability:GetLevelSpecialValueFor("jump_delay", level )
	local AbilityDamageType 	= ability:GetAbilityDamageType()
	local particleName      	= "particles/items/ether_shock/item_thunderstorm_totem_ether_shock.vpcf"

	-- set current damage stacks
	damage = item_thunderstorm_totem_player_aura_set_current_damage( aura_modifier, damage, caster )

	-- Make sure the main target is damaged
	local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	--ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType })
	target:EmitSound("DOTA_CustomItem.ThunderstormTotem.Jump")

	--DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 50, radius, true, 3)

    local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)
	if #units_to_damage > 0 then
		ability:ApplyDataDrivenModifier(caster, target, aura_debuff_modifier, {duration = (jump_delay * 2.5)})
	end
end

function item_thunderstorm_totem_player_aura_jumps( keys )
	local caster 				= keys.caster
	local target 				= keys.target
	local ability 				= keys.ability
	-- if caster drops item during work
	if not ability then return end
	local level             	= ability:GetLevel() - 1
	local aura_modifier 		= keys.aura_modifier
	local aura_debuff_modifier 	= keys.aura_debuff_modifier
	local radius            	= ability:GetLevelSpecialValueFor("radius_fork", level )
	local damage            	= ability:GetLevelSpecialValueFor("bonus_damage_per_tick", level )
	local jump_delay          	= ability:GetLevelSpecialValueFor("jump_delay", level )
	local AbilityDamageType 	= ability:GetAbilityDamageType()
	local particleName      	= "particles/items/ether_shock/item_thunderstorm_totem_ether_shock.vpcf"
	local units 				= keys.target_entities

	-- set current damage stacks
	damage = item_thunderstorm_totem_player_aura_set_current_damage( aura_modifier, damage, caster )

	--DebugDrawCircle(target:GetAbsOrigin(), Vector(255,0,0), 50, radius, true, 3)

	if #units > 0 then
	    for _,unit in pairs(units) do
	        if target ~= unit and unit ~= nil and not unit:HasModifier(aura_debuff_modifier) then
				-- Particle
				local origin = unit:GetAbsOrigin()
				local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))	
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
				target:EmitSound("DOTA_CustomItem.ThunderstormTotem.Jump")

				-- Damage
				ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = AbilityDamageType})

				ability:ApplyDataDrivenModifier(caster, unit, aura_debuff_modifier, {duration = (jump_delay * 2.5)})
	        end
	    end
	end
end

function item_thunderstorm_totem_player_aura_set_current_damage( modifier, damage, handler )
	-- modifier stacks
	local aura_stacks    = handler:GetModifierStackCount(modifier, handler)
		--print("aura_stacks: "..aura_stacks)
	-- saved stacks
	local current_stacks = handler:GetIntAttr("item_thunderstorm_totem_fork_damage")
		--print("current_stacks: "..current_stacks)

	if aura_stacks > current_stacks then current_stacks = aura_stacks end
	-- stacks = 1 once modifier is created - every other strike increment this stack and replenish aura duration
	if current_stacks > 1 then
		damage = damage * current_stacks
		-- save damage
		handler:SetIntAttr("item_thunderstorm_totem_fork_damage", damage)
	end

	return damage
end

function Darkness( keys )
	local ability  = keys.ability
	-- if caster drops item during work
	if not ability then return end
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1)) + 10 -- +10 for more dramatical moment :P

	-- Time variables
	local time_flow = 0.0020833333
	local time_elapsed = 0
	-- Calculating what time of the day will it be after Darkness ends
	local start_time_of_day = GameRules:GetTimeOfDay()
	local end_time_of_day = start_time_of_day + duration * time_flow

	if end_time_of_day >= 1 then end_time_of_day = end_time_of_day - 1 end

	-- Setting it to the middle of the night
	GameRules:SetTimeOfDay(0)

	-- Using a timer to keep the time as middle of the night and once Darkness is over, normal day resumes
	Timers:CreateTimer(1, function()
		if time_elapsed < duration then
			GameRules:SetTimeOfDay(0)
			time_elapsed = time_elapsed + 1
			return 1
		else
			GameRules:SetTimeOfDay(end_time_of_day)
			return nil
		end
	end)
end

function ReduceVision( keys )
	local target = keys.target
	local ability = keys.ability
	-- if caster drops item during work
	if not ability then return end
	local blind_percentage = ability:GetLevelSpecialValueFor("blind_percentage", (ability:GetLevel() - 1)) / -100

	target.original_vision = target:GetBaseNightTimeVisionRange()

	target:SetNightTimeVisionRange(target.original_vision * (1 - blind_percentage))
end

function RevertVision( keys )
	local target = keys.target

	target:SetNightTimeVisionRange(target.original_vision)
end

function casting_reset_cooldown( keys )
	local ability = keys.ability
	-- if caster drops item during work
	if not ability then return end
	ability:EndCooldown()
	ability:StartCooldown(keys.CastResetCooldown)
end