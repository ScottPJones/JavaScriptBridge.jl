using JuliaJS

# Open browser/refresh http://localhost:8000/julia

JuliaJS.add("d3")
JuliaJS.add("plotly")

function add_div(id)
    js"""
        var div = document.getElementById("$(id)");
        if (div === null) {
            d3.select("body").append("div").attr("id","$(id)").attr("class","js-plotly-plot");
        };
    """
end

n = 10
data = Dict[Dict("x"=>1:n,"y"=>rand(n))]
layout = Dict(
  "title"=>"Create a new <div> and plot a single trace",
  "width"=>600,
  "height"=>300,
)
id = "Plot1"
add_div(id)
js"""
Plotly.newPlot("$(id)",$(data),$(layout));
"""

data = Dict[Dict("x"=>1:n,"y"=>rand(n)),Dict("x"=>1:n,"y"=>rand(n))]
layout = Dict(
  "title"=>"Create a new <div> and plot an array of traces",
  "width"=>600,
  "height"=>300,
)
id = "Plot2"
add_div(id)
js"""
Plotly.newPlot("$(id)",$(data),$(layout))
"""

trace1 = Dict(
    "x"=>[1, 2, 3, 4],
    "y"=>[10, 15, 13, 17],
    "mode"=>"markers")

trace2 = Dict(
  "x"=>[2, 3, 4, 5],
  "y"=>[16, 5, 11, 10],
  "mode"=>"lines")

trace3 = Dict(
  "x"=>[1, 2, 3, 4],
  "y"=>[12, 9, 15, 12],
  "mode"=>"lines+markers")

data = Dict[ trace1, trace2, trace3 ]

layout = Dict(
  "title"=>"Line and Scatter Plot",
  "height"=>400,
  "width"=>480)

id = "Plot3"
add_div(id)
js"""
Plotly.newPlot("$(id)",$(data),$(layout))
"""

country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)", "United States (2012)", "Slovenia (2014)", "Canada (2011)", "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)", "Portugal (2011)"];
votingPop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6];
regVoters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9];
trace1 = Dict(
  "type"=>"scatter",
  "x"=>votingPop,
  "y"=>country,
  "mode"=>"markers",
  "name"=>"Percent of estimated voting age population",
  "marker"=>Dict(
    "color"=>"rgba(156, 165, 196, 0.95)",
    "line"=>Dict(
      "color"=>"rgba(156, 165, 196, 1.0)",
      "width"=>1,
    ),
    "symbol"=>"circle",
    "size"=>16
  )
)

trace2 = Dict(
  "x"=>regVoters,
  "y"=>country,
  "mode"=>"markers",
  "name"=>"Percent of estimated registered voters",
  "marker"=>Dict(
    "color"=>"rgba(204, 204, 204, 0.95)",
    "line"=>Dict(
      "color"=>"rgba(217, 217, 217, 1.0)",
      "width"=>1,
    ),
    "symbol"=>"circle",
    "size"=>16
  )
)

data = Dict[trace1, trace2]

layout = Dict(
  "title"=>"Votes cast for ten lowest voting age population in OECD countries",
  "xaxis"=>Dict(
    "showgrid"=>false,
    "showline"=>true,
    "linecolor"=>"rgb(102, 102, 102)",
    "titlefont"=>Dict(
      "font"=>Dict(
        "color"=>"rgb(204, 204, 204)"
      )
    ),
    "tickfont"=>Dict(
      "font"=>Dict(
        "color"=>"rgb(102, 102, 102)"
      )
    ),
    "autotick"=>false,
    "dtick"=>10,
    "ticks"=>"outside",
    "tickcolor"=>"rgb(102, 102, 102)"
  ),
  "margin"=>Dict(
    "l"=>140,
    "r"=>40,
    "b"=>50,
    "t"=>80
  ),
  "legend"=>Dict(
    "font"=>Dict(
      "size"=>10,
    ),
    "yanchor"=>"middle",
    "xanchor"=>"right"
  ),
  "width"=>600,
  "height"=>600,
  "paper_bgcolor"=>"rgb(254, 247, 234)",
  "plot_bgcolor"=>"rgb(254, 247, 234)",
  "hovermode"=>"closest"
)

id = "Plot4"
add_div(id)
js"""
Plotly.newPlot("$(id)",$(data),$(layout));
"""
