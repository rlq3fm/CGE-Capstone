$title  emission data in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) GHG emission
2) Air pollutants emission is not considered in this version of model

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*
*----------------------------------------------*
*==sets for emission
*----------------------------------------------*
sets
      ef  effluent categories /CO2/

      ghg(ef) greenhouse gases /CO2/

      pollutant /CO2/
      Pitem pollutant items /
                             e emission
                             g generation
                             a abatement/
      Psource /
              coal from coal conbustion
              roil from refined oil conbustion
              gas  from gas conbustion
              process from production process/
      ;

*----------------------------------------------*
*==read emission data from gdx
*----------------------------------------------*
Set        fuel fossul fuel source /coal, oil, gas/;
set        mapif(fuel,fe) maping from sectors to fuel/
           Coal    .    Coal
           Oil     .    Roil
           Gas     .    Gas/
           ;
parameter
           Emission(fuel)           China total CO2 emission from the combustion of fuel in 2012 in 100 million tonnes CO2 equivalent
           C(fuel)                  Carbon intensity per unit of energy released from the combustion of fuel    in 100 Million tonnes carbon per EJ
           eet                      The quantity of fuel combustion in China in 10 000 tce according to coal equivalent calculation(Mt)
           emissionfactor(fuel)     Emission factor by fuel  (100 million tonnes CO2 equivalent per 10 thousand Yuan Input)
           CO2at                    Aggregated co2 emission (100 million tonnes CO2 equivalent)
           Sat_feedstock            Feedstock rate for aggregated sectors;

$GDXIN    %DataPath%\CO2_%ExpPath%_%datagg%.gdx
$LOAD     CO2at emissionfactor Sat_feedstock Emission  C  eet
$GDXIN

*==parameters for emission accounts
parameter
          ccoef_pro                        carbon coefficient of process (T per yuan)
          ccoef_P                          carbon coefficient of production(T per yuan)
          ccoef_h                          carbon coefficient of consumption(T per yuan)
          r_feed                           share of energy input use as feedstock in specific sectors
          emission0(pollutant,pitem,*,*)   sectoral emission by source (0.1 Billion tonnes CO2 equivalent )
          Temission0                       Total emission by sector (0.1 Billion tonnes CO2 equivalent )
          Temission1                       Total emission by fuel (0.1 Billion tonnes CO2 equivalent )
          Temission2                       total emission (0.1 Billion tonnes CO2 equivalent )
          ;

          ccoef_P(fe)   = sum(fuel$mapif(fuel,fe), emissionfactor(fuel))/10*10**5;
          ccoef_h(fe)   = ccoef_P(fe);
          r_feed(fe,i)  = Sat_feedstock(fe,i);

          emission0('co2','e',fe,i)=ccoef_p(fe)*int0(fe,i)*(1-r_feed(fe,i));
          emission0('co2','e',fe,'fd')=ccoef_h(fe)*cons0(fe);

*==CO2 emission from cement Production from Liu, Zhu. Unit: 0.1 billion T
          emission0('co2','e','process',i)$Switch_pc(i)=6.838308725;

          ccoef_pro(i)=emission0('co2','e','process',i)/output0(i);

display   emission0, ccoef_p,ccoef_h,ccoef_pro, r_feed;


*==emission account
          Temission0('co2',i)=sum(fe,emission0("co2","e",fe,i))+emission0('co2','e','process',i);
          Temission0('co2','fd')=sum(fe,emission0('co2','e',fe,'fd'));

          Temission1('co2')=sum(i,Temission0('co2',i))+Temission0('co2','fd');
          
          Temission2('co2')=sum((i,fe),emission0("co2","e",fe,i))+sum(i,emission0('co2','e','process',i))+sum(fe,emission0("co2","e",fe,"fd"));

display   Temission0,Temission1,Temission2;
