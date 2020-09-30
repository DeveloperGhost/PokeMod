local PANEL = {}

-- Llamando cuando el panel se inicializa
function PANEL:Init()
	if (IsValid(PokeMod.gui.equipo)) then
		PokeMod.gui.equipo:Remove()
	end

	PokeMod.gui.equipo = self

	self:SetSize(ScrW() / 3, ScrH() / 3)
	self:SetTitle("Equipo Pokémon")
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2)
	self:SetDraggable(false)
	self:SetBackgroundBlur(true)
	self:SetSizable(false)
	self:MakePopup()
end

-- Llamado cuando el panel se rellena
function PANEL:Rellenar()		
	-- Variables de utilidad
	local ranAncho, ranAlto, margenY, margenX = self:GetWide() / 3, self:GetTall() / 6, 50, 70

    self.fondo = self:Add("DImage")
    self.fondo:SetImage("pokemod/equipoMenu.png")
    self.fondo:SetSize(self:GetSize())
    self.fondo:SetPos(0, 0)

	-- 1º ranura - 1º Col
	self.ranura1 = self:Add("DButton")
	self.ranura1:SetText("Ranura Vacía")
	self.ranura1:SetSize(ranAncho, ranAlto)
	self.ranura1:SetPos(margenX, margenY)
	self.ranura1:SetFont("PokeMod")
	self.ranura1:SetDisabled(true)

	-- 2º ranura - 1º Col
	self.ranura2 = self:Add("DButton")
	self.ranura2:SetText("Ranura Vacía")
	self.ranura2:SetSize(ranAncho, ranAlto)
	self.ranura2:SetPos(margenX, margenY * 3)
	self.ranura2:SetFont("PokeMod")
	self.ranura2:SetDisabled(true)

	-- 3º Ranura - 1º Col
	self.ranura3 = self:Add("DButton")
	self.ranura3:SetText("Ranura Vacía")
	self.ranura3:SetSize(ranAncho, ranAlto)
	self.ranura3:SetPos(margenX, margenY * 5)
	self.ranura3:SetFont("PokeMod")
	self.ranura3:SetDisabled(true)

	-- 4º ranura - 2º Col
	self.ranura4 = self:Add("DButton")
	self.ranura4:SetText("Ranura Vacía")
	self.ranura4:SetSize(ranAncho, ranAlto)
	self.ranura4:SetPos(margenX + 300, margenY)
	self.ranura4:SetFont("PokeMod")
	self.ranura4:SetDisabled(true)

	-- 5º ranura - 2º Col
	self.ranura5 = self:Add("DButton")
	self.ranura5:SetText("Ranura Vacía")
	self.ranura5:SetSize(ranAncho, ranAlto)
	self.ranura5:SetPos(margenX + 300, margenY * 3)
	self.ranura5:SetFont("PokeMod")
	self.ranura5:SetDisabled(true)
	
	-- 6º Ranura - 2º Col
	self.ranura6 = self:Add("DButton")
	self.ranura6:SetText("Ranura Vacía")
	self.ranura6:SetSize(ranAncho, ranAlto)
	self.ranura6:SetPos(margenX + 300, margenY * 5)
	self.ranura6:SetFont("PokeMod")
	self.ranura6:SetDisabled(true)
end

function PANEL:BuscarSlotVacio()
	local slots = {self.ranura1, self.ranura2, self.ranura3, self.ranura4, self.ranura5, self.ranura6}
	
	for _, slot in ipairs(slots) do
		if (!slot:GetDisabled()) then
			return slot
		end
	end
	
	return nil
end

function PANEL:AgregarPokemon(pPokemon)
	local slotVacio = self:BuscarSlotVacio()
	
	if !slotVacio then return end
	
	local nomRan = slotVacio:Add("DLabel")
	nomRan:SetText(pPokemon.nombre)
	nomRan:SetPos(30, 5)
	nomRan:SetTextColor(Color(82, 82, 82))
	nomRan:SetFont("PokeMod")
	nomRan:SetPaintBackground(false)

	local saludRan = slotVacio:Add("DProgress")
	saludRan:SetPos(30, 30)
	saludRan:SetSize(150, 6)
	saludRan:SetFraction(0.5)

	local saludTxtRan = slotVacio:Add("DLabel")
	saludTxtRan:SetText(pPokemon.vida.."/"..pPokemon.vidaMax)
	saludTxtRan:SetPos(30, 38)
	saludTxtRan:SetTextColor(Color(82, 82, 82))
	saludTxtRan:SetFont("PokeMod")
	saludTxtRan:SetPaintBackground(false)

	local nivelRan = slotVacio:Add("DLabel")
	nivelRan:SetText(pPokemon.nivel)
	nivelRan:SetPos(150, 38)
	nivelRan:SetTextColor(Color(82, 82, 82))
	nivelRan:SetFont("PokeMod")
	nivelRan:SetPaintBackground(false)
end

function PANEL:Think()
	if (gui.IsGameUIVisible()) then
		self:Remove()
	end
end

vgui.Register("pmMenuEquipo", PANEL, "DFrame")