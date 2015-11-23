x = "World"
x = Dict(:a=>2)

js"""
console.log({"Hello": $x});
console.log("Asawa ko!");
"""
