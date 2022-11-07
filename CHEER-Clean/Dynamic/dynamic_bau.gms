*----------------------------------------------*
*Code for BAU simulation 
*----------------------------------------------*

*// GDP endogenous while the TFP is exodgenous

options solprint=on;

loop(scn$(bscn(scn) ),

*// chage the below condition to control the solving period of the model
  loop(t$(ord(t) le card(t)),
*  loop(t$(ord(t) le 10),

*== drivers of dynamic simulation=====
	fact("capital") = 	fact_supp("capital",t);

	tqlabor_s0 		= 	fact_supp("labor",t);

*// keep the same population share as base year
	tlabor_s0(lm)   =	fact_supp("labor",t)*tlprop(lm,"2012");

*// energy effiency
	aeei(s)=AEEI_t(s,t);

*// use xscale the control the exogenous trade inbalance
	xscale = xscale_t(t);

*// here to control the exogenous TFP pathway or GDP pathway
	TFP0		=	TFP_b(t);


*==============parameter for policy shock===============
	clim 		=	1;

$include 	CHEER.gen

EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;

CHEER.Savepoint         =       1;
display 	CHEER.modelstat, CHEER.solvestat;

*------------------
*// update capital supply
*// assume the depreciation of new investmen transfer to capital supply
*------------------
	invest_k(t)                  =   grossinvk.l;

	fact_supp("capital",t+1)$(ord(t) eq 1)		=		3*invest_k(t)*deltak+(1-deltak)**3*fact_supp("capital",t);
	fact_supp("capital",t+1)$(ord(t) gt 1)		=		5*invest_k(t)*deltak+(1-deltak)**5*fact_supp("capital",t);

*------------------
*// update labor supply
*------------------

	fact_supp("labor",t+1)  $(ord(t) eq 1)  =		fact_supp("labor",t)  *(1+labor_g(t+1))**3;
	fact_supp("labor",t+1)  $(ord(t) gt 1)  =		fact_supp("labor",t)  *(1+labor_g(t+1))**5;


*=======energy effiency  update =========

	AEEI_t(i,t+1)$(ord(t) eq 1)  		= 	AEEI_t(i,t)/(1+0.01)**3;
	AEEI_t("fd",t+1)$(ord(t) eq 1)  	=  	AEEI_t("fd",t)/(1+0.01)**3;

	AEEI_t(i,t+1)$(ord(t) gt 1)  		=  	AEEI_t(i,t)/(1+0.01)**5;
	AEEI_t("fd",t+1)$(ord(t) gt 1)  	=  	AEEI_t("fd",t)/(1+0.01)**5;

*=======exogenous trade balance  =========
*trade imbalance and stock change phased out at 1% per year
	xscale_t(t+1)$(ord(t) eq 1)         =	xscale_t(t)*(1-0.01)**3;
	xscale_t(t+1)$(ord(t) gt 1)         =	xscale_t(t)*(1-0.01)**5;

*// record gdp 
	rgdp_m(t)	=	rgdp.l;

$include %RepPath%/report_dynamic

 );
);

