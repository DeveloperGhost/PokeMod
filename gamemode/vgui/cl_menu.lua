local PANEL = {}

-- Llamando cuando el panel se inicializa
function PANEL:Init()
	if (IsValid(PokeMod.gui.menu)) then
		PokeMod.gui.menu:Remove()
	end

	PokeMod.gui.menu = self

	self:SetSize(ScrW(), ScrH())
	self:SetTitle("")
	self:SetPos(0, 0)
    self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetBackgroundBlur(true)
	self:SetSizable(false)
	self:MakePopup()

    self:Rellenar()
end

-- Llamado cuando el panel se rellena
function PANEL:Rellenar()
    local escalaLogo = 1
    
    self.logo = self:Add("DImage")
    self.logo:SetImage("pokemod/logo.png")
    self.logo:SetSize(400 * escalaLogo, 400 * escalaLogo)
    self.logo:CenterHorizontal(0.5)
    self.logo:CenterVertical(0.4)

    self.info = self:Add("DLabel")
	self.info:SetTextColor(Color(255, 255, 255, 25))
	self.info:SetFont("pmMiniFont")
	self.info:SetText("PokeMod v"..GAMEMODE.Version)
	self.info:SizeToContents()
	self.info:SetPos(self:GetWide() - self.info:GetWide() - 4, self:GetTall() - self.info:GetTall() - 4)

    self.btnNuevo = self:Add("pmBoton")
    self.btnNuevo:SetText("Nuevo")
    self.btnNuevo:SizeToContents()
    self.btnNuevo:CenterHorizontal(0.5)
    self.btnNuevo:CenterVertical(0.65)
    self.btnNuevo.DoClick = function()
        self:Remove()

        surface.PlaySound("buttons/button15.wav")

        vgui.Create("pmMenuNuevo")
    end

    if (PokeMod.equipo.tieneEquipo) then
        --self.btnNuevo:SetDisabled(true)
    end

    self.btnCargar = self:Add("pmBoton")
    self.btnCargar:SetText("Cargar")
    self.btnCargar:SizeToContents()
    self.btnCargar:CenterHorizontal(0.5)
    self.btnCargar:CenterVertical(0.7)
    self.btnCargar:SetDisabled(true)
    self.btnCargar.DoClick = function()        
        if (LocalPlayer():Alive()) then
            self:Remove()
            notification.AddLegacy("¡Ya estás usando a tu Entrenador!", NOTIFY_HINT, 2)
            return
        end

        net.Start("pmCargarEntrenador")
        net.SendToServer()

        self:Remove()
        surface.PlaySound("buttons/button15.wav")
        notification.AddLegacy("Entrenador cargado.", NOTIFY_HINT, 2)
    end

    if (PokeMod.equipo.tieneEquipo) then
        self.btnCargar:SetDisabled(false)
    end

    self.btnDescon = self:Add("pmBoton")
    self.btnDescon:SetText("Salir")
    self.btnDescon:SizeToContents()
    self.btnDescon:CenterHorizontal(0.5)
    self.btnDescon:CenterVertical(0.75)
    self.btnDescon.DoClick = function()
        surface.PlaySound("buttons/button15.wav")
        RunConsoleCommand("disconnect")
    end
end

-- Llamado en cada frame del panel cuando es visible
function PANEL:Think()
    if (gui.IsGameUIVisible()) then
        gui.HideGameUI()
    end
end

-- Llamado cuando el panel debe dibujarse
function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("pmMenuPrincipal", PANEL, "DFrame")