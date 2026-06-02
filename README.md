# quadrant

A Stata command that draws a **quadrant scatter plot**: points of *y* against
*x* with a central cross of reference lines splitting the plane into four
quadrants. Points can be coloured **by a group** (with a legend), **labelled**,
and one category drawn with a **hollow marker**. Ideal for support-vs-opposition,
importance-vs-performance, and similar two-dimensional positioning maps.

![example](example_quadrant.png)

## Requirements

- Stata 16 or newer

## Installation

### Option A — `net install` (recommended)

```stata
net install quadrant, from("https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/") replace
```

### Option B — `github install`

```stata
github install ganma0517/stata_quadrant
```

After installing, read the help and run the example:

```stata
help quadrant
do quadrant_example.do
```

## Quick start

A practice dataset is included — **fictional** support (%) vs NIMBY (%) for four
energy types across four party blocs (no real-world source):

```stata
use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear")
```

## Three modes

```stata
* ungrouped (single colour)
quadrant support nimby, mlabel(energy) hollow("Nuclear")

* grouped (one colour per group + legend)
quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear")

* grouped + pooled overall mean point set (black)
quadrant support nimby, by(pid) overall mlabel(energy) hollow("Nuclear")
```

## Syntax

```
quadrant yvar xvar [if] [in] [, options]
```

| Option | Description | Default |
|---|---|---|
| `by(varname)` | colour points by group + legend | — |
| `overall` | also plot pooled mean points (black) | off |
| `mlabel(varname)` | point text labels | — |
| `hollow(string)` | label value drawn with a hollow marker | — |
| `xline(#)` `yline(#)` | reference cross position | 50 / 50 |
| `meanlines` | put the cross at the data means | off |
| `focus` | auto-zoom axes to the data (tidy ticks) | off |
| `range(# #)` | axis range (both axes) | 0 100 |
| `xrange(# #)` `yrange(# #)` | set each axis range separately | — |
| `legpos(#)` | legend position (6 = bottom) | 6 |
| `palette()` `msize()` `mlabsize()` | colors / sizes | — |
| `title()` `xtitle()` `ytitle()` `legend()` | titles / legend | — |
| `saving()` `name()` | export / window name | — |

See `help quadrant` for full documentation and examples.

## Files

- `quadrant.ado` — the command
- `quadrant.sthlp` — Stata help file
- `quadrant_example.do` — runnable tutorial
- `quadrant_demo.dta` — practice data (fictional, long format)
- `example_quadrant.png` — demo figure
- `quadrant.pkg`, `stata.toc` — package metadata for `net install`

## About the author

PhD in Political Science at National Chengchi University and a postdoctoral
research fellow at the Institute of Sociology, Academia Sinica. My research
focuses on political and social change in Taiwan and comparative politics, and I
use Claude to develop small Stata graphing tools that support empirical and
survey-experiment research. Questions welcome — beck740517@gmail.com

政治大學政治學系博士、中央研究院社會學研究所博士後研究員。研究聚焦台灣政治社會變遷與比較政治，
並使用 Claude 開發小型 Stata 製圖工具輔助實證與調查實驗研究。若有任何問題，歡迎寫信與我交流。

## Citation

Lin, Wen-Cheng (2026). *quadrant: Quadrant scatter plot with a central cross of
reference lines.* https://github.com/ganma0517/stata_quadrant

## License

MIT — see [LICENSE](LICENSE).
