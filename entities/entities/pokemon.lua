AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

function ENT:Initialize() 
	self:SetModel("models/yunpolmodels/pokemon/gen 1/(25) - pikachu_male_3ds.mdl")
end

function ENT:RunBehaviour()
	while (true) do
		self:StartActivity( ACT_WALK )
		self.loco:SetDesiredSpeed( 50 )
		self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200 )
		self:StartActivity( ACT_IDLE )
		coroutine.wait(2)

		coroutine.yield()
	end
end

list.Set("NPC", "pokemon", {
	Name = "Pokemon",
	Class = "pokemon",
	Category = "PokeMod"
})