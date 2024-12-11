using Test
using Memoization

test_input = "125 17"
my_input = "70949 6183 4 3825336 613971 0 15 182"

function evendigits(x)
    return length(string(x)) % 2 == 0
end

function splitstone(x)
    s = string(x)
    halfway = Int(length(s) / 2)
    return parse.(Int, [s[1:halfway], s[halfway+1:end]])
end


function blinkval(stone)
    if stone == 0
        return [1]
    elseif evendigits(stone)
        ss = splitstone(stone)
        return ss
    else
        return [2024 * stone]
    end
end


function problem(input, iterations)
    input = parse.(Int, split(input, " "))

    total = 0
    for stone in input
        result = fun(stone, iterations)
        total += result
    end
    println("total: ", total)

    return total
end

@memoize function fun(stone::Int, iter_remaining::Int)
    bv = blinkval(stone)
    if iter_remaining == 1
        return length(bv)
    else
        output = 0
        for v in bv
            a = fun(v, iter_remaining - 1)
            output += a
        end
    end


    return output
end
@test problem(test_input, 25) == 55312
@test problem(my_input, 25) == 185205
@test problem(my_input, 75) == 221280540398419
