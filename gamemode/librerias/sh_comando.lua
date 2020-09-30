-- Librería Comando
PokeMod.comando = PokeMod.comando or {}
PokeMod.comando.lista = PokeMod.comando.lista or {}

--[[
	Registra un comando.
	
	@param	string		pIdentificador		ID del comando
	@param	function	pLlamada			Función que se llama cuando se ejecuta el comando
	@param	varargs		...					Argumentos que se pasan al comando
	@return void
--]]
function PokeMod.comando:Registrar(pIdentificador, pLlamada, ...)
	local args = {...}
	
	-- Comprobamos que la ID, los argumentos y la función de llamada son válidos.
	if (pIdentificador and pIdentificador != "" and args and istable(args) and pLlamada) then
		local tblComando = {}
		
		-- Comprobamos si hay argumentos y cuántos tiene el comando.
		if (table.IsEmpty(args)) then
			tblComando.id = pIdentificador
			tblComando.numArgs = 0
			tblComando.llamada = pLlamada
		else
			tblComando.id = pIdentificador
			tblComando.args = args
			tblComando.numArgs = #args
			tblComando.llamada = pLlamada
		end
		
		-- Añade el comando a la lista y lo registra
		PokeMod.comando.lista[#PokeMod.comando.lista + 1] = tblComando
	end
end

--[[
	Obtiene un comando por su ID.
	
	@param	string	pIdentificador	ID del comando
	@return	table	comando
--]]
function PokeMod.comando:Obtener(pIdentificador)
	pIdentificador = pIdentificador:lower()
	return PokeMod.comando.lista[pIdentificador]
end

--[[
	Comprueba si un comando existe.
	
	@param 	string 	pIdentificador 	ID del comando
	@return	boolean	existe
	@return table	comando
--]]
function PokeMod.comando:Existe(pIdentificador)
	local cmd = self:Obtener(pIdentificador)
	
	if (cmd) then
		return true, cmd
	else
		return false, nil
	end
end