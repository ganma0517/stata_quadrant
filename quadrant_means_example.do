*===============================================================*
* quadrant — three "mean" presentations
* Using the bundled practice data (support % vs NIMBY % by energy & party).
*===============================================================*
clear all
set more off
use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear

* 1) OVERALL MEANS — one averaged point per energy type
*    (pool across parties first, then plot ungrouped)
preserve
    collapse (mean) support nimby, by(energy)
    quadrant support nimby, mlabel(energy) hollow("Nuclear") focus ///
        title("1. Overall means (by energy)")
restore

* 2) GROUP MEANS — one point per party x energy, coloured by party
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear") focus ///
    title("2. Group means (by party)")

* 3) OVERALL + GROUP MEANS — coloured group points plus a black
*    overall-mean point per energy (overall does the pooling for you)
quadrant support nimby, by(pid) overall mlabel(energy) hollow("Nuclear") focus ///
    title("3. Overall + group means")

display as result "quadrant means examples finished."
