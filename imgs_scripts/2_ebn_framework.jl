using EnhancedBayesianNetworks
using Cairo
using PGFPlotsX

cpt_A = DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(:A)
cpt_A[:A=>:a1] = 0.5
cpt_A[:A=>:a2] = 0.5
A = DiscreteNode(:A, cpt_A, Dict(:a1 => [Parameter(1, :a)], :a2 => [Parameter(0, :a)]))

cpt_B = DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(:B)
cpt_B[:B=>:b1] = 0.3
cpt_B[:B=>:b2] = 0.7
B = DiscreteNode(:B, cpt_B, Dict(:b1 => [Parameter(1, :b)], :b2 => [Parameter(0, :b)]))

cpt_C = ContinuousConditionalProbabilityTable{PreciseContinuousInput}()
cpt_C[] = Normal()
C = ContinuousNode(:C, cpt_C)

cpt_D = DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}([:A, :B, :D])
cpt_D[:A=>:a1, :B=>:b1, :D=>:d1] = 0.4
cpt_D[:A=>:a1, :B=>:b1, :D=>:d2] = 0.6
cpt_D[:A=>:a1, :B=>:b2, :D=>:d1] = 0.1
cpt_D[:A=>:a1, :B=>:b2, :D=>:d2] = 0.9
cpt_D[:A=>:a2, :B=>:b1, :D=>:d1] = 0.5
cpt_D[:A=>:a2, :B=>:b1, :D=>:d2] = 0.5
cpt_D[:A=>:a2, :B=>:b2, :D=>:d1] = 0.5
cpt_D[:A=>:a2, :B=>:b2, :D=>:d2] = 0.5
D = DiscreteNode(:D, cpt_D, Dict(:d1 => [Parameter(0.3, :d)], :d2 => [Parameter(0.7, :d)]))

model = Model(df -> df.d .+ df.C, :res)
sim = MonteCarlo(100)
performance = df -> 1 .- df.res
M = DiscreteFunctionalNode(:M, [model], performance, sim)

nodes = [A, B, C, D, M]

ebn = EnhancedBayesianNetwork(nodes)
add_child!(ebn, :A, :D)
add_child!(ebn, :B, :D)
add_child!(ebn, :D, :M)
add_child!(ebn, :C, :M)
order!(ebn)

fig1 = gplot(ebn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/1_ebn.pdf", 16cm, 16cm), fig1)

net = evaluate!(ebn)
bn = dispatch(ebn)
fig2 = gplot(bn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)

fig2 = gplot(ebn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/2_rbn.pdf", 16cm, 16cm), fig2)

cpt_C = ContinuousConditionalProbabilityTable{PreciseContinuousInput}()
cpt_C[] = Normal()
discretization = ExactDiscretization([-3, 0, 3])
C = ContinuousNode(:C, cpt_C, discretization)
nodes = [A, B, C, D, M]

ebn = EnhancedBayesianNetwork(nodes)
add_child!(ebn, :A, :D)
add_child!(ebn, :B, :D)
add_child!(ebn, :D, :M)
add_child!(ebn, :C, :M)
order!(ebn)

fig3 = gplot(ebn, NODESIZEFACTOR=0.18, NODELABELSIZE=8, DISCRETIZATION_THICKNESS=3)

fig3 = gplot(ebn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/3_d_ebn.pdf", 16cm, 16cm), fig3)

bn = dispatch(ebn)
fig4 = gplot(bn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/4_d_rbn.pdf", 16cm, 16cm), fig4)

bn.nodes[3]
ev = Evidence(:M => :M_fail)
infer(bn, :C_d, ev)

ev1 = Evidence(:C_d => Symbol([-Inf, -3.0]))
ev2 = Evidence(:C_d => Symbol([-3.0, 0.0]))
ev3 = Evidence(:C_d => Symbol([0.0, 3.0]))
ev4 = Evidence(:C_d => Symbol([3.0, Inf]))
infer(bn, :M, ev1)
infer(bn, :M, ev2)
infer(bn, :M, ev3)
infer(bn, :M, ev4)


### Imprecise ebn

cpt_A = DiscreteConditionalProbabilityTable{ImpreciseDiscreteProbability}(:A)
cpt_A = DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(:A)
cpt_A[:A=>:a1] = 0.5
cpt_A[:A=>:a2] = 0.5
A = DiscreteNode(:A, cpt_A)

cpt_B = DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(:B)
cpt_B[:B=>:b1] = 0.3
cpt_B[:B=>:b2] = 0.7
B = DiscreteNode(:B, cpt_B, Dict(:b1 => [Parameter(1, :b)], :b2 => [Parameter(0, :b)]))

cpt_C = ContinuousConditionalProbabilityTable{ImpreciseContinuousInput}()
cpt_C[] = UnamedProbabilityBox{Normal}([Interval(-0.5, 0.5, :μ), Interval(0.8, 1.2, :σ)])
C = ContinuousNode(:C, cpt_C)

cpt_D = DiscreteConditionalProbabilityTable{ImpreciseDiscreteProbability}([:A, :B, :D])
cpt_D[:A=>:a1, :B=>:b1, :D=>:d1] = (0.3, 0.5)
cpt_D[:A=>:a1, :B=>:b1, :D=>:d2] = (0.5, 0.7)
cpt_D[:A=>:a1, :B=>:b2, :D=>:d1] = (0.0, 0.2)
cpt_D[:A=>:a1, :B=>:b2, :D=>:d2] = (0.9, 1)
cpt_D[:A=>:a2, :B=>:b1, :D=>:d1] = (0.4, 0.6)
cpt_D[:A=>:a2, :B=>:b1, :D=>:d2] = (0.4, 0.6)
cpt_D[:A=>:a2, :B=>:b2, :D=>:d1] = (0.4, 0.6)
cpt_D[:A=>:a2, :B=>:b2, :D=>:d2] = (0.4, 0.6)
D = DiscreteNode(:D, cpt_D, Dict(:d1 => [Parameter(0.3, :d)], :d2 => [Parameter(0.7, :d)]))

model = Model(df -> df.d .+ df.C, :res)
sim = DoubleLoop(MonteCarlo(50))
performance = df -> 1 .- df.res
M = DiscreteFunctionalNode(:M, [model], performance, sim)

nodes = [A, B, C, D, M]

ebn = EnhancedBayesianNetwork(nodes)
add_child!(ebn, :A, :D)
add_child!(ebn, :B, :D)
add_child!(ebn, :D, :M)
add_child!(ebn, :C, :M)
order!(ebn)

fig5 = gplot(ebn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/5_imprecise_ebn.pdf", 16cm, 16cm), fig5)

net = evaluate!(ebn)
bn = dispatch(ebn)
fig6 = gplot(bn, NODESIZEFACTOR=0.18, NODELABELSIZE=8)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/6_imprecise_rbn.pdf", 16cm, 16cm), fig6)

ev = Evidence(:M => :M_fail)
infer(bn, :A, ev)
infer(bn, :B, ev)

cpt_F = DiscreteConditionalProbabilityTable{ImpreciseDiscreteProbability}(:F)
cpt_F[:F=>:f1] = (0.05, 0.1)
cpt_F[:F=>:f2] = (0.1, 0.2)
cpt_F[:F=>:f3] = (0.8, 0.9)

F = DiscreteNode(:F, cpt_F)

extremes = EnhancedBayesianNetworks._extreme_points(F)
ps = map(x -> x.cpt.data.Π, extremes)
ls = map(x -> append!(x, x[1]), deepcopy(ps))
points = ps
xs, ys, zs = [p[1] for p in points], [p[2] for p in points], [p[3] for p in points]

# Create the PGFPlotsX figure
fig = @pgf Axis(
    {
        view = "{60}{30}",  # Adjust viewing angle
        xlabel = "",
        ylabel = "",
        zlabel = "",
        enlargelimits = false,
        grid = "major",
        xmin = 0, xmax = 0.1,  # Set X range
        ymin = 0.09, ymax = 0.2,  # Set Y range
        zmin = 0.5, zmax = 1   # Set Z range
    },
    Plot3(
        {
            thick,
            "blue"
        },
        Coordinates(vcat(xs, xs[1]), vcat(ys, ys[1]), vcat(zs, zs[1]))  # Close the loop
    ),
    Plot3(
        {
            only_marks,  # Plot only the markers
            mark = "o",
            mark_size = "3pt",
            "red"
        },
        Coordinates(xs, ys, zs)
    )
)
pgfsave("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/7_polytope.pdf", fig)
