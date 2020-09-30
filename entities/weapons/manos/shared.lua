AddCSLuaFile()

if (CLIENT) then
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Información general de las Manos
SWEP.PrintName = "Manos"
SWEP.Author = "Ghost"
SWEP.Instructions = "Click izquierdo para pegar con la mano izquierda.\nClick derecho para pegar con la mano derecha.\nR para alzar/bajar las manos."
SWEP.Purpose = ""
SWEP.ViewModelFOV = 54
SWEP.WorldModel = ""
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "PokeMod"

-- Daño que proporcionan los puños al golpear
SWEP.Danyo = 10

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
SWEP.EnGuardia = false
SWEP.TiempoRecarga = 0

local SonidoGiro = Sound("WeaponFrag.Throw")
local SonidoGolpe = Sound("Flesh.ImpactHard")

-- Llamado cuando la entidad del arma se crea.
function SWEP:Initialize()
    self:SetHoldType("normal")
	
	timer.Simple(0.2, function()
		self.Owner:DrawViewModel(false)
	end)
end

-- Llamado cuando se pulsa el click izquierdo.
function SWEP:PrimaryAttack(derecha)
	if (self.EnGuardia) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		local anim = "fists_left"
		if (derecha) then anim = "fists_right" end

		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence( anim ))

		self:EmitSound(SonidoGiro)
		
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector() * 96
			data.filter = self.Owner
		local tr = util.TraceLine(data)
		local enemigo = tr.Entity
		if (tr.Hit and enemigo) then
			self.Owner:LagCompensation(true)

			local damageInfo = DamageInfo()
			damageInfo:SetAttacker(self.Owner)
			damageInfo:SetInflictor(self)
			damageInfo:SetDamage(self.Danyo)
			damageInfo:SetDamageType(DMG_SLASH)
			damageInfo:SetDamagePosition(tr.HitPos)
			damageInfo:SetDamageForce(self.Owner:GetAimVector() * 1024)
			
			enemigo:DispatchTraceAttack(damageInfo, data.start, data.endpos)
			
			self:EmitSound(SonidoGolpe)
		end

		self:SetNextPrimaryFire(CurTime() + 0.9)
		self:SetNextSecondaryFire(CurTime() + 0.9)
		
		self.Owner:LagCompensation(false)
	end
end

-- Llamado cuando se pulsa el click derecho.
function SWEP:SecondaryAttack()
	if (self.EnGuardia) then
		self:PrimaryAttack(true)
	end
end

-- Llamado mientras se pulsa la R.
function SWEP:Reload()
	if self.TiempoRecarga and CurTime() <= self.TiempoRecarga then return end
	
	self:Deploy()
	
	if (self.EnGuardia) then
		self:SetHoldType("normal")
		self.Owner:DrawViewModel(false)
		self.EnGuardia = false
	else
		self:SetHoldType("fist")
		self.Owner:DrawViewModel(true)
		self.EnGuardia = true
	end
	
	self.TiempoRecarga = CurTime() + 1
end

-- Llamado cuando el jugador cambia a este arma.
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)

	local velocidad = 1.5
	local vm = self.Owner:GetViewModel()
	
	if (IsValid(vm)) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
		vm:SetPlaybackRate(velocidad)

		self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / velocidad)
		self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / velocidad)
	end
	
	return false
end

if (SERVER) then
	function SWEP:OnDrop()
		self:Remove()
	end
end