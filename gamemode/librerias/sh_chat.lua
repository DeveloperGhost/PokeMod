-- Librería Chat
PokeMod.chat = PokeMod.chat or {}

--[[
	Abre el chat.

	@return void
--]]
function PokeMod.chat:Abrir()
    PokeMod.gui.chat:MakePopup()
    hook.Run("StartChat")
end

function PokeMod.chat:Cerrar()
    gui.EnableScreenClicker(false)
    hook.Run("FinishChat")
    PokeMod.gui.chat:Limpiar()
    hook.Run("ChatTextChanged", "")
end