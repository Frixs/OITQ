gate_trap_controls = class({})
--LinkLuaModifier( "modifier_gate_trap_controls_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gate_trap_controls:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )

	--local kv = {}
	--CreateModifierThinker( self:GetCaster(), self, "modifier_gate_trap_controls_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------




