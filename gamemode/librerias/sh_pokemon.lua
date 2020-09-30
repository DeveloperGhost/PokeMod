-- Librería Pokémon
PokeMod.pokemon = PokeMod.pokemon or {}
PokeMod.pokemon.lista = PokeMod.pokemon.lista or {} 

-- Registra un pokémon
function PokeMod.pokemon:Registrar(pPokemon)
	if (pPokemon.id and pPokemon.nombre) then
		if (!PokeMod.pokemon.lista[pPokemon.id]) then
			PokeMod.pokemon.lista[pPokemon.id] = pPokemon
		end
	end
end

-- Elimina un pokémon del registro
function PokeMod.pokemon:Eliminar(pPokemon)
	if (pPokemon.id and pPokemon.nombre) then
		if (PokeMod.pokemon.lista[pPokemon.id]) then
			table.remove(PokeMod.pokemon.lista, pPokemon)
		end
	end
end

-- Instancia un pokémon registrado
function PokeMod.pokemon:Crear(pIdentificador, pJug)
	local existe, pkm = PokeMod.pokemon:Existe(pIdentificador)
	
	if (existe) then
		PokeMod.log:Registrar(pJug, "El jugador "..pJug:Name().." ha creado un '"..pIdentificador.."'.", 1)
		return pkm
	else
		PokeMod.log:Registrar(pJug, "¡El jugador "..pJug:Name().." ha intentado crear un Pokémon que no está registrado ['"..pIdentificador.."']!", 4)
		return false
	end
end

-- Obtiene el Pokémon
function PokeMod.pokemon:Obtener(pIdentificador)
	return PokeMod.pokemon.lista[pIdentificador]
end

-- Obtiene la ID de un Pokémon
function PokeMod.pokemon:ObtenerID(pPokemon)
	return pPokemon.id
end

-- Comprueba si el Pokémon está registrado
function PokeMod.pokemon:Existe(pIdentificador)
	local idBuscar = pIdentificador:lower()
	local pkm = PokeMod.pokemon:Obtener(idBuscar)
	
	if (pkm) then
		return true, pkm
	else
		return false, nil
	end
end