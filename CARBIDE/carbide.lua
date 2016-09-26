local currentLog = { }

local function log( text )
    table.insert( currentLog, text )
end

local file = fs.open( "CARBIDE/config.ccml", "r" )

local config = textutils.unserialize( file.readAll( ) )

file.close( ) 

local bpc = { }

local coros = { }

--//Create Global Functions--//

_G.carbide = {
    addToProcessList = function( functionToStart )
        log("ADDED PROCESS TO QUEUE!")

        bpc[ #bpc + 1 ] = functionToStart
    end,
}

for k , v in pairs( config.startingBackgrndProcesses ) do
    local file = fs.open( k, "r" )

    table.insert(bpc, loadstring( file.readAll( ) ) )

    file.close( )

    print("LOADED: " .. v)

    log( "LOADED: " .. v )
end

for k, v in pairs( bpc ) do
    table.insert( coros, coroutine.create( v ) )

    print( "LOADED AS CORO: " .. bpc[ k ] )

    log( "LOADED AS CORO: " .. bpc[ k ] )
end

while true do
    for k, v in pairs( coros ) do
        if coroutine.status( v ) == "suspended" then
            coroutine.resume( v )
        elseif coroutine.status( v ) == "dead" then
            coros[ k ] = nil
        end
    end
end