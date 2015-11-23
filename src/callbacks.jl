const condition = Dict{AbstractString,Condition}()

unescape(x) = isvalid(UTF8String,unescape_string(x)) ? unescape_string(x) : error("Invalid UTF-8 sequence")
jprint(io::IO,args...) = print(io,[isa(arg,AbstractString) ? unescape(arg) : unescape(JSON.json(arg)) for arg in args]...)

"""
Send a JS command
"""
function js(script::AbstractString)
    message("script",script)
end

macro js_str(script)
    return quote
        s = @interpolate $script $(esc(unescape)) $(esc(jprint))
        js(s)
    end
end

"""
A dictionary of callbacks accessible from JS using coherent.message("notify",name).
"""
const callback = Dict{AbstractString,Function}()
callback["sayhello"] = () -> println("Hello World")
callback["add"] = args -> println(args[1]+args[2])
callback["say"] = args -> println(args)

"""
JS callback used for blocking Julia control flow until notified by the WebSocket.
"""
callback["notify"] = name -> begin
    if haskey(condition,name)
        notify(condition[name])
    else
        error("""Condition "$name" was not found.""")
    end
end
