function OnSpellStart( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Initialize the count and table
	caster.land_mine_table = caster.land_mine_table or {}

	-- Modifiers
	local modifier_land_mine = keys.modifier_land_mine
	local modifier_tracker = keys.modifier_tracker
	local modifier_land_mine_invisibility = keys.modifier_land_mine_invisibility

	-- Ability variables
	local activation_time = ability:GetLevelSpecialValueFor("activation_time", ability_level) 
	local fade_time		  = ability:GetLevelSpecialValueFor("fade_time", ability_level)
	local mine_duration   = ability:GetLevelSpecialValueFor("mine_duration", ability_level)

	-- Create the land mine and apply the land mine modifier
	local land_mine = CreateUnitByName("npc_dota_techies_land_mine", target_point, false, nil, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine, {})

	-- Update the table
	table.insert(caster.land_mine_table, land_mine)

	-- Apply the tracker after the activation time
	Timers:CreateTimer(activation_time, function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_tracker, {})
	end)

	-- Apply the invisibility after the fade time
	Timers:CreateTimer(fade_time, function()
		ability:ApplyDataDrivenModifier(caster, land_mine, modifier_land_mine_invisibility, {duration = (mine_duration - fade_time)})
	end)
end

function MineDestroy( keys )
	local target = keys.target
	local ability 		= keys.ability
	if not ability then
		target:ForceKill(true)
		return
	end
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local big_radius	 = ability:GetLevelSpecialValueFor("big_radius", ability_level) 
	local explode_delay  = ability:GetLevelSpecialValueFor("explode_delay", ability_level) 
	local duration  	 = ability:GetLevelSpecialValueFor("duration", ability_level) 

	-- Target variables
	local target_team  = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	Timers:CreateTimer(explode_delay, function()
		if target:IsAlive() then
			-- particles
			ability:ApplyDataDrivenModifier(target, target, "modifier_item_sudden_death_particle", {})
			
			-- apply debuff
			local unitsToDebuff = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, big_radius, target_team, target_types, target_flags, 0, false) 
			if #unitsToDebuff > 0 then
				for _,unit in pairs(unitsToDebuff) do
					ability:ApplyDataDrivenModifier(unit, unit, "modifier_item_sudden_death_debuff", {duration = duration})
				end
			end

			-- remove mine
			Timers:CreateTimer(1, function()
				target:ForceKill(true)
			end)
		end
	end)
end

function LandMineDeath( keys )
	local caster 		= keys.caster
	local unit 			= keys.unit
	local ability 		= keys.ability

	local mineExplode = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(mineExplode, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)

	-- Find the mine and remove it from the table
	for i = 1, #caster.land_mine_table do
		if caster.land_mine_table[i] == unit then
			table.remove(caster.land_mine_table, i)
			break
		end
	end

	if ability then
		local ability_level = ability:GetLevel() - 1

		-- Ability variables
		local vision_radius   = ability:GetLevelSpecialValueFor("vision_radius", ability_level) 
		local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

		-- Create vision on the mine position
		ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)
	end
end

function Tracker( keys )
	local target 		= keys.target
	local ability 		= keys.ability
	if not ability then
		target:ForceKill(true)
		return
	end
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local trigger_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level) 
	local big_radius	 = ability:GetLevelSpecialValueFor("big_radius", ability_level) 
	local explode_delay  = ability:GetLevelSpecialValueFor("explode_delay", ability_level) 
	local duration  	 = ability:GetLevelSpecialValueFor("duration", ability_level) 

	-- Target variables
	local target_team  = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

	-- Find the valid units in the trigger radius
	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, trigger_radius, target_team, target_types, target_flags, FIND_CLOSEST, false) 

	-- If there is a valid unit in range then explode the mine
	if #units > 0 then
		Timers:CreateTimer(explode_delay, function()
			if target:IsAlive() then
				-- particles
				ability:ApplyDataDrivenModifier(target, target, "modifier_item_sudden_death_particle", {})
				
				-- apply debuff
				local unitsToDebuff = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, big_radius, target_team, target_types, target_flags, 0, false) 
				if #unitsToDebuff > 0 then
					for _,unit in pairs(unitsToDebuff) do
						ability:ApplyDataDrivenModifier(unit, unit, "modifier_item_sudden_death_debuff", {duration = duration})
					end
				end

				-- remove mine
				Timers:CreateTimer(1, function()
					target:ForceKill(true)
				end)
			end
		end)
	end
end