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
    elseif varname == "C_Ch_B"
        return L"C \_ Ch \_ B"
    elseif varname == "D_Ch0_int"
        return L"D \_ Ch0 \_ int"
    elseif varname == "ke_int"
        return L"ke \_ int"
    elseif varname == "kt"
        return L"kt"
    elseif varname == "kc_int"
        return L"kc \_ int"
    end
end

model_aux_rh = Model(df -> model_RH_stable.(df.RH_int, RH_ref.value), :RH)
model_aux_ke = Model(df -> model_ke.(df.ke_int), :ke)
model_aux_kc = Model(df -> model_kc.(df.kc_int), :kc)
model_aux_D_Ch0 = Model(df -> model_D_Ch0.(df.D_Ch0_int), :D_Ch0)
model3 = Model(df -> model_fₜ.(df.E, df.R, T_ref.value, df.T), :fₜ)
model6 = Model(df -> model_f_rh_ch.(df.RH, RH_ref.value), :f_rh_ch)
model7 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ, df.f_rh_ch, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result)
model8 = Model(df -> model_corrosion_penetration.(df.fe_result, C_Ch_threshold.value), :corrosion_depth)

models_ch = [model_aux_rh, model_aux_kc, model_aux_ke, model_aux_D_Ch0, model3, model6, model7, model8]

μ_E = 38.3
COV_E = 0.09
σ_E = COV_E * μ_E
E = RandomVariable(Uniform(μ_E - σ_E, μ_E + σ_E), :E)
E_df = sample(E, 10_000)
minE = minimum(E_df.E)
maxE = maximum(E_df.E)

μ_C_Ch_B = 1.15
σ_C_Ch_B = 0.675
C_Ch_B = RandomVariable(truncated(Normal(μ_C_Ch_B, σ_C_Ch_B), 0, Inf), :C_Ch_B)
C_Ch_B_df = sample(C_Ch_B, 10_000)
minC_Ch_B = minimum(C_Ch_B_df.C_Ch_B)
maxC_Ch_B = maximum(C_Ch_B_df.C_Ch_B)

log_μ_D_Ch0 = 0
log_std_D_Ch0 = 0.5
D_Ch_0 = RandomVariable(truncated(LogNormal(log_μ_D_Ch0, log_std_D_Ch0), 0, 1), :D_Ch0_int)
D_Ch_0_df = sample(D_Ch_0, 10_000)
minD_Ch_0 = minimum(D_Ch_0_df.D_Ch0_int)
maxD_Ch_0 = maximum(D_Ch_0_df.D_Ch0_int)

gamma_shape_ke = 2
gamma_scale_ke = 1
ke = RandomVariable(Gamma(gamma_shape_ke, gamma_scale_ke), :ke_int)
ke_df = sample(ke, 10_000)
minke = minimum(ke_df.ke_int)
maxke = maximum(ke_df.ke_int)

μ_kt = 0.832
σ_kt = 0.024
kt = RandomVariable(truncated(Normal(μ_kt, σ_kt), 0, Inf), :kt)
kt_df = sample(kt, 10_000)
minkt = minimum(kt_df.kt)
maxkt = maximum(kt_df.kt)

first_shape_kc = 2
second_shape_kc = 2
kc = RandomVariable(Beta(first_shape_kc, second_shape_kc), :kc_int)
kc_df = sample(kc, 10_000)
minkc = minimum(kc_df.kc_int)
maxkc = maximum(kc_df.kc_int)

slices = [2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]

μ_T1 = [283.9, 284.2, 284.2, 284.5, 284.7, 284.7, 285.0, 284.8, 283.7]
COV_T1 = [0.003, 0.003, 0.003, 0.003, 0.004, 0.004, 0.004, 0.005, 0.005]
μ_T2 = [284.1, 284.2, 284.6, 284.8, 285.1, 285.2, 285.4, 286.7, 286.0]
COV_T2 = [0.003, 0.003, 0.003, 0.004, 0.003, 0.004, 0.004, 0.004, 0.004]
μ_T3 = [283.9, 284.3, 284.9, 285.4, 285.9, 286.5, 287.4, 288.1, 288.9]
COV_T3 = [0.003, 0.004, 0.004, 0.004, 0.004, 0.004, 0.005, 0.005, 0.005]

μ_H1 = [9.35, 9.52, 10.07, 11.66, 12.71, 12.47, 14.18, 14.16, 13.43]
COV_H1 = [0.606, 0.547, 0.564, 0.563, 0.522, 0.546, 0.532, 0.574, 0.668]
μ_H2 = [8.48, 9.18, 11.99, 13.43, 14.99, 16.03, 17.14, 17.86, 19.64]
COV_H2 = [0.758, 0.591, 0.552, 0.494, 0.493, 0.508, 0.460, 0.462, 0.440]
μ_H3 = [8.20, 11.08, 14.41, 16.62, 19.07, 23.01, 29.54, 32.80, 38.47]
COV_H3 = [0.610, 0.527, 0.491, 0.405, 0.381, 0.388, 0.385, 0.377, 0.373]

means_T = Dict(:ssp1 => μ_T1, :ssp2 => μ_T2, :ssp5 => μ_T3)
COV_T = Dict(:ssp1 => COV_T1, :ssp2 => COV_T2, :ssp5 => COV_T3)
means_H = Dict(:ssp1 => μ_H1, :ssp2 => μ_H2, :ssp5 => μ_H3)
COV_H = Dict(:ssp1 => COV_H1, :ssp2 => COV_H2, :ssp5 => COV_H3)

for (i, year) in enumerate(slices)
    t = Parameter(year, :t)
    for (j, proj) in enumerate([:ssp1, :ssp2, :ssp5])
        T = RandomVariable(truncated(Normal(means_T[proj][i], means_T[proj][i] * COV_T[proj][i]), 0, Inf), :T)
        RH_int = RandomVariable(truncated(Normal(means_H[proj][i], means_H[proj][i] * COV_H[proj][i]), 0, Inf), :RH_int)
        inputs = [R, t, T, RH_int, E, C_Ch_B, D_Ch0, ke, kt, kc]
        models = models_ch
        # df = sample(inputs, 100)
        # UncertaintyQuantification.evaluate!(models, df)
        s = sobolindices(models, inputs, :corrosion_depth, MonteCarlo(n_sim))
        sobols = sort!(s, [:FirstOrder, :TotalEffect], rev=[true, true])
        sum(s.FirstOrder)
        df = sobols
        class_labels = string.(df.Variables)
        class_labels_latex = latexify.(class_labels)
        group1_values = df.FirstOrder
        group2_values = df.TotalEffect
        n = length(class_labels)
        bar_width = 0.25
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
                title = L"Sobols \ Indices ",
                grid = "major"
            },
            # Group 1: shifted left
            Plot({fill = "orange", bar_shift = "-$(bar_shift_amt)cm"}, Coordinates([(i, group1_values[i]) for i in 1:n])),
            # Group 2: shifted right
            Plot({fill = "red", bar_shift = "$(bar_shift_amt)cm"}, Coordinates([(i, group2_values[i]) for i in 1:n])),
            Legend(["First Order", "Total Effect"])
        )
        PGFPlotsX.save("imgs/pdfs/sobols_indices/chloride/19_sobols_withRH_$(year)_$(proj).pdf", pgf)
    end
end

# ## Uniform Assumption
T_rvs = RandomVariable[]
H_rvs = RandomVariable[]

for (i, year) in enumerate(slices)
    for (j, proj) in enumerate([:ssp1, :ssp2, :ssp5])
        T = RandomVariable(truncated(Normal(means_T[proj][i], means_T[proj][i] * COV_T[proj][i]), 0, Inf), Symbol("T_$(i)_$(proj)"))
        push!(T_rvs, T)
        RH_int = RandomVariable(truncated(Normal(means_H[proj][i], means_H[proj][i] * COV_H[proj][i]), 0, Inf), Symbol("RH_int_$(i)_$(proj)"))
        push!(H_rvs, RH_int)
    end
end
Temps = sample(T_rvs, 10_000)
minT = minimum(skipmissing(vcat(eachcol(Temps)...)))
maxT = maximum(skipmissing(vcat(eachcol(Temps)...)))

RH_int_s = sample(H_rvs, 10_000)
minRH = minimum(skipmissing(vcat(eachcol(RH_int_s)...)))
maxRH = maximum(skipmissing(vcat(eachcol(RH_int_s)...)))

T = RandomVariable(Uniform(minT, maxT), :T)
RH_int = RandomVariable(Uniform(minRH / 100, maxRH / 100), :RH_int)

E = RandomVariable(Uniform(minE, maxE), :E)
C_Ch_B = RandomVariable(Uniform(minC_Ch_B, maxC_Ch_B), :C_Ch_B)
D_Ch0 = RandomVariable(Uniform(minD_Ch_0, maxD_Ch_0), :D_Ch0_int)
ke = RandomVariable(Uniform(minke, maxke), :ke_int)
kt = RandomVariable(Uniform(minkt, maxkt), :kt)
kc = RandomVariable(Uniform(minkc, maxkc), :kc_int)

for year in slices
    t = Parameter(year, :t)
    inputs = [R, t, T, RH_int, E, C_Ch_B, D_Ch0, ke, kt, kc]
    models = models_ch
    s = sobolindices(models, inputs, :corrosion_depth, MonteCarlo(n_sim))
    sobols = sort!(s, [:FirstOrder, :TotalEffect], rev=[true, true])
    df = sobols
    class_labels = string.(df.Variables)
    class_labels_latex = latexify.(class_labels)
    group1_values = df.FirstOrder
    group2_values = df.TotalEffect
    n = length(class_labels)
    bar_width = 0.25
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
            title = L"Sobols \ Indices \ - \ Uniform \ Assumption ",
            grid = "major"
        },

        # Group 1: shifted left
        Plot({fill = "orange", bar_shift = "-$(bar_shift_amt)cm"}, Coordinates([(i, group1_values[i]) for i in 1:n])),
        # Group 2: shifted right
        Plot({fill = "red", bar_shift = "$(bar_shift_amt)cm"}, Coordinates([(i, group2_values[i]) for i in 1:n])),
        Legend(["First Order", "Total Effect"])
    )
    PGFPlotsX.save("imgs/pdfs/sobols_indices/chloride/18_sobols_withRH_uniform_$(year).pdf", pgf)
end
