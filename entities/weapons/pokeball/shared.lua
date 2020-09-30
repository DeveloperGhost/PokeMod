AddCSLuaFile()

if (CLIENT) then
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Información general de la Pokeball
SWEP.PrintName = "Pokeball"
SWEP.Author = "Ghost"
SWEP.Instructions = "Click izquierdo para lanzar la Pokeball."
SWEP.Purpose = ""
SWEP.ViewModelFOV = 54
SWEP.WorldModel = Model("models/rtbmodels/pokemon/items/pokeball_medium.mdl")
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = ""

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "PokeMod"

-- Munición deshabilitada
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

-- Variables personalizadas
SWEP.Pokeball = nil
SWEP.PokemonSuelto = false

-- Llamado cuando la entidad del arma se crea.
function SWEP:Initialize()
    self:SetHoldType("melee")
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

-- Llamado cuando se pulsa el click izquierdo.
function SWEP:PrimaryAttack()
	if CLIENT or !IsFirstTimePredicted() then return end
	
	local jug = self.Owner
	local angJug = jug:EyeAngles()

	self.Weapon:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if (jug:ObtenerEquipo()) then
		-- TODO: ???	
	else
		self:TirarPokeball()
	end
	
	--self:SacarPokemon(angJug)
end

-- Llamado cuando se pulsa el click derecho.
function SWEP:SecondaryAttack()
	if SERVER or !IsFirstTimePredicted() then return end

	PokeMod.equipo:Visualizar()
end

function SWEP:TirarPokeball()
	local jug = self.Owner
	
	--self.PokemonSuelto = false

	if (SERVER) then
		self.Pokeball = ents.Create("prop_physics")
		self.Pokeball:SetModel("models/rtbmodels/pokemon/items/pokeball_large.mdl")
		self.Pokeball:SetPos(jug:EyePos() + (jug:GetAimVector() * 14))
		self.Pokeball:SetAngles(jug:EyeAngles())
		self.Pokeball:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.Pokeball:Spawn()
		
		local phys = self.Pokeball:GetPhysicsObject()
		if (!IsValid(phys)) then self.Pokeball:Remove() return end
		
		local velocidad = jug:GetAimVector()
		velocidad = velocidad * 500
		phys:ApplyForceCenter(velocidad)
		
		timer.Simple(3, function()
			self.Pokeball:Remove()
			return
		end)
	end
	
	self:SetHoldType("idle")
	self.PokemonSuelto = true
end

function SWEP:AtraparPokemon()
	local jug = self.Owner

	if (CLIENT) then
		PrintTable(PokeMod.gui.equipo)
	end

	if (SERVER) then
		self.Pokeball = ents.Create("prop_physics")
		self.Pokeball:SetModel("models/rtbmodels/pokemon/items/pokeball_large.mdl")
		self.Pokeball:SetPos(jug:EyePos() + (jug:GetAimVector() * 14))
		self.Pokeball:SetAngles(jug:EyeAngles())
		self.Pokeball:Spawn()
		
		local phys = self.Pokeball:GetPhysicsObject()
		if (!IsValid(phys)) then self.Pokeball:Remove() return end
		
		local velocidad = jug:GetAimVector()
		velocidad = velocidad * 500
		phys:ApplyForceCenter(velocidad)
	
		self.PokemonSuelto:Remove()

		timer.Simple(3, function()
			self.Pokeball:Remove()
			return
		end)
	end
end

function SWEP:SacarPokemon(pAngJug)
	local jug = self.Owner

	if (SERVER) then
		local pokeball = ents.Create("prop_physics")
		pokeball:SetModel("models/rtbmodels/pokemon/items/pokeball_large.mdl")
		pokeball:SetPos(jug:EyePos() + (jug:GetAimVector() * 14))
		pokeball:SetAngles(jug:EyeAngles())
		pokeball:Spawn()
		
		local phys = pokeball:GetPhysicsObject()
		if (!IsValid(phys)) then pokeball:Remove() return end
		
		local velocidad = jug:GetAimVector()
		velocidad = velocidad * 500
		phys:ApplyForceCenter(velocidad)
		
		timer.Simple(3, function()
			local info = PokeMod.pokemon:Crear("pikachu", jug) -- TODO: cambiar 'pikachu' por el asignado

			if (info) then
				local pkm = ents.Create("pokemon")
				pkm:SetModel(info.modelo)
				pkm:SetPos(pokeball:GetPos())
				pkm:SetAngles(Angle(0, pAngJug.yaw, 0))
				pkm:Spawn()
				pkm:DropToFloor()
			end
			
			pokeball:Remove()
		end)	
	
		--self:Remove()
	end
end

if (CLIENT) then
	local WorldModel = ClientsideModel(SWEP.WorldModel)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()
		
		if (!self.PokemonSuelto) then
			if (IsValid(_Owner)) then
				local offsetVec = Vector(1, -2.7, 0)
				local offsetAng = Angle(180, 90, 45)
				
				local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
				if !boneid then return end

				local matrix = _Owner:GetBoneMatrix(boneid)
				if !matrix then return end

				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)

				WorldModel:SetupBones()
			else
				WorldModel:SetPos(self:GetPos())
				WorldModel:SetAngles(self:GetAngles())
			end

			WorldModel:DrawModel()
		end
	end
end


