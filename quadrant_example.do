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

display as result "quadrant tutorial finished — see help quadrant."
