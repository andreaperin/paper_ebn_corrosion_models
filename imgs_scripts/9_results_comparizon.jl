using EnhancedBayesianNetworks
using JLD2
using PGFPlotsX
using LaTeXStrings

@load "/Users/andreaperin_macos/Documents/Code/Ali_ebn/final_version/ebns/5_unrolled_ebn/evaluated/ebn_mc_10000.jld2" ebn
precise_ebn = ebn
@load "/Users/andreaperin_macos/Documents/Code/Ali_ebn/final_version/ebns/6_imprecise/evaluated/ebn_RS_1000_2025-04-30_150503.jld2" ebn
imprecise_ebn = ebn

df_imprecise = imprecise_ebn.nodes[end].cpt.data
df_precise = precise_ebn.nodes[end].cpt.data

df_row_ssp1 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp1, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp2 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp2, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp5 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp5, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp1_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp1, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp2_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp2, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp5_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp5, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))

# Extract x values and min/max for each interval
x_vals = parse.(Int64, string.(df_row_ssp1.t))
y_min_ssp1 = first.(df_row_ssp1.Π)
y_max_ssp1 = last.(df_row_ssp1.Π)
y_min_ssp2 = first.(df_row_ssp2.Π)
y_max_ssp2 = last.(df_row_ssp2.Π)
y_min_ssp5 = first.(df_row_ssp5.Π)
y_max_ssp5 = last.(df_row_ssp5.Π)
p_ssp1 = first.(df_row_ssp1_p.Π)
p_ssp2 = first.(df_row_ssp2_p.Π)
p_ssp5 = first.(df_row_ssp5_p.Π)
offset = 1.5
lines = []
dots = []
for i in range(1, length(x_vals))
    opts_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_dot_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "x", "mark size" => "4pt")
    push!(lines, Plot(opts_ssp1, Coordinates([(x_vals[i] - offset, y_min_ssp1[i]), (x_vals[i] - offset, y_max_ssp1[i])])))
    push!(lines, Plot(opts_ssp2, Coordinates([(x_vals[i], y_min_ssp2[i]), (x_vals[i], y_max_ssp2[i])])))
    push!(lines, Plot(opts_ssp5, Coordinates([(x_vals[i] + offset, y_min_ssp5[i]), (x_vals[i] + offset, y_max_ssp5[i])])))
    push!(dots, Plot(opts_dot_ssp1, Coordinates([(x_vals[i] - offset, p_ssp1[i])])))
    push!(dots, Plot(opts_dot_ssp2, Coordinates([(x_vals[i], p_ssp2[i])])))
    push!(dots, Plot(opts_dot_ssp5, Coordinates([(x_vals[i] + offset, p_ssp5[i])])))
end

# Build the plot
plt = @pgf Axis(
    {
        xmin = 2015,
        xmax = 2105,
        # xlabel = L"Year",
        ylabel = L"P_f",
        title = L"chloride-induced \ corrosion \ P_f \  @ \ DeH \ \& \ DeCh\ - \ failed",
        width = "12cm",
        height = "8cm",
        grid = "major",
        ymin = -0.02,
        ymax = 0.6,
        xtick = 2020:10:2100,
        xticklabels = [L"2020", L"2030", L"2040", L"2050", L"2060", L"2070", L"2080", L"2090", L"2100"],
        xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
        legend_pos = "south east"
    },
    lines...,
    dots...,
    Legend([L"ssp1", L"ssp2", L"ssp5"])
)

PGFPlotsX.save("imgs/pdfs/20_Chloride_comparizon_brokenbroken.pdf", plt)


#! todo add deh working and evaluate the P_f in the same previous way
#! todo add carbonation pf analysis comparison

df_row_ssp1 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp1, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp2 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp2, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp5 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp5, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp1_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp1, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp2_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp2, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))
df_row_ssp5_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_working"), :deCh => dch -> dch .== Symbol("deCh_broken"), :proj => p -> p .== :ssp5, :ch_corr_depth => c -> c .== Symbol("ch_corr_depth_fail"))

# Extract x values and min/max for each interval
x_vals = parse.(Int64, string.(df_row_ssp1.t))
y_min_ssp1 = first.(df_row_ssp1.Π)
y_max_ssp1 = last.(df_row_ssp1.Π)
y_min_ssp2 = first.(df_row_ssp2.Π)
y_max_ssp2 = last.(df_row_ssp2.Π)
y_min_ssp5 = first.(df_row_ssp5.Π)
y_max_ssp5 = last.(df_row_ssp5.Π)
p_ssp1 = first.(df_row_ssp1_p.Π)
p_ssp2 = first.(df_row_ssp2_p.Π)
p_ssp5 = first.(df_row_ssp5_p.Π)
offset = 1.5
lines = []
dots = []
for i in range(1, length(x_vals))
    opts_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_dot_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "x", "mark size" => "4pt")
    push!(lines, Plot(opts_ssp1, Coordinates([(x_vals[i] - offset, y_min_ssp1[i]), (x_vals[i] - offset, y_max_ssp1[i])])))
    push!(lines, Plot(opts_ssp2, Coordinates([(x_vals[i], y_min_ssp2[i]), (x_vals[i], y_max_ssp2[i])])))
    push!(lines, Plot(opts_ssp5, Coordinates([(x_vals[i] + offset, y_min_ssp5[i]), (x_vals[i] + offset, y_max_ssp5[i])])))
    push!(dots, Plot(opts_dot_ssp1, Coordinates([(x_vals[i] - offset, p_ssp1[i])])))
    push!(dots, Plot(opts_dot_ssp2, Coordinates([(x_vals[i], p_ssp2[i])])))
    push!(dots, Plot(opts_dot_ssp5, Coordinates([(x_vals[i] + offset, p_ssp5[i])])))
end

# Build the plot
plt = @pgf Axis(
    {
        xmin = 2015,
        xmax = 2105,
        # xlabel = L"Year",
        ylabel = L"P_f",
        title = L"chloride-induced \ corrosion \ P_f \  @ \ DeH  - \ working \ ; \ DeCh \ - \ failed",
        width = "12cm",
        height = "8cm",
        grid = "major",
        ymin = -0.02,
        ymax = 0.6,
        xtick = 2020:10:2100,
        xticklabels = [L"2020", L"2030", L"2040", L"2050", L"2060", L"2070", L"2080", L"2090", L"2100"],
        xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
        legend_pos = "south east"
    },
    lines...,
    dots...,
    Legend([L"ssp1", L"ssp2", L"ssp5"])
)

PGFPlotsX.save("imgs/pdfs/21_Chloride_comparizon_workingbroken.pdf", plt)


## carbonation
df_imprecise = imprecise_ebn.nodes[end-1].cpt.data
df_precise = precise_ebn.nodes[end-1].cpt.data

df_row_ssp1 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :proj => p -> p .== :ssp1, :carb_depth => c -> c .== Symbol("carb_depth_fail"))
df_row_ssp2 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :proj => p -> p .== :ssp2, :carb_depth => c -> c .== Symbol("carb_depth_fail"))
df_row_ssp5 = subset(df_imprecise, :deH => dh -> dh .== Symbol("deh_broken"), :proj => p -> p .== :ssp5, :carb_depth => c -> c .== Symbol("carb_depth_fail"))
df_row_ssp1_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :proj => p -> p .== :ssp1, :carb_depth => c -> c .== Symbol("carb_depth_fail"))
df_row_ssp2_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :proj => p -> p .== :ssp2, :carb_depth => c -> c .== Symbol("carb_depth_fail"))
df_row_ssp5_p = subset(df_precise, :deH => dh -> dh .== Symbol("deH_broken"), :proj => p -> p .== :ssp5, :carb_depth => c -> c .== Symbol("carb_depth_fail"))

# Extract x values and min/max for each interval
x_vals = parse.(Int64, string.(df_row_ssp1.t))
y_min_ssp1 = first.(df_row_ssp1.Π)
y_max_ssp1 = last.(df_row_ssp1.Π)
y_min_ssp2 = first.(df_row_ssp2.Π)
y_max_ssp2 = last.(df_row_ssp2.Π)
y_min_ssp5 = first.(df_row_ssp5.Π)
y_max_ssp5 = last.(df_row_ssp5.Π)
p_ssp1 = first.(df_row_ssp1_p.Π)
p_ssp2 = first.(df_row_ssp2_p.Π)
p_ssp5 = first.(df_row_ssp5_p.Π)
offset = 1.5
lines = []
dots = []
for i in range(1, length(x_vals))
    opts_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "-", "mark size" => "1pt", "line width" => "0.6pt")
    opts_dot_ssp1 = PGFPlotsX.Options("color" => "blue", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp2 = PGFPlotsX.Options("color" => "orange", "mark" => "x", "mark size" => "4pt")
    opts_dot_ssp5 = PGFPlotsX.Options("color" => "red", "mark" => "x", "mark size" => "4pt")
    push!(lines, Plot(opts_ssp1, Coordinates([(x_vals[i] - offset, y_min_ssp1[i]), (x_vals[i] - offset, y_max_ssp1[i])])))
    push!(lines, Plot(opts_ssp2, Coordinates([(x_vals[i], y_min_ssp2[i]), (x_vals[i], y_max_ssp2[i])])))
    push!(lines, Plot(opts_ssp5, Coordinates([(x_vals[i] + offset, y_min_ssp5[i]), (x_vals[i] + offset, y_max_ssp5[i])])))
    push!(dots, Plot(opts_dot_ssp1, Coordinates([(x_vals[i] - offset, p_ssp1[i])])))
    push!(dots, Plot(opts_dot_ssp2, Coordinates([(x_vals[i], p_ssp2[i])])))
    push!(dots, Plot(opts_dot_ssp5, Coordinates([(x_vals[i] + offset, p_ssp5[i])])))
end

# Build the plot
plt = @pgf Axis(
    {
        xmin = 2015,
        xmax = 2105,
        # xlabel = L"Year",
        ylabel = L"P_f",
        title = L"carbonation-induced \ corrosion \ P_f \  @ \ DeH \ - \ failed",
        width = "12cm",
        height = "8cm",
        grid = "major",
        ymin = -0.02,
        ymax = 0.8,
        xtick = 2020:10:2100,
        xticklabels = [L"2020", L"2030", L"2040", L"2050", L"2060", L"2070", L"2080", L"2090", L"2100"],
        xticklabel_style = "{rotate=45, anchor=east}",  # Better for long labels
        legend_pos = "north west"
    },
    lines...,
    dots...,
    Legend([L"ssp1", L"ssp2", L"ssp5"])
)

PGFPlotsX.save("imgs/pdfs/22_carbonation_comparizon_broken.pdf", plt)
