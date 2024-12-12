using Test

function pp(regions)
    return map(listofindices -> map(x -> (x[1], x[2]), listofindices), regions)
end


vertdirs = [(1, 0), (-1, 0)]
horizdirs = [(0, 1), (0, -1)]
dirs = [horizdirs..., vertdirs...]


function expand(ci, mat, region, visited)
    regionval = mat[region[1]]
    for dir ∈ dirs
        newind = CartesianIndex(ci[1] + dir[1], ci[2] + dir[2])
        if checkbounds(Bool, mat, newind) && !(newind ∈ visited)
            if mat[newind] == regionval && !(newind ∈ region)
                push!(region, newind)

                region = expand(newind, mat, region, visited)
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
@test partone("12-test-3.txt") == 1930
# @test partone("12.txt") == 1381056


# careful of edgecase
# continuousgroupswithonesharedside

function countgroups(arr, hv, mat, gardenchar)
    isempty(arr) && return 0

    edgeindex = hv == :v ? 1 : 2

    # Sort the array first
    sorted = sort(arr, by=ci -> ci[edgeindex])
    edges = map(ci -> ci[edgeindex], sorted)

    # Start with 1 group
    groups = 1

    # Compare adjacent elements
    for i in 2:length(edges)
        # If difference > 1, we found a new group
        if edges[i] - edges[i-1] > 1
            groups += 1
        elseif  true && checkbounds(Bool, mat, CartesianIndex(sorted[i])) && checkbounds(Bool, mat, CartesianIndex(sorted[i-1]))
            a = mat[CartesianIndex(sorted[i])]
            b = mat[CartesianIndex(sorted[i-1])]
            if (a != b && (a == gardenchar || b == gardenchar))
                # split up edge case (also vertically)
                #     AAAAAA
                #     AAABBA
                #     AAABBA
                #        --
                #      --
                #     ABBAAA
                #     ABBAAA
                #     AAAAAA
                groups += 1

            end
        end
    end

    # split up edge case (also vertically)
    #     AAAAAA
    #     AAABBA
    #     AAABBA
    #        --
    #      --
    #     ABBAAA
    #     ABBAAA
    #     AAAAAA

    # if ()

    return groups
end

function calcsides(region, mat)
    gardenchar = mat[region[1]]
    vedges = []
    hedges = []
    for ci ∈ region
        for dir ∈ horizdirs
            newind = CartesianIndex(ci[1] + dir[1], ci[2] + dir[2])
            if !(newind ∈ region)
                if dir[2] > 0
                    newind = (ci[1] + dir[1], ci[2])
                    push!(vedges, newind)

                else
                    push!(vedges, newind)
                end
            end
        end
        for dir ∈ vertdirs
            newind = CartesianIndex(ci[1] + dir[1], ci[2] + dir[2])
            if !(newind ∈ region)
                if dir[1] > 0
                    newind = (ci[1], ci[2] + dir[2])
                    push!(hedges, newind)
                else
                    push!(hedges, newind)
                end
            end
        end
    end

    # display(map(x -> (x[1], x[2]), hedges) |> arr -> sort(arr, by=ci -> ci[1]))

    # now find number of disjoint continuous groups with shared second second index
    vsides = 0
    for xy in unique(ci -> ci[2], vedges)
        y = xy[2]
        reledges = filter(ci -> ci[2] == y, vedges)# |> arr -> map(ci -> ci[1], arr)
        vsides += countgroups(reledges, :v, mat, gardenchar)
    end

    hsides = 0
    for xy in unique(ci -> ci[1], hedges)
        x = xy[1]
        reledges = filter(ci -> ci[1] == x, hedges)# |> arr -> map(ci -> ci[2], arr)
        hsides += countgroups(reledges, :h, mat, gardenchar)
    end

    return vsides + hsides
end

function parttwo(input)
    garden_mat = (eachline(input) .|> line -> split(line, "")) |> arr -> reduce(hcat, arr)
    # display(garden_mat)

    println("\ndividing time: ")
    regions = @time divideintoregions(garden_mat)

    println("areas and sides: ")
    @time begin
        areas = map(calcarea, regions)
        sides = map(r -> calcsides(r, garden_mat), regions)

        total = 0
        for i ∈ eachindex(regions)
            total += sides[i] * areas[i]
        end
    end

    println("total: ", total)
    return total
end

@test parttwo("12-test-1.txt") == 80
@test parttwo("12-test-2.txt") == 436
@test parttwo("12-test-3.txt") == 1206
@test parttwo("12-test-4.txt") == 236
@test parttwo("12-test-5.txt") == 368

@test parttwo("12.txt"== 834828)