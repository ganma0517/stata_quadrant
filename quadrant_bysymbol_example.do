*------------------------------------------------------------------*
* quadrant_bysymbol_example.do
* Demonstrates bysymbol(): colour marks one grouping (by(), here region)
* and marker SHAPE marks a second (here the survey wave, year).
* Bundled fictional data quadrant_demo.dta:
*   region 1-4 North/South/East/West ; product Alpha/Beta/Gamma/Delta
*   year 2024 / 2026 ; satisf (y) ; price (x)
*------------------------------------------------------------------*
* If installed, load the bundled demo directly:
*   use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear
use quadrant_demo.dta, clear

* Faceted by product, colour = region, shape = wave
* sbsymbols(T O) -> 2024 triangle, 2026 circle ; larger markers via msize(*2)
quadrant satisf price, by(region) panel(product) bysymbol(year) msize(*2) ///
    range(10 95) ///
    bycolors(North=navy South=forest_green East=orange West=gs7) ///
    sbsymbols(T O) ///
    title("Satisfaction vs price by product (region x year)")

* Single quadrant version (no faceting)
quadrant satisf price, by(region) bysymbol(year) focus msize(*1.6) ///
    bycolors(North=navy South=forest_green East=orange West=gs7) ///
    sbsymbols(T O)

display as result "bysymbol example finished — see help quadrant."
