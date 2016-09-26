local file = fs.open( "CARBIDE/config.ccml", "r" )

local config = textutils.unserialize( file.readAll( ) )

file.close( ) 

local bpc = { }

local coros = { }

for k , v in pairs( config.startingBackgrndProcesses ) do
    local file = fs.open( k, "r" )

    table.insert(bpc, loadstring( file.readAll( ) ) )

    file.close( )

    print("LOADED: " .. v)
end

for k, v in pairs( bpc ) do
    table.insert( coros, coroutine.create( v ) )

    print("LOADED AS CORO: " .. bpc[ k ])
end

