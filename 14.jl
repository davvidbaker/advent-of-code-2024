using Test

function maptoquadrants(position, middlerow, middlecol)
    q = 0
    if (position[1] < middlecol) && (position[2] < middlerow)
        q = 1
    elseif (position[1] > middlecol) && (position[2] < middlerow)
        q = 2
    elseif (position[1] < middlecol) && (position[2] > middlerow)
        q = 3
    elseif (position[1] > middlecol) && (position[2] > middlerow)
        q = 4
    end

    return q
end

function partone(input, width, height)

    re = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"

    ITERATIONS = 100
    positions = []
    velocities = []

    for line ∈ readlines(input)
        m = match(re, line)
        c = map(cap -> parse(Int, cap), m.captures)
        push!(positions, (c[1], c[2]))
        push!(velocities, (c[3], c[4]))
    end

    println("positions: ", positions)

    finalpositions = []
    for robotind ∈ eachindex(positions)
        x = (ITERATIONS * velocities[robotind][1] + positions[robotind][1]) % width
        y = (ITERATIONS * velocities[robotind][2] + positions[robotind][2]) % height

        if x < 0
            x = width + x
        end
        if y < 0
            y = height + y
        end
        push!(finalpositions, (x, y))
    end

    middlerow = Int(floor(height / 2))
    middlecol = Int(floor(width / 2))

    println("middlerow: ", middlerow)
    println("middlecol: ", middlecol)


    quadrantcounts = [0, 0, 0, 0]
    qq = map(p -> maptoquadrants(p, middlerow, middlecol), finalpositions)

    for q ∈ qq
        if q != 0
            quadrantcounts[q] += 1
        end
    end

    mat = Int.(zeros(height, width))

    for p ∈ finalpositions
        mat[CartesianIndex(p[2] + 1, p[1] + 1)] += 1
    end

    println("quadrantcounts: ", quadrantcounts)

    total = reduce((acc, x) -> x * acc, quadrantcounts, init=1)

    return total
end

partone("14-test-1.txt", 11, 7)
# partone("14-test.txt", 11, 7)
@test partone("14-test.txt", 11, 7) == 12
partone("14.txt", 101, 103)

# ......2..1.
# ...........
# 1..........
# .11........
# .....1.....
# ...12......
# .1....1....