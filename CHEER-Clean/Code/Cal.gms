$title calibration for general Parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read SAM data
2) calibration of general Parameters

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
*==read IO data from gdx
*----------------------------------------------*
Parameter 	SAM(*,*);
$GDXIN 		%DataPath%\data.gdx
$LOAD 		sam
*----------------------------------------------*
*=== transfer unit to 0.1 billion yuan
*----------------------------------------------*

			sam(i,j)	=	sam(i,j)/10000;
			sam(f,i)	=	sam(f,i)/10000;
			sam(i,fd)	=	sam(i,fd)/10000;
			sam('tax',i)=	sam('tax',i)/10000;

DISPLAY 	SAM;

*----------------------------------------------*
*==definition  of benchmark parameters
*----------------------------------------------*
parameters
*==parameters to extract the benchmark
			int0           intermediate inputs
			fact0          factor inputs to industry sectors
			tax0           net tax payments to industry sectors
			tx0            tax rate on industry output
			output0        sectoral gross output
			fact           aggregate factor supplies

			inv0           sectoral investment in physical capital
			xinv0          exogenous(negative) sectoral investment in physical capital

			cons0          consumption of conmmodities
			xcons0         exogenous(negative) consumption of commodities

			exp0           benchmark commodity exports
			imp0           benchmark commodity imports

			xexp0          exogenous(negative) benchmark commodity exports
			ximp0          exogenous(negative) benchmark commodity imports

			nx0            net commodity exports
			nxf0           net factor exports

*// fixed factor parameters
			theta(x)     	imputed fixed factor share of capital      from GTAP-E
			/coal       0.68
			 Oilgas     0.51
			 mine       0.07
*			 AgriPr		0.28
*      		 FrsPr		0.28
*       		 AnimPr		0.28
*       		 FshPr		0.28
			 gas        0.59
			/
			ffact0       	benchmark fixed factor supply

			xscale 			parameter to scale exogenous endowments	/1/;
*----------------------------------------------*
*// calibrate benchmark quantities
*----------------------------------------------*
			int0(i,j)   = 	sam(i,j);
			fact0(f,j)  = 	sam(f,j);
			ffact0(x)   = 	theta(x)*sam("capital",x);
			fact0("capital",x) =	(1-theta(x))*sam("capital",x);

display 	ffact0,fact0,int0;

*// use two parameter in case there are negative number
			inv0(i)     =	max(0,sam(i,"investment"));
			xinv0(i)    =	min(0,sam(i,"investment"));

			cons0(i)    =	max(0,sam(i,"Household"))+max(0,sam(i,"GOVERNMENT"));
			xcons0(i)   =	min(0,sam(i,"Household"))+min(0,sam(i,"GOVERNMENT"));

			exp0(i)    	=	max(0,sam(i,"export"));
			xexp0(i)    =	min(0,sam(i,"export"));

			imp0(i)    	=	max(0,-sam(i,"import"));
			ximp0(i)    =	min(0,-sam(i,"import"));

			nx0(i)      =	exp0(i)-imp0(i)-(xexp0(i)-ximp0(i));

			output0(i)  =	sum(j,sam(i,j))+inv0(i)+cons0(i)+nx0(i)+(xinv0(i)+xcons0(i));

			fact(f)     =	sum(j,fact0(f,j));
			
			tax0(j)    	=	sam("tax",j);

display 	inv0,xinv0,cons0,xcons0,nx0,output0,xexp0,exp0,fact,tax0;

*// comvert from tax to tax rate
			tx0(j)$output0(j) =	tax0(j)/output0(j);

display   	tx0;

parameter	etemp energ consumption;
			etemp(e)    =(output0(e)-(nx0(e)+xinv0(e)+xcons0(e)));

*//armington good
parameter a0;
a0(i)     =output0(i)-ximp0(i);
display a0,output0,imp0,ximp0,nx0,inv0,cons0,xinv0,xcons0;


*// calibrate labor input
parameter tlabor_s0(lm)   total labor supply by sub_labor
          tqlabor_s0      total labor supply
          labor_q0(lm,i)
          tlabor_q0;


		tlabor_s0(lm)	=	sum(i,sam("labor",i));
		tqlabor_s0		=	sum(lm,tlabor_s0(lm));

		labor_q0(lm,i)	=	sam("labor",i);
		tlabor_q0(lm)		=	sum(i,sam("labor",i));