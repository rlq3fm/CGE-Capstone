using JuMP, Complementarity, DataFrames, CSV
PATHSolver.c_api_License_SetString("2830898829&Courtesy&&&USR&45321&5_1_2021&1000&PATH&GEN&31_12_2025&0_0_0&6000&0_0")

samList = ["agri", "manu", "serv", "lab", "cap", "tax", "hh", "govt"]
sector = ["agri", "manu", "serv"]
sectors = collect(1:1:length(sector))
household = ["hh"]
households = collect(1:1:length(household))
va = ["lab","cap","tax"]
va_indx = [4,5,6]
cap_lab_indx = [4,5]
cap = 4
lab = 5
tax = 6
NumSector = length(sectors)
NumHouseholds = length(households)
samdir = joinpath(@__DIR__, "data", "cge6.csv")
sam = Array(CSV.read(samdir, DataFrames.DataFrame, header=1))

#
# Bill's translation of China variables to a more understandable (for him) variable set
#   see Textbook of Computable General Equilibrium Modeling

# 1.0 calibrate model
X0 = sam[sectors, sectors]               # goods production i/o matrix
F0 = sam[cap_lab_indx, sectors]          # factor payments in sam
Y0 = sum(F0,dims=1)                      # sum of factor payments by sector
Z0 = Y0 + sum(X0,dims=1)                 # total payments to intermediate inputs and factors -> total 
Xp0 = sam[sectors,7]                     # HH payments to sectors in sam
Xg0 = sam[sectors,8]                     # Govt payments to sectors in sam

FF0 = sum(sam[7,cap_lab_indx])           # total HH factor income in sam
Q0 = Xp0 + Xg0 + sum(X0,dims=2)          # Total production by sector 
alpha = Xp0 ./ sum(Xp0)                  # share of HH expenditures on each good as a fraction of total expenditures 
beta = F0 ./ Y0                          # factor payment as share of total factor payments by sector
ay = Y0 ./ Z0                            # composite factor input requirement coefficient ##fixed constant
ax = X0 ./ (sum(X0, dims=1))             # intermediate input requirement coefficient ##fixed constant
#b = Y0 ./ prod(F0.**beta,dims=1)

# Now back to the original cge variables
l0 = sam[lab, sectors]          # factor payments to labor 
k0 = sam[cap, sectors]          # factor payments to capital
ls = sum(l0)                    # total labor income in sam
ks = sum(k0)                    # total capital income in sam
kl0 = k0 + l0                   # total factor income in sam by sector
ak = k0 ./ kl0                  # capital share of total factor income
al = l0 ./ kl0                  # labor share of total factor income

qint0 = sam[sectors, sectors]            # i/o matrix
int0 = sum(X0, dims=1)[1, :]             # total expenditures on intermediate goods by sector
aqint = X0 ./ (sum(X0, dims=1))          # intermediate input requirement coefficient (same as ax)

prod0 = int0 + kl0 + sam[tax, sectors]   # same as Q0, total expenditure by sector (same as total income)
pprod0 = 1 .- sam[tax,sectors] ./ prod0  # 

aint = int0 ./ prod0                     # intermediate input expenditures as shares of total production by sector 
akl = kl0 ./ prod0                       # factor payments as shares of total production by sector

# income block
transfr = sam[7, 8]                      # transfer from Govt to HH
inch0 = ks + ls + transfr                # total HH income
taxh = sam[8, 7] / inch0                 # tax as a fraction of total income

dinch0 = inch0 * (1 - taxh)              #disposable income

prodtr = sam[tax, sectors]./ prod0       # tax as a fraction of total production
# pprod0 = 1 ./ (1 .+ prodtr)

incg0 = taxh * inch0 + sum(sam[6,sectors])  # total income to government HH tax rate * income plus taxes paid by each sector
consg0 = sam[sectors, 8]                    # govt consumption by sector
thetag = consg0 ./ (incg0-transfr)          #sector share of total government revenue - transfer payments to households

rho = 0.6   

# Household consumption function coefficients
thetah = Xp0 ./ dinch0                  # share of each sector in total disposable income

# 3.0 Elasticities
sigmap = [0,0,0]
sigmakl = [0.6, 0.6, 0.6]

# 4. Generate CGE Model
function solve_cge()  
    m = MCPModel()
    pl = 1 # exogenous setting of labor price as one
    @variables m begin
        pprod[i = sectors], (start = pprod0[i]) # production cost of each sector
        pprodt[i = sectors], (start = 1)  # production cost by adding tax
        pk, (start = 1) # price of capital
        pint[i = sectors], (start = 1) # price of aggregated intermediate goods
        pkl[i = sectors], (start = 1) # price of capital-labor bundle
        prod[i = sectors], (start = prod0[i]) # production lelve of each sector
        int[i = sectors], (start = int0[i]) # amount of aggregated intermediate goods
        kl[i = sectors], (start = kl0[i]) # capital-labor bundle
        k[i = sectors], (start = k0[i]) # capital bundle
        l[i = sectors], (start = l0[i]) # labor bundle
        qint[j = sectors, i = sectors], (start = qint0[j, i]) # segmented intermediate goods
        consh[i = sectors], (start=consh0[i]) # consumption of households
        inch, (start=inch0) # income of households 
        dinch, (start=dinch0) # disposable income of households
        incg, (start=incg0) # income of governments
        expg, (start=incg0) # expenditure of governments
        consg[i = sectors], (start=consg0[i]) # consumption of government
        walras, (start = 0) # walras variable for testing the balance
        # gdp, (start=y0)
        # pgdp, (start=1)
    end

    # int + kl = prod
    # intermediate inputs are constant shares of total production
    @mapping(m, eq_int[i in sectors], int[i]  - aint[i] * prod[i]) #int[i] = aint[i]*prod[i] supply =demand
    @complementarity(m, eq_int, int)

    # composite capital labor bundle is a constant share of total production
    @mapping(m, eq_kl[i in sectors], kl[i] - akl[i] * prod[i] )
    @complementarity(m, eq_kl, kl)

    # total pre-tax payments to intermediate goods and factors is pprod
    @mapping(m, eq_pprod[i in sectors], aint[i] * pint[i] + akl[i] * pkl[i]  - pprod[i] )
    @complementarity(m, eq_pprod, pprod)
    
    # pprodt is the pre-tax production total
    @mapping(m, eq_pprodt[i in sectors], pprod[i]/(1 - prodtr[i]) - pprodt[i])
    @complementarity(m, eq_pprodt, pprodt)

    # k + l = kl
    # capital share in total factor payments is constant
    @mapping(m, eq_k[i in sectors], k[i] * pk ^ sigmakl[i] - ak[i] * kl[i] * pkl[i] ^ sigmakl[i])
    @complementarity(m, eq_k, k)

    # labor share in total factor payments is constant
    @mapping(m, eq_l[i in sectors], l[i] * pl ^ sigmakl[i] - al[i] * kl[i] * pkl[i] ^ sigmakl[i])
    @complementarity(m, eq_l, l)

    # the price of the capital-labor bundle must be consistent with the fixed capital and labor shares of factor income
    @mapping(m, eq_pkl[i in sectors], ak[i] * pk ^ (1- sigmakl[i]) + al[i] * pl ^ (1 - sigmakl[i]) - pkl[i] ^ (1 - sigmakl[i]))
    @complementarity(m, eq_pkl, pkl)

    # qint ++ = int
    # intermediate shares in production are constant
    @mapping(m, eq_qint[j in sectors, i in sectors], qint[j, i] - aqint[j, i] * int[i])
    @complementarity(m, eq_qint, qint)

    @mapping(m, eq_pint[i in sectors], sum(aqint[j, i] * pprodt[j] for j in sectors) - pint[i])
    @complementarity(m, eq_pint, pint)

    # income: household income (inch) as total income to capital and labor plus transfers
    @mapping(m, eq_inch, (pl * ls + pk * ks + transfr) - inch)
    @complementarity(m, eq_inch, inch)

    # disposable income = total income minus taxes paid so income*(1 - taxh)
    @mapping(m, eq_dinch, inch * (1 - taxh) - dinch)
    @complementarity(m, eq_dinch, dinch)

    @mapping(m, eq_incg, inch * taxh + sum(prod[i] *pprodt[i] * prodtr[i] for i in sectors) - incg)
    @complementarity(m, eq_incg, incg)

    # govt income = govt expenditures
    @mapping(m, eq_expg, incg - expg)
    @complementarity(m, eq_expg, expg)

    # the sector share of govt purchases from sectors is constant
    @mapping(m, eq_consg[i in sectors], consg[i] * pprodt[i] - thetag[i] * (expg - transfr))
    @complementarity(m, eq_consg, consg)

    # demand: household demand for each output
    # thetah is a the share of household disposable income spent on each good in the base SAM
    @mapping(m, eq_consh[i in sectors], thetah[i] * dinch - consh[i] * pprodt[i])
    @complementarity(m, eq_consh, consh)

    # demand = supply market clearing condition
    # output of each good = household (final) demand + govt demand + intermediate demand by firms
    @mapping(m, eq_prod[i in sectors], prod[i] - (consh[i] + consg[i] + sum(qint[i, j] for j in sectors)))
    @complementarity(m, eq_prod, prod)

    # factor supply market clearing condition 
    # total supply of k = sum of demand for k by firms
    @mapping(m, eq_pk, ks - sum(k[i] for i in sectors))
    @complementarity(m, eq_pk, pk)

    # total supply of l = sum of demand for l by firms
    @mapping(m, eq_pl, ls + walras - sum(l[i] for i in sectors))
    @complementarity(m, eq_pl, walras)

    # Model Solver
    status = solveMCP(m; convergence_tolerance=1e-8, output="yes", time_limit=600)
    @show result_value.(pk)
    @show result_value.(prod)
    @show result_value.(consh)
    @show result_value.(walras)
end

solve_cge()

ls = sum(l0) * 6
ks = sum(k0) * 10
solve_cge()
