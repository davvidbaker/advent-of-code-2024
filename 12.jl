using Test

function pp(regions)
    return map(listofindices -> map(x -> (x[1], x[2]), listofindices), regions)
end

dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]


function expand(ci, mat, region, visited)
    regionval = mat[region[1]]
    for dir ∈ dirs
        newind = CartesianIndex(ci[1] + dir[1], ci[2] + dir[2])
        if checkbounds(Bool, mat, newind) && !(newind ∈ visited)
            if mat[newind] == regionval && !(newind ∈ region)
                push!(region, newind)

                region = expand(newind, mat, region, visited)

                push!(region)
            end
        end
    end

    return region
end

function divideintoregions(mat)
    visited = []
    regions = []

    for idx ∈ CartesianIndices(mat)
        if idx ∈ visited
            continue
        end

        region = [idx]

        region = unique(expand(idx, mat, region, visited))

        push!(visited, region...)
        push!(regions, region)
    end

    # display(pp(regions))
    return regions
end

function calcarea(region)
    return length(region)
end

function calcperim(region, mat)
    perim = 0
    for ci ∈ region
        for dir ∈ dirs
            newind = CartesianIndex(ci[1] + dir[1], ci[2] + dir[2])
            if !(newind ∈ region)
                perim += 1
            end
        end
    end

    return perim
end

function partone(input)
    garden_mat = (eachline(input) .|> line -> split(line, "")) |> arr -> reduce(hcat, arr)

    println("\ndividing time: ")
    regions = @time divideintoregions(garden_mat)

    println("areas and perim: ")
    @time begin
        areas = map(calcarea, regions)
        perims = map(r -> calcperim(r, garden_mat), regions)

        total = 0
        for i ∈ eachindex(regions)
            total += perims[i] * areas[i]
        end
    end

    println("total: ", total)
    return total
end

@test partone("12-test-1.txt") == 140

@test partone("12-test-2.txt") == 772
# partone("12.txt")

# x = @time [i^2 for i in 1:1000000]
