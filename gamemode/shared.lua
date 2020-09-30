DeriveGamemode("sandbox")

-- Variable global del gamemode
PokeMod = PokeMod or {}

-- Define información sobre PokeMod.
GM.Name = "PokeMod"
GM.Author = "Ghost"
GM.Version = "0.0.1b"

-- Llamado cuando el servidor actualiza su nombre en el navegador de servidores.
function GM:GetGameDescription()
	return "PokeMod"
end

function PokeMod:Incluir(nomArchivo)
	if (!nomArchivo) then
		ErrorNoHalt("[PokeMod] No se ha especificado el nombre del archivo al incluir.")
		return
	end

	if (nomArchivo:find("sv_") and SERVER) then
		return include(nomArchivo)
	elseif (nomArchivo:find("shared.lua") or nomArchivo:find("sh_")) then
		if (SERVER) then
			AddCSLuaFile(nomArchivo)
		end

		return include(nomArchivo)
	elseif (nomArchivo:find("cl_")) then
        print(nomArchivo)
		if (SERVER) then
			AddCSLuaFile(nomArchivo)
		else
			return include(nomArchivo)
		end
	end
end

-- Añadir sistemas y librerías
do
	local _, modulos = file.Find("gamemodes/pokemod/gamemode/*", "MOD")

	for i = 1, #modulos do
        local sistemas, _ = file.Find("gamemodes/pokemod/gamemode/"..modulos[i].."/*", "MOD")
		
		for j = 1, #sistemas do
			PokeMod:Incluir(modulos[i].."/"..sistemas[j])
		end
	end
end