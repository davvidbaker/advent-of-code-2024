using Test

function pparse(str)
    if str == '.'
        return 11

    end
    return parse(Int, str)
end

function one(input)
    topo_map = (eachline(input) .|> line -> pparse.(collect(line))) |> arr -> reduce(hcat, arr)''

    trailheads = findall(val -> val == 0, topo_map)

    nines_reachable = []

    paths = map(x -> [[x]], trailheads)
    # println("paths: ", paths)
    for (ind, th) ∈ enumerate(trailheads)
        pointer = th
        for elev ∈ 1:9
            valid_steps = []
            for pointer ∈ paths[ind][end]
                # down
                for dir ∈ [(1, 0), (-1, 0), (0, 1), (0, -1)]
                    new_ind = CartesianIndex(pointer[1] + dir[1], pointer[2] + dir[2])
                    # println("new_ind: ", new_ind)
                    if (checkbounds(Bool, topo_map, new_ind) && topo_map[new_ind] == elev)
                        push!(valid_steps, new_ind)
                    end
                end
            end
            # println("valid_steps $elev: ", valid_steps)
            valid_steps = unique(valid_steps)
            push!(paths[ind], valid_steps)

            if elev == 9
                # println("\nnlength(9 steps): ", length(valid_steps))
                push!(nines_reachable, length(valid_steps))
            end
        end


    end

    # println("nines_reachable: ", nines_reachable)
    s = sum(nines_reachable)
    # println("sum(nines_reachable): ", s)
    return (s, paths)
    # map(line -> map(x -> x == "." ? 0 : (x == "#" ? 7 : 2), line),) |> lines -> Matrix(hcat(lines...))'
end


one("10-test-2.txt")[1] == 36
@test one("10-test-2.txt")[1] == 36

@test one("10.txt")[1] == 587

function valid_step(a, b)
    if abs(a[1] - b[1]) + abs(a[2] - b[2]) == 1
        return true
    else
        return false
    end
end

function pathscore(valid_steps)
    score = 1
    poss_last_step_count = 1
    num_branches = 1

    paths = [valid_steps[1]]
    for (ind, steps) in enumerate(valid_steps[2:end])
        for path in paths
            last_spot = path[end]
            bitmask = map(s -> valid_step(last_spot, s), steps)
            next_valid_steps = steps[bitmask]

            if length(next_valid_steps) == 1
                push!(path, next_valid_steps[1])
            elseif length(next_valid_steps) > 1
                for s in next_valid_steps[2:end]
                    new_path = copy(path)
                    push!(new_path, s)
                    push!(paths, new_path)
                end
                push!(path, next_valid_steps[1])
            end
        end
    end
    pp = map(path -> map(x -> (x[1], x[2]), path), paths)
    paths = filter(p -> length(p) == 10, paths)

    # display(pp)
    return length(paths)
end

function two(input)
    _s, valid_steps = one(input)

    scores = map(pathscore, valid_steps)
    println("\nscores: ", scores)
    println("sum : ", sum(scores))
    return sum(scores)
end

display(enumerate(one("10-test.txt")[2][1]) |> collect)
@test two("10-test-227.txt") == 227
@test two("10-test-13.txt") == 13
@test two("10-test-2.txt") == 81
@test two("10-test-3.txt") == 3

#  20, 24, 10, 4, 1, 4, 5, 8, and 5
two("10.txt")
