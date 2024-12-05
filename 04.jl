using Test

function forwards(xInd, row, rows, rowInd)
    try
        if (row[xInd+1] == "M" && row[xInd+2] == "A" && row[xInd+3] == "S")
            return true
        end
    catch e
    end
    return false
end

function backwards(xInd, row, rows, rowInd)
    try
        if (row[xInd-1] == "M" && row[xInd-2] == "A" && row[xInd-3] == "S")
            return true
        end
    catch e
    end
    return false
end

function down(xInd, row, rows, rowInd)
    try
        if (rows[rowInd+1][xInd] == "M" && rows[rowInd+2][xInd] == "A" && rows[rowInd+3][xInd] == "S")
            return true
        end
    catch e
    end
    return false
end

function up(xInd, row, rows, rowInd)
    try
        if (rows[rowInd-1][xInd] == "M" && rows[rowInd-2][xInd] == "A" && rows[rowInd-3][xInd] == "S")
            return true
        end
    catch e
    end
    return false
end

function diagupright(xInd, row, rows, rowInd)
    try
        if (rows[rowInd-1][xInd+1] == "M" && rows[rowInd-2][xInd+2] == "A" && rows[rowInd-3][xInd+3] == "S")
            return true
        end
    catch e
    end
    return false
end

function diagupleft(xInd, row, rows, rowInd)
    try
        if (rows[rowInd-1][xInd-1] == "M" && rows[rowInd-2][xInd-2] == "A" && rows[rowInd-3][xInd-3] == "S")
            return true
        end
    catch e
    end
    return false
end

function diagdownright(xInd, row, rows, rowInd)
    try
        if (rows[rowInd+1][xInd+1] == "M" && rows[rowInd+2][xInd+2] == "A" && rows[rowInd+3][xInd+3] == "S")
            return true
        end
    catch e
    end
    return false
end

function diagdownleft(xInd, row, rows, rowInd)
    try
        if (rows[rowInd+1][xInd-1] == "M" && rows[rowInd+2][xInd-2] == "A" && rows[rowInd+3][xInd-3] == "S")
            return true
        end
    catch e
    end
    return false
end






function partOne(input_filename)
    rows = readlines(input_filename)
    rows = map(row -> split(row, ""), rows)

    occurrences = 0
    for (rowInd, row) ∈ enumerate(rows)
        allX = findall(v -> v == "X", row)
        for xInd ∈ allX
            if forwards(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if backwards(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if down(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if up(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if diagupright(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if diagupleft(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if diagdownright(xInd, row, rows, rowInd)
                occurrences += 1
            end
            if diagdownleft(xInd, row, rows, rowInd)
                occurrences += 1
            end
            #||
            #    (rows[rowInd-1][xInd] == "M" && rows[rowInd-2][xInd] == "A" && rows[rowInd-3][xInd] == "S")
        end
    end

    println("occurrences: ", occurrences)
    return occurrences
end

@test partOne("04-test.txt") == 18

answer = partOne("04.txt")
println("Part One answer:")
println(answer)

function orientation1(mInd, rows, rowInd)
    try
        if (rows[rowInd][mInd+2] == "S" && rows[rowInd+1][mInd+1] == "A" && rows[rowInd+2][mInd] == "M" && rows[rowInd+2][mInd+2] == "S")
            return true
        end
    catch e
    end
    return false
end

function orientation2(mInd, rows, rowInd)
    try
        if (rows[rowInd][mInd+2] == "M" && rows[rowInd+1][mInd+1] == "A" && rows[rowInd+2][mInd] == "S" && rows[rowInd+2][mInd+2] == "S")
            return true
        end
    catch e
    end
    return false
end
function orientation3(mInd, rows, rowInd)
    try
        if (rows[rowInd+2][mInd] == "M" && rows[rowInd+1][mInd-1] == "A" && rows[rowInd][mInd-2] == "S" && rows[rowInd+2][mInd-2] == "S")
            return true
        end
    catch e
    end
    return false
end

function orientation4(mInd, rows, rowInd)
    try
        if (rows[rowInd][mInd-2] == "M" && rows[rowInd-1][mInd-1] == "A" && rows[rowInd-2][mInd-2] == "S" && rows[rowInd-2][mInd] == "S")
            return true
        end
    catch e
    end
    return false
end
function partTwo(input_filename)
    rows = readlines(input_filename)
    rows = map(row -> split(row, ""), rows)

    occurrences = 0
    for (rowInd, row) ∈ enumerate(rows)
        allM = findall(v -> v == "M", row)
        for mInd ∈ allM

            if orientation1(mInd, rows, rowInd)
                # println("O1: rowInd, mind: $rowInd, $mInd")

                occurrences += 1
            end
            if orientation2(mInd, rows, rowInd)
                # println("O2: rowInd, mind: $rowInd, $mInd")

                occurrences += 1
            end
            if orientation3(mInd, rows, rowInd)
                # println("O3: rowInd, mind: $rowInd, $mInd")

                occurrences += 1
            end
            if orientation4(mInd, rows, rowInd)
                # println("O4: rowInd, mind: $rowInd, $mInd")

                occurrences += 1
            end
        end
    end
    println("occurrences: ", occurrences)
    return occurrences
end

@test partTwo("04-test.txt") == 9

answer = partTwo("04.txt")
println("Part Two answer:")
println(answer)