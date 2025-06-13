using EnhancedBayesianNetworks
using UncertaintyQuantification
using PGFPlotsX
using LaTeXStrings
try
    include("imgs_scripts/models.jl")
catch
    include("models.jl")
end

n_sim = 100_000

function model_RH_stable(RH_int, RH_ref)
    l = RH_ref * RH_int
    RH = RH_ref - l
    if RH > 1
        RH = 1
    elseif RH < 0
        RH = 0
    end
    return RH
end

function latexify(varname::String)
    if varname == "RH_int"
        return L"RH \_ int"
    elseif varname == "ppm_CO₂"
        return L"ppm \_ CO_2"
    elseif varname == "K_site"
        return L"k \_ site"
    elseif varname == "D_i"
        return L"D \_ i"
    elseif varname == "Cₑ"
        return L"C_e"
    elseif varname == "CₐO"
        return L"CaO"
    elseif varname == "ratio_wc"
        return L"ratio \_ wc"
    elseif varname == "T"
        return L"T"
    elseif varname == "n_d"
        return L"n \_ d"
    elseif varname == "n_m"
        return L"n \_ m"
    elseif varname == "E"
        return L"E"
    end
end

model_aux_rh = Model(df -> model_RH_stable.(df.RH_int, RH_ref.value), :RH)
model_aux_ppm = Model(df -> model_ppm2kg(df.ppm_CO₂), :Conc_CO₂)
model1 = Model(df -> model_αₕ.(df.ratio_wc), :αₕ)
model2 = Model(df -> model_a.(df.Cₑ, df.CₐO, df.αₕ, M_CO₂.value, M_CₐO.value), :a)
model3 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T), :fₜ)
model4 = Model(df -> model_f_rh_carb.(df.RH, RH_ref.value), :f_rh_carb)
model5 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ, df.f_rh_carb, df.D_i, df.a, df.n_d, df.Conc_CO₂, df.n_m), :Δx_c)

μ_Dᵢ = 2.2e-4
σ_Dᵢ = 0.15e-4
CO₂_diff = RandomVariable(truncated(Normal(μ_Dᵢ, σ_Dᵢ), 0, Inf), :D_i)
CO2diff_df = sample(CO₂_diff, 10_000)
minCO2diff = minimum(CO2diff_df.D_i)
maxCO2diff = maximum(CO2diff_df.D_i)

μ_nd = 0.24
COV_nd = 0.12
σ_nd = COV_nd * μ_nd
n_d = RandomVariable(truncated(Normal(μ_nd, σ_nd), 0, Inf), :n_d)
nd_df = sample(n_d, 10_000)
minnd = minimum(nd_df.n_d)
maxnd = maximum(nd_df.n_d)

μ_nm = 0.12
COV_nm = 0.1
σ_nm = COV_nm * μ_nm
n_m = RandomVariable(truncated(Normal(μ_nm, σ_nm), 0, Inf), :n_m)
nm_df = sample(n_m, 10_000)
minnm = minimum(nm_df.n_m)
maxnm = maximum(nm_df.n_m)

μ_Cₑ = 300
COV_Cₑ = 0.1
σ_Cₑ = COV_Cₑ * μ_Cₑ
C_e = RandomVariable(truncated(Normal(μ_Cₑ, σ_Cₑ), 0, Inf), :Cₑ)
Ce_df = sample(C_e, 10_000)
minCe = minimum(Ce_df.Cₑ)
maxCe = maximum(Ce_df.Cₑ)

μ_CₐO = 0.65
COV_CₐO = 0.1
σ_CₐO = COV_CₐO * μ_CₐO
CₐO = RandomVariable(Uniform(μ_CₐO - σ_CₐO, μ_CₐO + σ_CₐO), :CₐO)
CaO_df = sample(CₐO, 10_000)
minCaO = minimum(CaO_df.CₐO)
maxCaO = maximum(CaO_df.CₐO)

μ_K_site = 1.15
COV_K_site = 0.1
σ_K_site = COV_K_site * μ_K_site
K_site = RandomVariable(truncated(Normal(μ_K_site, σ_K_site), 0, Inf), :K_site)
K_site_df = sample(K_site, 10_000)
minK_site = minimum(K_site_df.K_site)
maxK_site = maximum(K_site_df.K_site)

μ_E = 38.3
COV_E = 0.09
σ_E = COV_E * μ_E
E = RandomVariable(Uniform(μ_E - σ_E, μ_E + σ_E), :E)
E_df = sample(E, 10_000)
minE = minimum(E_df.E)
maxE = maximum(E_df.E)

μ_ratio_wc = 0.5
COV_ratio_wc = 0.05
σ_ratio_wc = COV_ratio_wc * μ_ratio_wc
log_μ_ratio_wc, log_std_ratio_wc = distribution_parameters(μ_ratio_wc, σ_ratio_wc, LogNormal)
ratio_wc = RandomVariable(truncated(LogNormal(log_μ_ratio_wc, log_std_ratio_wc), 0, 1), :ratio_wc)
ratio_wc_df = sample(ratio_wc, 10_000)
minratio_wc = minimum(ratio_wc_df.ratio_wc)
maxratio_wc = maximum(ratio_wc_df.ratio_wc)

slices = [2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]

μ_T1 = [283.9, 284.2, 284.2, 284.5, 284.7, 284.7, 285.0, 284.8, 283.7]
COV_T1 = [0.003, 0.003, 0.003, 0.003, 0.004, 0.004, 0.004, 0.005, 0.005]
μ_T2 = [284.1, 284.2, 284.6, 284.8, 285.1, 285.2, 285.4, 286.7, 286.0]
COV_T2 = [0.003, 0.003, 0.003, 0.004, 0.003, 0.004, 0.004, 0.004, 0.004]
μ_T3 = [283.9, 284.3, 284.9, 285.4, 285.9, 286.5, 287.4, 288.1, 288.9]
COV_T3 = [0.003, 0.004, 0.004, 0.004, 0.004, 0.004, 0.005, 0.005, 0.005]

μ_CO₂1 = [412.5, 430.8, 440.2, 442.7, 441.7, 437.5, 431.6, 426.0, 420.9]
COV_CO₂1 = [0, 0.016, 0.016, 0.017, 0.010, 0.008, 0.009, 0.010, 0.011]
μ_CO₂2 = [412.5, 435.0, 460.8, 486.5, 508.9, 524.3, 531.1, 533.7, 538.4]
COV_CO₂2 = [0, 0.018, 0.016, 0.015, 0.016, 0.014, 0.012, 0.010, 0.008]
μ_CO₂3 = [412.5, 448.8, 489.4, 540.5, 603.5, 677.1, 758.2, 844.8, 935.9]
COV_CO₂3 = [0, 0.022, 0.018, 0.019, 0.015, 0.013, 0.013, 0.012, 0.010]

μ_H1 = [9.35, 9.52, 10.07, 11.66, 12.71, 12.47, 14.18, 14.16, 13.43]
COV_H1 = [0.606, 0.547, 0.564, 0.563, 0.522, 0.546, 0.532, 0.574, 0.668]
μ_H2 = [8.48, 9.18, 11.99, 13.43, 14.99, 16.03, 17.14, 17.86, 19.64]
COV_H2 = [0.758, 0.591, 0.552, 0.494, 0.493, 0.508, 0.460, 0.462, 0.440]
μ_H3 = [8.20, 11.08, 14.41, 16.62, 19.07, 23.01, 29.54, 32.80, 38.47]
COV_H3 = [0.610, 0.527, 0.491, 0.405, 0.381, 0.388, 0.385, 0.377, 0.373]

means_T = Dict(:ssp1 => μ_T1, :ssp2 => μ_T2, :ssp5 => μ_T3)
COV_T = Dict(:ssp1 => COV_T1, :ssp2 => COV_T2, :ssp5 => COV_T3)
means_CO2 = Dict(:ssp1 => μ_CO₂1, :ssp2 => μ_CO₂2, :ssp5 => μ_CO₂3)
COV_CO2 = Dict(:ssp1 => COV_CO₂1, :ssp2 => COV_CO₂2, :ssp5 => COV_CO₂3)
means_H = Dict(:ssp1 => μ_H1, :ssp2 => μ_H2, :ssp5 => μ_H3)
COV_H = Dict(:ssp1 => COV_H1, :ssp2 => COV_H2, :ssp5 => COV_H3)

for (i, year) in enumerate(slices)
    t = Parameter(year, :t)
    for (j, proj) in enumerate([:ssp1, :ssp2, :ssp5])
        T = RandomVariable(truncated(Normal(means_T[proj][i], means_T[proj][i] * COV_T[proj][i]), 0, Inf), :T)
        CO₂ = RandomVariable(truncated(Normal(means_CO2[proj][i], means_CO2[proj][i] * COV_CO2[proj][i]), 0, Inf), :ppm_CO₂)
        RH_int = RandomVariable(truncated(Normal(means_H[proj][i], means_H[proj][i] * COV_H[proj][i]), 0, Inf), :RH_int)
        inputs = [R, M_CₐO, M_CO₂, t, T, CO₂, RH_int, CO₂_diff, n_d, n_m, C_e, CₐO, K_site, E, ratio_wc]
        models = [model_aux_ppm, model_aux_rh, model1, model2, model3, model4, model5]
        s = sobolindices(models, inputs, :Δx_c, MonteCarlo(n_sim))
        sobols = sort!(s, [:FirstOrder, :TotalEffect], rev=[true, true])
        sum(s.FirstOrder)
        df = sobols
        class_labels = string.(df.Variables)
        class_labels_latex = latexify.(class_labels)
        group1_values = df.FirstOrder
        group2_values = df.TotalEffect
        n = length(class_labels)
        bar_width = 0.3
        bar_shift_amt = 0.20  # relative to each other
        pgf = @pgf Axis(
            {
                ybar,
                bar_width = bar_width,
                xtick = 1:n,
                xticklabels = class_labels_latex,
                xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
                enlargelimits = 0.1,
                ylabel = "",
                ymin = 0,
                ymax = 1,
                height = "8cm",  # Optional: can tweak height/width
                width = "15cm",
                title = L"Sobol's \ Indices ",
                grid = "major"
            },
            # Group 1: shifted left
            Plot({fill = "orange", bar_shift = "-$(bar_shift_amt)cm"}, Coordinates([(i, group1_values[i]) for i in 1:n])),
            # Group 2: shifted right
            Plot({fill = "red", bar_shift = "$(bar_shift_amt)cm"}, Coordinates([(i, group2_values[i]) for i in 1:n])),
            Legend(["First Order", "Total Effect"])
        )
        PGFPlotsX.save("imgs/pdfs/sobols_indices/carbonation/17_1_sobols_$(year)_$(proj).pdf", pgf)
    end
end

## Uniform Assumption
T_rvs = RandomVariable[]
CO2_rvs = RandomVariable[]
H_rvs = RandomVariable[]

for (i, year) in enumerate(slices)
    for (j, proj) in enumerate([:ssp1, :ssp2, :ssp5])
        T = RandomVariable(truncated(Normal(means_T[proj][i], means_T[proj][i] * COV_T[proj][i]), 0, Inf), Symbol("T_$(i)_$(proj)"))
        push!(T_rvs, T)
        CO₂ = RandomVariable(truncated(Normal(means_CO2[proj][i], means_CO2[proj][i] * COV_CO2[proj][i]), 0, Inf), Symbol("ppm_CO₂_$(i)_$(proj)"))
        push!(CO2_rvs, CO₂)
        RH_int = RandomVariable(truncated(Normal(means_H[proj][i], means_H[proj][i] * COV_H[proj][i]), 0, Inf), Symbol("RH_int_$(i)_$(proj)"))
        push!(H_rvs, RH_int)
    end
end

Temps = sample(T_rvs, 10_000)
minT = minimum(skipmissing(vcat(eachcol(Temps)...)))
maxT = maximum(skipmissing(vcat(eachcol(Temps)...)))

CO2s = sample(CO2_rvs, 10_000)
minCO2 = minimum(skipmissing(vcat(eachcol(CO2s)...)))
maxCO2 = maximum(skipmissing(vcat(eachcol(CO2s)...)))

RH_int_s = sample(H_rvs, 10_000)
minRH = minimum(skipmissing(vcat(eachcol(RH_int_s)...)))
maxRH = maximum(skipmissing(vcat(eachcol(RH_int_s)...)))

T = RandomVariable(Uniform(minT, maxT), :T)
CO₂ = RandomVariable(Uniform(minCO2, maxCO2), :ppm_CO₂)
RH_int = RandomVariable(Uniform(minRH / 100, maxRH / 100), :RH_int)

CO₂_diff = RandomVariable(Uniform(minCO2diff, maxCO2diff), :D_i)
n_d = RandomVariable(Uniform(minnd, maxnd), :n_d)
n_m = RandomVariable(Uniform(minnm, maxnm), :n_m)
C_e = RandomVariable(Uniform(minCe, maxCe), :Cₑ)
CₐO = RandomVariable(Uniform(minCaO, maxCaO), :CₐO)
K_site = RandomVariable(Uniform(minK_site, maxK_site), :K_site)
E = RandomVariable(Uniform(minE, maxE), :E)
ratio_wc = RandomVariable(Uniform(minratio_wc, maxratio_wc), :ratio_wc)

for year in slices
    t = Parameter(year, :t)
    inputs = [R, M_CₐO, M_CO₂, t, T, CO₂, RH_int, CO₂_diff, n_d, n_m, C_e, CₐO, K_site, E, ratio_wc]
    models = [model_aux_ppm, model_aux_rh, model1, model2, model3, model4, model5]
    s = sobolindices(models, inputs, :Δx_c, MonteCarlo(n_sim))
    sobols = sort!(s, [:FirstOrder, :TotalEffect], rev=[true, true])
    sum(s.FirstOrder)
    df = sobols
    class_labels = string.(df.Variables)
    class_labels_latex = latexify.(class_labels)
    group1_values = df.FirstOrder
    group2_values = df.TotalEffect
    n = length(class_labels)
    bar_width = 0.3
    bar_shift_amt = 0.20  # relative to each other
    pgf = @pgf Axis(
        {
            ybar,
            bar_width = bar_width,
            xtick = 1:n,
            xticklabels = class_labels_latex,
            xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
            enlargelimits = 0.1,
            ymin = 0,
            ymax = 1,
            ylabel = "",
            height = "8cm",  # Optional: can tweak height/width
            width = "15cm",
            title = L"Sobol's \ Indices \ - \ Uniform \ Assumption ",
            grid = "major"
        },

        # Group 1: shifted left
        Plot({fill = "orange", bar_shift = "-$(bar_shift_amt)cm"}, Coordinates([(i, group1_values[i]) for i in 1:n])),
        # Group 2: shifted right
        Plot({fill = "red", bar_shift = "$(bar_shift_amt)cm"}, Coordinates([(i, group2_values[i]) for i in 1:n])),
        Legend(["First Order", "Total Effect"])
    )
    PGFPlotsX.save("imgs/pdfs/sobols_indices/carbonation/16_1_sobols_uniform_$(year).pdf", pgf)
end