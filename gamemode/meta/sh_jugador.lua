AddCSLuaFile()

-- Meta de los Jugadores
local mJug = FindMetaTable("Player")

-- Obtiene el Equipo Pokémon de un jugador
function mJug:ObtenerEquipo()
	if CLIENT then return end
	
    local existe, equipo = PokeMod.equipo:Obtener(self)

    if (existe) then
		return util.JSONToTable(equipo) or nil
    else
        PokeMod.log:Registrar(self, "¡Se ha intentado acceder al equipo de '"..self:Name().."' y no existe!", 3)
        return false
    end
end
