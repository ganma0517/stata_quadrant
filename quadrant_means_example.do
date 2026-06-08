*===============================================================*
* quadrant — three "mean" presentations
* Bundled practice data (fictional): satisf (%) vs price (%)
* by region (colour) and product (facet/label). Uses the 2024 wave.
*===============================================================*
clear all
set more off
use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear
keep if year==2024

* 1) OVERALL MEANS — one averaged point per product
*    (pool across regions first, then plot ungrouped)
preserve
    collapse (mean) satisf price, by(product)
    quadrant satisf price, mlabel(product) hollow("Delta") focus ///
        title("1. Overall means (by product)")
restore

* 2) GROUP MEANS — one point per region x product, coloured by region
quadrant satisf price, by(region) mlabel(product) hollow("Delta") focus ///
    title("2. Group means (by region)")

* 3) OVERALL + GROUP MEANS — coloured group points plus a black
*    overall-mean point per product (overall does the pooling for you)
quadrant satisf price, by(region) overall mlabel(product) hollow("Delta") focus ///
    title("3. Overall + group means")

display as result "quadrant means examples finished."
