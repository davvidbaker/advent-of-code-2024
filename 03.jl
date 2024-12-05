using Test

function partOne(input_filename)
    input = read(input_filename, String)

    pattern = r"mul\((\d+),(\d+)\)"

    sum = 0
    for m ∈ eachmatch(pattern, input)

        prod = 1
        for c ∈ m.captures
            prod = prod * parse(Int, c)
        end

        sum += prod
    end

    return sum

end

@test partOne("03-test.txt") == 161

answer = partOne("03.txt")
println("Part One answer:")
println(answer)

function partTwo(input_filename)
    enabled = true

    input = read(input_filename, String)

    pattern = r"(do\(\))|(don\'t\(\))|(?:mul\((\d+),(\d+)\))"

    sum = 0
    for m ∈ eachmatch(pattern, input)
        if occursin("do()", m.match)
            enabled = true
            continue
        elseif occursin("don't()", m.match)
            enabled = false
            continue
        end

        if (enabled)
            prod = 1
            for c ∈ m.captures
                if isnothing(c)
                    continue
                end
                prod = prod * parse(Int, c)
            end

            sum += prod
        end
    end

    return sum
    println("sum: ", sum)

end

@test partTwo("03-test-2.txt") == 48

answer = partTwo("03.txt")
println("Part Two answer:")
println(answer)