using PlotlyJS
using Test
using Images
using Statistics
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


    total = reduce((acc, x) -> x * acc, quadrantcounts, init=1)

    return total
end

partone("14-test-1.txt", 11, 7)
# partone("14-test.txt", 11, 7)
@test partone("14-test.txt", 11, 7) == 12
partone("14.txt", 101, 103)

function visualize(posarr, width, height, t)
    img = ones(RGB, width, height)  # Create blank image

    for (x, y) in posarr
        img[x+1, y+1] = RGB(0, 0, 0)  # Note: Images uses [y,x] ordering
    end
    save("14-out/$t.png", img)
end


function parttwo(input, width, height)


    re = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"

    positions = []
    velocities = []

    varx = []
    vary = []

    for line ∈ readlines(input)
        m = match(re, line)
        c = map(cap -> parse(Int, cap), m.captures)
        push!(positions, (c[1], c[2]))
        push!(velocities, (c[3], c[4]))
    end

    for t in 1:10000
        for robotind ∈ eachindex(positions)
            x = (velocities[robotind][1] + positions[robotind][1]) % width
            y = (velocities[robotind][2] + positions[robotind][2]) % height

            if x < 0
                x = width + x
            end
            if y < 0
                y = height + y
            end

            positions[robotind] = (x, y)

        end

        xs = map(p -> p[1], positions)
        ys = map(p -> p[2], positions)

        push!(varx, var(xs) + var(ys))
        push!(vary, var(ys))
        # visualize(positions, width, height, t)
    end

    px = plot(1:length(varx), varx + vary)
    # py = plot(1:length(varx), vary)
    display(px)
    # display(py)

end



parttwo("14.txt", 101, 103)
# ......2..1.
# ...........
# 1..........
# .11........
# .....1.....
# ...12......
# .1....1....