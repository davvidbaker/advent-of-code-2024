function partOne(input_filename)
    input = read(input_filename, String)


end

@test partOne("05-test.txt") == 161

answer = partOne("03.txt")
println("Part One answer:")
println(answer)