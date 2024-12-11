using Test
test_input = "125 17"
my_input = "70949 6183 4 3825336 613971 0 15 182"

JUMP = 5
cache = Dict()


function evendigits(x)
    return length(string(x)) % 2 == 0
end

function splitstone(x)
    s = string(x)
    halfway = Int(length(s) / 2)
    return parse.(Int, [s[1:halfway], s[halfway+1:end]])
end


function blink(stone, depth=1)
    # if stone in cache[stone] 
    if stone == 0
        return [1]
        # push!(newstones, 1)
    elseif evendigits(stone)
        ss = splitstone(stone)
        return ss
    else
        return [stone * 2024]
    end
end


function fifteen_later(digit)
    dig_iterations = [[digit]]
    for i ∈ 1:5
        laststones = dig_iterations[end]
        newstones = []
        for stone ∈ laststones
            push!(newstones, blink(stone)...)
        end
        push!(dig_iterations, newstones)
    end

    return dig_iterations[end]
end

function problem(input, iterations)


    input = parse.(Int, split(input, " "))

    println("input: ", input)
    stoners = [input]

    # 0
    # 1
    # 2024
    # 20 24
    # 2 0 2 4
    # 4048 1 4048 8096
    # 40 48 2024 40 48 80 96
    # 4 0 4 8 20 24 4 0 4 8 8 0 9 6
    # 8096 1 8096 16192 2 0 2 4 ....

    # 1 1 1 2 4 4 

    fifteen_map = Dict()
    for digit ∈ 1:9
        fifteen_map[digit] = fifteen_later(digit)
    end

    for i ∈ 1:iterations
        println(i, " ", length(fifteen_map))
        # display(fifteen_map)
        laststones = stoners[end]
        newstones = []
        println("length(laststones): ", length(laststones))
        for stone ∈ laststones
            if !(stone in keys(fifteen_map))
                # println("stone: ", stone)
                fifteen_map[stone] = fifteen_later(stone)
            end
            push!(newstones, fifteen_map[stone]...)
            # println("done pushing")
            # push!(newstones, fifteen_map[stone])
            #     fifteen_map[stone] = fifteen_later(stone)
            #     push


            # push!(newstones, blink(stone)...)
        end
        # println("stoners: ", stoners)

        # println("newstones: ", newstones)
        push!(stoners, newstones)
    end
    # println("stoners: ")
    # display(stoners)
    return length(stoners[end])
end

problem(test_input, Int(25 / JUMP))
problem("1", 3)
# @test problem(test_input, 25) == 55312
@test problem(my_input, 25 / JUMP) == 185205
# @test problem(my_input, 75 / 25) == 185205
