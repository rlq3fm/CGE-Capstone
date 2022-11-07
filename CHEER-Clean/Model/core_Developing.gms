*----------------------------------------------*
*1206, to build the basic model for employment analysis
*0723, add backstop technologies for elec and ist
*1128，modify CHEER based on EPPA
*201712, use individual production functions for labor allocation and co2 constrains
*----------------------------------------------*

$ONTEXT
$Model:CHEER

$Sectors:
y(i)                   !activity level for domestic production

consum                 !activity level for aggregate consumption
invest                 !activity level for aggregate physical capital investment
welf                   !activity level for aggregate welfare

yelec(sub_elec)        !Activity level for electricity production

l_s(lm)                !Activity level for labor allocation
l_a(i)$(not elec(i))                          !Activity level for labor aggregation
l_elec(sub_elec)

yco2_i(fe,i)$(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))            !energy demand include carbon emission
yco2_h(fe)              !energy demand include carbon emission

$Commodities:
py(i)                  !domestic price inex for goods

py_c(fe,i)$(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))               !domestic price inex for energy goods include carbon emission
py_ch(fe)               !domestic price inex for energy goods include carbon emission

pelec(sub_elec)        !domestic price inex for subelec

pls(lm)                  !domestic price index for labor demand
pl(i)$(not elec(i))                    !domestic price index for aggregated labor demand
pl_ELEC(sub_elec)
plo(lm,i)$(labor_q0(lm,i))                 !domestic price index for labor demand

pk                     !domestic price index for captial

pffact(i)$ffact0(i)                                !domestic price index for fixed factors
pffelec(sub_elec)$ffelec0(sub_elec)                !domestic price index for fixed factors in electric sector

pcons                  !price index for aggregate consumption
pinv                   !price index for aggregate physical capital investment
pu                     !price index for utility

pco2$clim              !shadow value of carbon all sectors covered

$consumers:
ra                     !income level for representative agent

$auxiliary:
sff(x)$ffact0(x)                            !side constraint modelling supply of fixed factor
sffelec(sub_elec)$ffelec0(sub_elec)         !side constraint modelling supply of fixed factors

t_re(sub_elec)$cfe(sub_elec)       !FIT for renewable energy

rgdp                     !real gdp
TFP                    !productivity index

tclim$clim               ! carbon limit all sectors

*// electriricy sector
*// the nested structure of electricity is to be checked
$prod:y(i)$elec(i)   s:esub_gt   a:esub_pe     c(a):esub_be
        o:py(i)                               q:output0(i)
        i:pelec(sub_elec)$TD(sub_elec)        q:outputelec0(sub_elec)     p:(costelec0(sub_elec))
        i:pelec(sub_elec)$ffe(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  c:
        i:pelec(sub_elec)$cfe(sub_elec)       q:outputelec0(sub_elec)     p:(costelec0(sub_elec))  a:

*       Production of T&D electricity
$prod:yelec(sub_elec)$TD(sub_elec) s:esub_elec("IT","T_D")
        o:pelec(sub_elec)        q:(outputelec0(sub_elec))              p:((1-txelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:txelec0(sub_elec)
        i:py(i)$(not e(i))       q:intelec0(i,sub_elec)
        i:py(elec)               q:(intelec0(elec,sub_elec)*aeei("elec"))
        i:py(fe)                 q:(intelec0(fe,sub_elec)*aeei("elec"))
        i:pl_elec(sub_elec)      q:(lelec0(sub_elec)*emkup(sub_elec))
        i:pk                     q:kelec0(sub_elec)


*       Production of fossile fuel electricity
$prod:yelec(sub_elec)$ffe(sub_elec) s:esub_elec("IT",sub_elec)   kle(s):esub_elec("KLE",sub_elec) kl(kle):esub_elec("KL",sub_elec) l(kl):esub_l("l")   ene(kle):esub_elec("E",sub_elec)
        o:pelec(sub_elec)                q:(outputelec0(sub_elec))                 p:((1-txelec0(sub_elec))*costelec0(sub_elec))  a:ra  t:txelec0(sub_elec)
        i:py(i)$(not e(i))               q:(intelec0(i,sub_elec)*emkup(sub_elec))
        i:py(elec)                       q:(intelec0(elec,sub_elec)*aeei("elec")*emkup(sub_elec))
        i:pl_elec(sub_elec)              q:(lelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:pk                             q:(kelec0(sub_elec)*emkup(sub_elec))                         kl:
        i:py_c(fe,"elec")                q:(intelec0(fe,sub_elec)*aeei("elec")*emkup(sub_elec))       kle:

*       Production of non-fossil electricity      va2 from wang ke
$prod:yelec(sub_elec)$cfe(sub_elec)  s:esub_elec("NR",sub_elec) a:esub_elec("IT",sub_elec) va(a):esub_elec("KL",sub_elec) l(va):esub_l("l")
        o:pelec(sub_elec)                       q:outputelec0(sub_elec)              p:((1-txelec0(sub_elec)+sbelec0(sub_elec))*costelec0(sub_elec))   a:ra  N:t_re(sub_elec)
        i:py(i)$(not elec(i))                   q:(intelec0(i,sub_elec)*emkup(sub_elec))                                              a:
        i:py(elec)                              q:(intelec0(elec,sub_elec)*emkup(sub_elec))                                              a:
        i:pl_elec(sub_elec)                     q:(lelec0(sub_elec)*emkup(sub_elec))                      va:
        i:pk                                    q:(kelec0(sub_elec)*emkup(sub_elec))                                                  va:
        i:pffelec(sub_elec)$ffelec0(sub_elec)   q:(ffelec0(sub_elec)*emkup(sub_elec))      P:1

*// other sectors
$prod:y(i)$(not elec(i)) s:esub("TOP",i) a:esub("NR",i) b(a):esub("IT",i)  kle(b):esub("KLE",i) kl(kle):esub("KL",i) e(kle):esub("E",i)  ne(e):esub("NELE",i)
        o:py(i)                             q:(output0(i))                    p:(1-tx0(i))     a:ra    t:tx0(i)
        i:pco2$clim                         q:(emission0("co2","e","process",i))      p:1e-5
        i:pffact(i)$ffact0(i)               q:ffact0(i)                                           a:
        i:py(j)$(not e(j))                  q:int0(j,i)                                         b:
        i:py(fe)                            q:(int0(fe,i)*r_feed(fe,i))                     b:
        i:pk                                q:fact0("capital",i)                              kl:
        i:pl(i)                             q:fact0("labor",i)                                kl:
        i:py(elec)                          q:(int0(elec,i)*aeei(i))                          e:
        i:py_c(fe,i)                        q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))       ne:

*// energy demand include co2 emission
$prod:yco2_i(fe,i)$(int0(fe,i)*aeei(i)*(1-r_feed(fe,i))) s:0
        o:py_c(fe,i)                        q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))
        i:py(fe)                            q:(int0(fe,i)*aeei(i)*(1-r_feed(fe,i)))
        i:pco2$clim                    q:(emission0("co2","e",fe,i)*aeei(i))      p:1e-5

$prod:yco2_h(fe) s:0
        o:py_ch(fe)                         q:(cons0(fe)*aeei("fd"))
        i:py(fe)                            q:(cons0(fe)*aeei("fd"))
        i:pco2$clim                    q:(emission0("co2","e",fe,"fd")*aeei("fd"))      p:1e-5

*// sectoral allocation of labor
$prod:l_s(lm)       t:esub_LabDist(lm)
         o:plo(lm,i)      q:labor_q0(lm,i)
         i:pls(lm)        q:tlabor_q0(lm)

*// aggregation of labor
$prod:l_a(i)$(not elec(i))       l:esub_l("l")
         o:pl(i)                              q:fact0("labor",i)
         i:plo(lm,i)$ll(lm)                   q:labor_q0(lm,i)                           l:
         i:plo(lm,i)$hl(lm)                   q:labor_q0(lm,i)                           l:

$prod:l_elec(sub_elec)       l:esub_l("l")
         o:pl_elec(sub_elec)                  q:(lelec0(sub_elec)*emkup(sub_elec))
         i:plo(lm,"elec")$ll(lm)              q:(lelec0(sub_elec)*emkup(sub_elec))          l:
         i:plo(lm,"elec")$hl(lm)              q:(lelec0(sub_elec)*emkup(sub_elec))          l:

*//        consumption of goods and factors    based on EPPA
$prod:consum   s:esub_c("TOP")  a:esub_c("NE") e:esub_c("E") roil(e):0 coal(e):0 gas(e):0
         o:pcons                  q:(sum(i,cons0(i)))
         i:py(i)$(not e(i))       q:cons0(i)                a:
         i:py(i)$(elec(i))        q:(cons0(i)*aeei("fd"))                e:
         i:py_ch(fe)              q:(cons0(fe)*aeei("fd"))                 fe.tl:

*//        aggregate capital investment
$prod:invest     s:esub_inv
         o:pinv            q:(sum(i,inv0(i)))
         i:py(i)           q:inv0(i)

*//        welfare          Ke Wang=1, EPPA=0
$prod:welf    s:esub_wf         a:1
         o:pu                 q:(sum(i,cons0(i)+inv0(i)))
         i:pcons              q:(sum(i,cons0(i)))
         i:pinv               q:(sum(i,inv0(i)))                a:

$demand:ra

*// demand for consumption,invest and rd
d:pu                 q:(sum(i,cons0(i)+inv0(i)))

*endowment of factor supplies

e:pk                     q:fact("capital")                         r:TFP

e:pls(lm)                q:(tlabor_s0(lm))                                                 r:TFP
e:pffact(x)          q:ffact0(x)                 r:sff(x)$ffact0(x)
e:pffelec(sub_elec)  q:(ffelec0(sub_elec)*emkup(sub_elec))         r:sffelec(sub_elec)$ffelec0(sub_elec)

*exogenous endowment of net exports(include variances)

e:py(i)              q:(-(nx0(i)+xinv0(i)+xcons0(i))*xscale)

*endowment of carbon emission allowances
e:pco2$clim                     q:1                        r:tclim


*supplement benchmark fixed-factor endowments according to assumed price elasticities of resource supply

$constraint:sff(x)$ffact0(x)
        sff(x)    =e= (pffact(x)/pu)**eta(x);

$constraint:sffelec(sub_elec)$(ffelec0(sub_elec))
        sffelec(sub_elec) =e=  (pffelec(sub_elec)/pu)**eta(sub_elec);

*// indentification of FIT
$constraint:t_re(sub_elec)$(tax_s(sub_elec) eq 1)
         t_re(sub_elec) =e=     txelec0(sub_elec) -sbelec0(sub_elec);

*//accounting of gdp
$constraint:rgdp
        pu*rgdp =e= pcons*sum(i,cons0(i))*consum
              +pinv*(sum(i,inv0(i)))*invest
              +sum(i,py(i)*((nx0(i)+xinv0(i)+xcons0(i))*xscale));

*//calibration of productivity factors
$constraint:TFP$(simu_s eq 0)
        rgdp =e= rgdp0;

$constraint:TFP$(simu_s ne 0)
        TFP =e= TFP0;

*// total co2 accounting
$constraint:tclim$(clim eq 1)
        pco2 =e=1e-5;

*// national co2 market —— quantity target
$constraint:tclim$(clim eq 2 )
        tclim =l= clim0*temission2("co2");

*// national co2 market —— intensity target
$constraint:tclim$(clim eq 3 )
        tclim =l= clim0*temission2("co2")/rgdp0*rgdp;

*// national co2 market —— recycling to renewables
$constraint:tclim$(clim eq 4)
        pco2*tclim =e=sum(sub_elec,yelec(sub_elec)*outputelec0(sub_elec)*costelec0(sub_elec)*pelec(sub_elec)*(txelec0(sub_elec)-t_re(sub_elec) -subelec_b(sub_elec)));


$report:

v:qdout(j)             o:py(j)       prod:y(j)     !output by sector(domestic market)

v:qc(i)                i:py(i)       prod:consum   !consumpiton of final commodities
v:grosscons            o:pcons       prod:consum   !aggregate consumpiton

v:qinvk(i)             i:py(i)       prod:invest   !physical capital investment by non-energy sectors
v:grossinvk            o:pinv        prod:invest   !aggregate physical capital investment

v:util                 o:pu          prod:welf       !welf

v:qin(i,j)             i:py(i)       prod:y(j)      !inputs of intermediate goods
v:qin_ele(i,sub_elec)  i:py(i)       prod:yelec(sub_elec)      !inputs of intermediate goods to fossil fuel fired generation

v:qein(fe,i)             i:py(fe)       prod:yco2_i(fe,i)      !inputs of fossil energy goods
v:qec(fe)                i:py(fe)       prod:yco2_h(fe)        !consumption of fossil energy goods

v:qkin(j)              i:pk          prod:y(j)        !capital inputs
v:qkin_ele(sub_elec)   i:pk          prod:yelec(sub_elec)        !capital inputs
v:qffin(j)$x(j)        i:pffact(j)   prod:y(j)        !fixed factor inputs
v:qffelec(sub_elec)$cfe(sub_elec)    i:pffelec(sub_elec)     prod:yelec(sub_elec)      !fixed factor inputs

v:qlin(lm,j)           i:plo(lm,j)      prod:l_a(j)        !labor inputs
v:qlin_ele(lm,sub_elec)      i:plo(lm,"elec")      prod:l_elec(sub_elec)        !labor inputs

V:qelec(sub_elec)        o:pelec(sub_elec)       prod:yelec(sub_elec)

v:ECO2(fe,i)              i:pco2        prod:yco2_i(fe,i)
v:Eco2_h(fe)              i:pco2        prod:yco2_h(fe)

v:labors(lm)                i:pls(lm)       prod:l_s(lm)
v:laborss(lm,i)              o:plo(lm,i)        prod:l_s(lm)


$offtext
$sysinclude mpsgeset CHEER

*carbon has zero price in the benchmark

*initialize constraints

        sff.l(x)$ffact0(x)      =       1;
        t_re.l(sub_elec)        =       -sbelec0(sub_elec)+txelec0(sub_elec);
        t_re.lo(sub_elec)       =       -inf;

        pu.fx=1;

        tclim.l                 =       temission2("co2");

        pelec.l(sub_elec)       =       costelec0(sub_elec);

        CHEER.iterlim           =       100000;

$include CHEER.gen

EXECUTE_LOADPOINT 'CHEER_p';
solve CHEER using mcp;

CHEER.Savepoint         =       0;

display CHEER.modelstat, CHEER.solvestat;

