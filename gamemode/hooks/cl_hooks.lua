-- Carga los fonts que se van a usar
function GM:CargarFonts()
    surface.CreateFont("PokeMod", {
        font = "Arial",
        size = 17,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true
    })

    surface.CreateFont("pmTitulo", {
        font = "GModNotify",
        size = ScreenScale(30),
        extended = true,
        weight = 300
    })

    surface.CreateFont("pmBotonFont", {
        font = "GModNotify",
        size = ScreenScale(14),
        extended = true,
        weight = 100
    })

    surface.CreateFont("pmMiniFont", {
		font = "GModNotify",
		size = math.max(ScreenScale(4), 18),
		weight = 300,
	})
end

-- Llamado cuando el jugador intenta abrir el menú contextual.
function GM:ContextMenuOpen()
	return true
end

-- Llamado cuando el jugador intenta abrir el menú spawn.
function GM:SpawnMenuOpen()
	return true
end

function GM:ScoreboardShow()
end

local oculto = {}
oculto["CHudHealth"] = true
oculto["CHudBattery"] = true
oculto["CHudAmmo"] = true
oculto["CHudSecondaryAmmo"] = true
oculto["CHudCrosshair"] = true
oculto["CHudHistoryResource"] = true
oculto["CHudPoisonDamageIndicator"] = true
oculto["CHudSquadStatus"] = true
oculto["CHUDQuickInfo"] = true
--oculto["CHudWeaponSelection"] = true
oculto["CHudChat"] = true

function GM:HUDShouldDraw(elemento)
    if (oculto[elemento]) then
        return false
    end

    return true
end

function GM:HUDPaint()
    self.BaseClass:HUDPaint()
end

net.Receive("pmCrearMenu", function()
	vgui.Create("pmMenuPrincipal")
end)

-- DEBUG DEL MENÚ
-- TODO: Quitar esto cuando se termine de debugear
function GM:PlayerButtonDown(ply, btn)
    if (btn == KEY_X) then
        vgui.Create("pmMenuPrincipal")
    end
end

-- Chat hooks
function GM:StartChat()
    return true
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)

end

function GM:PlayerBindPress(ply, bind, pressed)
    self.BaseClass:PlayerBindPress(ply, bind, pressed)

    if (bind == "messagemode") then
        PokeMod.chat:Abrir()        
    end
end