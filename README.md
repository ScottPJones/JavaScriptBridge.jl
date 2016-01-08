Warning: This package is still very early in development. Feedback, issues and PRs are most welcome.

# JuliaJS.jl

This is simple package that allows Julia to interact with JavaScript in a browser and is heavily inspired by [Blink.jl](https://github.com/JunoLab/Blink.jl).

## Installation

JuliaJS is not registered and it requires another unregistered package: [StringInterpolation](https://github.com/EricForgy/StringInterpolation.jl.git). To install, you'll need to run the following commands:

~~~julia
julia> Pkg.clone("https://github.com/EricForgy/StringInterpolation.jl.git")
julia> Pkg.clone("https://github.com/EricForgy/JuliaJS.jl.git")
~~~

## Usage Example:

After installation, running the following from the Julia REPL

~~~julia
julia> using JuliaJS
Listening on 0.0.0.0:8000...
~~~

will start an HttpServer. Open your browser to [http://localhost:8000/julia](http://localhost:8000/julia) and you should see a blank page with "JuliaJS" in the browser tab.

With the browser open, run the following:

~~~julia
julia> include(Pkg.dir("JuliaJS","examples","plotly.jl"))
~~~

If the stars are aligned, you should see several sample charts appear in the browser window.

## Notes:

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

JuliaJS creates an active link between Julia and your browser via WebSockets so you can update your charts from Julia without reloading the page. To see this, try rerunning the above example several times:

~~~julia
julia> include(Pkg.dir("JuliaJS","examples","plotly.jl"))
julia> include(Pkg.dir("JuliaJS","examples","plotly.jl"))
julia> include(Pkg.dir("JuliaJS","examples","plotly.jl"))
julia> include(Pkg.dir("JuliaJS","examples","plotly.jl"))
~~~

Each time you run from the REPL, the charts are updated without having to reload.

A fun artefact of using WebSockets is that you can "broadcast" your charts to several browsers and they will all get updated interactively. Here is a [silly video](https://www.youtube.com/watch?v=mWDyyfVNqP0) demonstrating three browsers (including an iphone) with charts being interactively controlled from the Julia REPL.
