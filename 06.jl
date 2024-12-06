using Test



# integer sin and cosine
isin = dir -> -round(Int, sin(dir))
icos = dir -> round(Int, cos(dir))

nextPos = (xy, dir) -> xy + CartesianIndex(isin(dir), icos(dir))


function partOne(input_filename)
    obstacle_map = readlines(input_filename) # |> x -> map(line -> split("", line), x)
    obstacle_map = input_filename |> readlines |> lines -> map(line -> split(line, ""), lines)
    obstacle_map = map(line -> map(x -> x == "." ? 0 : (x == "#" ? 7 : 2), line), obstacle_map) |> number_lines -> Matrix(hcat(number_lines...))'

    visited_map = zeros(Int, size(obstacle_map, 1), size(obstacle_map, 2))
    starting_position = findfirst(val -> val == 2, obstacle_map)

    direction = π / 2

    pointer = starting_position
    visited_map[pointer] = 1

    # display(visited_map)

    while (true)
        tentative_next_position = nextPos(pointer, direction)

        if (tentative_next_position[1] < 1 || tentative_next_position[2] < 1 || tentative_next_position[1] > size(obstacle_map, 1) || tentative_next_position[2] > size(obstacle_map, 2))
            break
        end
        if (obstacle_map[tentative_next_position] < 3)
            next_position = tentative_next_position
            pointer = next_position
        elseif obstacle_map[tentative_next_position] == 7
            direction -= π / 2
            tentative_next_position = nextPos(pointer, direction)
            next_position = tentative_next_position
            pointer = next_position
        end
        visited_map[pointer] = 1
        # println("pointer: ", pointer)
        # display(visited_map)
    end


    println("sum: ", sum(visited_map))
    return visited_map
end

@test sum(partOne("06-test.txt")) == 41

# answer = partOne("06.txt")
# println("Part One answer:")
# println(answer)

#  up is 1, right is 2, down is 3, left is 4

function check_if_path_is_loop(newObstacle, obstacle_map, pointer, visited_map)
    visited_map = copy(visited_map)
    obstacle_map = copy(obstacle_map)
    direction = π / 2

    obstacle_map[newObstacle] = 7

    while (true)
        tentative_next_position = nextPos(pointer, direction)

        if (tentative_next_position[1] < 1 || tentative_next_position[2] < 1 || tentative_next_position[1] > size(obstacle_map, 1) || tentative_next_position[2] > size(obstacle_map, 2))
            # println("\nloop NOT found:", newObstacle)

            return 0
        end
        if (obstacle_map[tentative_next_position] < 3)
            next_position = tentative_next_position
            pointer = next_position
        elseif obstacle_map[tentative_next_position] == 7
            direction -= π / 2
            direction = direction % 2π
            tentative_next_position = nextPos(pointer, direction)

            if obstacle_map[tentative_next_position] == 7
                direction -= π / 2
                direction = direction % 2π
                tentative_next_position = nextPos(pointer, direction)
                next_position = tentative_next_position
                pointer = next_position
            else
                next_position = tentative_next_position
                pointer = next_position
            end


        end
        # println("direction: ", direction / pi)
        value_to_place = direction == π / 2 ? 1 : direction == 0 ? 2 : direction == -π / 2 ? 3 : direction == -3π / 2 ? 1 : 4
        if visited_map[pointer] == value_to_place
            # println("\nloop found:", newObstacle)
            agg_map = visited_map + obstacle_map
            agg_map[newObstacle] = 8
            # display(agg_map)
            return 1
        end

        visited_map[pointer] = value_to_place
    end
end


function partTwo(input_filename)

    visited_spots = partOne(input_filename)
    potential_obstacles = findall(spot -> spot == 1, visited_spots)
    println("1. length(potential_obstacles): ", length(potential_obstacles))

    obstacle_map = readlines(input_filename) # |> x -> map(line -> split("", line), x)
    obstacle_map = input_filename |> readlines |> lines -> map(line -> split(line, ""), lines)
    input_map = map(line -> map(x -> x == "." ? 0 : (x == "#" ? 7 : 2), line), obstacle_map) |> number_lines -> Matrix(hcat(number_lines...))'
    obstacle_map = map(line -> map(x -> x == "#" ? 7 : 0, line), obstacle_map) |> number_lines -> Matrix(hcat(number_lines...))'



    visited_map = zeros(Int, size(obstacle_map, 1), size(obstacle_map, 2))
    starting_position = findfirst(val -> val == 2, input_map)

    potential_obstacles = deleteat!(potential_obstacles, findfirst(s -> s == starting_position, potential_obstacles))
    println("2. length(potential_obstacles): ", length(potential_obstacles))


    pointer = starting_position
    visited_map[pointer] = 1

    results_in_loop = map(obs -> check_if_path_is_loop(obs, obstacle_map, pointer, visited_map), potential_obstacles)

    println("sum: ", sum(results_in_loop))
    return sum(results_in_loop)
end

partTwo("06-test-2.txt") == 1


answer = partTwo("06.txt")
println("Part Two answer:")
println(answer)