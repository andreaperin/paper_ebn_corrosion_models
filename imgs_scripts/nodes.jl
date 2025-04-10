using EnhancedBayesianNetworks

try
    include("imgs_scripts/models.jl")
catch
    include("models.jl")
end

slices = [2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]
slices_parameter = Dict(
    Symbol("2020") => [Parameter(2020, :t)],
    Symbol("2030") => [Parameter(2030, :t)],
    Symbol("2040") => [Parameter(2040, :t)],
    Symbol("2050") => [Parameter(2050, :t)],
    Symbol("2060") => [Parameter(2060, :t)],
    Symbol("2070") => [Parameter(2070, :t)],
    Symbol("2080") => [Parameter(2080, :t)],
    Symbol("2090") => [Parameter(2090, :t)],
    Symbol("2100") => [Parameter(2100, :t)]
)
time_slice = DiscreteNode(
    :t,
    DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(DataFrame(
        :t => [Symbol(n) for n in slices],
        :Π => repeat([1 / length(slices)], outer=length(slices))
    )),
    slices_parameter
)

projections_node = DiscreteNode(
    :proj,
    DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(DataFrame(
        :proj => [:ssp1, :ssp2, :ssp5],
        :Π => [1 / 3, 1 / 3, 1 / 3]
    ))
)

deH_node = DiscreteNode(
    :deH,
    DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(DataFrame(
        :deH => [:deH_working, :deH_broken],
        :Π => [1 - 10^(-4), 10^-4]
    )),
    Dict(:deH_working => [Parameter(true, :deH)], :deH_broken => [Parameter(false, :deH)])
)

deCh_node = DiscreteNode(
    :deCh,
    DiscreteConditionalProbabilityTable{PreciseDiscreteProbability}(DataFrame(
        :deCh => [:deCh_working, :deCh_broken],
        :Π => [1 - 10^(-4), 10^-4]
    )),
    Dict(:deCh_working => [Parameter(true, :deCh)], :deCh_broken => [Parameter(false, :deCh)])
)

## Temperature in K
μ_T1 = [283.9, 284.2, 284.2, 284.5, 284.7, 284.7, 285.0, 284.8, 283.7]
COV_T1 = [0.003, 0.003, 0.003, 0.003, 0.004, 0.004, 0.004, 0.005, 0.005]
μ_T2 = [284.1, 284.2, 284.6, 284.8, 285.1, 285.2, 285.4, 286.7, 286.0]
COV_T2 = [0.003, 0.003, 0.003, 0.004, 0.003, 0.004, 0.004, 0.004, 0.004]
μ_T3 = [283.9, 284.3, 284.9, 285.4, 285.9, 286.5, 287.4, 288.1, 288.9]
COV_T3 = [0.003, 0.004, 0.004, 0.004, 0.004, 0.004, 0.005, 0.005, 0.005]

T = Dict()
for i in range(1, length(slices))
    T[i] = [Normal(μ_T1[i], μ_T1[i] * COV_T1[i]), Normal(μ_T2[i], μ_T2[i] * COV_T2[i]), Normal(μ_T3[i], μ_T3[i] * COV_T3[i])]
end

temperature_2020_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[1]...])
temperature_2020_node = ContinuousNode(:T_2020, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2020_df))

temperature_2030_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[2]...])
temperature_2030_node = ContinuousNode(:T_2030, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2030_df))

temperature_2040_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[3]...])
temperature_2040_node = ContinuousNode(:T_2040, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2040_df))

temperature_2050_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[4]...])
temperature_2050_node = ContinuousNode(:T_2050, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2050_df))

temperature_2060_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[5]...])
temperature_2060_node = ContinuousNode(:T_2060, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2060_df))

temperature_2070_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[6]...])
temperature_2070_node = ContinuousNode(:T_2070, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2070_df))

temperature_2080_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[7]...])
temperature_2080_node = ContinuousNode(:T_2080, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2080_df))

temperature_2090_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[8]...])
temperature_2090_node = ContinuousNode(:T_2090, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2090_df))

temperature_2100_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [T[9]...])
temperature_2100_node = ContinuousNode(:T_2100, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(temperature_2100_df))


## C_CO₂ in ppm
μ_CO₂1 = [412.5, 430.8, 440.2, 442.7, 441.7, 437.5, 431.6, 426.0, 420.9]
COV_CO₂1 = [0, 0.016, 0.016, 0.017, 0.010, 0.008, 0.009, 0.010, 0.011]
μ_CO₂2 = [412.5, 435.0, 460.8, 486.5, 508.9, 524.3, 531.1, 533.7, 538.4]
COV_CO₂2 = [0, 0.018, 0.016, 0.015, 0.016, 0.014, 0.012, 0.010, 0.008]
μ_CO₂3 = [412.5, 448.8, 489.4, 540.5, 603.5, 677.1, 758.2, 844.8, 935.9]
COV_CO₂3 = [0, 0.022, 0.018, 0.019, 0.015, 0.013, 0.013, 0.012, 0.010]


CO₂ = Dict()
for i in range(1, length(slices))
    CO₂[i] = [Normal(μ_CO₂1[i], μ_CO₂1[i] * COV_CO₂1[i]), Normal(μ_CO₂2[i], μ_CO₂2[i] * COV_CO₂2[i]), Normal(μ_CO₂3[i], μ_CO₂3[i] * COV_CO₂3[i])]
end

CO₂_2020_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[1]...])
CO₂_2020_node = ContinuousNode(:ppm_CO₂_2020, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2020_df))

CO₂_2030_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[2]...])
CO₂_2030_node = ContinuousNode(:ppm_CO₂_2030, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2030_df))

CO₂_2040_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[3]...])
CO₂_2040_node = ContinuousNode(:ppm_CO₂_2040, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2040_df))

CO₂_2050_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[4]...])
CO₂_2050_node = ContinuousNode(:ppm_CO₂_2050, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2050_df))

CO₂_2060_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[5]...])
CO₂_2060_node = ContinuousNode(:ppm_CO₂_2060, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2060_df))

CO₂_2070_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[6]...])
CO₂_2070_node = ContinuousNode(:ppm_CO₂_2070, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2070_df))

CO₂_2080_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[7]...])
CO₂_2080_node = ContinuousNode(:ppm_CO₂_2080, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2080_df))

CO₂_2090_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[8]...])
CO₂_2090_node = ContinuousNode(:ppm_CO₂_2090, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2090_df))

CO₂_2100_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [CO₂[9]...])
CO₂_2100_node = ContinuousNode(:ppm_CO₂_2100, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(CO₂_2100_df))

## Humidity in percentage
μ_H1 = [9.35, 9.52, 10.07, 11.66, 12.71, 12.47, 14.18, 14.16, 13.43]
COV_H1 = [0.606, 0.547, 0.564, 0.563, 0.522, 0.546, 0.532, 0.574, 0.668]
μ_H2 = [8.48, 9.18, 11.99, 13.43, 14.99, 16.03, 17.14, 17.86, 19.64]
COV_H2 = [0.758, 0.591, 0.552, 0.494, 0.493, 0.508, 0.460, 0.462, 0.440]
μ_H3 = [8.20, 11.08, 14.41, 16.62, 19.07, 23.01, 29.54, 32.80, 38.47]
COV_H3 = [0.610, 0.527, 0.491, 0.405, 0.381, 0.388, 0.385, 0.377, 0.373]

H = Dict()
for i in range(1, length(slices))
    H[i] = [Normal(μ_H1[i] / 100, μ_H1[i] / 100 * COV_H1[i]), Normal(μ_H2[i] / 100, μ_H2[i] / 100 * COV_H2[i]), Normal(μ_H3[i] / 100, μ_H3[i] / 100 * COV_H3[i])]
end

H_2020_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[1]...])
H_2020_node = ContinuousNode(:RH_int_2020, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2020_df))

H_2030_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[2]...])
H_2030_node = ContinuousNode(:RH_int_2030, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2030_df))

H_2040_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[3]...])
H_2040_node = ContinuousNode(:RH_int_2040, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2040_df))

H_2050_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[4]...])
H_2050_node = ContinuousNode(:RH_int_2050, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2050_df))

H_2060_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[5]...])
H_2060_node = ContinuousNode(:RH_int_2060, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2060_df))

H_2070_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[6]...])
H_2070_node = ContinuousNode(:RH_int_2070, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2070_df))

H_2080_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[7]...])
H_2080_node = ContinuousNode(:RH_int_2080, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2080_df))

H_2090_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[8]...])
H_2090_node = ContinuousNode(:RH_int_2090, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2090_df))

H_2100_df = DataFrame(
    :proj => [:ssp1, :ssp2, :ssp5],
    :Π => [H[9]...])
H_2100_node = ContinuousNode(:RH_int_2100, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(H_2100_df))

μ_Dᵢ = 2.2e-4
σ_Dᵢ = 0.15e-4
CO₂_diff_node = ContinuousNode(:D_i, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_Dᵢ, σ_Dᵢ), 0, Inf))))

μ_nd = 0.24
COV_nd = 0.12
σ_nd = COV_nd * μ_nd
n_d_node = ContinuousNode(:n_d, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_nd, σ_nd), 0, Inf))))

μ_nm = 0.12
COV_nm = 0.1
σ_nm = COV_nm * μ_nm
n_m_node = ContinuousNode(:n_m, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_nm, σ_nm), 0, Inf))))

μ_Cₑ = 300
COV_Cₑ = 0.1
σ_Cₑ = COV_Cₑ * μ_Cₑ
C_e_node = ContinuousNode(:Cₑ, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_Cₑ, σ_Cₑ), 0, Inf))))

μ_CₐO = 0.65
COV_CₐO = 0.1
σ_CₐO = COV_CₐO * μ_CₐO
CₐO_node = ContinuousNode(:CₐO, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => Uniform(μ_CₐO - σ_CₐO, μ_CₐO + σ_CₐO))))

μ_K_site = 1.15
COV_K_site = 0.1
σ_K_site = COV_K_site * μ_K_site
K_site_node = ContinuousNode(:K_site, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_K_site, σ_K_site), 0, Inf))))

μ_E = 38.3
COV_E = 0.09
σ_E = COV_E * μ_E
E_node = ContinuousNode(:E, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => Uniform(μ_E - σ_E, μ_E + σ_E))))

μ_ratio_wc = 0.5
COV_ratio_wc = 0.05
σ_ratio_wc = COV_ratio_wc * μ_ratio_wc
log_μ_ratio_wc, log_std_ratio_wc = distribution_parameters(μ_ratio_wc, σ_ratio_wc, LogNormal)
ratio_wc_node = ContinuousNode(:ratio_wc, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(LogNormal(log_μ_ratio_wc, log_std_ratio_wc), 0, 1))))

## Chloride models
μ_C_Ch_B = 1.15
σ_C_Ch_B = 0.675
C_Ch_B_node = ContinuousNode(:C_Ch_B1, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_C_Ch_B, σ_C_Ch_B), 0, Inf))))

log_μ_D_Ch0 = 0
log_std_D_Ch0 = 0.5
D_Ch0_node = ContinuousNode(:D_Ch0_int, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(LogNormal(log_μ_D_Ch0, log_std_D_Ch0), 0, 1))))

gamma_shape_ke = 2
gamma_scale_ke = 1
ke_node = ContinuousNode(:ke_int, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => Gamma(gamma_shape_ke, gamma_scale_ke))))

μ_kt = 0.832
σ_kt = 0.024
kt_node = ContinuousNode(:kt, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => truncated(Normal(μ_kt, σ_kt), 0, Inf))))

first_shape_kc = 2
second_shape_kc = 2
kc_node = ContinuousNode(:kc_int, ContinuousConditionalProbabilityTable{PreciseContinuousInput}(DataFrame(:Π => Beta(first_shape_kc, second_shape_kc))))

nodes = [
    time_slice,
    projections_node,
    deH_node, deCh_node,
    temperature_2020_node,
    temperature_2030_node,
    temperature_2040_node,
    temperature_2050_node,
    temperature_2060_node,
    temperature_2070_node,
    temperature_2080_node,
    temperature_2090_node,
    temperature_2100_node,
    CO₂_2020_node,
    CO₂_2030_node,
    CO₂_2040_node,
    CO₂_2050_node,
    CO₂_2060_node,
    CO₂_2070_node,
    CO₂_2080_node,
    CO₂_2090_node,
    CO₂_2100_node,
    H_2020_node,
    H_2030_node,
    H_2040_node,
    H_2050_node,
    H_2060_node,
    H_2070_node,
    H_2080_node,
    H_2090_node,
    H_2100_node,
    CO₂_diff_node,
    n_d_node,
    n_m_node,
    C_e_node,
    CₐO_node,
    K_site_node,
    E_node,
    ratio_wc_node,
    C_Ch_B_node,
    D_Ch0_node,
    kc_node,
    ke_node,
    kt_node
]

"nodes imported with T RH and CO₂ now time dependent"