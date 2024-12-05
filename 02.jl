using CSV
using DataFrames
using Test



function isSafe(list)
    prevVal = list[1]
    if list[2] == list[1]
        return 0
    end
    direction = list[2] - list[1] > 0 ? "INC" : "DEC"


    for val ∈ list[2:end]
        if typeof(val) == Missing
            continue
        end
        diff = abs(val - prevVal)

        if !(diff ≥ 1 && diff ≤ 3)
            return 0
        end

        if val > prevVal
            if direction == "DEC"
                return 0
            end

        elseif val < prevVal
            if direction == "INC"
                return 0
            end
        else
            return 0
        end


        prevVal = val
    end

    return 1
end


function partOne(input_filename)
    df = CSV.read(input_filename, DataFrame, delim=" ", header=false)

    safeMask = map(isSafe, eachrow(df))
    return sum(safeMask)
end

@test partOne("02-test.txt") == 2

answer = partOne("02.txt")
println("Part One answer:")
println(answer)


function listSubsets(list)
    subsets = []
    for i in eachindex(list)
        new_list = copy(list)
        deleteat!(new_list, i)
        push!(subsets, new_list)
    end
    return subsets
end

function isSafeEnough(list)
    if isSafe(list) == 1
        return 1
    end

    list = collect(skipmissing(list))

    safeEnoughMask = map(isSafe, listSubsets(list))
    if sum(safeEnoughMask) > 0
        return 1
    end
    return 0
end

function partTwo(input_filename)
    df = CSV.read(input_filename, DataFrame, delim=" ", header=false)

    safeMask = map(isSafeEnough, eachrow(df))
    return sum(safeMask)
end

@test partTwo("02-test.txt") == 4

answer = partTwo("02.txt")
println("Part Two answer:")
println(answer)