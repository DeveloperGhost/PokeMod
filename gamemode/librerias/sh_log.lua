-- Librería Log
PokeMod.log = PokeMod.log or {}

local COLOR = {
	Color(30, 144, 255),	-- Info - 1
	Color(0, 128, 0),		-- Éxito - 2
	Color(255, 255, 0),		-- Aviso - 3
	Color(255, 165, 0),		-- Error - 4
	Color(255, 0, 0) 		-- Fatal - 5
}

function PokeMod.log:Registrar(pJug, pMsj, pNivel)
	if (pMsj) then
        if (pJug and IsEntity(pJug) and pJug:IsPlayer()) then
            if (pNivel and isnumber(pNivel)) then
                MsgC(COLOR[5], "[PokeMod] ", COLOR[pNivel], pMsj, "\n")
                
                if (pJug:IsAdmin()) then
                    PokeMod.log:Enviar(pJug, pMsj, pNivel)
                end
            else
                MsgN("[PokeMod] ", pMsj)
                
                if (pJug:IsAdmin()) then
                    PokeMod.log:Enviar(pJug, pMsj, 1)
                end
            end
        elseif (pJug == "chat") then
            PokeMod.log:Chat(player.GetHumans(), pMsj)
            PokeMod.log:Enviar(player.GetHumans(), pMsj, pNivel)
        elseif (pJug == nil) then
            PokeMod.log:Enviar(player.GetHumans(), pMsj, pNivel)
        end
    end
end

function PokeMod.log:Enviar(pJug, pMsj, pNivel)
	net.Start("pmEnviarLog")
		net.WriteString(pMsj)
		net.WriteInt(pNivel, 4)
	net.Send(pJug)
end

function PokeMod.log:Chat(pJug, pMsj)
	net.Start("pmEnviarChat")
		net.WriteString(pMsj)
	net.Send(pJug)
end

if (CLIENT) then
	net.Receive("pmEnviarLog", function(pLon, pJug)
		local msj = net.ReadString()
		local nivel = net.ReadInt(4)

		MsgC(COLOR[5], "[PokeMod] ", COLOR[nivel], msj, "\n")
	end)

    net.Receive("pmEnviarChat", function(pLon, pJug)
		local msj = net.ReadString()

		chat.AddText(COLOR[5], "[PokeMod] ", COLOR[1], msj)
	end)
end
