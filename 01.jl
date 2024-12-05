using CSV
using DataFrames
using Test

function partOne(input_filename)
    df = CSV.read(input_filename, DataFrame, delim="   ", header=false)

    sorted_l = sort(df.Column1)
    sorted_r = sort(df.Column2)

    sum = 0
    for i ∈ eachindex(sorted_l)
        sum += abs(sorted_l[i] - sorted_r[i])
    end

    return sum
end

@test partOne("01-test.txt") == 11


answer = partOne("01.txt")
println("Part One answer:")
println(answer)


function partTwo(input_filename)
    df = CSV.read(input_filename, DataFrame, delim="   ", header=false)

    sum = 0
    for location_id ∈ df.Column1
        sum += location_id * count(x -> x == location_id, df.Column2)
    end

    return sum
end


answer = partTwo("01.txt")
println("Part Two answer:")
println(answer)
