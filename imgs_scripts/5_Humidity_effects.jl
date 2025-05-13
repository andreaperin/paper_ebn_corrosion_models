using UncertaintyQuantification
using PGFPlotsX
using LaTeXStrings

try
    include("imgs_scripts/models.jl")
catch
    include("models.jl")
end

sim = MonteCarlo(10^4)
model_aux_rh = Model(df -> model_RH.(df.RH_int, df.RH_ref), :RH)
model_aux_ppm = Model(df -> model_ppm2kg(df.ppm_CO₂), :Conc_CO₂)
model1 = Model(df -> model_αₕ.(df.ratio_wc), :αₕ)
model2 = Model(df -> model_a.(df.Cₑ, df.CₐO, df.αₕ, df.M_CO₂, df.M_CₐO), :a)
model3 = Model(df -> model_fₜ.(df.E, df.R, df.T_ref, df.T), :fₜ)
model4 = Model(df -> model_f_rh_carb.(df.RH, df.RH_ref), :f_rh_carb)
model5 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ, df.f_rh_carb, df.Dᵢ, df.a, df.n_d, df.Conc_CO₂, df.n_m), :Δx_c)

models = [model_aux_ppm, model1, model2, model3, model4, model5]

t = Parameter(2020, :t)
T = Parameter(283.9, :T)
CO₂ = Parameter(412.5, :ppm_CO₂)
RH_int = RandomVariable(Uniform(0, 1), :RH)
CO₂_diff = Parameter(2.2e-4, :Dᵢ)
n_d = Parameter(0.24, :n_d)
n_m = Parameter(0.12, :n_m)
C_e = Parameter(300, :Cₑ)
CₐO = Parameter(0.65, :CₐO)
K_site = Parameter(1.15, :K_site)
E = Parameter(38.3, :E)
ratio_wc = Parameter(0.5, :ratio_wc)
inputs1 = [t, R, t₀, M_CₐO, M_CO₂, RH_ref, T_ref, T, CO₂, RH_int, CO₂_diff, n_d, n_m, C_e, CₐO, K_site, E, ratio_wc]

df = sample(inputs1, 2000)
evaluate!(models, df)

x_vals = df.RH
y_vals = df.Δx_c

plt = @pgf Axis(
    {
        xlabel = L"RH",
        ylabel = L"\Delta carbonation \ depth \ [cm]",
        title = L"RH \ vs \ \Delta \ carbonation \ depth ",
        width = "10cm",
        height = "8cm",
        grid = "major",
    },
    Plot(
        {
            only_marks,
            mark = "*",
            mark_size = 0.5,
            color = "blue"
        },
        Table(x_vals, y_vals)
    )
)
PGFPlotsX.save("imgs/pdfs/10_RH_carb.pdf", plt)

sim = MonteCarlo(10^4)

model_aux_ke = Model(df -> model_ke.(df.ke_int), :ke)
model_aux_kc = Model(df -> model_kc.(df.kc_int), :kc)
model_aux_D_Ch0 = Model(df -> model_D_Ch0.(df.D_Ch0_int), :D_Ch0)
model3 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T), :fₜ)
model6 = Model(df -> model_f_rh_ch.(df.RH, RH_ref.value), :f_rh_ch)
model7 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ, df.f_rh_ch, df.ke, df.kt, df.kc, df.C_Ch_B1, df.t, thickness.value), :fe_result)
model8 = Model(df -> model_corrosion_penetration.(df.fe_result, C_Ch_threshold.value), :corrosion_depth)

models_corrosion = [model_aux_kc, model_aux_ke, model_aux_D_Ch0, model3, model6, model7, model8]

t = Parameter(2020, :t)
T = Parameter(283.9, :T)
RH_int = RandomVariable(Uniform(0, 1), :RH)
E = Parameter(38.3, :E)
C_Ch_B = Parameter(1.15, :C_Ch_B1)
D_Ch0 = Parameter(0.7, :D_Ch0_int)
ke = Parameter(2.13, :ke_int)
kt = Parameter(0.832, :kt)
kc = Parameter(0.5, :kc_int)
inputs1 = [R, t₀, RH_ref, T_ref, t, T, RH_int, E, C_Ch_B, D_Ch0, ke, kt, kc]

df = sample(inputs1, 2000)
evaluate!(models_corrosion, df)

x_vals = df.RH
y_vals = df.corrosion_depth

plt = @pgf Axis(
    {
        xlabel = L"RH",
        ylabel = L"chloride \ penetration \ depth \ [m]",
        title = L"RH \ vs \ chloride \ penetration \ depth ",
        width = "10cm",
        height = "8cm",
        grid = "major",
    },
    Plot(
        {
            only_marks,
            mark = "*",
            mark_size = 0.5,
            color = "blue"
        },
        Table(x_vals, y_vals)
    )
)
PGFPlotsX.save("imgs/pdfs/11_RH_corr.pdf", plt)
