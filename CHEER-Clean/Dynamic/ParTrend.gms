$title  trend parameters in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) Read trend  data
2) calibration of benchmark


Revision Logs:
**0317 加入GDP趋势，劳动力趋势
**0131 trend parameters include:
  1)GDP
  2)population
  3)TFP
  4)aeei

Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext
*----------------------------------------------*

*----------------------------------------------*
*// Read trend data
*----------------------------------------------*
*============================macro parameter with trend=========================
Parameter   labor_g     annual labor growth rate  from IIASA SSP1
            /2015   0.0016
            2020    -0.0020
            2025    -0.0067
            2030    -0.0036
            2035    -0.0102
            2040    0.0007
            2045    -0.0009
            2050    -0.0155
            2055    -0.0234
            2060    -0.0232
            2065    -0.0241
            2070    -0.0241
            2075    -0.0274
            2080    -0.0249
            2085    -0.0254
            2090    -0.0246
            2095    -0.0235
            2100    -0.0235
            /;

Parameter   rgdp_g     annual real gdp growth from IIASA SSP1
            /2015   0.1288
            2020    0.0778
            2025    0.0537
            2030    0.0423
            2035    0.0222
            2040    0.0199
            2045    0.0102
            2050    0.0097
            2055    0.0044
            2060    0.0043
            2065    0.0003
            2070    0.0003
            2075    -0.0025
            2080    -0.0025
            2085    -0.0050
            2090    -0.0052
            2095    -0.0086
            2100    -0.0090
            /;

Parameter   rgdp_b         real gdp pathway according to SSP1
            rgdp_m         real gdp pathway according to the model
            rgdp0          benchmark real gdp
            TFP_b          productivity index pathway
            TFP0           benchmark productivity index
            ls_b           labor supply path
            ls0            benchmark labor supply
            aeei           auto energy effiency index;

            rgdp0           =   sum(i,cons0(i))+(sum(i,inv0(i)))+sum(i,nx0(i)+xinv0(i)+xcons0(i));
            loop(t,
            rgdp_b(t)$(ord(t) eq 1)      =   rgdp0;
            rgdp_b(t)$(ord(t) eq 2)      =   rgdp0*(1+rgdp_g(t))**3;   
            rgdp_b(t+1)$(ord(t) ge 2)    =   rgdp_b(t)*(1+rgdp_g(t+1))**5;
            );

*// assume the annual growth rate of tfp is 5%
            TFP0        =     1;
            loop(t,
            TFP_b(t)$(ord(t) eq 1)      =   TFP0;
            TFP_b(t)$(ord(t) eq 2)      =   TFP0*(1+0.05)**3;   
            TFP_b(t+1)$(ord(t) ge 2)    =   TFP_b(t)*(1+0.05)**5;
            );

            ls0             =   sum(lm,tlabor_s0(lm));

            aeei(i)         =   1;
            aeei("fd")      =   1;

Parameter   clim_b      CO2 emission pathway;

*// assume the co2 emission grow by 5% each year before 2030 and reduce by 10% each year after 2030
            clim0 =     1;           
            loop(t,
            clim_b(t)$(ord(t) eq 1)      =   clim0;                 
            clim_b(t)$(ord(t) eq 2)      =   clim0*(1+0.05)**3;
            clim_b(t+1)$(ord(t) ge 2 and ord(t) le 4)      =   clim_b(t)*(1+0.05)**5;            
            clim_b(t+1)$(ord(t) ge 5)    =   clim_b(t)*(1-0.1)**5;
            );