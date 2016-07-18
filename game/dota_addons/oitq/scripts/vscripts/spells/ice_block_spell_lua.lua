function immobility( event )
	if IsServer() then
		local caster = event.caster
		if caster == nil then
		  return
		end

	    caster:SetBaseMoveSpeed( 100 )
	end
end

function set_invul_on( event )
	if IsServer() then
		local caster = event.caster
		if caster == nil then
		  return
		end

	    caster:SetPhysicalArmorBaseValue( 1000 )
	    caster:SetBaseMagicalResistanceValue( 100 )
	end
end

function set_invul_off( event )
	if IsServer() then
		local caster = event.caster
		if caster == nil then
		  return
		end

	    caster:SetPhysicalArmorBaseValue( 0 )
	    caster:SetBaseMagicalResistanceValue( 0 )
	end
end

function increase_move_speed( event )
	if IsServer() then
		local caster = event.caster
		local ability = event.ability
		
		if caster == nil then
		  return
		end

	    local actual_move_speed = caster:GetBaseMoveSpeed()
	    local pick_up = ability:GetSpecialValueFor("slow_steps")
	    
	    caster:SetBaseMoveSpeed( actual_move_speed + pick_up )
	end
end