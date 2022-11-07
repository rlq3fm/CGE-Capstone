$title  electricity sector in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read electricity data
2) calibration of benchmark
3) covert from value unit (Yuan) to physical unit (GWh)
4) calibration of substitution elasticities between fixed factor and other inputs for elecpower

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*
*==Read electricity data
*----------------------------------------------*
Parameter  sam_elec(*,*) input data of sub-electricity sectors
;
$GDXIN    %DataPath%\data.gdx
$LOAD     sam_elec

*----------------------------------------------*
*==calibration of benchmark
*----------------------------------------------*

*=== transfer unit from 10 thousand yuan to 0.1 billion yuan
            sam_elec(i,sub_elec)=sam_elec(i,sub_elec)/10000;
            sam_elec(f,sub_elec)=sam_elec(f,sub_elec)/10000;
            sam_elec('tax',sub_elec)=sam_elec('tax',sub_elec)/10000;

parameter
         ffshr           Fraction of electric sector capital as fixed factor
         lelec0          Labor in electricity generation
         kelec0          Capital in electricity generation
         ffelec0         Fixed factor in electricity generation
         intelec0        Intermediate input to electricity generation
         taxelec0        Tax cost in electricity generation
         subelec0        Total subsidy in billion yuan
         outputelec0     Output of electricity generation
         Toutputelec0    Total Output of electricity generation
         subelec_b       Benchmark for electricity subsidy
         ;

*// block for markup factor; do not work if emkup=1;
parameter
          emkup           electricity markup
          emkup0          base year electricity markup;

          emkup(sub_elec)       =      1;
          emkup0(sub_elec)      =      emkup(sub_elec);

          lelec0(sub_elec)      =       sam_elec("labor",sub_elec)/emkup(sub_elec);
          kelec0(sub_elec)      =       sam_elec("capital",sub_elec)/emkup(sub_elec);
          intelec0(i,sub_elec)  =       sam_elec(i,sub_elec)/emkup(sub_elec);
          taxelec0(sub_elec)    =       sam_elec("tax",sub_elec);

*// fixed factors for elecpower
*==to be updata
parameter theta_elec(sub_elec)     imputed fixed factor share of capital      from Sue Wing 2006
          p_ff            proportion of fix-factor£»

table ff_data(*,*) cost structure from Sue Wing
                 hydro      nuclear    Wind       Solar      Biomass
labor            24         13         17         7          19
capital          56         60         64         73         59
ff               19         27         20         20         22
;
            theta_elec(sub_elec)    =0;
            theta_elec(sub_elec)$ff_data("ff",sub_elec)
                                    = ff_data("ff",sub_elec)/(ff_data("ff",sub_elec)+ff_data("capital",sub_elec));
*// split fixed factors from capital
            ffelec0(sub_elec)       =    0;
            ffelec0(sub_elec)       =    theta_elec(sub_elec)*kelec0(sub_elec);
            kelec0(sub_elec)        =   (1-theta_elec(sub_elec))*kelec0(sub_elec);

display     taxelec0,ffelec0;

*----------------------------------------------*
*// bleck for tax and subsidy
*----------------------------------------------*
parameter   q_gen(*)    data for power generation by technology in GWh from Stats
            subsidy(*)  total value of subsidy by technologies  in  10 thousand yuan
            P_elec(*)   Feed in tariff Price Yuan per kwh Source Qi 2014 Energy Policy;
$GDXIN     %DataPath%\electricity_%ExpPath%_%datagg%.gdx         
$LOAD       q_gen subsidy P_elec
$GDXIN

*// convert subsidy from 10 thousand yuan to 0.1 billion yuan
            subelec0(sub_elec) =    subsidy(sub_elec)/10000;

*// update the gross tax = net tax + subsidy
            taxelec0(sub_elec) =   taxelec0(sub_elec)
                                   + subelec0(sub_elec)  ;

display     subelec0, taxelec0;

*//update outputelec0
            outputelec0(sub_elec)   =   emkup(sub_elec)*(lelec0(sub_elec)+kelec0(sub_elec)
                                        +ffelec0(sub_elec)+sum(i,intelec0(i,sub_elec)))
                                        +(taxelec0(sub_elec)-subelec0(sub_elec));

            Toutputelec0            =   sum(sub_elec,outputelec0(sub_elec));


*//convert tax value to tax rate
parameter txelec0  tax rate for subelec
          sbelec0  subsidy rate for subelec;

            txelec0(sub_elec)$outputelec0(sub_elec)    =   taxelec0(sub_elec)/outputelec0(sub_elec);
            sbelec0(sub_elec)$outputelec0(sub_elec)    =   subelec0(sub_elec)/outputelec0(sub_elec);

            subelec_b(sub_elec)     =   sbelec0(sub_elec);
            p_ff(sub_elec)          =   emkup(sub_elec)*ffelec0(sub_elec)/((1-txelec0(sub_elec))*outputelec0(sub_elec));

*// key debug points=======
*emarkup

            fact('capital')         =   fact('capital')-sum(sub_elec,ffelec0(sub_elec)*emkup(sub_elec));

*----------------------------------------------*
*// covert from value unit (Yuan) to physical unit (GWh)
*----------------------------------------------*
*convert q from MWh to GWh
            q_gen(sub_elec)    =    q_gen(sub_elec)/1000;

display     q_gen;

*// transfer elecoutput from value to physical in TWH
parameter   costelec0(sub_elec) unit generation cost by technomogy in 0.1 billion yuan per TWH;

            costelec0(sub_elec)     =   outputelec0(sub_elec)/q_gen(sub_elec)*1000;

            outputelec0(sub_elec)   =   q_gen(sub_elec)/1000;

*// set emission for electricity sector
parameter   emissionelec0(*,*,*,*)  electricity emission by source ;

            emissionelec0('co2','e',fe,sub_elec)    =   ccoef_p(fe)*intelec0(fe,sub_elec)*(1-r_feed(fe,"elec"));

*//EPPA 6 elecpower substitution elasticity between fixed factor and other inputs
            esub(sub_elec,"ff")     =   0.2;
            esub("nuclear","ff")    =   0.6*p_ff("nuclear")/(1-p_ff("nuclear"));
            esub("hydro","ff")      =   0.5*p_ff("hydro")/(1-p_ff("hydro"));
            esub("wind","ff")       =   0.25;

display     costelec0,outputelec0,esub,emissionelec0, esub;
