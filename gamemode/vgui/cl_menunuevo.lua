local PANEL = {}

-- Llamando cuando el panel se inicializa
function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:SetTitle("")
	self:SetPos(0, 0)
    self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetBackgroundBlur(true)
	self:SetSizable(false)
	self:MakePopup()

    -- Variables personalizadas
    self.modeloElegido = "models/pokemon/red.mdl"

    self:Rellenar()
end

-- Llamado cuando el panel se rellena
function PANEL:Rellenar()
    self.lblPregunta = self:Add("DLabel")
    self.lblPregunta:SetFont("pmTitulo")
    self.lblPregunta:SetText("¿Y tú, quién eres?")
    self.lblPregunta:SizeToContents()
    self.lblPregunta:CenterHorizontal(0.5)
    self.lblPregunta:CenterVertical(0.2)

    -- Render del modelo chico
    self.modeloChico = self:Add("DModelPanel")
    self.modeloChico:SetModel("models/pokemon/red.mdl")
    self.modeloChico:SetSize(300, 300)
    self.modeloChico:CenterHorizontal(0.4)
    self.modeloChico:CenterVertical(0.5)

    local pos = self.modeloChico.Entity:GetBonePosition(self.modeloChico.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    pos:Add(Vector(0, 0, 2))

    self.modeloChico:SetLookAt(pos)
    self.modeloChico:SetCamPos(pos - Vector(-30, 0, 0))
    self.modeloChico.DoClick = function()
        self.modeloElegido = self.modeloChico:GetModel()
    end

    -- Render del modelo chica
    self.modeloChica = self:Add("DModelPanel")
    self.modeloChica:SetModel("models/pokemon/red.mdl")
    self.modeloChica:SetSize(300, 300)
    self.modeloChica:CenterHorizontal(0.6)
    self.modeloChica:CenterVertical(0.5)

    local pos2 = self.modeloChica.Entity:GetBonePosition(self.modeloChico.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    pos2:Add(Vector(0, 0, 2))

    self.modeloChica:SetLookAt(pos2)
    self.modeloChica:SetCamPos(pos2 - Vector(-30, 0, 0))
    self.modeloChica.DoClick = function()
        self.modeloElegido = self.modeloChica:GetModel()
    end

    self.btnAnterior = self:Add("pmBoton")
    self.btnAnterior:SetText("Anterior")
    self.btnAnterior:SizeToContents()
    self.btnAnterior:CenterHorizontal(0.25)
    self.btnAnterior:CenterVertical(0.9)
    self.btnAnterior.DoClick = function()
        self:Remove()
        vgui.Create("pmMenuPrincipal")
    end
    
    self.btnSiguiente = self:Add("pmBoton")
    self.btnSiguiente:SetText("Siguiente")
    self.btnSiguiente:SizeToContents()
    self.btnSiguiente:CenterHorizontal(0.75)
    self.btnSiguiente:CenterVertical(0.9)
    self.btnSiguiente.DoClick = function()
        LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0, 2)
        self:Remove()

        net.Start("pmCrearEntrenador")
            net.WriteString(self.modeloElegido)
        net.SendToServer()

        self.He
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

vgui.Register("pmMenuNuevo", PANEL, "DFrame")