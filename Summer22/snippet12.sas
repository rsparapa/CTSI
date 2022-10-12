* snippet12.sas ;
%include "snippet11.sas";

proc sql;
    create table zdates as
    select patient_hash, measure_date_shifted 
               from db.fh_hb_vitals_jupyter  
               where patient_hash %_inclause(data=zombies, var=patient_hash) 
               order by patient_hash, measure_date_shifted;
quit;

proc univariate noprint data=zdates;
    by patient_hash;
    var measure_date_shifted;
    output out=max_zdates max=measure_date_shifted;
run;

data max_zdates;
    merge zombies max_zdates;
    by patient_hash;
run;

proc print;
    var patient_hash vital_status_source death_date_shifted measure_date_shifted ;
    format death_date_shifted measure_date_shifted dtdate9.;
run;
