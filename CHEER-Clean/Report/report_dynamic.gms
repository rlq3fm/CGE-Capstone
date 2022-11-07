*=====================================generation of accounting scalar====================

*=====================================transfer to csv file================================

* ----- Output the results


put reportfile ;


* ----- Sectoral results

loop(i,
    put scn.tl, t.tl, 'output',         i.tl, '', '', '', 'output',         (qdout.l(i)), CHEER.modelstat / ;
    put scn.tl, t.tl, 'Sectoral price', i.tl, '', '', '', 'Sectoral price', (pa.l(i)),    CHEER.modelstat / ;
  loop(lm,
    put scn.tl, t.tl, 'employment',     i.tl, '', '', lm.tl,  'employment',     (qlin.l(lm,i)), CHEER.modelstat / ;
    put scn.tl, t.tl, 'Sectoral wage',  i.tl, '', '', lm.tl,  'Sectoral wage',  (plo.l(lm,i)),  CHEER.modelstat / ;
    put scn.tl, t.tl, 'aggregated wage',i.tl, '', '', lm.tl,  'Sectoral wage',  (pl.l(i)),      CHEER.modelstat / ;
      );
) ;

* ----- electricity results
loop(sub_elec,
    put scn.tl, t.tl, 'elec_output',  '', '', sub_elec.tl,  '', 'elec_output',  (qelec.l(sub_elec)),  CHEER.modelstat / ;
    put scn.tl, t.tl, 'elec_price',   '', '', sub_elec.tl,  '', 'elec_price',   (pelec.l(sub_elec)),  CHEER.modelstat / ;
    put scn.tl, t.tl, 'elec_tax',     '', '', sub_elec.tl,  '', 'elec_tax',     (t_re.l(sub_elec)),   CHEER.modelstat / ;
  loop(lm,
    put scn.tl, t.tl, 'employment',   '', '', sub_elec.tl , lm.tl,  'employment', (qlin_ele.l(lm,sub_elec)),  CHEER.modelstat / ;
      );
) ;

* ----- emission results
loop(fe,
loop(i,
    put scn.tl, t.tl, 'ECO2', i.tl, '', '', '', 'ECO2', eco2.l(fe,i), CHEER.modelstat / ;
) ;
    put scn.tl,t.tl,  'ECO2', 'fd', '', '','','ECO2', eco2_h.l(fe),CHEER.modelstat / ;
);
* ----- employment results
loop(lm,
    put scn.tl,t.tl, 'total employment','', '', '',lm.tl,'total employment', (tlabor_s0(lm)),CHEER.modelstat / ;
    put scn.tl,t.tl, 'aggregated wage','','', '',lm.tl,'aggregated wage', (pls.l(lm)),CHEER.modelstat / ;
) ;


* ----- macro results
    put scn.tl,t.tl, 'GDP','', '', '','','GDP', rgdp.l,CHEER.modelstat / ;
    put scn.tl,t.tl, 'TFP','', '', '','','TFP', TFP.l,CHEER.modelstat / ;
    put scn.tl,t.tl, 'Welfare','', '', '','','Welfare', util.l,CHEER.modelstat / ;

*------- policy shock

    put scn.tl,t.tl, 'clim0','', '', '','','clim0', clim0,CHEER.modelstat / ;
    put scn.tl,t.tl, 'tclim','', '', '','','tclim', tclim.l,CHEER.modelstat / ;
    put scn.tl,t.tl, 'pco2','', '', '','','carbon price', pco2.l,CHEER.modelstat / ;