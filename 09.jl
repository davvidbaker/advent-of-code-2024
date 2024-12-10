using Test

function reducer(acc, (ind, val))
    id = Int(floor(ind / 2))
    if (ind % 2 == 1)
        return [acc..., fill(id, val)...]
    end
    return [acc..., fill(-1, val)...]
end

function stringify(arr)
    return reduce((acc, val) -> acc * (val == -1 ? "." : string(val)), arr, init="")
end

function checksum(arr)
    return reduce((acc, (ind, val)) -> acc + (ind - 1) * (val == -1 ? 0 : val), enumerate(arr), init=0)
end
function organize_memory(arr)
    complete_length = sum(map(x -> x ≥ 0 ? 1 : 0, arr))

    while (true)
        ind = findfirst(val -> val == -1, arr)
        ind2 = findlast(val -> val != -1, arr)
        if (ind > complete_length)
            break
        end

        arr[ind], arr[ind2] = arr[ind2], arr[ind]
    end

    return arr
end

function one(input)
    disk_map = read(input, String) |> str -> parse.(Int, split(str, ""))

    memory_arr = reduce(reducer, enumerate(disk_map), init=[])
    memory_str = stringify(memory_arr)

    # println("memory_arr: ", memory_arr)
    # println("memory_str: ", memory_str)

    ordered = organize_memory(memory_arr)
    # println("ordered: ", ordered)
    # println("stringify(ordered): ", stringify(ordered))

    return checksum(ordered)

end

# 0..111....22222
# 00...111...2...333.44.5555.6666.777.888899

one("09-test-1.txt")
@test one("09-test-2.txt") == 1928

one("09.txt")