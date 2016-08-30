--[[ gate_trap_controls_trigger.lua ]]

local triggerActive = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	--print("Trap Button Trigger Entered")
	local button = triggerName .. "_button"
	local model = triggerName .. "_model"
	if not triggerActive then
		print( "Trap Skip" )
		return
	end
	triggerActive = false

	local cycle    = false
	local sum      = 0
	local npc 	   = Entities:FindByName( nil, triggerName .. "_npc" )
	local target   = nil
	local gateTrap = nil

	-- if has ability more gates or not
	if npc == nil then
		cycle = true
	else
		target   = Entities:FindByName( nil, triggerName .. "_target" )
		gateTrap = npc:FindAbilityByName("gate_trap_controls")
		
		-- reset button
		npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 25 )

		StartAbility(self, button, model, npc, target, gateTrap)
	end

	while cycle do
		npc 	 = Entities:FindByName( nil, triggerName .. "_" .. sum .. "_npc" )
		if npc == nil then break end
		target   = Entities:FindByName( nil, triggerName .. "_" .. sum .. "_target" )
		gateTrap = npc:FindAbilityByName("gate_trap_controls")

		StartAbility(self, button, model, npc, target, gateTrap)
		if sum == 0 then
			-- reset button
			npc:SetContextThink( "ResetButtonModel", function() ResetButtonModel() end, 25 )
		end
		sum = sum + 1
	end
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	--print("Trap Button Trigger Exited")
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
end

function ResetButtonModel()
	print( "Trap RESET" )
	triggerActive = true
end

function StartAbility( self, button, model, npc, target, gateTrap )
		npc:CastAbilityOnPosition( target:GetOrigin(), gateTrap, -1 )

		DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
		DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
		DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 25, self, self )
		DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 25.5, self, self )

		npc:EmitSound("Conquest.GateTrap.Interact")
		DoEntFire( model, "SetAnimation", "gate_entrance_custom_close", 0, self, self )
		DoEntFire( model, "SetAnimation", "gate_entrance_custom_close_idle", 0.8, self, self )
		DoEntFire( model, "SetAnimation", "gate_entrance_custom_open", 10.8, self, self )
		DoEntFire( model, "SetAnimation", "gate_entrance_custom_open_idle", 11.6, self, self )
	    Timers:CreateTimer(10.8, function()
	        npc:EmitSound("Conquest.GateTrap.Interact")
	    end)

		local heroIndex = npc:GetEntityIndex()
		local heroHandle = EntIndexToHScript(heroIndex)
		npc.KillerToCredit = heroHandle
end