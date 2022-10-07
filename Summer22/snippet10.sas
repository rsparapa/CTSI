* snippet10.sas ;
%include "snippet3.sas";

proc sql;
    create table a as
    select geocode_result from db.fh_hb_demographics_jupyter;
quit;

proc freq;
    tables geocode_result;
run;

proc sql;
    create table b as
    select adi_narank from db.fh_hb_demographics_jupyter
        where geocode_result='geocoded';
quit;

proc freq;
    tables adi_narank;
run;

data b;
    set b;

    unk=(adi_narank in(' ', 'GQ', 'PH', 'GQ-PH', 'QDI'));

    if unk then adi=.;
    else adi=adi_narank;
run;

proc univariate plot;
    var adi;
run;
