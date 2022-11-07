$Title           Run CHEER model
*=============================================================================
$ontext
This file is wrote to link all the files of CHEER model and run the simulation
*check before run

*===========labor============
*rigid wage?  ---core
*labor type   ---labor market
*labor q or v?   ---labor market
*umemployment  ---core
*labor structure ---dynamic

*===========learning curve===
*--- dynamic

*===========renewable========
*fixed subsidy? exogenous subsidy? renewable quota?

*===========emission cap========
*the quantity of emission cap
*the coverage of sectors

By Yaqian Mu
Please send comments to muyaqian13@gmail.com
January 2017
$offtext

*========Path Variable========
$if not set CalPath $set CalPath code
$if not set DataPath $set DataPath data
$if not set ModPath $set ModPath model
$if not set DynPath $set DynPath dynamic
$if not set RepPath $set RepPath report
$if not set OutPath $set OutputPath Output
$if not set SimPath $set SimPath Experiment

$if not set ExpPath $set ExpPath TR
*$if not set ExpPath $set ExpPath experiment


parameter Switch_labor(*) switch for labor aggregation ;
Switch_labor("gender")=0;
Switch_labor("region")=0;
Switch_labor("education")=1;

*== bridge variable for labor aggregation
$if not set Labagg $set labagg

*== bridge variable for data aggregation
*$if not set datagg $set datagg output
*gas is split from oilgas
$if not set datagg $set datagg oilgas

*== bridge variable for model choice
*$if not set modstr $set modstr _Developing
$if not set modstr $set modstr _Developing_arminton

*== bridge variable for simulation choice
$if not set simsce $set simsce _RE

*========workflows========
*== definition of sets
$include %CalPath%/sets%labagg%

*========Switch variable========
parameter Switch_feed switch for feedstock ;
Switch_feed=1;

parameter Switch_learn switch for learning effect ;
Switch_learn=1;

parameter Switch_pc switch for process co2 emission ;
Switch_pc(i)=0;
Switch_pc("CMMfg")=1;

*== in the data process to change the feed stock rate
*parameter Switch_feed switch for feedstock ;

*// read data from xlxs

*parameter sam(*,*)
*                  sam_elec(*,*);
*$CALL GDXXRW.EXE %DataPath%\data.xlsx o=%DataPath%\data.gdx par=sam rng=IO!A1:AH31 par=sam_elec rng=elec!A1:J31
*$gdxin %DataPath%\data.gdx
*$load sam, sam_elec


*== data and calibration
$include %CalPath%/cal
$include %CalPath%/elasticities
$include %CalPath%/emission
$include %CalPath%/electricity
$include %CalPath%/ParShock
$include %DynPath%/ParTrend

*// core model
$include %ModPath%/core%modstr%


*========static simulation========
*$include %SimPath%/Sim_Test

*========dynamic simulation========
$include %DynPath%/dyncal

*======= BAU simulation
$include %DynPath%/dynamic_BAU

*=======Policy simulation
*$include %DynPath%/dynamic_cer
