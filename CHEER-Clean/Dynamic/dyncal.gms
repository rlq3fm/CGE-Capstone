
*============================ parameter for dynamic process =========================

*// other parameter for dynamic 
parameter   fact_supp    factor supplies pathway;            

            fact_supp("capital","2012")   =     fact("capital");
            fact_supp("labor","2012")     =     ls0 ;

parameter   tlprop(*,*)  the proportion of total labor supply by year;  
            
            tlprop(lm,"2012") =   tlabor_s0(lm)/ls0;  


parameter   AEEI_t      AEEI trend
            xscale_t    trade unbalance trend
            ;

            AEEI_t(s,"2012")  =     aeei(s);
            xscale_t("2012")  =     xscale;

parameter   invest_k	annual investment pathway
			deltak		annual rate of capital depreciation /0.03/;


*=============================== Scenarios block =============================
set
			scn       	all scenarios   			/ BAU, CER /
			bscn(scn) 	reference scenarios		/ BAU /
                  pscn(scn)   policy scenarios              / CER /;

*// 
parameter 	clim_scn 		"switch for national carbon market 0=off,1=accounting; 2= quantity target;3 = intensity target";

			clim_scn(scn)		=		1;


*============================== parameter for report ========================
parameter 	Header 		Flag determining whether to output header records in output files ;
			
			Header 		= 	1;

*//----- Declare the output file names
file 		reportfile /"Output/output.csv"/ ;

*// ----- Model output options
display 	"Begin output listing" ;

options limcol=000, limrow=000 ;
*options 	solprint=off ;
*option 		solvelink=2;

*// create the output file
put 		reportfile ;
if 			(Header eq 1, 
			put 'Scenario,year,variable,sector,sector2,subsector,labor,qualifier,value,solvestat' / ; ) ;

*//print control (.pc)     5 Formatted output; Non-numeric output is quoted, and each item is delimited with commas.
			reportfile.pc   = 5 ;
*//page width (.pw)
			reportfile.pw = 255 ;
*//.nj numeric justification (default 1)
			reportfile.nj =   1 ;
*//.nw numeric field width (default 12)
			reportfile.nw =  15 ;
*//number of decimals displayed (.nd)
			reportfile.nd =   9 ;
*//numeric zero tolerance (.nz)
			reportfile.nz =   0 ;
*//numeric zero tolerance (.nz)
			reportfile.nr =   0 ;

file 		screen / 'con' / ;


parameter
report1    reporting variable
report2    reporting variable
report3    reporting variable
report4    reporting variable
;

*//emissions restriction policies,with or without inducement of innovation


