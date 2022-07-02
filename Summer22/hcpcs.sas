
%*_cimport(infile=HCPC17_CONTR_ANWEB.csv,
    header=11, out=hcpcs, rename=hcpc=hcpcs, index=hcpcs); 

proc import datafile='HCPC17_CONTR_ANWEB.csv'
    out=hcpcs(rename=(hcpc=hcpcs) index=(hcpcs));
    guessingrows=max;
run;

data hcpcs(index=(hcpcs/unique));
    set hcpcs;
    by hcpcs;

    drop add_dt term_dt;
    rename _add_dt=add_dt _term_dt=term_dt;
    
    _add_dt =input(put(add_dt, $8.), yymmdd8.);
    if _add_dt=. then _add_dt='01JAN1982'd;
    
    _term_dt =input(put(term_dt, $8.), yymmdd8.);
    if _term_dt=. then _term_dt='01JAN2082'd;

    format _add_dt _term_dt date7.;
run;

/*
proc contents varnum;
run;

proc freq;
    tables term_dt add_dt;
    format add_dt term_dt year4.;
run;

proc print;
    where length(hcpcs)=5;
run;
*/
