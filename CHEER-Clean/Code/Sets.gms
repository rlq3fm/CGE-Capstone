$title Sets for China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
$offlisting
$offsymxref

*----------------------------------------------*
*==sets for sectors
*----------------------------------------------*
SETS
    s  all labels in SAM
      /Elec
       Coal
       Oilgas
       Roil
       Gas
       AgriPr
       FrsPr
       AnimPr
       FshPr
       OthAgri
       Mine
       PapMfg
       CheMfg
       CMMfg
       IST
       NFM
       MetalPr
       GenEqp
       TransEqp
       ElecEqp
       Biofuel
       OthMfg
       Constr
       AirTran
       OthTran
       RD
       Service

       fd

       Labor "Labour"
       capital "Physical capital"

       Household,GOVERNMENT,INVESTMENT,export,import
       /

    i(s) commodities in SAM table(produced goods represented by sector name
      /Elec
       Coal
       Oilgas
       Roil
       Gas
       AgriPr
       FrsPr
       AnimPr
       FshPr
       OthAgri
       Mine
       PapMfg
       CheMfg
       CMMfg
       IST
       NFM
       MetalPr
       GenEqp
       TransEqp
       ElecEqp
       Biofuel
       OthMfg
       Constr
       AirTran
       OthTran
       RD
       Service
       /

*// subset for specific sector groups 
    e(i)    energy supply sectors
      /Elec,Coal,Roil,Gas/

    fe(i)   fuel energy supply sectors
      /Coal,roil,gas/

    x(i)    exhaustible resource sectors
*      /AgriPr,FrsPr,AnimPr,FshPr,coal,Oilgas,Mine,gas/
      /coal,Oilgas,Mine,gas/
    elec(i) electrici power sector
      /elec/

    ist(i)  ist sector
      /ist/

    cm(i)   sectors selected in carbon market
      /roil,elec,PapMfg,CheMfg,CMMfg,IST,NFM,AirTran/

    agri(i)  agriculture and non-energy mine
      /AgriPr,FrsPr,AnimPr,FshPr,OthAgri/

alias (i,j),(e,ee),(fe,fee);
*----------------------------------------------*
*==sets for factors and final demands
*----------------------------------------------*
sets
    f(s)    primary factors
    /Labor  "Labour"
    capital "Physical capital"/

    lab(f)  labor 
    /labor/

    fd(s)   final demands 
    /Household,GOVERNMENT,INVESTMENT,export,import/

    h(fd)   households 
    /Household,GOVERNMENT/
    ;

*----------------------------------------------*
*==sets for dynamic process
*----------------------------------------------*
sets
    yr      time in years   /2005*2100/
    t(yr)   time in 5 years periods   /2012,2015,2020,2025,2030,2035,2040,2045,2050/
*                                     2055,2060,2065,2070,2075,2080,2085,2090,2095,2100/
    baseyear(yr) baseyear   /2012/
    year years within each time period  /1*5/
;

*----------------------------------------------*
*==sets for disaggregated electricity sector
*----------------------------------------------*
set      sub_elec       /T_D, Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Wind, Solar, Biomass/
         TD(sub_elec)   transport and distribution /T_D/
         gen(sub_elec)  /Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Wind, Solar, Biomass/
         bse(sub_elec)  base load electricity /Coal_Power, Gas_Power, Oil_Power, Nuclear, Hydro, Biomass/
         ffe(sub_elec)  fossil fuel electricity /Coal_Power, Gas_Power, Oil_Power/
         cge(sub_elec)  fossil fuel electricity /Coal_Power, Gas_Power/
         cfe(sub_elec)  carbon free electricity /Nuclear, Hydro, Wind, Solar, Biomass/
         hnb(sub_elec)  hydro and nuclear biomass electricity /Nuclear, Hydro,Biomass/
         wse(sub_elec)  wind and solar /Wind, Solar/
         hne(sub_elec)  hydro and nuclear electricity /Nuclear, Hydro/
         wsb(sub_elec)  wind and solar biomass/Wind, Solar, Biomass/;

alias   (sub_elec,sub_elecc),(gen,genn);

*----------------------------------------------*
*==sets for disaggregated IST sector
*----------------------------------------------*
set     sub_ist /BOF,EAF/

alias   (sub_ist,sub_istt);

*----------------------------------------------*
*==sets for Backstop technologies
*----------------------------------------------*
set bt  /ngcc,ngcap,igcap,BOFA,EAFA,DRP/
    bt_elec(bt) /ngcc,ngcap,igcap/
    ngcap(bt_elec) /ngcap/
    bt_ist(bt)  /BOFA,EAFA/;

*----------------------------------------------*
*==sets for labor market
*----------------------------------------------*
set lmo original labor type /
        L1              LabMUUL
        L2              LabMUES
        L3              LabMUMS
        L4              LabMUHS
        L5              LabMUJC
        L6              LabMURC
        L7              LabMUPG
        L8              LabMRUL
        L9              LabMRES
        L10             LabMRMS
        L11             LabMRHS
        L12             LabMRJC
        L13             LabMRRC
        L14             LabMRPG
        L15             LabFUUL
        L16             LabFUES
        L17             LabFUMS
        L18             LabFUHS
        L19             LabFUJC
        L20             LabFURC
        L21             LabFUPG
        L22             LabFRUL
        L23             LabFRES
        L24             LabFRMS
        L25             LabFRHS
        L26             LabFRJC
        L27             LabFRRC
        L28             LabFRPG/;

*== change here to do other labor aggregation
set lm   aggregared labor type
       /labor/;

alias (lm,lmm);

display lm;

set maplmo (lmo,lm) /
              L1      .       labor
              L2      .       labor
              L3      .       labor
              L4      .       labor
              L5      .       labor
              L6      .       labor
              L7      .       labor
              L8      .       labor
              L9      .       labor
              L10     .       labor
              L11     .       labor
              L12     .       labor
              L13     .       labor
              L14     .       labor
              L15     .       labor
              L16     .       labor
              L17     .       labor
              L18     .       labor
              L19     .       labor
              L20     .       labor
              L21     .       labor
              L22     .       labor
              L23     .       labor
              L24     .       labor
              L25     .       labor
              L26     .       labor
              L27     .       labor
              L28     .       labor
                /;
set ll(lm) low level labor type 
      /labor/;

set hl(lm) high level labor type ;

      hl(lm)$(not ll(lm)) = 1;

display ll,hl;
