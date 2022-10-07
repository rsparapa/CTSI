%include "snippet11.sas";

proc sql;
    create table zdates as
    select patient_hash, measure_date_shifted 
               from db.fh_hb_vitals_jupyter  
               where patient_hash in%_inclause(data=zombies, var=patient_hash) 
               order by patient_hash, measure_date_shifted;
quit;

proc contents varnum;
run;
