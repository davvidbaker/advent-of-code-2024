using JuMP
using HiGHS
import MathOptInterface as MOI
function parsere(m)
    return (parse(Int, m[1]), parse(Int, m[2]))
end

function clawgame(a, b, p)
    m = Model(HiGHS.Optimizer)
    MOI.set(m, MOI.Silent(), true)

    @variable(m, A ≥ 0, Int)
    @variable(m, B ≥ 0, Int)

    @objective(m, Min, 3 * A + B)

    @constraint(m, a[1] * A + b[1] * B == p[1])
    @constraint(m, a[2] * A + b[2] * B == p[2])

    optimize!(m)

    return termination_status(m) == MOI.INFEASIBLE ? 0 : Int(objective_value(m))
end

function partone(input)
    rea = r"Button A: X\+(\d+), Y\+(\d+)"
    reb = r"Button B: X\+(\d+), Y\+(\d+)"
    rep = r"Prize: X=(\d+), Y=(\d+)"

    lines = readlines(input)


    arra = []
    arrb = []
    arrp = []

    for i ∈ 1:4:length(lines)
        aline, bline, pline = lines[i:i+2]

        am = match(rea, aline)
        push!(arra, parsere(am))

        bm = match(reb, bline)
        push!(arrb, parsere(bm))

        pm = match(rep, pline)
        push!(arrp, parsere(pm))
    end


    total = 0
    for i ∈ eachindex(arrp)
        result = clawgame(arra[i], arrb[i], arrp[i])
        total += result

        println("$i, result: ", result)
    end

    return total
end

partone("13-test.txt")
partone("13.txt")