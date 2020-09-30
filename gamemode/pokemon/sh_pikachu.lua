-- Registro de Pokémon
local PKM = {}

PKM.id 			= "pikachu"
PKM.nombre 		= "Pikachu"
PKM.desc 		= "Descripción"
PKM.modelo		= "models/yunpolmodels/pokemon/gen 1/(25) - pikachu_male_3ds.mdl"
PKM.tipo 		= {"Eléctrico"}
PKM.genero 		= -1 				-- -1 no especificado, 0 macho, 1 hembra y 2 no-binario
PKM.nivel		= 1
PKM.vida		= 0
PKM.vidaMax		= 0

PokeMod.pokemon:Registrar(PKM)