using Test, YaoBlockTree, YaoArrayRegister

@testset "test constructor" for T in [Float16, Float32, Float64]
    @test ShiftGate(T(0.1)) isa ShiftGate{T}
    @test_throws TypeError ShiftGate{Complex{T}} # will not accept non-real type
    @test shift(T(0.1)) isa ShiftGate{T}
end

@testset "test matrix" begin
    g = ShiftGate{Float64}(pi)
    @test mat(g) ≈ exp(im * pi/2) * [exp(-im * pi/2) 0; 0  exp(im * pi/2)]
end

@testset "test apply" begin
    g = ShiftGate{Float64}(pi)
    reg = rand_state(1)
    @test mat(g) * state(reg) ≈ state(apply!(reg, g))
end

@testset "test compare" begin
    @test (ShiftGate(2.0) == ShiftGate(2.0)) == true
    @test (ShiftGate(2.0) == ShiftGate(1.0)) == false
end

@testset "test copy" begin
    g = ShiftGate(0.1)
    cg = copy(g)
    cg.theta = 0.2
    @test g.theta == 0.1
end

@testset "test properties" begin
    g = ShiftGate{Float64}(0.1)
    @test nqubits(g) == 1
    @test isreflexive(g) == false
    @test isunitary(g) == true
    @test ishermitian(g) == false
end
