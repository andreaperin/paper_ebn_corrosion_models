using UncertaintyQuantification
using PGFPlotsX
using LaTeXStrings

try
    include("imgs_scripts/models.jl")
catch
    include("models.jl")
end


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
RH_int = Parameter(0.2, :RH)
E = Parameter(38.3, :E)
C_Ch_B = RandomVariable(Uniform(0, 5), :C_Ch_B1)
D_Ch0 = Parameter(0.7, :D_Ch0_int)
ke = Parameter(2.13, :ke_int)
kt = Parameter(0.832, :kt)
kc = Parameter(0.5, :kc_int)
inputs1 = [R, t₀, RH_ref, T_ref, t, T, RH_int, E, C_Ch_B, D_Ch0, ke, kt, kc]

df = sample(inputs1, 2000)
UncertaintyQuantification.evaluate!(models_corrosion, df)
x_vals = df.C_Ch_B1
y_vals = df.corrosion_depth

plt = @pgf Axis(
    {
        xlabel = L"[Ch] \ [kg/$m^3$]",
        ylabel = L"chloride \ penetration \ depth \ [m]",
        title = L"[Ch] \ vs \ chloride \ penetration \ depth",
        width = "10cm",
        height = "8cm",
        grid = "major",
        xmin = 0,
        ymin = 0,
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
PGFPlotsX.save("imgs/pdfs/11_Chloride_corr.pdf", plt)
