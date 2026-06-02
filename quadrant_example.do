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

display as result "quadrant tutorial finished — see help quadrant."
