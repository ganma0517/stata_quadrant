*===============================================================*
* quadrant — example / tutorial do-file
* Uses the bundled practice data (fictional; no real-world source):
* support (%) vs NIMBY (%) for 4 energy types, by 4 party blocs.
*===============================================================*
clear all
set more off

* load practice data from the repo (no install needed)
use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear

* 1) Grouped by party, labelled, nuclear hollow
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear") ///
    xtitle("NIMBY (%)") ytitle("Support (%)")

* 2) Ungrouped (single colour)
quadrant support nimby, mlabel(energy) hollow("Nuclear")

* 3) Grouped plus the pooled overall mean point set (black)
quadrant support nimby, by(pid) overall mlabel(energy) hollow("Nuclear")

* 4) Reference cross at the data means instead of 50/50
quadrant support nimby, by(pid) meanlines

* 5) Custom cross position + export
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear") ///
    xline(40) yline(60) saving("quadrant_demo.png")

* 6) Faceting: one quadrant per party, labelled by energy source
*    focus zooms each panel to its own data so the points are easy to read
quadrant support nimby, panel(party) mlabel(energy) meanlines focus

* 7) Faceting + grouping: one quadrant per energy source, coloured by party.
*    Grouped panels get a single shared legend at the bottom (6 o'clock).
quadrant support nimby, panel(energy) by(party) range(30 90)

* 8) Marker style & size: large diamonds (the hollow category becomes a
*    hollow diamond automatically). Try also msymbol(S) or msymbol(T).
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear") focus ///
    msymbol(D) msize(large)

* 9) Bigger title and axis-title fonts via inline size() sub-options
*    (no separate *size options needed); no side gap because aspect is off.
quadrant support nimby, by(pid) mlabel(energy) focus ///
    title("Energy positioning", size(large)) ///
    xtitle("NIMBY (%)", size(large)) ytitle("Support (%)", size(large))

* 10) Want a perfectly square quadrant? Add aspect(1).
quadrant support nimby, by(pid) mlabel(energy) aspect(1)

* 11) Assign an explicit colour to each group with value=colour pairs.
*     Keys match the value label (or the raw level). Here pid is labelled
*     Blue/Green/Other/White in the demo; map them to chosen colours.
quadrant support nimby, by(pid) mlabel(energy) focus ///
    bycolors(Blue=navy Green=forest_green Other=orange White=gs8)

* 12) Legend behaves like twoway's legend(): move it, set columns, resize, off.
quadrant support nimby, by(pid) mlabel(energy) focus ///
    legend(position(3) cols(1) size(small))

* 13) Assign a marker SHAPE to each group with value=symbol pairs, and pair it
*     with colors() for a legend coded by both colour and shape.
*     (D=large diamond, d=small diamond, O=large circle, o=small circle)
quadrant support nimby, by(pid) mlabel(energy) focus ///
    symbols(Blue=D Green=d Other=O White=o) ///
    bycolors(Blue=navy Green=forest_green Other=orange White=gs8)

* 14) symbolby(): a SECOND grouping coded by marker SHAPE while colour still
*     follows by(). Classic use: compare two survey waves — 2024 hollow circle,
*     2026 solid circle. Build a 2-wave demo on the fly:
preserve
    expand 2
    bysort pid energy: gen wave = cond(_n==1, 2024, 2026)
    set seed 1
    replace support = support + runiformint(-9, 9) if wave==2026
    replace nimby   = nimby   + runiformint(-9, 9) if wave==2026
    label define wavelbl 2024 "2024" 2026 "2026"
    label values wave wavelbl
    gen wlab = cond(wave==2024, "24", "26")     // short point labels

    * single plot: colour = party, shape = wave (2024 hollow, 2026 solid)
    quadrant support nimby, by(pid) symbolby(wave) mlabel(wlab) focus

    * panel + grouping + symbolby (the full combination)
    quadrant support nimby, panel(energy) by(pid) symbolby(wave) ///
        mlabel(wlab) range(10 95) ///
        bycolors(Blue=blue Green=dkgreen Other=orange White=black)

    * customise the wave symbols if you prefer triangles, etc.
    quadrant support nimby, by(pid) symbolby(wave) sbsymbols(Th T) focus
restore

display as result "quadrant tutorial finished — see help quadrant."
