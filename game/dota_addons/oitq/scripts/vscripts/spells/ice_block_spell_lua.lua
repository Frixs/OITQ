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