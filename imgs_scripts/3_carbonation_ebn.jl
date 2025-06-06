using EnhancedBayesianNetworks
using Cairo

try
    include("imgs_scripts/nodes.jl")
catch e
    include("nodes.jl")
end

n = 2
sim_carbonation = MonteCarlo(n)
sim_corrosion = MonteCarlo(n)

model_aux_rh_2020 = Model(df -> model_RH.(df.RH_int_2020, RH_ref.value), :RH1_2020)
model_aux_rh_2030 = Model(df -> model_RH.(df.RH_int_2030, RH_ref.value), :RH1_2030)
model_aux_rh_2040 = Model(df -> model_RH.(df.RH_int_2040, RH_ref.value), :RH1_2040)
model_aux_rh_2050 = Model(df -> model_RH.(df.RH_int_2050, RH_ref.value), :RH1_2050)
model_aux_rh_2060 = Model(df -> model_RH.(df.RH_int_2060, RH_ref.value), :RH1_2060)
model_aux_rh_2070 = Model(df -> model_RH.(df.RH_int_2070, RH_ref.value), :RH1_2070)
model_aux_rh_2080 = Model(df -> model_RH.(df.RH_int_2080, RH_ref.value), :RH1_2080)
model_aux_rh_2090 = Model(df -> model_RH.(df.RH_int_2090, RH_ref.value), :RH1_2090)
model_aux_rh_2100 = Model(df -> model_RH.(df.RH_int_2100, RH_ref.value), :RH1_2100)

model_aux_ppm_2020 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2020), :Conc_CO₂_2020)
model_aux_ppm_2030 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2030), :Conc_CO₂_2030)
model_aux_ppm_2040 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2040), :Conc_CO₂_2040)
model_aux_ppm_2050 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2050), :Conc_CO₂_2050)
model_aux_ppm_2060 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2060), :Conc_CO₂_2060)
model_aux_ppm_2070 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2070), :Conc_CO₂_2070)
model_aux_ppm_2080 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2080), :Conc_CO₂_2080)
model_aux_ppm_2090 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2090), :Conc_CO₂_2090)
model_aux_ppm_2100 = Model(df -> model_ppm2kg.(df.ppm_CO₂_2100), :Conc_CO₂_2100)

model_deh_2020 = Model(df -> model_dehumidifier.(df.RH1_2020, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2020)
model_deh_2030 = Model(df -> model_dehumidifier.(df.RH1_2030, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2030)
model_deh_2040 = Model(df -> model_dehumidifier.(df.RH1_2040, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2040)
model_deh_2050 = Model(df -> model_dehumidifier.(df.RH1_2050, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2050)
model_deh_2060 = Model(df -> model_dehumidifier.(df.RH1_2060, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2060)
model_deh_2070 = Model(df -> model_dehumidifier.(df.RH1_2070, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2070)
model_deh_2080 = Model(df -> model_dehumidifier.(df.RH1_2080, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2080)
model_deh_2090 = Model(df -> model_dehumidifier.(df.RH1_2090, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2090)
model_deh_2100 = Model(df -> model_dehumidifier.(df.RH1_2100, df.deH, dehumidifier_threshold.value, dehumidifier_target.value), :RH_2100)

model_alpha_h = Model(df -> model_αₕ.(df.ratio_wc), :αₕ)
model_a_ = Model(df -> model_a.(df.Cₑ, df.CₐO, df.αₕ, M_CO₂.value, M_CₐO.value), :a)

model_ft_2020 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2020), :fₜ_2020)
model_ft_2030 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2030), :fₜ_2030)
model_ft_2040 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2040), :fₜ_2040)
model_ft_2050 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2050), :fₜ_2050)
model_ft_2060 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2060), :fₜ_2060)
model_ft_2070 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2070), :fₜ_2070)
model_ft_2080 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2080), :fₜ_2080)
model_ft_2090 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2090), :fₜ_2090)
model_ft_2100 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2100), :fₜ_2100)

model_f_rh_carb_2020 = Model(df -> model_f_rh_carb.(df.RH_2020, RH_ref.value), :f_rh_carb_2020)
model_f_rh_carb_2030 = Model(df -> model_f_rh_carb.(df.RH_2030, RH_ref.value), :f_rh_carb_2030)
model_f_rh_carb_2040 = Model(df -> model_f_rh_carb.(df.RH_2040, RH_ref.value), :f_rh_carb_2040)
model_f_rh_carb_2050 = Model(df -> model_f_rh_carb.(df.RH_2050, RH_ref.value), :f_rh_carb_2050)
model_f_rh_carb_2060 = Model(df -> model_f_rh_carb.(df.RH_2060, RH_ref.value), :f_rh_carb_2060)
model_f_rh_carb_2070 = Model(df -> model_f_rh_carb.(df.RH_2070, RH_ref.value), :f_rh_carb_2070)
model_f_rh_carb_2080 = Model(df -> model_f_rh_carb.(df.RH_2080, RH_ref.value), :f_rh_carb_2080)
model_f_rh_carb_2090 = Model(df -> model_f_rh_carb.(df.RH_2090, RH_ref.value), :f_rh_carb_2090)
model_f_rh_carb_2100 = Model(df -> model_f_rh_carb.(df.RH_2100, RH_ref.value), :f_rh_carb_2100)

model_Δ_carb_2020 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2020, df.f_rh_carb_2020, df.D_i, df.a, df.n_d, df.Conc_CO₂_2020, df.n_m), :Δcarb_2020)
model_Δ_carb_2030 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2030, df.f_rh_carb_2030, df.D_i, df.a, df.n_d, df.Conc_CO₂_2030, df.n_m), :Δcarb_2030)
model_Δ_carb_2040 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2040, df.f_rh_carb_2040, df.D_i, df.a, df.n_d, df.Conc_CO₂_2040, df.n_m), :Δcarb_2040)
model_Δ_carb_2050 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2050, df.f_rh_carb_2050, df.D_i, df.a, df.n_d, df.Conc_CO₂_2050, df.n_m), :Δcarb_2050)
model_Δ_carb_2060 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2060, df.f_rh_carb_2060, df.D_i, df.a, df.n_d, df.Conc_CO₂_2060, df.n_m), :Δcarb_2060)
model_Δ_carb_2070 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2070, df.f_rh_carb_2070, df.D_i, df.a, df.n_d, df.Conc_CO₂_2070, df.n_m), :Δcarb_2070)
model_Δ_carb_2080 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2080, df.f_rh_carb_2080, df.D_i, df.a, df.n_d, df.Conc_CO₂_2080, df.n_m), :Δcarb_2080)
model_Δ_carb_2090 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2090, df.f_rh_carb_2090, df.D_i, df.a, df.n_d, df.Conc_CO₂_2090, df.n_m), :Δcarb_2090)
model_Δ_carb_2100 = Model(df -> Δ_carbonation.(df.K_site, df.t, df.fₜ_2100, df.f_rh_carb_2100, df.D_i, df.a, df.n_d, df.Conc_CO₂_2100, df.n_m), :Δcarb_2100)

model_total_corrosion = Model(df -> model_total_corrosion_depth.(df.t, df.Δcarb_2020, df.Δcarb_2030, df.Δcarb_2040, df.Δcarb_2050, df.Δcarb_2060, df.Δcarb_2070, df.Δcarb_2080, df.Δcarb_2090, df.Δcarb_2100), :x_c_tot)

models_carbonation = [
    model_aux_rh_2020,
    model_aux_rh_2030,
    model_aux_rh_2040,
    model_aux_rh_2050,
    model_aux_rh_2060,
    model_aux_rh_2070,
    model_aux_rh_2080,
    model_aux_rh_2090,
    model_aux_rh_2100,
    model_aux_ppm_2020,
    model_aux_ppm_2030,
    model_aux_ppm_2040,
    model_aux_ppm_2050,
    model_aux_ppm_2060,
    model_aux_ppm_2070,
    model_aux_ppm_2080,
    model_aux_ppm_2090,
    model_aux_ppm_2100,
    model_deh_2020,
    model_deh_2030,
    model_deh_2040,
    model_deh_2050,
    model_deh_2060,
    model_deh_2070,
    model_deh_2080,
    model_deh_2090,
    model_deh_2100,
    model_alpha_h,
    model_a_,
    model_ft_2020,
    model_ft_2030,
    model_ft_2040,
    model_ft_2050,
    model_ft_2060,
    model_ft_2070,
    model_ft_2080,
    model_ft_2090,
    model_ft_2100,
    model_f_rh_carb_2020,
    model_f_rh_carb_2030,
    model_f_rh_carb_2040,
    model_f_rh_carb_2050,
    model_f_rh_carb_2060,
    model_f_rh_carb_2070,
    model_f_rh_carb_2080,
    model_f_rh_carb_2090,
    model_f_rh_carb_2100,
    model_Δ_carb_2020,
    model_Δ_carb_2030,
    model_Δ_carb_2040,
    model_Δ_carb_2050,
    model_Δ_carb_2060,
    model_Δ_carb_2070,
    model_Δ_carb_2080,
    model_Δ_carb_2090,
    model_Δ_carb_2100,
    model_total_corrosion]

carbonation_node = DiscreteFunctionalNode(:carb_depth, models_carbonation, df -> threshold_carbonation.value .- df.x_c_tot, sim_carbonation)

carbonation_nodes = [
    time_slice,
    projections_node,
    deH_node,
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
    carbonation_node,
]

carbonation_ebn = EnhancedBayesianNetwork(carbonation_nodes)

add_child!(carbonation_ebn, projections_node, temperature_2020_node)
add_child!(carbonation_ebn, projections_node, temperature_2030_node)
add_child!(carbonation_ebn, projections_node, temperature_2040_node)
add_child!(carbonation_ebn, projections_node, temperature_2050_node)
add_child!(carbonation_ebn, projections_node, temperature_2060_node)
add_child!(carbonation_ebn, projections_node, temperature_2070_node)
add_child!(carbonation_ebn, projections_node, temperature_2080_node)
add_child!(carbonation_ebn, projections_node, temperature_2090_node)
add_child!(carbonation_ebn, projections_node, temperature_2100_node)

add_child!(carbonation_ebn, projections_node, H_2020_node)
add_child!(carbonation_ebn, projections_node, H_2030_node)
add_child!(carbonation_ebn, projections_node, H_2040_node)
add_child!(carbonation_ebn, projections_node, H_2050_node)
add_child!(carbonation_ebn, projections_node, H_2060_node)
add_child!(carbonation_ebn, projections_node, H_2070_node)
add_child!(carbonation_ebn, projections_node, H_2080_node)
add_child!(carbonation_ebn, projections_node, H_2090_node)
add_child!(carbonation_ebn, projections_node, H_2100_node)

add_child!(carbonation_ebn, projections_node, CO₂_2020_node)
add_child!(carbonation_ebn, projections_node, CO₂_2030_node)
add_child!(carbonation_ebn, projections_node, CO₂_2040_node)
add_child!(carbonation_ebn, projections_node, CO₂_2050_node)
add_child!(carbonation_ebn, projections_node, CO₂_2060_node)
add_child!(carbonation_ebn, projections_node, CO₂_2070_node)
add_child!(carbonation_ebn, projections_node, CO₂_2080_node)
add_child!(carbonation_ebn, projections_node, CO₂_2090_node)
add_child!(carbonation_ebn, projections_node, CO₂_2100_node)

add_child!(carbonation_ebn, temperature_2020_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2030_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2040_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2050_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2060_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2070_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2080_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2090_node, carbonation_node)
add_child!(carbonation_ebn, temperature_2100_node, carbonation_node)
add_child!(carbonation_ebn, H_2020_node, carbonation_node)
add_child!(carbonation_ebn, H_2030_node, carbonation_node)
add_child!(carbonation_ebn, H_2040_node, carbonation_node)
add_child!(carbonation_ebn, H_2050_node, carbonation_node)
add_child!(carbonation_ebn, H_2060_node, carbonation_node)
add_child!(carbonation_ebn, H_2070_node, carbonation_node)
add_child!(carbonation_ebn, H_2080_node, carbonation_node)
add_child!(carbonation_ebn, H_2090_node, carbonation_node)
add_child!(carbonation_ebn, H_2100_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2020_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2030_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2040_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2050_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2060_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2070_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2080_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2090_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_2100_node, carbonation_node)

add_child!(carbonation_ebn, E_node, carbonation_node)
add_child!(carbonation_ebn, CO₂_diff_node, carbonation_node)
add_child!(carbonation_ebn, n_d_node, carbonation_node)
add_child!(carbonation_ebn, n_m_node, carbonation_node)
add_child!(carbonation_ebn, C_e_node, carbonation_node)
add_child!(carbonation_ebn, CₐO_node, carbonation_node)
add_child!(carbonation_ebn, K_site_node, carbonation_node)
add_child!(carbonation_ebn, ratio_wc_node, carbonation_node)
add_child!(carbonation_ebn, time_slice, carbonation_node)
add_child!(carbonation_ebn, deH_node, carbonation_node)

order!(carbonation_ebn)

plt = gplot(carbonation_ebn, NODESIZEFACTOR=0.1, NODELABELSIZE=1.6, ARROWLENGTH=0.05)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/8_carb_ebn.pdf", 16cm, 16cm), plt)
