using Test


add(a, b) = a + b
mult(a, b) = a * b
concat(a,b) = parse(Int, string(a) * string(b))


function check_equation_validity(eq)
    result = eq[1]
    inputs = eq[2:end]
    # println("length(inputs): ", length(inputs))
    # println("inputs: ", inputs)

    operand_places = length(inputs) - 1


    # println("operand_places: ", operand_places)
    for i ∈ (0:2^operand_places-1)
        binary_str = lpad(string(i, base=2), operand_places, '0')
        # println(binary_str)

        agg = inputs[1]
        bin_arr = parse.(Int, split(binary_str, ""))
        # println("bin_arr: ", bin_arr)
        for (ind, op) in enumerate(bin_arr)
            fn = op == 1 ? add : mult
            agg = fn(agg, inputs[ind+1])
        end

        # println("agg, result: ", agg, "-", result)
        if (agg == result)
            return true
        end
    end

    return false
end

function part_one(input_filename)
    equations = readlines(input_filename)
    pattern = r"(\d+): (.*)"
    equations = map(eq_raw -> match(pattern, eq_raw).captures, equations)
    equations = map(eq -> parse.(Int, [eq[1], split(eq[2], " ")...]), equations)

    # println("equations: ", equations)

    valid_mask = map(check_equation_validity, equations)
    # println("valid_mask: ", valid_mask)

    valid_equations = equations[valid_mask]
    # println("valid_equations: ", valid_equations)

    total = reduce((acc, eq) -> eq[1] + acc, valid_equations; init=0)

    println("total: ", total)
    return total

end


function check_equation_validity2(eq)
    result = eq[1]
    inputs = eq[2:end]
    # println("length(inputs): ", length(inputs))
    # println("inputs: ", inputs)

    operand_places = length(inputs) - 1


    # println("operand_places: ", operand_places)
    for i ∈ (0:3^operand_places-1)
        trinary_str = lpad(string(i, base=3), operand_places, '0')
        # println(binary_str)

        agg = inputs[1]
        trin_arr = parse.(Int, split(trinary_str, ""))
        # println("bin_arr: ", trin_arr)
        for (ind, op) in enumerate(trin_arr)
            fn = op == 1 ? add : op == 2 ? mult : concat
            agg = fn(agg, inputs[ind+1])
        end

        # println("agg, result: ", agg, "-", result)
        if (agg == result)
            return true
        end
    end

    return false
end

function part_two(input_filename)
    equations = readlines(input_filename)
    pattern = r"(\d+): (.*)"
    equations = map(eq_raw -> match(pattern, eq_raw).captures, equations)
    equations = map(eq -> parse.(Int, [eq[1], split(eq[2], " ")...]), equations)

    # println("equations: ", equations)

    valid_mask = map(check_equation_validity2, equations)
    # println("valid_mask: ", valid_mask)

    valid_equations = equations[valid_mask]
    # println("valid_equations: ", valid_equations)

    total = reduce((acc, eq) -> eq[1] + acc, valid_equations; init=0)

    println("total: ", total)
    return total

end


@test part_one("07-test.txt") == 3749
part_one("07.txt")

@test part_two("07-test.txt") == 11387
part_two("07.txt")
