Warning: This package is still very early in development. Feedback, issues and PRs are most welcome.

# JavaScriptBridge.jl

This is simple package that allows Julia to interact with JavaScript in a browser and is heavily inspired by [Blink.jl](https://github.com/JunoLab/Blink.jl).

## Installation

JavaScriptBridge is not registered and it requires another unregistered package: [StringInterpolation](https://github.com/EricForgy/StringInterpolation.jl.git). To install, you'll need to run the following commands:

~~~julia
julia> Pkg.clone("https://github.com/EricForgy/StringInterpolation.jl.git")
julia> Pkg.clone("https://github.com/EricForgy/JavaScriptBridge.jl.git")
~~~

## Usage Example:

After installation, running the following from the Julia REPL

~~~julia
julia> using JavaScriptBridge
Listening on 0.0.0.0:8000...
~~~

will start an HttpServer. Open your browser to [http://localhost:8000/julia](http://localhost:8000/julia) and you should see a blank page with "JavaScriptBridge" in the browser tab.

With the browser open, run the following:

~~~julia
julia> include(Pkg.dir("JavaScriptBridge","examples","plotly.jl"))
~~~

If the stars are aligned, you should see several sample charts appear in the browser window. If not, you can try running the above command again. If that still doesn't work, please let me know and I'll try to help.

## Notes:

### Callbacks

Julia code can be called from JavaScript using `callback`s stored in a `Dict`. For example, in Julia, you can define:

~~~julia
callback["sayhello"] = () -> println("Hello")
~~~

and call this from JavaScript (console or scripts) via:

~~~js
Julia.message("sayhello")
~~~

You can also define callbacks with arguments, e.g. in Julia, define:

~~~julia
callback["say"] = args -> println(args)
~~~

and call this from JavaScript via:

~~~js
Julia.message("say","Hello")
~~~

Multiple arguments are also supported, e.g. in Julia, define:

~~~julia
callback["rand"] = args -> println(rand(args...))
~~~

and call this from JavaScript via:

~~~js
Julia.message("rand",[2,3,4])
~~~

### Events & Conditions

An important callback is `notify`. This callback allows Julia to listen for JavaScript events via `Condition`s. An example is provided in `api.jl`:

~~~julia
function addlibrary(url)
    name = basename(url)
    condition[name] = Condition()
    js"""
    var script = document.createElement("script");
    script.src = "$(url)";
    script.onload = Julia.message("notify","$(name)");
    document.head.appendChild(script);
    """
    wait(condition[name])
    delete!(condition,name)
end
~~~

JavaScriptBridge keeps a dictionary of `Condition`s. The method, `addlibrary`, takes a url and adds a `Condition` indexed by the basename of the url to the dictionary. The JS library is added to the page in the browser and, when loading is completed, sends a message back to Julia using the `notify` callback. Julia will wait for this notification and finally delete it from the dictionary. This provides a simple blocking mechanism so that subsequent Julia code will not execute until the library is ready for use.

### Interpolation

The non-standard string literal `js` supports interpolation, but at the moment, the Julia expression needs to be enclosed in parentheses, e.g. instead of

~~~julia
julia> msg = "Hello World"
julia> js"""
console.log("$msg")
"""
~~~

you will need to enclose `msg` in parentheses as illustrated below:

~~~julia
julia> msg = "Hello World"
julia> js"""
console.log("$(msg)")
"""
~~~

### WebSockets

JavaScriptBridge creates an active link between Julia and your browser via WebSockets so you can update your charts from Julia without reloading the page. To see this, try rerunning the above example several times:

~~~julia
julia> include(Pkg.dir("JavaScriptBridge","examples","plotly.jl"))
julia> include(Pkg.dir("JavaScriptBridge","examples","plotly.jl"))
julia> include(Pkg.dir("JavaScriptBridge","examples","plotly.jl"))
julia> include(Pkg.dir("JavaScriptBridge","examples","plotly.jl"))
~~~

Each time you run from the REPL, the charts are updated without having to reload.

A fun artefact of using WebSockets is that you can "broadcast" your charts to several browsers and they will all get updated interactively. Here is a [silly video](https://www.youtube.com/watch?v=mWDyyfVNqP0) demonstrating three browsers (including an iphone) with charts being interactively controlled from the Julia REPL.
