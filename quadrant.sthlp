{smcl}
{* *! version 1.0  2jun2026}{...}
{vieweralsosee "twoway scatter" "help twoway scatter"}{...}
{viewerjumpto "Syntax" "quadrant##syntax"}{...}
{viewerjumpto "Description" "quadrant##description"}{...}
{viewerjumpto "Options" "quadrant##options"}{...}
{viewerjumpto "Examples" "quadrant##examples"}{...}
{viewerjumpto "Author" "quadrant##author"}{...}
{title:Title}

{phang}
{bf:quadrant} {hline 2} Quadrant scatter plot with a central cross of reference lines


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:quadrant}
{it:yvar} {it:xvar}
{ifin}
[{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Grouping}
{synopt:{opth by(varname)}}colour points by this group and add a legend{p_end}
{synopt:{opt byc:olors(string)}}explicit colour per {opt by()} group as {it:value=colour} pairs, e.g. {cmd:bycolors(KMT=blue DPP=green TPP=gs8)} ({opt colors()} is a backward-compatible alias){p_end}
{synopt:{opt overall}}also plot the overall (ungrouped) point set in black (with {opt by()}){p_end}

{syntab:Labels and markers}
{synopt:{opth mlabel(varname)}}text label for each point{p_end}
{synopt:{opt hollow(string)}}value of {opt mlabel()} drawn with a hollow marker{p_end}
{synopt:{opt msize(string)}}marker size; default {cmd:medium}{p_end}
{synopt:{opt msymbol(string)}}marker symbol for all groups; default {cmd:O} (the hollow category uses the matching outline symbol){p_end}
{synopt:{opt symbols(string)}}explicit marker symbol per group as {it:value=symbol} pairs, e.g. {cmd:symbols(KMT=D DPP=d TPP=O)}{p_end}
{synopt:{opt symbolby(varname)}}a SECOND grouping mapped to marker symbols (colour still follows {opt by()}); default 1st level hollow circle, 2nd solid circle, e.g. years 2024 vs 2026{p_end}
{synopt:{opt sbsymbols(string)}}symbol list for the {opt symbolby()} levels, positional, e.g. {cmd:sbsymbols(Oh O)} or {cmd:sbsymbols(Th T)}{p_end}
{synopt:{opt mlabsize(string)}}label size; default {cmd:small}{p_end}

{syntab:Reference cross}
{synopt:{opt xline(#)}}vertical reference line; default {cmd:50}{p_end}
{synopt:{opt yline(#)}}horizontal reference line; default {cmd:50}{p_end}
{synopt:{opt meanlines}}put the cross at the means of x and y instead{p_end}
{synopt:{opt focus}}auto-zoom the axes to the data range (tidy integer ticks){p_end}
{synopt:{opt xrange(# #)} {opt yrange(# #)}}set each axis range separately{p_end}

{syntab:Faceting}
{synopt:{opth panel(varname)}}draw one quadrant per level of this variable and combine them{p_end}
{synopt:{opt cols(#)}}number of columns when faceting (default: auto){p_end}

{syntab:Axes and titles}
{synopt:{opt range(# #)}}axis range for both axes; default {cmd:0 100}{p_end}
{synopt:{opt palette(string)}}colours, one per group (positional); see {opt bycolors()} for explicit mapping{p_end}
{synopt:{opt title(string)}}graph title; accepts sub-options, e.g. {cmd:title("Map", size(large))}{p_end}
{synopt:{opt xtitle(string)} {opt ytitle(string)}}axis titles; accept sub-options, e.g. {cmd:xtitle("NIMBY (%)", size(large))}{p_end}
{synopt:{opt aspect(string)}}aspect ratio (off by default); use {cmd:aspect(1)} for a square quadrant{p_end}
{synopt:{opt legend(string)}}{cmd:off}, or any {help legend_options:legend()} sub-options, e.g. {cmd:legend(position(3) cols(1))}{p_end}

{syntab:Saving}
{synopt:{opt saving(string)}}export the graph{p_end}
{synopt:{opt name(string)}}graph window name; default {cmd:quadrant}{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:quadrant} draws a quadrant scatter plot: {it:yvar} against {it:xvar} with a
central cross of reference lines splitting the plane into four quadrants. Points
can be coloured {opt by()} a group (with a legend), labelled with {opt mlabel()},
and one category drawn with a hollow marker via {opt hollow()}. The cross
defaults to (50, 50); set it with {opt xline()} / {opt yline()} or place it at
the data means with {opt meanlines}.

{pstd}
Three common modes: {bf:ungrouped} (omit {opt by()}, one colour); {bf:grouped}
({opt by(group)}, one colour per group + legend); {bf:grouped + overall} (add
{opt overall} to also show the pooled point set in black).


{marker options}{...}
{title:Options}

{phang}{opth by(varname)} colours points by group and adds a legend.

{phang}{opt bycolors(string)} assigns an explicit colour to each {opt by()} group
as a list of {it:value=colour} pairs, e.g.
{cmd:bycolors(KMT=blue DPP=green TPP=gs8 中立無反應=black)} ({opt colors()} still
works as an alias). The key may be the
group's value label or its raw level value (use the raw value when the label
contains spaces); any group not listed falls back to the positional
{opt palette()}. Use named colours (e.g. {cmd:blue}, {cmd:gs8}, {cmd:black}).

{phang}{opt overall} (with {opt by()}) also plots the pooled point set in black.

{phang}{opth mlabel(varname)} labels each point; {opt hollow(string)} draws
points whose label equals that value with a hollow marker.

{phang}{opt xline(#)} / {opt yline(#)} set the reference cross (default 50/50);
{opt meanlines} places it at the means of x and y.

{phang}{opth panel(varname)} draws one quadrant per level of the panel variable
and combines them into a single faceted graph; {opt cols(#)} sets the number of
columns (default: auto). All other options (including {opt by()}, {opt mlabel()},
{opt meanlines}, {opt range()}) apply within each panel.

{phang}{opt msymbol(string)} sets the marker symbol for all groups (default
{cmd:O}); the hollow category automatically uses the matching outline symbol.
{opt msize()} sets the marker size.

{phang}{opt symbols(string)} assigns a marker symbol to specific groups as
{it:value=symbol} pairs, e.g. {cmd:symbols(KMT=D DPP=d TPP=O 中立無反應=o)}
(D = large diamond, d = small diamond, O = large circle, o = small circle, ...).
The key may be the group's value label or its raw value (use the raw value when
the label contains spaces); groups not listed keep {opt msymbol()}.

{phang}{opt symbolby(varname)} encodes a {it:second} grouping by marker
{it:symbol} while colour continues to follow {opt by()}. By default the first
level is drawn as a hollow circle and the second as a solid circle (e.g.
{cmd:2024} hollow vs {cmd:2026} solid); customise with
{opt sbsymbols()} (a positional symbol list, e.g. {cmd:sbsymbols(Th T)}). The
shared legend gains neutral grey keys for each level. Works in single and
{opt panel()} modes. Example:

{phang2}{cmd:quadrant support nimby, by(party) panel(energy) symbolby(year) mlabel(yr2)}{p_end}

{pmore}Pairs nicely
with {opt bycolors()} for a colour- and shape-coded legend.

{phang}{opt title()}, {opt xtitle()} and {opt ytitle()} are passed through to
{cmd:twoway} verbatim, so any sub-option works inside them, e.g.
{cmd:xtitle("NIMBY (%)", size(large))} or {cmd:title("Map", size(large) color(navy))}.
{opt aspect()} is off by default so a title leaves no side gaps; pass
{opt aspect(1)} for a square quadrant.

{phang}{opt legend(string)} accepts {cmd:off} to hide the legend, or any
{help legend_options:legend()} sub-options, which are merged with the
automatically-built key order, e.g. {cmd:legend(position(3) cols(1) size(small))}.
In a faceted figure the legend is shared once at the bottom by default.

{phang}{opt range(# #)}, {opt palette()}, {opt msize()}, {opt mlabsize()},
{opt saving()}, {opt name()} control appearance and output.


{marker examples}{...}
{title:Examples}

{pstd}Load the bundled practice data (fictional; no real source){p_end}
{phang2}{cmd:. use "https://raw.githubusercontent.com/ganma0517/stata_quadrant/main/quadrant_demo.dta", clear}{p_end}

{pstd}Grouped, labelled, one category hollow{p_end}
{phang2}{cmd:. quadrant support nimby, by(pid) mlabel(energy) hollow("Nuclear")}{p_end}

{pstd}Ungrouped (single colour){p_end}
{phang2}{cmd:. quadrant support nimby, mlabel(energy) hollow("Nuclear")}{p_end}

{pstd}Grouped plus the pooled overall point set{p_end}
{phang2}{cmd:. quadrant support nimby, by(pid) overall mlabel(energy) hollow("Nuclear")}{p_end}

{pstd}Reference cross at the data means{p_end}
{phang2}{cmd:. quadrant support nimby, by(pid) meanlines}{p_end}

{pstd}Faceted: one quadrant per party, points labelled by energy source{p_end}
{phang2}{cmd:. quadrant support nimby, panel(party) mlabel(energy) meanlines}{p_end}

{pstd}Faceted and grouped: one quadrant per energy source, coloured by party{p_end}
{phang2}{cmd:. quadrant support nimby, panel(energy) by(party) range(40 90)}{p_end}


{marker author}{...}
{title:Author}

{pstd}{bf:Wen-Cheng Lin (林文正)}{break}
PhD, Department of Political Science, National Chengchi University{break}
Postdoctoral research fellow, Institute of Sociology, Academia Sinica{break}
Email: beck740517@gmail.com{break}
{browse "https://github.com/ganma0517/stata_quadrant":github.com/ganma0517/stata_quadrant}{p_end}

{pstd}This package was developed with Claude. Questions and feedback are very
welcome.{p_end}

{pstd}本套件由作者使用 Claude 開發，目前仍屬實驗性階段。若有任何問題，歡迎來信交流。{p_end}
