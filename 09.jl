using Test

struct EmptySpace
    len::Int
end

struct UsedSpace
    id::Int
    len::Int
end

function reducer(acc, (ind, val))
    id = Int(floor(ind / 2))
    if (ind % 2 == 1)
        return [acc..., fill(id, val)...]
    end
    return [acc..., EmptySpace(val)]
end

function make_memory(disk_map)
    arr = []

    for (i, val) in enumerate(disk_map)
        id = Int(floor(i / 2))
        if (i % 2 == 1)
            push!(arr, fill(id, val)...)
        elseif val != 0
            push!(arr, EmptySpace(val))
        end
    end

    return arr

end

function stringify(arr)
    return reduce((acc, val) -> begin
            if val isa EmptySpace
                acc * repeat(".", val.len)
            else
                acc * string(val)
            end
        end, arr, init="")
end


function checksum(arr)
    println("doing checksum")
    # not working for some reason
    # arr_flat = Iterators.flatmap(x -> x isa EmptySpace ? fill(-1, x.len) : x, arr) |> collect
    # return reduce((acc, (ind, val)) -> acc + (ind - 1) * (val == -1 ? 0 : val), enumerate(arr_flat), init=0)

    total = 0
    counter = 0
    for x in arr
        if !(x isa EmptySpace)
            total += counter * x
            counter += 1
        else
            counter += x.len
        end
    end
    return total
end

function organize_memory(arr)
    println("organizing memory")
    complete_length = sum(map(x -> x isa EmptySpace ? 0 : 1, arr))


    while (true)
        # for i in 1:20
        ind_empty = findfirst(val -> val isa EmptySpace, arr)
        ind2 = findlast(val -> !(val isa EmptySpace), arr)
        if (ind_empty > complete_length)
            break
        end

        e = arr[ind_empty]
        id = arr[ind2]

        if e.len < 2
            arr[ind_empty] = id
            arr[ind2] = EmptySpace(1)
        else
            arr[ind_empty] = EmptySpace(e.len - 1)
            arr[ind2] = EmptySpace(1)
            insert!(arr, ind_empty, id)
        end

    end

    return arr
end

function one(input)
    disk_map = read(input, String) |> str -> parse.(Int, split(str, ""))

    println("doing reducer")
    # memory_arr = reduce(reducer, enumerate(disk_map), init=[])
    memory_arr = make_memory(disk_map)

    # memory_str = stringify(memory_arr)

    # println("memory_arr: ", memory_arr)
    # println("memory_str: ", memory_str)

    ordered = organize_memory(memory_arr)
    # println("ordered: ", ordered)
    # println("stringify(ordered): ", stringify(ordered))

    return checksum(ordered)

end


# 0..111....22222
# 00...111...2...333.44.5555.6666.777.888899

@test one("09-test-1.txt") == 60
@test one("09-test-2.txt") == 1928
one("09-test-2.txt") == 1928

one("09-test-3.txt")
one("09-test-3.txt") == 825
one("09.txt") == 6337921897505



function make_memory2(disk_map)
    arr = []

    for (i, val) in enumerate(disk_map)
        id = Int(floor(i / 2))
        if (i % 2 == 1)
            push!(arr, UsedSpace(id, val))
        elseif val != 0
            push!(arr, EmptySpace(val))
        end
    end

    return arr

end

function pretty(arr)
    return map(x -> x isa UsedSpace ? fill(x.id, x.len) : fill(".", x.len), arr)
end

function organize_memory2(arr)
    println("organizing memory 2")

    ids_checked = []
    last_ind_moved = length(arr)
    while (true)
        if (length(ids_checked) % 100 == 0)
            print(length(ids_checked))
        end
        # for i in 1:20

        ind_to_move = findlast(val -> val isa UsedSpace && !(val.id in ids_checked), arr[1:last_ind_moved])
        last_ind_moved = ind_to_move
        # println("\nids_checked: ", ids_checked)
        # println("arr: ", pretty(arr))
        if (isnothing(ind_to_move))
            break
        end

        memory_block_to_move = arr[ind_to_move]
        # println("trying to move: ", memory_block_to_move.id)

        push!(ids_checked, memory_block_to_move.id)

        ind_empty = findfirst(val -> val isa EmptySpace && val.len >= memory_block_to_move.len, arr)

        if (isnothing(ind_empty) || ind_empty > ind_to_move)
            continue
        end

        # println("ind_empty: ", ind_empty)

        # if (ind_empty > complete_length)
        #     break
        # end

        e = arr[ind_empty]

        if e.len == memory_block_to_move.len
            arr[ind_empty] = memory_block_to_move
            arr[ind_to_move] = EmptySpace(memory_block_to_move.len)
        else
            arr[ind_empty] = EmptySpace(e.len - memory_block_to_move.len)
            arr[ind_to_move] = EmptySpace(memory_block_to_move.len)
            insert!(arr, ind_empty, memory_block_to_move)
        end

    end

    return arr
end


function checksum2(arr)
    println("doing checksum2")
    # not working for some reason
    # arr_flat = Iterators.flatmap(x -> x isa EmptySpace ? fill(-1, x.len) : x, arr) |> collect
    # return reduce((acc, (ind, val)) -> acc + (ind - 1) * (val == -1 ? 0 : val), enumerate(arr_flat), init=0)

    total = 0
    counter = 0
    for x in arr
        if !(x isa EmptySpace)
            for i in 1:x.len
                total += counter * x.id
                counter += 1
            end
        else
            counter += x.len
        end
    end
    return total
end



function two(input)
    disk_map = read(input, String) |> str -> parse.(Int, split(str, ""))

    println("doing reducer")
    # memory_arr = reduce(reducer, enumerate(disk_map), init=[])
    memory_arr = make_memory2(disk_map)

    asdf = filter(x -> x isa UsedSpace, memory_arr)
    un = unique(x -> x.id, asdf)
    println("num unique ids", length(un))

    # memory_str = stringify(memory_arr)

    # println("memory_arr: ", memory_arr)
    # println("memory_str: ", memory_str)

    ordered = organize_memory2(memory_arr)
    # println("ordered: ", pretty(ordered))
    # println("stringify(ordered): ", stringify(ordered))

    return checksum2(ordered)
end

@test two("09-test-2.txt") == 2858
two("09.txt")