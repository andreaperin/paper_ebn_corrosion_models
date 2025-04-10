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

model_ft_2020 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2020), :fₜ_2020)
model_ft_2030 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2030), :fₜ_2030)
model_ft_2040 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2040), :fₜ_2040)
model_ft_2050 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2050), :fₜ_2050)
model_ft_2060 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2060), :fₜ_2060)
model_ft_2070 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2070), :fₜ_2070)
model_ft_2080 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2080), :fₜ_2080)
model_ft_2090 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2090), :fₜ_2090)
model_ft_2100 = Model(df -> model_fₜ.(df.E, R.value, T_ref.value, df.T_2100), :fₜ_2100)

model_dech = Model(df -> model_dechlorifier.(df.C_Ch_B1, df.deCh, dechlorifier_threshold.value, dechlorifier_target.value), :C_Ch_B)
model_aux_ke = Model(df -> model_ke.(df.ke_int), :ke)
model_aux_kc = Model(df -> model_kc.(df.kc_int), :kc)
model_aux_D_Ch0 = Model(df -> model_D_Ch0.(df.D_Ch0_int), :D_Ch0)

model_f_rh_ch_2020 = Model(df -> model_f_rh_ch.(df.RH_2020, RH_ref.value), :f_rh_ch_2020)
model_f_rh_ch_2030 = Model(df -> model_f_rh_ch.(df.RH_2030, RH_ref.value), :f_rh_ch_2030)
model_f_rh_ch_2040 = Model(df -> model_f_rh_ch.(df.RH_2040, RH_ref.value), :f_rh_ch_2040)
model_f_rh_ch_2050 = Model(df -> model_f_rh_ch.(df.RH_2050, RH_ref.value), :f_rh_ch_2050)
model_f_rh_ch_2060 = Model(df -> model_f_rh_ch.(df.RH_2060, RH_ref.value), :f_rh_ch_2060)
model_f_rh_ch_2070 = Model(df -> model_f_rh_ch.(df.RH_2070, RH_ref.value), :f_rh_ch_2070)
model_f_rh_ch_2080 = Model(df -> model_f_rh_ch.(df.RH_2080, RH_ref.value), :f_rh_ch_2080)
model_f_rh_ch_2090 = Model(df -> model_f_rh_ch.(df.RH_2090, RH_ref.value), :f_rh_ch_2090)
model_f_rh_ch_2100 = Model(df -> model_f_rh_ch.(df.RH_2100, RH_ref.value), :f_rh_ch_2100)

model_ch_corrosion_fe_2020 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2020, df.f_rh_ch_2020, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2020)
model_ch_corrosion_fe_2030 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2030, df.f_rh_ch_2030, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2030)
model_ch_corrosion_fe_2040 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2040, df.f_rh_ch_2040, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2040)
model_ch_corrosion_fe_2050 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2050, df.f_rh_ch_2050, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2050)
model_ch_corrosion_fe_2060 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2060, df.f_rh_ch_2060, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2060)
model_ch_corrosion_fe_2070 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2070, df.f_rh_ch_2070, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2070)
model_ch_corrosion_fe_2080 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2080, df.f_rh_ch_2080, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2080)
model_ch_corrosion_fe_2090 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2090, df.f_rh_ch_2090, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2090)
model_ch_corrosion_fe_2100 = Model(df -> model_ch_corrosion_FE.(df.D_Ch0, df.fₜ_2100, df.f_rh_ch_2100, df.ke, df.kt, df.kc, df.C_Ch_B, df.t, thickness.value), :fe_result_2100)

model_corrosion_ch_penetration_2020 = Model(df -> model_corrosion_penetration.(df.fe_result_2020, C_Ch_threshold.value), :ch_corrosion_depth_2020)
model_corrosion_ch_penetration_2030 = Model(df -> model_corrosion_penetration.(df.fe_result_2030, C_Ch_threshold.value), :ch_corrosion_depth_2030)
model_corrosion_ch_penetration_2040 = Model(df -> model_corrosion_penetration.(df.fe_result_2040, C_Ch_threshold.value), :ch_corrosion_depth_2040)
model_corrosion_ch_penetration_2050 = Model(df -> model_corrosion_penetration.(df.fe_result_2050, C_Ch_threshold.value), :ch_corrosion_depth_2050)
model_corrosion_ch_penetration_2060 = Model(df -> model_corrosion_penetration.(df.fe_result_2060, C_Ch_threshold.value), :ch_corrosion_depth_2060)
model_corrosion_ch_penetration_2070 = Model(df -> model_corrosion_penetration.(df.fe_result_2070, C_Ch_threshold.value), :ch_corrosion_depth_2070)
model_corrosion_ch_penetration_2080 = Model(df -> model_corrosion_penetration.(df.fe_result_2080, C_Ch_threshold.value), :ch_corrosion_depth_2080)
model_corrosion_ch_penetration_2090 = Model(df -> model_corrosion_penetration.(df.fe_result_2090, C_Ch_threshold.value), :ch_corrosion_depth_2090)
model_corrosion_ch_penetration_2100 = Model(df -> model_corrosion_penetration.(df.fe_result_2100, C_Ch_threshold.value), :ch_corrosion_depth_2100)

model_ch_corrosion = Model(df -> model_ch_corrosion_depth.(df.t, df.ch_corrosion_depth_2020, df.ch_corrosion_depth_2030, df.ch_corrosion_depth_2040, df.ch_corrosion_depth_2050, df.ch_corrosion_depth_2060, df.ch_corrosion_depth_2070, df.ch_corrosion_depth_2080, df.ch_corrosion_depth_2090, df.ch_corrosion_depth_2100), :x_ch_tot)

models_chloride = [
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
    model_dech,
    model_aux_kc,
    model_aux_ke,
    model_aux_D_Ch0,
    model_ft_2020,
    model_ft_2030,
    model_ft_2040,
    model_ft_2050,
    model_ft_2060,
    model_ft_2070,
    model_ft_2080,
    model_ft_2090,
    model_ft_2100,
    model_f_rh_ch_2020,
    model_f_rh_ch_2030,
    model_f_rh_ch_2040,
    model_f_rh_ch_2050,
    model_f_rh_ch_2060,
    model_f_rh_ch_2070,
    model_f_rh_ch_2080,
    model_f_rh_ch_2090,
    model_f_rh_ch_2100,
    model_ch_corrosion_fe_2020,
    model_ch_corrosion_fe_2030,
    model_ch_corrosion_fe_2040,
    model_ch_corrosion_fe_2050,
    model_ch_corrosion_fe_2060,
    model_ch_corrosion_fe_2070,
    model_ch_corrosion_fe_2080,
    model_ch_corrosion_fe_2090,
    model_ch_corrosion_fe_2100, model_corrosion_ch_penetration_2020,
    model_corrosion_ch_penetration_2030,
    model_corrosion_ch_penetration_2040,
    model_corrosion_ch_penetration_2050,
    model_corrosion_ch_penetration_2060,
    model_corrosion_ch_penetration_2070,
    model_corrosion_ch_penetration_2080,
    model_corrosion_ch_penetration_2090,
    model_corrosion_ch_penetration_2100,
    model_ch_corrosion
]

chloride_node = DiscreteFunctionalNode(:ch_corr_depth, models_chloride, df -> threshold_corrosion.value .- df.x_ch_tot, sim_corrosion)

ch_nodes = [
    time_slice,
    projections_node,
    deH_node,
    deCh_node,
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
    E_node,
    C_Ch_B_node,
    D_Ch0_node,
    kc_node,
    ke_node,
    kt_node,
    chloride_node
]

ch_ebn = EnhancedBayesianNetwork(ch_nodes)

add_child!(ch_ebn, projections_node, temperature_2020_node)
add_child!(ch_ebn, projections_node, temperature_2030_node)
add_child!(ch_ebn, projections_node, temperature_2040_node)
add_child!(ch_ebn, projections_node, temperature_2050_node)
add_child!(ch_ebn, projections_node, temperature_2060_node)
add_child!(ch_ebn, projections_node, temperature_2070_node)
add_child!(ch_ebn, projections_node, temperature_2080_node)
add_child!(ch_ebn, projections_node, temperature_2090_node)
add_child!(ch_ebn, projections_node, temperature_2100_node)

add_child!(ch_ebn, projections_node, H_2020_node)
add_child!(ch_ebn, projections_node, H_2030_node)
add_child!(ch_ebn, projections_node, H_2040_node)
add_child!(ch_ebn, projections_node, H_2050_node)
add_child!(ch_ebn, projections_node, H_2060_node)
add_child!(ch_ebn, projections_node, H_2070_node)
add_child!(ch_ebn, projections_node, H_2080_node)
add_child!(ch_ebn, projections_node, H_2090_node)
add_child!(ch_ebn, projections_node, H_2100_node)

add_child!(ch_ebn, projections_node, CO₂_2020_node)
add_child!(ch_ebn, projections_node, CO₂_2030_node)
add_child!(ch_ebn, projections_node, CO₂_2040_node)
add_child!(ch_ebn, projections_node, CO₂_2050_node)
add_child!(ch_ebn, projections_node, CO₂_2060_node)
add_child!(ch_ebn, projections_node, CO₂_2070_node)
add_child!(ch_ebn, projections_node, CO₂_2080_node)
add_child!(ch_ebn, projections_node, CO₂_2090_node)
add_child!(ch_ebn, projections_node, CO₂_2100_node)

add_child!(ch_ebn, temperature_2020_node, chloride_node)
add_child!(ch_ebn, temperature_2030_node, chloride_node)
add_child!(ch_ebn, temperature_2040_node, chloride_node)
add_child!(ch_ebn, temperature_2050_node, chloride_node)
add_child!(ch_ebn, temperature_2060_node, chloride_node)
add_child!(ch_ebn, temperature_2070_node, chloride_node)
add_child!(ch_ebn, temperature_2080_node, chloride_node)
add_child!(ch_ebn, temperature_2090_node, chloride_node)
add_child!(ch_ebn, temperature_2100_node, chloride_node)
add_child!(ch_ebn, H_2020_node, chloride_node)
add_child!(ch_ebn, H_2030_node, chloride_node)
add_child!(ch_ebn, H_2040_node, chloride_node)
add_child!(ch_ebn, H_2050_node, chloride_node)
add_child!(ch_ebn, H_2060_node, chloride_node)
add_child!(ch_ebn, H_2070_node, chloride_node)
add_child!(ch_ebn, H_2080_node, chloride_node)
add_child!(ch_ebn, H_2090_node, chloride_node)
add_child!(ch_ebn, H_2100_node, chloride_node)
add_child!(ch_ebn, CO₂_2020_node, chloride_node)
add_child!(ch_ebn, CO₂_2030_node, chloride_node)
add_child!(ch_ebn, CO₂_2040_node, chloride_node)
add_child!(ch_ebn, CO₂_2050_node, chloride_node)
add_child!(ch_ebn, CO₂_2060_node, chloride_node)
add_child!(ch_ebn, CO₂_2070_node, chloride_node)
add_child!(ch_ebn, CO₂_2080_node, chloride_node)
add_child!(ch_ebn, CO₂_2090_node, chloride_node)
add_child!(ch_ebn, CO₂_2100_node, chloride_node)

add_child!(ch_ebn, E_node, chloride_node)
add_child!(ch_ebn, deH_node, chloride_node)
add_child!(ch_ebn, deCh_node, chloride_node)
add_child!(ch_ebn, ke_node, chloride_node)
add_child!(ch_ebn, kc_node, chloride_node)
add_child!(ch_ebn, kt_node, chloride_node)
add_child!(ch_ebn, D_Ch0_node, chloride_node)
add_child!(ch_ebn, C_Ch_B_node, chloride_node)
add_child!(ch_ebn, time_slice, chloride_node)

order!(ch_ebn)

plt = gplot(ch_ebn, NODESIZEFACTOR=0.1, NODELABELSIZE=1.6, ARROWLENGTH=0.05)
draw(PDF("/Users/andreaperin_macos/Documents/PhD/3_Academic/Papers_Presentations/Papers/2_LASAR/Andrea/imgs/pdfs/9_chloride_ebn.pdf", 16cm, 16cm), plt)
