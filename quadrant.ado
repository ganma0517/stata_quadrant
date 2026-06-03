*! quadrant v1.0  2Jun2026
*! Quadrant (scatter) plot: points coloured by group, with a central
*! cross of reference lines splitting the plane into four quadrants,
*! optional point labels, and an optional "hollow" category.
*!
*! Syntax:
*!   quadrant yvar xvar [if] [in] [ , options ]
*!
*! Options:
*!   by(varname)        colour points by this group; adds a legend
*!   overall            also plot the overall (ungrouped) mean point set
*!                      (only with by(); drawn in black)
*!   mlabel(varname)    text label for each point
*!   hollow(string)     value of mlabel() drawn with a hollow marker
*!                      (e.g. hollow("Nuclear"))
*!   xline(#)           vertical reference line (default 50)
*!   yline(#)           horizontal reference line (default 50)
*!   meanlines          put the reference cross at the means of x and y
*!                      instead of xline()/yline()
*!   palette(string)    space-separated colors, one per group (positional)
*!   colors(string)     explicit colour per group as value=colour pairs, e.g.
*!                      colors(KMT=blue DPP=green TPP=gs8 中立無反應=black)
*!   msize(string)      marker size (default medium)
*!   msymbol(string)    marker symbol for all groups (default O)
*!   symbols(string)    explicit marker symbol per group as value=symbol pairs,
*!                      e.g. symbols(KMT=D DPP=d TPP=O 中立無反應=o)
*!   mlabsize(string)   label size (default small)
*!   title/xtitle/ytitle  passed through verbatim, so sub-options work, e.g.
*!                        xtitle("NIMBY (%)", size(large))
*!   aspect(string)     aspect ratio (off by default; aspect(1) = square)
*!   range(# #)         axis range for both axes (default 0 100)
*!   panel(varname)     facet: draw one quadrant per level and combine them
*!   cols(#)            number of columns when faceting (default: auto)
*!   xtitle ytitle title(string)
*!   legend(string)     "off", or any twoway legend() sub-options, e.g.
*!                      legend(position(3) cols(1) size(small))
*!   saving(string) name(string)

program define quadrant
    version 16.0
    syntax varlist(min=2 max=2 numeric) [if] [in] , ///
        [ by(varname) OVERALL MLABel(varname) HOLLOW(string) ///
          XLINE(real 50) YLINE(real 50) MEANlines FOCus ///
          PALette(string) COLORS(string asis) ///
          MSize(string) MSYMbol(string) SYMBOLS(string asis) MLABSize(string) ///
          XRANGE(numlist min=2 max=2) YRANGE(numlist min=2 max=2) ///
          RANGE(numlist min=2 max=2) ASPect(string) ///
          PANel(varname) COLs(integer 0) ///
          title(string asis) XTITle(string asis) YTITle(string asis) ///
          Legend(string asis) saving(string) name(string) NODRAW ]

    gettoken yv xv : varlist

    * =====================================================
    * PANEL MODE: draw one quadrant per level of panel()
    * and combine them into a single faceted graph.
    * =====================================================
    if "`panel'" != "" {
        if "`name'"=="" local name "quadrant"
        tempvar ptouse
        marksample ptouse, novarlist
        markout `ptouse' `xv'
        if "`by'"!=""     markout `ptouse' `by', strok
        markout `ptouse' `panel', strok
        quietly levelsof `panel' if `ptouse', local(plevs)
        local np : word count `plevs'
        capture confirm string variable `panel'
        local pstr = (_rc==0)
        if `cols'==0 {
            if `np'<=2 local cols = `np'
            else if `np'<=4 local cols = 2
            else local cols = 3
        }
        * a single shared legend (at the bottom) is drawn once for the whole
        * figure whenever points are grouped; the sub-plots themselves carry
        * no legend so the panels stay clean.
        local sharedleg = ("`by'"!="" & `"`legend'"'!="off")

        * collect passthrough options
        local opts `"xline(`xline') yline(`yline') `meanlines' `focus' `overall'"'
        if "`by'"!=""       local opts `"`opts' by(`by')"'
        if "`mlabel'"!=""   local opts `"`opts' mlabel(`mlabel')"'
        if `"`hollow'"'!="" local opts `"`opts' hollow(`"`hollow'"')"'
        if "`msize'"!=""    local opts `"`opts' msize(`msize')"'
        if "`msymbol'"!=""  local opts `"`opts' msymbol(`msymbol')"'
        if `"`symbols'"'!="" local opts `"`opts' symbols(`symbols')"'
        if "`mlabsize'"!="" local opts `"`opts' mlabsize(`mlabsize')"'
        if "`aspect'"!=""   local opts `"`opts' aspect(`aspect')"'
        if "`palette'"!=""  local opts `"`opts' palette(`"`palette'"')"'
        if `"`colors'"'!="" local opts `"`opts' colors(`colors')"'
        if "`range'"!=""    local opts `"`opts' range(`range')"'
        if "`xrange'"!=""   local opts `"`opts' xrange(`xrange')"'
        if "`yrange'"!=""   local opts `"`opts' yrange(`yrange')"'
        if `"`xtitle'"'!="" local opts `"`opts' xtitle(`xtitle')"'
        if `"`ytitle'"'!="" local opts `"`opts' ytitle(`ytitle')"'
        * suppress per-panel legends when we will draw one shared legend
        if `sharedleg'                local opts `"`opts' legend(off)"'
        else if `"`legend'"'!=""      local opts `"`opts' legend(`legend')"'

        local subnames ""
        local j = 0
        foreach pl of local plevs {
            local ++j
            if `pstr' {
                local pcond `"`panel'=="`pl'""'
                local plab "`pl'"
            }
            else {
                local pcond `"`panel'==`pl'"'
                local plab : label (`panel') `pl'
                if `"`plab'"'=="" local plab "`pl'"
            }
            local sub`j' "_qd_panel`j'"
            quadrant `yv' `xv' if `pcond' & `ptouse', `opts' ///
                title("`plab'") name(`sub`j'') nodraw
            local subnames `subnames' `sub`j''
        }

        * combined-figure title, passed through verbatim (supports size() etc.)
        if `"`title'"'=="" local ptit ""
        else               local ptit `"title(`title')"'

        if `sharedleg' {
            * build a legend-only graph (no visible markers) and attach it as a
            * thin strip beneath the grid via a second graph combine.
            local lpal "`palette'"
            if "`lpal'"=="" local lpal "blue forest_green orange gs8 cranberry navy purple teal"
            capture confirm string variable `by'
            local bystr = (_rc==0)
            quietly levelsof `by' if `ptouse', local(glv)
            local lplot ""
            local lord ""
            local ii = 0
            foreach g of local glv {
                local ++ii
                local lc : word `ii' of `lpal'
                if `bystr' local glab "`g'"
                else {
                    local glab : label (`by') `g'
                    if `"`glab'"'=="" local glab "`g'"
                }
                * honour the same colors("group=colour") mapping as the panels
                if `"`colors'"'!="" {
                    foreach kv of local colors {
                        local eq = strpos(`"`kv'"',"=")
                        if `eq' {
                            local k = substr(`"`kv'"',1,`eq'-1)
                            local c = substr(`"`kv'"',`eq'+1,.)
                            if `"`k'"'==`"`glab'"' | `"`k'"'=="`g'" local lc `"`c'"'
                        }
                    }
                }
                * honour the same symbols("group=symbol") mapping as the panels
                local lsym = cond("`msymbol'"=="","O","`msymbol'")
                if `"`symbols'"'!="" {
                    foreach kv of local symbols {
                        local eq = strpos(`"`kv'"',"=")
                        if `eq' {
                            local k = substr(`"`kv'"',1,`eq'-1)
                            local s = substr(`"`kv'"',`eq'+1,.)
                            if `"`k'"'==`"`glab'"' | `"`k'"'=="`g'" local lsym `"`s'"'
                        }
                    }
                }
                local lplot `"`lplot' (scatteri . ., msymbol(`lsym') mcolor(`lc')) "'
                local lord `lord' `ii' `"`glab'"'
            }
            * default shared legend sits at the bottom; user legend() sub-options
            * (other than off) override the placement.
            if `"`legend'"'=="" | `"`legend'"'=="on" local leglg `"rows(1) position(6)"'
            else local leglg `"`legend'"'
            twoway `lplot' ///
                , legend(order(`lord') `leglg') ///
                  xscale(off) yscale(off) ///
                  graphregion(color(white)) plotregion(color(white) margin(zero)) ///
                  fysize(14) name(_qd_legend, replace) nodraw
            graph combine `subnames', cols(`cols') ///
                graphregion(color(white)) name(_qd_grid, replace) nodraw
            graph combine _qd_grid _qd_legend, cols(1) imargin(zero) ///
                `ptit' ///
                graphregion(color(white)) name(`name', replace) `nodraw'
        }
        else {
            graph combine `subnames', cols(`cols') ///
                `ptit' ///
                graphregion(color(white)) name(`name', replace) `nodraw'
        }
        if `"`saving'"' != "" {
            quietly graph export `"`saving'"', replace width(2600)
            di as result "saved: `saving'"
        }
        exit
    }

    marksample touse
    markout `touse' `xv'
    if "`by'"!="" markout `touse' `by', strok

    if "`msize'"==""    local msize "medium"
    if "`msymbol'"==""  local msymbol "O"
    if "`mlabsize'"=="" local mlabsize "small"
    if "`name'"==""     local name "quadrant"
    if "`legend'"==""   local legend "on"
    * hollow variant of the chosen marker (O->Oh, D->Dh, S->Sh, T->Th, ...)
    if substr("`msymbol'", -1, 1)=="h" local hsym "`msymbol'"
    else                               local hsym "`msymbol'h"
    * axis ranges (x and y can differ). Priority:
    *   xrange()/yrange() > range() (both axes) > focus (auto) > default 0..100
    * default
    local xlo 0
    local xhi 100
    local ylo 0
    local yhi 100
    * focus: zoom tightly to the data with a small pad. When point labels are
    * shown they sit to the right of each marker, so give the right edge a
    * little extra room to keep the text from being clipped.
    if "`focus'"!="" {
        local rpad = 0.06
        if "`mlabel'"!="" local rpad = 0.16
        quietly summarize `xv' if `touse', meanonly
        local xspn = r(max)-r(min)
        if `xspn'==0 local xspn 1
        local xlo = r(min) - `xspn'*0.06
        local xhi = r(max) + `xspn'*`rpad'
        quietly summarize `yv' if `touse', meanonly
        local yspn = r(max)-r(min)
        if `yspn'==0 local yspn 1
        local ylo = r(min) - `yspn'*0.06
        local yhi = r(max) + `yspn'*0.06
    }
    * range() sets both axes
    if "`range'"!="" {
        local xlo : word 1 of `range'
        local xhi : word 2 of `range'
        local ylo `xlo'
        local yhi `xhi'
    }
    * xrange()/yrange() override their axis
    if "`xrange'"!="" {
        local xlo : word 1 of `xrange'
        local xhi : word 2 of `xrange'
    }
    if "`yrange'"!="" {
        local ylo : word 1 of `yrange'
        local yhi : word 2 of `yrange'
    }

    * reference-line positions
    if "`meanlines'"!="" {
        quietly summarize `xv' if `touse', meanonly
        local xline = r(mean)
        quietly summarize `yv' if `touse', meanonly
        local yline = r(mean)
    }

    * default palette
    if "`palette'"=="" {
        local palette "blue forest_green orange gs8 cranberry navy purple teal"
    }

    * label option for scatters
    if "`mlabel'"!="" local mlab `"mlabel(`mlabel') mlabsize(`mlabsize')"'
    else              local mlab ""

    * hollow-match condition (quote the value if mlabel is a string variable)
    local hasH = ("`mlabel'"!="" & "`hollow'"!="")
    if `hasH' {
        capture confirm string variable `mlabel'
        if !_rc local hcond `"`mlabel'=="`hollow'""'
        else    local hcond `"`mlabel'==`hollow'"'
    }

    * overall layer: pooled mean of (y,x) within each mlabel category,
    * computed once so it overlays as a single black point per category.
    if "`overall'"!="" & "`by'"!="" {
        tempvar oy ox otag
        if "`mlabel'"!="" {
            quietly egen double `oy' = mean(`yv') if `touse', by(`mlabel')
            quietly egen double `ox' = mean(`xv') if `touse', by(`mlabel')
            quietly egen byte `otag' = tag(`mlabel') if `touse'
        }
        else {
            quietly summarize `yv' if `touse', meanonly
            local oym = r(mean)
            quietly summarize `xv' if `touse', meanonly
            local oxm = r(mean)
            quietly gen double `oy' = `oym' if `touse'
            quietly gen double `ox' = `oxm' if `touse'
            quietly gen byte `otag' = (_n==1)
        }
    }

    * ---- build scatter layers ----
    local plot ""
    local legord ""
    local i = 0

    if "`by'"=="" {
        * single colour
        local col : word 1 of `palette'
        if `hasH' {
            local plot `"(scatter `yv' `xv' if `touse' & !(`hcond'), msymbol(`msymbol') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
            local plot `"`plot' (scatter `yv' `xv' if `touse' & `hcond', msymbol(`hsym') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
        }
        else {
            local plot `"(scatter `yv' `xv' if `touse', msymbol(`msymbol') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
        }
        local legend "off"
    }
    else {
        capture confirm string variable `by'
        local bystr = (_rc==0)
        quietly levelsof `by' if `touse', local(glevs)
        foreach g of local glevs {
            local ++i
            if `bystr' {
                local gcond `"`by'=="`g'""'
                local glab "`g'"
            }
            else {
                local gcond `"`by'==`g'"'
                local glab : label (`by') `g'
                if `"`glab'"'=="" local glab "`g'"
            }
            * colour: explicit colors("group=colour" ...) mapping wins; the
            * key may be the value label (e.g. KMT) or the raw level value.
            * Otherwise fall back to the positional palette().
            local col : word `i' of `palette'
            if `"`colors'"'!="" {
                foreach kv of local colors {
                    local eq = strpos(`"`kv'"',"=")
                    if `eq' {
                        local k = substr(`"`kv'"',1,`eq'-1)
                        local c = substr(`"`kv'"',`eq'+1,.)
                        if `"`k'"'==`"`glab'"' | `"`k'"'=="`g'" local col `"`c'"'
                    }
                }
            }
            * marker symbol: explicit symbols("group=symbol" ...) mapping wins,
            * else the global msymbol(). The hollow category uses the matching
            * outline variant (D->Dh, o->oh, ...).
            local gsym "`msymbol'"
            if `"`symbols'"'!="" {
                foreach kv of local symbols {
                    local eq = strpos(`"`kv'"',"=")
                    if `eq' {
                        local k = substr(`"`kv'"',1,`eq'-1)
                        local s = substr(`"`kv'"',`eq'+1,.)
                        if `"`k'"'==`"`glab'"' | `"`k'"'=="`g'" local gsym `"`s'"'
                    }
                }
            }
            if substr("`gsym'",-1,1)=="h" local ghsym "`gsym'"
            else                          local ghsym "`gsym'h"
            if `hasH' {
                local plot `"`plot' (scatter `yv' `xv' if `touse' & `gcond' & !(`hcond'), msymbol(`gsym') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
                local n1 = `=2*`i'-1'
                local plot `"`plot' (scatter `yv' `xv' if `touse' & `gcond' & `hcond', msymbol(`ghsym') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
                local legord `legord' `n1' `"`glab'"'
            }
            else {
                local plot `"`plot' (scatter `yv' `xv' if `touse' & `gcond', msymbol(`gsym') msize(`msize') mcolor(`col') `mlab' mlabcolor(`col')) "'
                local legord `legord' `i' `"`glab'"'
            }
        }
        * overall mean layer: one pooled black point per mlabel category
        if "`overall'"!="" {
            if `hasH' {
                local plot `"`plot' (scatter `oy' `ox' if `otag' & !(`hcond'), msymbol(`msymbol') msize(`msize') mcolor(black) `mlab' mlabcolor(black)) "'
                local plot `"`plot' (scatter `oy' `ox' if `otag' & `hcond', msymbol(`hsym') msize(`msize') mcolor(black) `mlab' mlabcolor(black)) "'
            }
            else {
                local plot `"`plot' (scatter `oy' `ox' if `otag', msymbol(`msymbol') msize(`msize') mcolor(black) `mlab' mlabcolor(black)) "'
            }
        }
    }

    * legend — the key order() is managed internally (the hollow category adds
    * extra plot entries); any twoway legend() sub-options the user supplies are
    * merged in, e.g. legend(position(3) cols(1) size(small)). Default: bottom.
    if `"`legend'"'=="off" local legopt "legend(off)"
    else if `"`legend'"'=="" | `"`legend'"'=="on" ///
        local legopt `"legend(order(`legord') rows(1) position(6))"'
    else local legopt `"legend(order(`legord') `legend')"'

    * tidy axis label step for each axis: aim for ~5 intervals and snap to a
    * "nice" number (1, 2, 5 x 10^k) so the axes stay clean and uncluttered.
    local xspan = `xhi' - `xlo'
    local yspan = `yhi' - `ylo'
    foreach ax in x y {
        local sp = ``ax'span'
        if `sp' <= 0 {
            local `ax'step = 1
        }
        else {
            local raw = `sp'/5
            local mag = 10^(floor(log10(`raw')))
            local nrm = `raw'/`mag'
            if `nrm' < 1.5      local nice = 1
            else if `nrm' < 3   local nice = 2
            else if `nrm' < 7   local nice = 5
            else                local nice = 10
            local `ax'step = `nice'*`mag'
        }
    }
    * Keep the axis scale tight to the (padded) data and place tick labels at
    * nice round positions strictly *inside* that range. This avoids the large
    * empty margins that result from snapping the whole axis out to the grid.
    local xlab_lo = ceil(`xlo'/`xstep')*`xstep'
    local xlab_hi = floor(`xhi'/`xstep')*`xstep'
    local ylab_lo = ceil(`ylo'/`ystep')*`ystep'
    local ylab_hi = floor(`yhi'/`ystep')*`ystep'
    * aspect ratio is off by default (so a title does not leave side gaps);
    * pass aspect(1) for a square quadrant, or any value twoway accepts.
    if "`aspect'"!="" local aspopt "aspect(`aspect')"
    else              local aspopt ""

    * Axis titles and main title are passed through verbatim, so the user can
    * add any twoway sub-option inside them, e.g.
    *   xtitle("NIMBY (%)", size(large))   ytitle("Support (%)", size(large))
    *   title("My map", size(large) color(navy))
    * When an axis title is omitted, fall back to the variable label (quoted).
    if `"`xtitle'"'!="" local xtopt `"xtitle(`xtitle')"'
    else {
        local xtl : variable label `xv'
        if `"`xtl'"'=="" local xtl "`xv'"
        local xtopt `"xtitle(`"`xtl'"')"'
    }
    if `"`ytitle'"'!="" local ytopt `"ytitle(`ytitle')"'
    else {
        local ytl : variable label `yv'
        if `"`ytl'"'=="" local ytl "`yv'"
        local ytopt `"ytitle(`"`ytl'"')"'
    }
    if `"`title'"'=="" local titopt ""
    else               local titopt `"title(`title')"'

    twoway `plot' ///
        , xline(`xline', lcolor(cranberry) lwidth(medium)) ///
          yline(`yline', lcolor(cranberry) lwidth(medium)) ///
          xlabel(`xlab_lo'(`xstep')`xlab_hi', grid glcolor(gs13)) ///
          ylabel(`ylab_lo'(`ystep')`ylab_hi', grid glcolor(gs13) angle(0)) ///
          xscale(range(`xlo' `xhi')) yscale(range(`ylo' `yhi')) ///
          `xtopt' `ytopt' `titopt' ///
          `legopt' ///
          graphregion(color(white)) plotregion(color(white) margin(small)) ///
          `aspopt' name(`name', replace) `nodraw'

    if `"`saving'"' != "" {
        quietly graph export `"`saving'"', replace width(2200)
        di as result "saved: `saving'"
    }
end
