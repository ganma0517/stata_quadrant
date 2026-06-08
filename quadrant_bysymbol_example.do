*------------------------------------------------------------------*
* quadrant_bysymbol_example.do
* Two groupings on one map:
*   by(...)       -> COLOUR   (here region: each region a colour)
*   bysymbol(...) -> SHAPE    (here year:   2024 vs 2026)
* Put DIFFERENT variables in by() and bysymbol(). If you accidentally
* put the same variable (e.g. year) in BOTH, colour and shape will both
* track that variable — which is usually not what you want.
*
* Bundled fictional data quadrant_demo.dta:
*   region 1-4 North/South/East/West ; product Alpha/Beta/Gamma/Delta
*   year 2024 / 2026 ; satisf (y) ; price (x)
*------------------------------------------------------------------*
* If installed, load the bundled demo directly:
*   use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear
use quadrant_demo.dta, clear

* Faceted by product: within each panel, COLOUR = region, SHAPE = year.
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

* COLOUR FOLLOWS THE PANEL: put the SAME variable in by() and panel().
* Each region's panel is drawn entirely in that region's colour; only the
* symbol differs by year (2024 triangle, 2026 circle).
* (e.g. with party data: by(party) panel(party) bysymbol(year) — every point
*  in the "Blue" panel is blue, in the "Green" panel green, and so on.)
quadrant satisf price, by(region) panel(region) bysymbol(year) msize(*2) ///
    range(10 95) ///
    bycolors(North=navy South=forest_green East=orange West=gs7) sbsymbols(T O)

display as result "bysymbol example finished — see help quadrant."
