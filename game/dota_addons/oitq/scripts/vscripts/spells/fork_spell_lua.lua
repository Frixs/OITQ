function OnHit(event)
    if IsServer() then
        local caster        = event.caster

        if caster:HasModifier("modifier_fork") then
            local ability       = event.ability
            local target        = event.target
            local damage_radius = event.bounce_range
            local damage_value  = event.damage_value
            local damage_part   = event.particle_damage   

            local validTargets = {}
            local damage_table = {}
            damage_table.attacker = caster
            damage_table.damage_type = ability:GetAbilityDamageType()
            damage_table.ability = ability
            damage_table.damage = damage_value

            local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)
            
            if #units_to_damage > 0 then
                for _,v in pairs(units_to_damage) do
                    if target ~= v and v ~= nil then
                        damage_table.victim = v
                        -- Play the particle
                        local damage_particle = ParticleManager:CreateParticle(damage_part, PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(damage_particle)
                        ApplyDamage(damage_table)
                    end
                end
            end
        end
    end
end

--[[
function OnAttackLanded(keys)
    if IsServer() then    
        local caster = keys.caster
        local target = keys.target
        local damage = keys.damage_value
        local particle_shuriken = keys.particle_shuriken        
        DamageEntitiesInArea(target:GetAbsOrigin(), 300, caster, damage / 2)

        local bounce_target = FindBounceTarget(target, keys.bounce_range, caster)
        if bounce_target then
            local sourceLoc = target:GetAbsOrigin()
            sourceLoc.z = sourceLoc.z + 90

            ProjectileManager:CreateTrackingProjectile({
                Target = bounce_target,
                Source = target,
                Ability = caster.ability,
                EffectName = particle_shuriken,
                iMoveSpeed = 300,
                vSourceLoc = sourceLoc,
                bReplaceExisting = false,
                flExpireTime = GameRules:GetGameTime() + 100,
            })
        end
    end
end

function OnBounceHit(keys)
    if IsServer() then
        local target = keys.target
        local damage = self.tower:GetAverageTrueAttackDamage() * self.bounceDamage
        DamageEntitiesInArea(target:GetAbsOrigin(), self.halfAOE, self.tower, damage / 2)
        DamageEntitiesInArea(target:GetAbsOrigin(), self.fullAOE, self.tower, damage / 2)
    end
end

function FindBounceTarget(original_target, radius, caster)
    if IsServer() then
        local validTargets = {}
        local units = FindUnitsInRadius( caster:GetTeam(), original_target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
        
        for _, unit in pairs(units) do
            if unit:IsAlive() and unit:entindex() ~= original_target:entindex() then
                table.insert(validTargets, unit)
            end
        end

        if #validTargets > 0 then
            return validTargets[math.random(#validTargets)]
        end
    end
end

function DamageEntitiesInArea(origin, radius, attacker, damage)
    local entities = GetCreepsInArea(origin, radius)
    for _,e in pairs(entities) do
        DamageEntity(e, attacker, damage)
    end
end

function GetCreepsInArea(center, radius)
    local creeps = FindUnitsInRadius(0, center, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    for k, v in pairs(creeps) do
        if v:GetTeam() ~= DOTA_TEAM_NEUTRALS then
            creeps[k] = nil;
        end
    end
    return creeps;
end
]]