$title  elasticity in China Hybrid Energy and Economics Research (CHEER) Model

$Ontext
1) substitution elasticities in the production blocks
2) supply elasticities for factors

based on 2012 data
Author:Yaqian Mu, Tsinghua University (muyaqian00@163.com)
UpDate:    12-2016
$offtext

*----------------------------------------------*
*==substitution elasticities
*----------------------------------------------*

*==subsititution elasticities from Ke Wang
table esub(*,*)     elasticity of substitution in the production functions
		Elec	Coal	Oilgas	Roil	Gas	Agri	Mine	PapMfg	CheMfg	CMMfg	IST	NFM	MetalPr	GenEqp	TransEqp	ElecEqp	OthMfg	Constr	AirTran	OthTran	RD	Service
TOP		0		0		0		0		0	0		0		0		0		0		0	0	0		0		0			0		0		0		0		0		0	0
NR		0.3		0.5		0.5		0.3		0.5	0.3		0.3		0.3		0.3		0.3		0.3	0.3	0.3		0.3		0.3			0.3		0.3		0.3		0.3		0.3		0.3	0.3
IT		0		0		0		0		0	0.7		0		0		0		0		0	0	0		0		0			0		0		0		0		0		0	0
KLE		0.1		0.8		0.8		0.8		0.8	0.6		1		1		1		1		1	1	1		1		1			1		1		1		1		1		1	1
KL		1		1		1		1		1	1		1		1		1		1		1	1	1		1		1			1		1		1		1		1		1	1
E		0.5		0.5		0.5		0.5		0.5	0.5		0.5		0.5		0.5		0.5		0.5	0.5	0.5		0.5		0.5			0.5		0.5		0.5		0.5		0.5		0.5	0.5
NELE	1		1		1		1		1	1		1		1		1		1		1	1	1		1		1			1		1		1		1		1		1	1
;

table esub(*,*)  elasticity of substitution in the production functions transposed to run properly in Rivanna
            TOP     NR      IT      KLE     KL      E       NELE
Elec        0       0.3     0       0.1     1       0.5     1
Coal        0       0.5     0       0.8     1       0.5     1
Oilgas      0       0.5     0       0.8     1       0.5     1
Roil        0       0.3     0       0.8     1       0.5     1
Gas         0       0.5     0       0.8     1       0.5     1
Agri        0       0.3     0.7     0.6     1       0.5     1
Mine        0       0.3     0       1       1       0.5     1
PapMfg      0       0.3     0       1       1       0.5     1
CheMfg      0       0.3     0       1       1       0.5     1
IST         0       0.3     0       1       1       0.5     1
NFM         0       0.3     0       1       1       0.5     1
MetalPr     0       0.3     0       1       1       0.5     1
GenEqp      0       0.3     0       1       1       0.5     1
TransEqp    0       0.3     0       1       1       0.5     1
ElecEqp     0       0.3     0       1       1       0.5     1
OthMfg      0       0.3     0       1       1       0.5     1
Constr      0       0.3     0       1       1       0.5     1
AirTran     0       0.3     0       1       1       0.5     1
OthTran     0       0.3     0       1       1       0.5     1
RD          0       0.3     0       1       1       0.5     1
Service     0       0.3     0       1       1       0.5     1
;

*esub("TOP",agri)	=	esub("TOP","agri");
*esub("NR",agri)	=	esub("NR","agri");
*esub("IT",agri)	=	esub("IT","agri");
*esub("KLE",agri)	=	esub("KLE","agri");
*esub("KL",agri)	=	esub("KL","agri");
*esub("E",agri)	=	esub("E","agri");
*esub("NELE",agri)	=	esub("NELE","agri");

*esub("TOP","Biofuel")	=	esub("TOP","OthMfg");
*esub("NR","Biofuel")	=	esub("NR","OthMfg");
*esub("IT","Biofuel")	=	esub("IT","OthMfg");
*esub("KLE","Biofuel")	=	esub("KLE","OthMfg");
*esub("KL","Biofuel")	=	esub("KL","OthMfg");
*esub("E","Biofuel")	=	esub("E","OthMfg");
*esub("NELE","Biofuel")	=	esub("NELE","OthMfg");

*== SWITCH POSITIONS TO CORRESPOND TO TRANSPOSED TABLE
esub(agri,"TOP") = esub("agri","TOP")
esub(agri, "NR",) = esub("agri","NR",);
esub(agri,"IT")    =   esub("agri","IT");
esub(agri,"KLE")   =   esub("agri","KLE");
esub(agri,"KL")    =   esub("agri","KL");
esub(agri,"E") =   esub("agri","E");
esub(agri,"NELE")  =   esub("agri","NELE");


parameter
           esub_inv     elasticity of substitution among inputs to investment
           esub_c       elasticity of substitution among inputs to consumption
           esub_wf      elasticity of substitution of investment and consumption in the welf function
;

			esub_c("TOP")     	=	0.25 ;
			esub_c("NE")     	=	0.3 ;
			esub_c("E")     	=	0.4 ;

			esub_inv   =	5;

*//wangke=1；EPPA=0
			esub_wf    =	0;

*==electricity sector
*==substitution elasticity between fixed factor and other inputs is calibrated in electricity block
*parameter   enesta   substitution elasticity between different sub_elec    from EPPA 6; enesta=1.5;

parameter   esub_gt 	substitution elasticity between generation and T&D
            esub_pe   	substitution elasticity between peak load technologies
            esub_be   	substitution elasticity between base load technologies
;
			esub_gt		=	0;
			esub_pe		=	1.5;
			esub_be		=	1.5;

table 	esub_elec(*,*)   substitution elasticity in electricity sector
        T_D         Coal_Power         Gas_Power         Oil_Power         Nuclear         Hydro         Wind         Solar         Biomass
NR                                                                         0.6             0.5           0.25         0.2           0.2
*NR                                                                         0.2             0.2           0.1         0.2           0.1
IT       0              0                  0                 0             1               1             1            1             1
KLE                     0.1                0.1               0.1
KL                      1                  1                 1             1               1             1            1             1
E                       1.5                1.5               1.5

;
*// labor market
parameter 	esub_LabDist  	substitution elasticity in the CET founction to allocate labor among sectors
          	esub_l        	substitution elasticity between different labor inputs ;

			esub_LabDist(lm) 	= 	1;
			esub_l("l")      	= 	1;
			esub_l("ll")		=	1.5;
			esub_l("lh")		=	1.5;


*----------------------------------------------*
*// supply elasticities
*----------------------------------------------*
parameter
			eta           	fixed factor supply elasticity;

			eta("coal") 		=	2.0;
			eta("Oilgas")		=	1.0;
			eta("agri")			=	0.5;
			eta("mine")			=	2.0;
			eta("gas")			=	1.0;
			eta("elec")			= 	1.0;

			eta("biomass")		=	0.5;
			eta("hydro")		=	0.1;
			eta("wind")			=	1.5;
			eta("solar")		=	1.5;
			eta("nuclear")		=	0.5;
