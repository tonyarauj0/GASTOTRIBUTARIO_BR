*DECLARAR PAINEL
xtset reg ano

*DEFINIR REGIOES
label variable reg "Regioes"
label define reg 1 "N" 2 "NE" 3 "CO" 4 "SE" 5 "S"
label values reg reg

*CRIAR AS DUMMIES DE ANO
**ano eleitoral
gen d0=0
replace d0=1 if ano==1998 |ano==2002 |ano==2006 |ano==2010 |ano==2014 |ano==2018
label variable d0 "ano_eleitoral"

**1 ano pos-eleitoral
gen d1=0
replace d1=1 if ano==1999 |ano==2003 |ano==2007 |ano==2011 |ano==2015 |ano==2019
label variable d1 "1ano_pos-eleitoral"

**2 anos pos-eleitoral
gen d2=0
replace d2=1 if ano==1996 |ano==2000 |ano==2004 |ano==2008 |ano==2012 |ano==2016 
label variable d2 "2anos_pos-eleitoral"

**3 anos pos-eleitoral
gen d3=0
replace d3=1 if ano==1997 |ano==2001 |ano==2005 |ano==2009 |ano==2013 |ano==2017 
label variable d3 "3anos_pos-eleitoral"

***dummy para LRF(2002)
gen LRF=0
replace LRF=1 if ano>2001
label variable LRF "Lei_Responsabilidade_Fiscal"

***dummy para crise(2009)
gen crise=0
replace crise=1 if ano==2009
label variable crise "Crise_mundial_2008/09"

*DEFLACIONAR AS VARIAVEIS
*CRIAR DEFLATOR COM BASE NO IGPDI PARA 2018 
gen igpdi18=697.68445
label variable igpdi18 "Valor do IGPDI para o ano de 2018" 
gen igpdibase18=igpdi/igpdi18
label variable igpdibase18 "Mudança da base do IGPDI para 2018" 
*DEFLACIONAR VARIAVEIS

foreach j in cd_101 cd_201 cd_202 cd_203 cd_301 ///
cd_302 cd_401 cd_501 cd_502 cd_503 {
gen `j'_d = `j'/igpdibase18 
}
*CRIAR LEGENDA PARA VARIAVEIS DEFLACIONADAS 
label variable cd_101_d "(II)deflacionado"
label variable cd_201_d "(IRPF)deflacionado"
label variable cd_202_d "(IRPJ)deflacionado"
label variable cd_203_d "(IRRF)deflacionado"
label variable cd_301_d "(IPI_I)deflacionado"
label variable cd_302_d "(IPI_V)deflacionado"
label variable cd_401_d "(IOF)deflacionado"
label variable cd_501_d "(PIS-PASEP)deflacionado"
label variable cd_502_d "(COFINS)deflacionado"
label variable cd_503_d "(CSLL)deflacionado"

*CRIAR LOGARITMO DAS VARIAVEIS
foreach j in cd_101_d cd_201_d cd_202_d  cd_203_d  cd_301_d  ///
cd_302_d cd_401_d  cd_501_d  cd_502_d  cd_503_d  {

gen ln`j' = ln(`j') 

}

*CRIAR LEGENDA PARA VARIAVEIS DEFLACIONADAS E EM LOGARITMOS
label variable lncd_101_d "LN(II)"
label variable lncd_201_d "LN(IRPF)"
label variable lncd_202_d "LN(IRPJ)"
label variable lncd_203_d "LN(IRRF)"
label variable lncd_301_d "LN(IPI_I)"
label variable lncd_302_d "LN(IPI_V)"
label variable lncd_401_d "LN(IOF)"
label variable lncd_501_d "LN(PIS-PASEP)"
label variable lncd_502_d "LN(COFINS)"
label variable lncd_503_d "LN(CSLL)"


*CRIAR TAXA DE CRESCIMENTO DAS VARIAVEIS
drop if ano>2016

sort reg ano 
foreach j in lncd_101_d lncd_201_d lncd_202_d  lncd_203_d  lncd_301_d  ///
lncd_302_d lncd_401_d  lncd_501_d  lncd_502_d  lncd_503_d  {

gen tx`j' = d.`j' 

}

*CRIAR LEGENDA PARA TAXAS DE CRESCIMENTO
label variable txlncd_101_d "taxa de crescimento do(II)"
label variable txlncd_201_d "taxa de crescimento do(IRPF)"
label variable txlncd_202_d "taxa de crescimento do(IRPJ)"
label variable txlncd_203_d "taxa de crescimento do(IRRF)"
label variable txlncd_301_d "taxa de crescimento do(IPI_I)"
label variable txlncd_302_d "taxa de crescimento do(IPI_V)"
label variable txlncd_401_d "taxa de crescimento do(IOF)"
label variable txlncd_501_d "taxa de crescimento do(PIS-PASEP)"
label variable txlncd_502_d "taxa de crescimento do(COFINS)"
label variable txlncd_503_d "taxa de crescimento do(CSLL)"

*DEFLACIONAR O PIB, CRIAR O LOGARITMO E A TAXA DE CRESCIMENTO(PIB em MILHOES de reais)
gen pib_d = pib_/mudancabase18
label variable pib_d "PIB deflacionado pelo igpdi para 2018"
gen lnpib_d = ln(pib_d)
label variable lnpib_d "LN do pib deflacionado" 
gen txpib_d = d.lnpib_d 
label variable txpib_d "taxa de crescimento do PIB"


*CRIAR DUMMY PARA SUDESTE E SUL
gen sul=0 
replace sul=1 if reg==5
gen sudeste=0 
replace sudeste=1 if reg==4


*CRIAR VARIAVEIS PARA CADA GOVERNO
gen FHC = 0
replace FHC=1 if ano<2003
gen DILMA=0
replace DILMA=1 if ano>2010
gen LULA=0
replace LULA=1 if FHC==0 & DILMA==0
*DEFINIR GOVERNOS
label variable FHC "Governo FHC"
label define FHC 1 "FHC" 0 "NFHC"
label values FHC FHC
label variable LULA "Governo LULA"
label define LULA 1 "LULA" 0 "NLULA"
label values LULA LULA
label variable DILMA "Governo DILMA"
label define DILMA 1 "DILMA" 0 "NDILMA"
label values DILMA DILMA
gen GOVERNO =0 if FHC==1
replace GOVERNO =1 if LULA==1
replace GOVERNO =2 if DILMA==1
label variable GOVERNO "Governo"
label define GOVERNO 1 "LULA" 0 "FHC" 2 "DILMA"
label values GOVERNO GOVERNO
*DEFINIR ANOS ELEITORAIS
gen CICLO=0 if d0==1
replace CICLO=1 if d1==1
replace CICLO=2 if d2==1
replace CICLO=3 if d3==1
label variable CICLO "Período Eleitoral"
label define CICLO 0 "ano_eleição" 1 "1_ano_pos-eleição" 2 "2_anos_pos-eleição" 3 "3_anos_pos-eleição"
label values CICLO CICLO
*DESCREVENDO NUMERO DE MISSING NA BASE
ssc install mdesc
mdesc txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_502_d txlncd_503_d


mdesc cd_101 cd_201 cd_202 cd_203 cd_301 cd_302 ///
cd_401 cd_501 cd_502 cd_503 cd_504 cd_601 cd_602 cd_603 cd_604

*GRAFICOS
foreach j in txlncd_101_d txlncd_201_d txlncd_202_d txlncd_203_d txlncd_301_d ///
txlncd_302_d txlncd_401_d txlncd_501_d txlncd_502_d txlncd_503_d {  
xtline `j', overlay xlabel(1997 (3) 2017)
graph export `j'grafico.pdf , replace
}


*MODELOS
*APAGAR 1996 DEVIDO MISSING
drop if ano==1996


*ESTIMACAO DO MODELO EFEITO FIXO E TESTE DE CHOW
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_502_d  txlncd_503_d {  
xtreg `j' d1 d2 d3  LULA DILMA sudeste, fe
}
estimate store `j'fe 
}
**RESULTADOS = TODOS POOLED

*ESTIMACAO DO MODELO EFEITO ALEATORIO E TESTE BREUSCH-PAGAN (ESPECIFICACAO 1)
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_503_d {    
quietly xtreg `j' d1 d2 d3 LRF L.txpib_d ano, re

xttest0

estimate store `j're 
}
*ESTIMACAO DO MODELO EFEITO ALEATORIO E TESTE BREUSCH-PAGAN (ESPECIFICACAO 2)
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_503_d {    
quietly xtreg `j' d1 d2 d3  LULA DILMA sudeste, re

xttest0
}
estimate store `j're 
}

**RESULTADOS = TODOS ALEATORIOS
*obs 503 ciclo d1 d2 d3  L.txpib_d

////*MODELO POOLED////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
 quietly reg  txlncd_`j'_d  d1 d2 d3  LULA DILMA crise if ano>1996 ,robust 
 
 estimate store model_`j'
}
*TABELA DE RESULTADOS
logout, save(modelos) excel  replace: esttab model_101 model_201 model_202 model_203 model_301 ///
model_302 model_401 model_501 model_502 model_503 , nodepvar nonumber r2 star (* .1 ** .05 *** .01)

////*MODELO POOLED SIMPLES NACIONAL////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
 quietly reg  txlncd_`j'_d  d1 d2 d3 SIMPLES LULA DILMA crise if ano>1996 ,robust 
 
 estimate store modelS_`j'
}
*TABELA DE RESULTADOS
logout, save(modelosS) excel  replace: esttab modelS_101 modelS_201 modelS_202 modelS_203 modelS_301 ///
modelS_302 modelS_401 modelS_501 modelS_502 modelS_503 , nodepvar nonumber r2 star (* .1 ** .05 *** .01)


*DROPANDO OUTLIERS DA BASE COMO UM TODO (1 E 99 PERCENTIL)
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_503_d {    
summarize `j', detail
keep if inrange(`j', r(p1), r(p99)) 
}
*DROPANDO OUTLIERS DA BASE POR PAINEL (1 E 99 PERCENTIL)
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_503_d {    
by reg, sort: egen p1_`j' = pctile(`j'), p(1)
by reg, sort: egen p99_`j' = pctile(`j'), p(99)
keep if inrange(`j', p1_`j', p99_`j') 
}
*ACHANDO OUTLIERS
ssc install grubbs
foreach j in txlncd_101_d txlncd_202_d txlncd_301_d  ///
txlncd_302_d txlncd_501_d txlncd_503_d {    
grubbs `j', gen(gru_`j') 
}


////BASE PARA ESTATISTICAS DESCRITIVAS///
label variable cd_gt "Código do Tipo de Gasto Tributário"
label define cd_gt 101 "II" 201 "IRPF" 202 "IRPJ" 203 "IRRF" ///
301 "IPI_I" 302 "IPI_V" 401 "IOF"  501 "PIS-PASEP" 502 "COFINS" 503 "CSLL"
label values cd_gt cd_gt
drop if cd_gt>503
*DEFLACIONAR VALORES
gen valor_gt_d = valor_gt/igpdibase18 

*ESTATISTICAS DESCRITIVAS
*QUANTIL
*GRAFICOS
foreach j in txlncd_101_d txlncd_201_d txlncd_202_d txlncd_203_d txlncd_301_d ///
txlncd_302_d txlncd_401_d txlncd_501_d txlncd_502_d txlncd_503_d {  
qplot `j', recast(line) by (GOVERNO)
graph export `j'grafico_quantil.pdf , replace
}
foreach j 101 201 202 203 301 302 401 501 502 503///
{graph box gt if cd_gt==`j', over ( GOVERNO, sort(0)) ylabel (minmax, labsize(small)) ///
ytitle (Milhões de Reais) legend(rows(1)) 
graph export `j'grafico_quantil.pdf , replace
}
***********
qplot gt , recast(line)  over ( GOVERNO) by( cd_gt, rescale note("")) ylabel (minmax, labsize(small)) ///
ytitle ("") xlabel (#5, labsize(small)) graphregion(margin(tiny)) plotregion(margin(tiny)) ///
legend(rows(1)) xtitle("")
graph export quantil_over_gov_by_cd.png , replace
//////////////////////////
*BOX-PLOT
foreach j in txlncd_101_d txlncd_201_d txlncd_202_d txlncd_203_d txlncd_301_d ///
txlncd_302_d txlncd_401_d txlncd_501_d txlncd_502_d txlncd_503_d {  
graph hbox `j', over (GOVERNO, sort (0))
graph export `j'grafico_boxplot.pdf , replace
}
***********
foreach j in 0 1 2 {
graph hbox gt if GOVERNO==`j' , over ( cd_gt, sort(0)) ytitle ("") legend(rows(1)) 
graph export `j'box-plot_by_gov.png , replace
}
 



foreach j in M101 M201 M202 M203 M301 M302 M401 M501 M502 M503 { 
local jtext : variable label `j'
if `"`j'"' == "" local jtext "`j'" 
xtline `j' , overlay ylabel(#4, angle(horizontal)) tlabel(1998(4)2018, nogrid) legend(rows(1)) xtitle("") ytitle ("") title(`"`jtext'"') /// 
name (graf`j', replace)
}
graph combine  grafM101 grafM201 grafM202 grafM203 grafM301 grafM302 grafM401 grafM501 grafM502 grafM503
graph export serie_tipo_reg.png , replace
graph combine  grafM101 grafM201 grafM202 grafM203 grafM301 grafM302 grafM401 grafM501 grafM502 grafM503
graph export serie_tipo_reg.pdf , replace


 
/////////////////////////
graph box gt if cd_gt==101, over ( GOVERNO, sort(0)) ylabel (minmax, labsize(small)) ///
ytitle (Milhões de Reais) legend(rows(1)) 
graph hbox gt , over ( cd_gt, sort(0)) ytitle (Milhões de Reais) legend(rows(1)) 

*DESCREVENDO NUMERO DE MISSING NA BASE
ssc install mdesc
mdesc gt

*TABELAS DE ESTATISTICAS
*POR GOVERNO E POR ANO ELEITORAL
sort GOVERNO CICLO
logout, save(descritivas) excel  replace: by GOVERNO CICLO: tabstat gt, stat(n mean sd min max)
logout,  save(descritivas) excel  replace dec(3): by GOVERNO, sort : tabstat gt, statistics( mean sd min max q n) by(CICLO) missing noseparator 

*GERAR GASTO EM MILHOES PARA GRAFICOS E TABELAS
foreach j in 101 201 202 203 301 302 401 501 502 503 { 
gen M`j' = cd_`j'_d/1000000
}
label variable M101 "II"
label variable M201 "IRPF"
label variable M202 "IRPJ"
label variable M203 "IRRF"
label variable M301 "IPI_I"
label variable M302 "IPI_V"
label variable M401 "IOF"
label variable M501 "PIS-PASEP"
label variable M502 "COFINS"
label variable M503 "CSLL"

foreach j in 101 201 202 203 301 302 401 501 502 503 { 
local mylabel: variable label M`j'
}

foreach v of var <varlist> { 
	local vtext : variable label `v' 
	if `"`vtext'"' == "" local vtext "`v'" 
	twoway (scatter `v' xvar, sort), title(`"Scatter plot for `vtext'"')
} 


*GRAFICOS POR TIPO DE GT EM TODO PERIODO POR REGIAO
foreach j in M101 M201 M202 M203 M301 M302 M401 M501 M502 M503 { 
local jtext : variable label `j'
if `"`j'"' == "" local jtext "`j'" 
xtline `j' , overlay ylabel(#4, angle(horizontal)) tlabel(1998(4)2018, nogrid) legend(rows(1)) xtitle("") ytitle ("") title(`"`jtext'"') /// 
name (graf`j', replace)
}
graph combine  grafM101 grafM201 grafM202 grafM203 grafM301 grafM302 grafM401 grafM501 grafM502 grafM503
graph export serie_tipo_reg.png , replace
graph combine  grafM101 grafM201 grafM202 grafM203 grafM301 grafM302 grafM401 grafM501 grafM502 grafM503
graph export serie_tipo_reg.pdf , replace
*GRAFICOS TX DE CRESCIMENTO POR TIPO DE GT EM TODO PERIODO POR REGIAO
foreach j in 101 201 202 203 301 302 401 501 502 503 { 
xtline txlncd_`j'_d , overlay ylabel(#6, angle(horizontal)) tlabel(1998(4)2018, nogrid) legend(rows(1)) xtitle("") ytitle ("")
graph export `j'serie_tx_tipo_reg.pdf , replace
}


*GRAFICOS POR TIPO DE GT EM TODO PERIODO POR REGIAO USANDO OUTRO COMANDO
foreach j in M101 M201 M202 M203 M301 M302 M401 M501 M502 M503 { 
local jtext : variable label `j'
if `"`j'"' == "" local jtext "`j'" 
xtline `j' , overlay ylabel(#4, angle(horizontal)) tlabel(1998(4)2018, nogrid angle (vertical)) legend(rows(1)) xtitle("") ytitle ("") title(`"`jtext'"') /// 
name (graf`j', replace)
}
grc1leg grafM101 grafM201 grafM202 grafM203 grafM301 grafM302 grafM401 grafM501 grafM502 grafM503
graph export serie_tipo_reg2.png , replace

*GRAFICOS TX DE CRESCIMENTO POR TIPO DE GT EM TODO PERIODO POR REGIAO USANDO OUTRO COMANDO
label variable txlncd_101_d "II"
label variable txlncd_201_d "IRPF"
label variable txlncd_202_d "IRPJ"
label variable txlncd_203_d "IRRF"
label variable txlncd_301_d "IPI_I"
label variable txlncd_302_d "IPI_V"
label variable txlncd_401_d "IOF"
label variable txlncd_501_d "PIS-PASEP"
label variable txlncd_502_d "COFINS"
label variable txlncd_503_d "CSLL"

foreach j in txlncd_101_d txlncd_201_d txlncd_202_d txlncd_203_d txlncd_301_d ///
txlncd_302_d txlncd_401_d txlncd_501_d txlncd_502_d txlncd_503_d { 
local jtext : variable label `j'
if `"`j'"' == "" local jtext "`j'" 
xtline `j' , overlay ylabel(#6, angle(horizontal)) tlabel(1998(4)2018, nogrid) legend(rows(1)) xtitle("") ytitle ("") title(`"`jtext'"') ///
name (tgraf`j', replace)
}
grc1leg tgraftxlncd_101_d tgraftxlncd_201_d tgraftxlncd_202_d tgraftxlncd_203_d tgraftxlncd_301_d tgraftxlncd_302_d tgraftxlncd_401_d ///
tgraftxlncd_501_d tgraftxlncd_502_d tgraftxlncd_503_d 
graph export tx_cre_tipo_GT2.png , replace
graph export `j'serie_tx_tipo_reg.pdf , replace
}


*TABELA DE CORRELACAO
logout, save(correlacao) excel  replace: correlate cd_101_d cd_201_d cd_202_d cd_203_d cd_301_d cd_302_d cd_401_d cd_501_d cd_502_d cd_503_d




*robust
foreach j in .25 .50 .75{
foreach z in txlncd_101_d txlncd_201_d txlncd_202_d txlncd_203_d txlncd_301_d ///
txlncd_302_d txlncd_401_d txlncd_501_d txlncd_502_d txlncd_503_d {
quietly qreg `z' d1 d2 d3  LULA DILMA crise if ano>1996 , q(`j') vce(robust)
}
}
estimate store `j'model
}

*****TESTES****
////*MODELO POOLED////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
 quietly reg  txlncd_`j'_d  d1 d2 d3  LULA DILMA crise if ano>1996 ,robust 
  estimate store pooled_`j'
}

////*MODELO FIXO////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
 quietly xtreg  txlncd_`j'_d  d1 d2 d3  LULA DILMA crise if ano>1996 ,fe 
  estimate store fixed_`j'
}
logout, save(modelos_fixo) excel  replace: esttab fixed_101 fixed_201 fixed_202 fixed_203 fixed_301 ///
fixed_302 fixed_401 fixed_501 fixed_502 fixed_503 , nodepvar nonumber r2 star (* .1 ** .05 *** .01)


////*MODELO FIXO////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
  xtreg  txlncd_`j'_d  d1 d2 d3  LULA DILMA crise if ano>1996 ,fe 
  estimate store fixed_`j'
  esttab
}


////*MODELO POOLED////
foreach j in 101 201 202 203 301 302 401 501 502 503 {  
 quietly xtreg  txlncd_`j'_d  d1 d2 d3  LULA DILMA crise if ano>1996 ,re 
  estimate store random_`j'
}



