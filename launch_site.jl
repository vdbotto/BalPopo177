#=
import Pkg
Pkg.add("Genie")
Pkg.add("FileIO")
Pkg.add("Images")
Pkg.add("ImageMagick")
Pkg.add("Base64")
Pkg.add("Dates")
Pkg.add("XLSX")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("SMTPClient")
Pkg.add("Random")
Pkg.add("SHA")
Pkg.add("Printf")
Pkg.add("JSON")
Pkg.add("QRCoders")
=#

using Genie
using Genie.Router
using Genie.Renderer.Html
using FileWatching
using XLSX
using Dates
using CSV
using DataFrames
using Genie.Requests
using SMTPClient
using Random
using SHA
using Printf
using JSON
using FileIO
using Images
using ImageMagick
using Base64
using QRCoders
using Downloads


url ="https://raw.githubusercontent.com/vdbotto/BalPopo177/refs/heads/main/BalPopo/Bal%20popo%20website%20actual.jl"
try
    Downloads.download(url,"BalPopo/Bal popo website actual.jl")
catch e
    println("Fialed to download update")
    println("Error:$e")
end

filepath = "BalPopo/Bal popo website actual.jl"
include(filepath)

up(host="10.67.110.167")


# automatic up() when file is changed
@async while true
    prev = read(filepath,String)
    try
        Downloads.download(url,"BalPopo/Bal popo website actual.jl")
    catch e
        println("Error:$e")
    end
    sleep(10)
    new = read(filepath,String)
    if prev !== new
        print("Site updated @time $(now())")
        include(filepath)
        up(host="10.67.110.167")
    else
    end

end
