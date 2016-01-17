module JavaScriptBridge

module JS

using HttpServer, WebSockets, JSON, StringInterpolation

include("server.jl")
include("callbacks.jl")
include("api.jl")

export callback, @js_str, js

end

using JavaScriptBridge.JS

export JS, callback, @js_str, js

end
