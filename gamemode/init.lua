AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- Organizar cosas del server-side
util.AddNetworkString("pmEnviarLog")
util.AddNetworkString("pmEnviarChat")
util.AddNetworkString("pmCrearMenu")