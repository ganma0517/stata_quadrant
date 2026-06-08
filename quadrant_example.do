*===============================================================*
* quadrant — example / tutorial do-file
* Bundled practice data (fictional; no real-world source):
*   region   1-4  North/South/East/West   (colour group)
*   product       Alpha/Beta/Gamma/Delta  (facet / point label, string)
*   year     2024 / 2026                  (survey wave)
*   satisf   Satisfaction (%)             (y axis)
*   price    Price sensitivity (%)        (x axis)
*===============================================================*
clear all
set more off

* load practice data from the repo (no install needed)
use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear

* Most examples below use one wave; keep 2024 so there is one point per cell.
* (Section 14 uses both waves to demonstrate bysymbol().)

* 1) Grouped by region, labelled by product, Delta drawn hollow
quadrant satisf price if year==2024, by(region) mlabel(product) hollow("Delta")

* 2) Ungrouped (single colour)
quadrant satisf price if year==2024, mlabel(product) hollow("Delta")

* 3) Grouped plus the pooled overall-mean point set (black)
quadrant satisf price if year==2024, by(region) overall mlabel(product) hollow("Delta")

* 4) Reference cross at the data means instead of 50/50
quadrant satisf price if year==2024, by(region) meanlines

* 5) Custom cross position + export
quadrant satisf price if year==2024, by(region) mlabel(product) hollow("Delta") ///
    xline(45) yline(55) saving("quadrant_demo_fig.png")

* 6) Faceting: one quadrant per region, labelled by product
*    focus zooms each panel to its own data so the points are easy to read
quadrant satisf price if year==2024, panel(region) mlabel(product) meanlines focus

* 7) Faceting + grouping: one quadrant per product, coloured by region.
*    Grouped panels get a single shared legend at the bottom (6 o'clock).
quadrant satisf price if year==2024, panel(product) by(region) range(10 95)

* 8) Marker style & size: large diamonds (the hollow category becomes a
*    hollow diamond automatically). Try also msymbol(S) or msymbol(T).
quadrant satisf price if year==2024, by(region) mlabel(product) hollow("Delta") focus ///
    msymbol(D) msize(large)

* 9) Bigger title and axis-title fonts via inline size() sub-options
quadrant satisf price if year==2024, by(region) mlabel(product) focus ///
    title("Market positioning", size(large)) ///
    xtitle("Price sensitivity (%)", size(large)) ytitle("Satisfaction (%)", size(large))

* 10) Want a perfectly square quadrant? Add aspect(1).
quadrant satisf price if year==2024, by(region) mlabel(product) aspect(1)

* 11) Assign an explicit colour to each by() group with value=colour pairs.
*     Keys match the value label (or the raw level).
quadrant satisf price if year==2024, by(region) mlabel(product) focus ///
    bycolors(North=navy South=forest_green East=orange West=gs7)

* 12) Legend behaves like twoway's legend(): move it, set columns, resize, off.
quadrant satisf price if year==2024, by(region) mlabel(product) focus ///
    legend(position(3) cols(1) size(small))

* 13) Assign a marker SHAPE to each group with value=symbol pairs, paired with
*     bycolors() for a legend coded by both colour and shape.
*     (D=large diamond, d=small diamond, O=large circle, o=small circle)
quadrant satisf price if year==2024, by(region) mlabel(product) focus ///
    symbols(North=O South=D East=S West=T) ///
    bycolors(North=navy South=forest_green East=orange West=gs7)

* 14) bysymbol(): a SECOND grouping coded by marker SHAPE while colour still
*     follows by(). Here: colour = region, shape = survey wave (year).
*     sbsymbols(T O) -> 2024 triangle, 2026 circle.
quadrant satisf price, panel(product) by(region) bysymbol(year) msize(*2) range(10 95) ///
    bycolors(North=navy South=forest_green East=orange West=gs7) sbsymbols(T O)

display as result "quadrant tutorial finished — see help quadrant."
