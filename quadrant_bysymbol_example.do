*------------------------------------------------------------------*
* quadrant_bysymbol_example.do
* Demonstrates bysymbol(): colour marks one grouping (by(), here party)
* and marker SHAPE marks a second (here survey wave 2024 vs 2026).
* Default: first level hollow circle, second solid circle.
* Uses the shipped two-wave demo dataset, quadrant_wave_demo.dta.
*------------------------------------------------------------------*
* If installed via net/github install, load the bundled demo directly:
*   use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_wave_demo.dta", clear
use quadrant_wave_demo.dta, clear

* 1) Single quadrant: colour = party, shape = wave (2024 hollow, 2026 solid)
quadrant support nimby, by(party) bysymbol(wave) mlabel(yr) focus ///
    bycolors(KMT=blue DPP=dkgreen TPP=ebblue Neutral=black) ///
    title("Support vs NIMBY (party × wave)")

* 2) Faceted by energy type, colour = party, shape = wave
quadrant support nimby, panel(energy) by(party) bysymbol(wave) ///
    mlabel(yr) range(10 95) ///
    bycolors(KMT=blue DPP=dkgreen TPP=ebblue Neutral=black) ///
    title("Support vs NIMBY by energy type (party × wave)")

* 3) Customise the two wave symbols (e.g. hollow vs solid triangle)
quadrant support nimby, by(party) bysymbol(wave) sbsymbols(Th T) focus ///
    bycolors(KMT=blue DPP=dkgreen TPP=ebblue Neutral=black)

display as result "bysymbol example finished — see help quadrant."
