util.AddNetworkString("pmCrearEntrenador")
util.AddNetworkString("pmCargarEntrenador")

-- Llamado cuando el jugador spawnea por primera vez.
function GM:PlayerInitialSpawn(pJug)
    PokeMod.log:Registrar("chat", "El jugador '"..pJug:Name().."' se ha conectado.", 1)
    PokeMod.equipo:Obtener(pJug)

	timer.Simple(1, function()
		pJug:KillSilent()
		pJug:StripAmmo()
        pJug:SetNoDraw(true)
        pJug:SetNotSolid(true)
        pJug:Lock()

        net.Start("pmCrearMenu")
	    net.Send(pJug)
    end)
end

-- Llamado cuando el jugador respawnea
function GM:PlayerSpawn(pJug)
    pJug:SetNoDraw(false)
    pJug:SetNotSolid(false)
    pJug:UnLock()

    pJug:Give("manos")
	pJug:Give("pokeball")
end

-- Llamado cuando el jugador spawnea y tiene que elegir un modelo.
function GM:PlayerSetModel(pJug)
	pJug:SetModel("models/player/red.mdl")
end

-- Llamado cuando se dan armas por defecto al jugador.
function GM:PlayerLoadout(pJug)
	return true
end

-- Llamado cuando el jugador intenta encender/apagar su linterna.
function GM:PlayerSwitchFlashlight(pJug)
	return false
end

net.Receive("pmCrearEntrenador", function(pLon, pJug)
    local modelo = net.ReadString()

    PokeMod.equipo:Crear(pJug)
    pJug:SetModel(modelo)
    pJug:Spawn()
end)

net.Receive("pmCargarEntrenador", function(pLon, pJug)
    pJug:Spawn()
end)