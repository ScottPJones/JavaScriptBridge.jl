const connections = Dict{Int,WebSocket}()

"""
Send a message to a web page to be interpetted by WebSocket listener. See coherent.js -> ws.onmessage.
"""
function message(t,data)
    msg = Dict("type"=>t,"data"=>data)
    for (k,v) in connections
        if ~v.is_closed
            write(v, json(msg))
        end
    end
end

"""
Evaluates a JS script and blocks the Julia control flow until JS sends a coherent.message("notify",name) back.
"""
function block(name,script)
    test = """coherent.message("notify","$name")"""
    if contains(script,test)
        condition[name] = Condition()
        message("script",script)
        wait(condition[name])
        delete!(condition,name)
    else
        error("""Script must contain "$test".""")
    end
end

ws = WebSocketHandler() do req::Request, client::WebSocket
    while true
        connections[client.id] = client
        json = bytestring(read(client))
        msg = JSON.parse(json)
        if haskey(msg,"args")
            callback[msg["name"]](msg["args"])
        else
            callback[msg["name"]]()
        end
    end
end

http = HttpHandler() do req::Request, res::Response
    if ismatch(r"^/plot.ly", req.resource)
        res = Response(open(readall,Pkg.dir("JuliaJS","res","plotly.html")))
    elseif ismatch(r"^/julia", req.resource)
        res = Response(open(readall,Pkg.dir("JuliaJS","res","JuliaJS.html")))
    elseif ismatch(r"^/JuliaJS.js", req.resource)
        res = Response(open(readall,Pkg.dir("JuliaJS","res","JuliaJS.js")))
    end
    res
end

server = Server(http,ws)

@async run(server, 8000)
