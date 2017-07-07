local s, odium = pcall( collectgarbage, 'odium' ) if (not odium) or (not odium.aegis) then
	return
end

local playerTable = FindMetaTable("Player")
local cbacks = {}
local blockedCmds = {}

local _oRunConsoleCommand = RunConsoleCommand
local _oConCommand = playerTable.ConCommand

local _oInclude = include
local _oRequire = require

local _ipairs = ipairs
local _Getfenv = debug.getfenv
local oStr, oValue = nil

local unlock_time
local tbl_BadSrc = {}

local function LogString( str ) 
	chat.AddText(Color(134, 171, 167), "Iron-Curtain # ", Color(255, 255, 255), str)
end

local function StartsWith( source, with )
	local len = with:len()
	
	if(source:len() < len) then
		return false
	end
	
	for i=1, len do
		if(source[i] ~= with[i]) then
			return false
		end
	end
	
	return true
end

local function IsBadSource( info )
	if(not info) then
		return false
	end

	if((info.short_src:find("[C]")) or (info.short_src:find("LuaCmd"))) then
		return true
	end
	
	return false
end

local function Alert()
	local t = os.time()
	
	if(unlock_time == nil) then
		unlock_time = t + 3
	elseif(t > unlock_time) then
		unlock_time = t + 3
	else return end
	
	LogString("We've blocked a malicious attempt to read GMod's memory.")
end

ipairs = odium.aegis.Detour( ipairs, function ( tbl )
	local str, val = debug.getupvalue( ipairs, 1 )
	
	if(type(val) == "number") then
		Alert()
		debug.setupvalue(_ipairs, 1, oValue)
		
		local info = debug.getinfo( 1 )
		table.insert(tbl_BadSrc, info.short_src)
		return _ipairs({ })
	end
	
	return _ipairs( tbl )
end)

debug.getfenv = odium.aegis.Detour( debug.getfenv, function ( tbl )
	local info = debug.getinfo( 1 )
	if(table.HasValue(tbl_BadSrc, info.short_src)) then
		local key = table.KeyFromValue(tbl_BadSrc, info.short_src)
		
		if(key ~= nil) then
			table.remove(tbl_BadSrc, key)
			return nil
		end
	end
	
	return _Getfenv( tbl )
end)
oStr, oValue = debug.getupvalue(_ipairs, 1)

--[[
WaitForPostLoad
Summary:
]]

include = odium.aegis.Detour( include, function ( file )
	local inc = _oInclude( file )
	
	local ctr = 1
	for k,v in pairs(cbacks) do
		if(string.find(file, k)) then
			v()
			table.remove(cbacks, ctr)
		end
		
		ctr = ctr + 1
	end
	return inc
end)

require = odium.aegis.Detour( require, function ( file )
	local req = _oRequire( file )
	
	local ctr = 1
	for k,v in pairs(cbacks) do
		if(string.find(file, k)) then
			v()
			table.remove(cbacks, ctr)
		end
		
		ctr = ctr + 1
	end
	return req
end)

local function WaitForPostLoad( file, callback )
	if(cbacks[file] ~= nil) then
		return
	end
	cbacks[file] = callback
end

--

--[[
ConCommand blocking
Summary:
]]
local function IsCommandBlocked( cmd_raw )
	for k,v in pairs(blockedCmds) do
		if(StartsWith(cmd_raw, v) == true) then
			return true
		end
	end
	
	return false
end

RunConsoleCommand = odium.aegis.Detour( RunConsoleCommand, function ( cmd, ... )
	if(IsCommandBlocked(cmd) and IsBadSource()) then
		return
	end
	
	return _oRunConsoleCommand( cmd, ... )
end)

playerTable.ConCommand = odium.aegis.Detour( playerTable.ConCommand, function ( ply, cmd )
	if(IsCommandBlocked(cmd) and IsBadSource()) then
		return
	end
	return _oConCommand( ply, cmd )
end)

function ProtectCommand(cmd)
	if(blockedCmds[cmd]  ~= nil) then
		return
	end
	blockedCmds[#blockedCmds + 1] = cmd
end

function UnProtectCommand(cmd)
	for k,v in pairs(blockedCmds) do
		if(v == cmd) then
			odium.security.BlockRemoteExecCmd(cmd, false)
			table.remove(blockedCmds, k)
			break
		end
	end
end

WaitForPostLoad("hook", function ()
	hook.Add("InitPostEntity", "BlockCmds", function ()
		if(odium and odium.GetConCommandList) then
			local aegis_Cmds = odium.GetConCommandList()
			for k,v in pairs(aegis_Cmds) do
				ProtectCommand(k)
			end
		end
	
		for k,v in pairs(blockedCmds) do
			odium.security.BlockRemoteExecCmd(v, true)
		end
	end)
end)
--

print("# Iron-Curtain #")
print("# Garry's Mod Client Security")
print("# created by Anubis")

-- Some default commands to protect.
ProtectCommand("say")
ProtectCommand("impulse")
ProtectCommand("pp_texturize")
ProtectCommand("pp_texturize_scale")