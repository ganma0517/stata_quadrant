*------------------------------------------------------------------*
* quadrant_bysymbol_example.do
* Demonstrates bysymbol(): colour marks one grouping (by(), here party)
* and marker SHAPE marks a second (here survey wave 2024 vs 2026).
* Uses the shipped two-wave demo dataset, quadrant_wave_demo.dta
*   pid4   : 1 泛藍 2 泛綠 3 民眾黨 4 無政黨傾向
*   energy : 1 地熱 2 地面型光電 3 核能 4 風力
*   y      : 2024 / 2026 (survey wave)
*------------------------------------------------------------------*
* If installed via net/github install, load the bundled demo directly:
*   use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_wave_demo.dta", clear
use quadrant_wave_demo.dta, clear

* Faceted by energy type: colour = party, shape = wave
* (2024 = triangle T, 2026 = circle O), larger markers via msize(*3)
quadrant support nimby, by(pid4) panel(energy) ///
    msize(*3) ///
    xrange(10 85) yrange(10 90) ///
    xtitle("鄰避率(%)", size(*1.2)) ytitle("支持率(%)", size(*1.2)) ///
    title("不同能源類型的鄰避率與支持率(政黨)") ///
    bycolors(泛藍=blue 泛綠=dkgreen 民眾黨=ebblue 無政黨傾向=black) ///
    symbolby(y) sbsymbols(T O)

* Single quadrant version (no faceting)
quadrant support nimby, by(pid4) bysymbol(y) focus ///
    msize(*2.2) ///
    bycolors(泛藍=blue 泛綠=dkgreen 民眾黨=ebblue 無政黨傾向=black) ///
    sbsymbols(T O)

display as result "bysymbol example finished — see help quadrant."
