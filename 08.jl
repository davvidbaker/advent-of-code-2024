using Test
using SparseArrays

distance(a, b) = (a[1] - b[1], a[2] - b[2])

Base.zero(::Tuple{Int64,Int64}) = (0, 0)

function one(filename)
    lines = readlines(filename) |> arr -> map(line -> split(line, ""), arr)
    mat = reduce(vcat, [permutedims(line) for line in lines])

    antennas = filter(x -> x != ".", unique(mat))

    output = zeros(Int, size(mat, 1), size(mat, 2))

    for a ∈ antennas
        a_locations = findall(x -> x == a, mat)

        distances = map(x -> map(y -> distance(x, y), a_locations), a_locations)
        distances = reduce(vcat, [permutedims(d) for d in distances])
        distances = SparseArrays.triu(sparse(distances))


        rows, cols, values = findnz(distances)
        for (ind, val) in enumerate(values)
            row = rows[ind]
            col = cols[ind]

            a_loc = a_locations[row]
            b_loc = a_locations[col]
            an_locs = [(a_loc[1] + val[1], a_loc[2] + val[2]), (b_loc[1] - val[1], b_loc[2] - val[2])]


            for an_loc ∈ an_locs
                if (size(mat, 1) >= an_loc[1] > 0 && size(mat, 2) >= an_loc[2] > 0)
                    output[CartesianIndex(an_loc)] = 1
                end
            end

        end
    end

    return sum(output)
end

@test one("08-test-1.txt") == 2
@test one("08-test-2.txt") == 4
@test one("08-test.txt") == 14


@test one("08.txt") == 409


function two(filename)
    lines = readlines(filename) |> arr -> map(line -> split(line, ""), arr)
    mat = reduce(vcat, [permutedims(line) for line in lines])

    antennas = filter(x -> x != ".", unique(mat))

    output = zeros(Int, size(mat, 1), size(mat, 2))

    for a ∈ antennas
        a_locations = findall(x -> x == a, mat)

        distances = map(x -> map(y -> distance(x, y), a_locations), a_locations)
        distances = reduce(vcat, [permutedims(d) for d in distances])
        distances = SparseArrays.triu(sparse(distances))


        rows, cols, values = findnz(distances)
        for (ind, val) in enumerate(values)
            row = rows[ind]
            col = cols[ind]

            a_loc = a_locations[row]
            b_loc = a_locations[col]

            an_locs = []

            r = a_loc[1]
            c = a_loc[2]

            while (size(mat, 1) ≥ r > 0 && size(mat, 2) ≥ c > 0)
                push!(an_locs, (r, c))
                r += val[1]
                c += val[2]
            end

            r = b_loc[1]
            c = b_loc[2]

            while (size(mat, 1) ≥ r > 0 && size(mat, 2) ≥ c > 0)
                push!(an_locs, (r, c))
                r -= val[1]
                c -= val[2]
            end


            for an_loc ∈ an_locs
                output[CartesianIndex(an_loc)] = 1
            end

        end
    end


    return sum(output)
end

@test two("08-test-1.txt") == 5
@test two("08-test-3.txt") == 9
@test two("08-test.txt") == 34

@test two("08.txt") == 1308
