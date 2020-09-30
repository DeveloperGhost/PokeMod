local PANEL = {}

-- Llamando cuando el panel se inicializa
function PANEL:Init()
    PokeMod.gui.chat = self

    self:SetSize(200, 100)
    self:SetTitle("")
    self:SetPos(0, ScrH() - self:GetTall())
    self:ShowCloseButton(false)
    self:SetDraggable(true)
    self:SetSizable(false)

    self:Rellenar()
end

-- Llamado cuando el panel se rellena
function PANEL:Rellenar()
end