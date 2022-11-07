* -- This file is used to initialize the parameter for report

*===========================policy shock on static model========================

        UNEM(lm,z)    =   UR.l(lm);
        pwage(lm,i,z) =   plO.l(lm,i);

*// emission accounting
		report2(z,i)		=	sum(fe,ccoef_p(fe)*qein.l(fe,i)) + ccoef_pro(i)*qdout.l(i);
		report2(z,"fd")		=	sum(fe,ccoef_h(fe)*qec.l(fe));
		report2(z,"Total")	=	sum(i,report2(z,i))+report2(z,"fd");

		report3(z,"coal_power")	=	ccoef_p("coal")*qein.l("coal","elec");
		report3(z,"oil_power")	=	ccoef_p("roil")*qein.l("roil","elec");
		report3(z,"gas_power")	=	ccoef_p("gas")*qein.l("gas","elec");


*// employment accounting
		report6(z,lm,"total")	= sum(i,qlin.l(lm,i))
								+sum(sub_elec,qlin_ele.l(lm,sub_elec))+sum(sub_ist,qlin_ist.l(lm,sub_ist));
		report6(z,lm,i)		= 	qlin.l(lm,i);
		report6(z,lm,"elec")= sum(sub_elec,qlin_ele.l(lm,sub_elec));
		report6(z,lm,"ist")	= sum(sub_ist,qlin_ist.l(lm,sub_ist));
		report6(z,lm,sub_elec)= qlin_ele.l(lm,sub_elec);

		report6(z,"total","total")	= sum(lm,sum(i,qlin.l(lm,i))
									+sum(sub_elec,qlin_ele.l(lm,sub_elec))+sum(sub_ist,qlin_ist.l(lm,sub_ist)));
		report6(z,"total",i)		= sum(lm,qlin.l(lm,i));
		report6(z,"total","elec")	= sum(lm,sum(sub_elec,qlin_ele.l(lm,sub_elec)));
		report6(z,"total","ist")	= sum(lm,sum(sub_ist,qlin_ist.l(lm,sub_ist)));
		report6(z,"total",sub_elec)	= sum(lm,qlin_ele.l(lm,sub_elec));