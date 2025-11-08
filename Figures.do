* Naika Jean Baptiste
* Replication Project Figure 1 and Figure 2

set more off
cap log close_ all
clear all

global ROOT "/Users/naikajeanbaptiste/Documents/Eco 726/Project"
global FIG  "$ROOT/figures"
cap mkdir "$FIG"
cd "$ROOT"

log using "replication_figure1.log", name(fig1) replace

use "case_counts_population.dta", clear
export delimited using "case_counts_population.csv", replace

* Figure 1

* Add up all the measles counts across states for each year
collapse (sum) measles (sum) pertussis (sum) chicken_pox (sum) mumps (sum) rubella, by(year) 

label variable measles "measles"


gen Infectious_disease=pertussis+mumps+rubella+chicken_pox

label variable Infectious_disease "Infectious disease"
label variable year "Year"

drop if year<1956

*graph
twoway (line measles year, xline(1964) ytitle("Number of reported cases"))(line Infectious_disease year, lpattern(dash))

graph save   "$FIG/Figure1.gph", replace
graph export "$FIG/Figure1.png", replace width(2000)

log close fig1


/*==============================================================================

Figure 2   */

log using "replication_figure2.log", name(fig2) replace

use "inc_rate.dta", clear
export delimited using "inc_rate.dta.csv", replace


* Create new variable to reflect change in measles rates
gen changem62_67 = measles_rate_1967 - measles_rate_1962
label variable changem62_67 "Change in measles rate, 1962–1967 (per 100,000)"

* Scatter plot 

 twoway (scatter changem62_67 measles_rate_1962, ///
    msymbol(O) msize(small) mlabel(state) mlabsize(vsmall) mcolor(black) /// 
	  mlabpos(12) mlabgap(1)), ///
      ytitle("Change in measles incidence rate, 1962–1967 (per 100,000)") ///
      xtitle("Measles incidence rate in 1962 (per 100,000)") ///
      legend(off) ///
      title("Pre-vaccine rate vs. change in measles incidence")

graph save   "$FIG/Figure2.gph", replace
graph export "$FIG/Figure2.png", replace width(2000)

log close fig2
