using Test
using JuMP
using HiGHS
using GAMS
import MathOptInterface as MOI

function parsere(m)
    return (parse(Int, m[1]), parse(Int, m[2]),)
end

function clawgame(a, b, p, adder)
    m = Model(HiGHS.Optimizer)
    # doesn't give correct answers without turning off presolve
    set_optimizer_attribute(m, "presolve", "off")
    MOI.set(m, MOI.Silent(), true)

    @variable(m, A ≥ 0, Int)
    @variable(m, B ≥ 0, Int)

    @objective(m, Min, 3 * A + B)

    @constraint(m, a[1] * A + b[1] * B == p[1] + adder)
    @constraint(m, a[2] * A + b[2] * B == p[2] + adder)

    optimize!(m)

    return termination_status(m) == MOI.INFEASIBLE ? 0 : Int(objective_value(m))
end

function partone(input, adder=0)
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
        result = clawgame(arra[i], arrb[i], arrp[i], adder)
        total += result
    end

    return total
end

@test partone("13-test.txt") == 480
@test partone("13.txt") == 36954

function parttwo(input)
    partone(input, 10000000000000)
end

@test parttwo("13-test.txt") == 875318608908
@test parttwo("13-test-2.txt") == 875318608908 * 256
@test parttwo("13.txt") == 79352015273424