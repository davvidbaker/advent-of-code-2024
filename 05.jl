using Test

function is_correctly_ordered(update, rules)
    for (ind, page) ∈ enumerate(update)
        other_pages = deleteat!(copy(update), 1:ind)
        for other ∈ other_pages
            found_rule = findfirst(rule -> rule[1] == page && rule[2] == other, rules)
            if (isnothing(found_rule))
                return false
            end
        end
    end

    return true
end

function partOne(input_prefix)
    rules = readlines("$input_prefix-rules.txt")
    rules = map(rule -> parse.(Int, split(rule, "|")), rules)

    updates = readlines("$input_prefix-updates.txt")
    updates = map(update -> parse.(Int, split(update, ",")), updates)


    sum = 0
    for update ∈ updates
        correct = is_correctly_ordered(update, rules)
        if (correct)
            middle_index = Int(ceil(length(update) / 2))
            middle_element = update[middle_index]

            sum += middle_element
        end
    end
    println("sum: ", sum)

    return sum
end

@test partOne("05-test") == 143

answer = partOne("05")
println("Part One answer:")
println(answer)

function remove_a_page(pages_remaining, relevant_rules)
    right_sides = map(r -> r[2], relevant_rules)

    for page ∈ pages_remaining
        if isnothing(findfirst(val -> val == page, right_sides))
            return page
        end
    end
end


function fix_update(update, rules)
    pages_left_to_order = copy(update)
    ordered_pages = []

    relevant_rules = filter(rule -> rule[1] ∈ update && rule[2] ∈ update, rules)

    # find page that is not on the right side
    while (length(pages_left_to_order) > 0)
        removed_page = remove_a_page(pages_left_to_order, relevant_rules)
        push!(ordered_pages, removed_page)
        deleteat!(pages_left_to_order, findfirst(val -> val == removed_page, pages_left_to_order))
        deleteat!(relevant_rules, findall(rule -> rule[1] == removed_page, relevant_rules))
    end

    return ordered_pages


    return update
end

function partTwo(input_prefix)
    rules = readlines("$input_prefix-rules.txt")
    rules = map(rule -> parse.(Int, split(rule, "|")), rules)

    updates = readlines("$input_prefix-updates.txt")

    updates = map(update -> parse.(Int, split(update, ",")), updates)


    sum = 0
    for update ∈ updates
        correct = is_correctly_ordered(update, rules)
        if (!correct)
            println("\nINCORRECT: ", update)

            correct_update = fix_update(update, rules)

            println("CORRECT: ", correct_update)


            middle_index = Int(ceil(length(correct_update) / 2))
            middle_element = correct_update[middle_index]

            sum += middle_element
        end
    end
    println("sum: ", sum)

    return sum
end

@test partTwo("05-test") == 123

answer = partTwo("05")
println("Part Two answer:")
println(answer)