"""Add a JS library to the current page from a url."""
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

const library = Dict{ASCIIString,ASCIIString}()
library["d3"] = "https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.12/d3.js"
library["plotly"] = "https://cdn.plot.ly/plotly-latest.min.js"
# Add addition common JS libraries here...

"""Add a JS library from the dictionary `library` of common JS libraries."""
function add(lib::AbstractString)
    addlibrary(library[lib])
end

function iframe(id,url)
    name = basename(url)
    condition[name] = Condition()
    js"""
    d3.select("body").append("iframe").attr("id","$(id)").attr("src","$(url)").on("load", function() {Julia.message("notify","$(name)");});
    """
    wait(condition[name])
    delete!(condition,name)
end

# function table(id,attr)
#
# end
