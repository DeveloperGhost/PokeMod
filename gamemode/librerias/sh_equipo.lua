-- Librería Equipo Pokémon
PokeMod.equipo = PokeMod.equipo or {}

if (SERVER) then
    util.AddNetworkString("pmTieneEquipo")

	-- Llamado cuando se crea o actualiza un Equipo Pokémon
	function PokeMod.equipo:Crear(pJug)
		if (pJug and pJug:IsPlayer()) then
			local nomTabla = "pokemod_equipos"
			local existe, _ = PokeMod.equipo:Obtener(pJug)

			if (!sql.TableExists(nomTabla)) then
				PokeMod.log:Registrar(pJug, "¡La tabla '"..nomTabla.."' no existe!", 3)
				PokeMod.log:Registrar(pJug, "Creando tabla '"..nomTabla.."'...", 1)
				
				sql.Query("CREATE TABLE "..nomTabla.."(equipoID INTEGER PRIMARY KEY AUTOINCREMENT, steamID TEXT, equipo TEXT)")

				PokeMod.log:Registrar(pJug, "Tabla '"..nomTabla.."' creada.", 1)
			end

			if (existe) then
				PokeMod.log:Registrar(pJug, "El usuario '"..pJug:Name().."' ya tiene su equipo creado.", 2)
			else
				sql.Query("INSERT INTO "..nomTabla.."(steamID, equipo) VALUES('"..pJug:SteamID().."', '')")
				PokeMod.log:Registrar(pJug, "Equipo creado para el usuario '"..pJug:Name().."'.", 1)
			end
		end
	end

	-- Llamado cuando se obtiene la información de un Equipo Pokémon
	function PokeMod.equipo:Obtener(pJug)
		local consulta = sql.Query("SELECT equipo FROM pokemod_equipos WHERE steamID = '"..pJug:SteamID().."'")

		if (consulta and istable(consulta) and consulta[1]) then
            net.Start("pmTieneEquipo")
            net.Send(pJug)

            return true, consulta[1].equipo
		else
			return false, nil
		end
	end
	
	-- Llamado cuando se añade un pokémon al Equipo de un jugador
	function PokeMod.equipo:Agregar(pJug, pIdentificador)
		if (PokeMod.pokemon:Existe(pIdentificador)) then
			local existe, equipoActual = PokeMod.equipo:Obtener(pJug)
			
			if (existe) then
				local equipo = util.JSONToTable(equipoActual)
				table.insert(equipo, pIdentificador)
				sql.Query("UPDATE pokemod_equipos SET equipo = '"..util.TableToJSON(equipo).."' WHERE steamID = '"..pJug:SteamID().."'")

				-- TODO: Pasar la info al cliente, librería net; ¿Función actualizarGUI?
				--vgui.Create("pmMenuEquipo"):AgregarPokemon(pIdentificador)

				PokeMod.log:Registrar(pJug, "Se ha añadido el pokémon '"..pIdentificador.."' al Equipo Pokémon del usuario '"..pJug:Name().."'.", 1)
			else
				local equipo = util.TableToJSON({pIdentificador})
				sql.Query("UPDATE pokemod_equipos SET equipo = '"..equipo.."' WHERE steamID = '"..pJug:SteamID().."'")

				-- TODO: Pasar la info al cliente, librería net; ¿Función actualizarGUI?
				--vgui.Create("pmMenuEquipo"):AgregarPokemon(pIdentificador)

				PokeMod.log:Registrar(pJug, "Se ha añadido el pokémon '"..pIdentificador.."' al Equipo Pokémon del usuario '"..pJug:Name().."'.", 1)
			end
		else
			PokeMod.log:Registrar(pJug, "Se ha intentado añadir el Pokémon no registrado '"..pIdentificador.."' al Equipo Pokémon de '"..pJug:Name().."'.", 1)
			return false
		end
	end
	
	-- Llamado cuando se quiere vaciar el Equipo Pokémon de un jugador
	function PokeMod.equipo:VaciarEquipo(pJug)
		sql.Query("UPDATE pokemod_equipos SET equipo = '' WHERE steamID = '"..pJug:SteamID().."'")
	end
else
    PokeMod.equipo.tieneEquipo = PokeMod.equipo.tieneEquipo or false

	-- Llamado cuando se visualiza el equipo del jugador local
	function PokeMod.equipo:Visualizar()
		vgui.Create("pmMenuEquipo"):Rellenar()
	end

    net.Receive("pmTieneEquipo", function()
        PokeMod.equipo.tieneEquipo = true
    end)
end
