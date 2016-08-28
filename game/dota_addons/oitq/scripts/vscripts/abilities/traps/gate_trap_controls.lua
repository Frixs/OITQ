gate_trap_controls = class({})

--------------------------------------------------------------------------------

function gate_trap_controls:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local casterOrigin = self:GetCaster():GetOrigin()

	local BlockUnit_1 = CreateUnitByName("npc_dummy_unit_invis",casterOrigin,false,nil,nil,DOTA_TEAM_NEUTRALS)
	local BlockUnit_2 = CreateUnitByName("npc_dummy_unit_invis",vPos,false,nil,nil,DOTA_TEAM_NEUTRALS)

	BlockUnit_1:SetHullRadius(80)
	BlockUnit_2:SetHullRadius(80)

    Timers:CreateTimer( self.duration, function()
        BlockUnit_1:ForceKill(false)
        BlockUnit_2:ForceKill(false)
    end)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------