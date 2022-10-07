* snippet11.sas ;
%include "snippet3.sas";

proc sql;
    create table zombies as
        select distinct a.patient_hash, 
        a.death_date_shifted,
        a.vital_status_source
        from db.fh_hb_demographics_jupyter a
        inner join db.fh_hb_vitals_jupyter b 
        on a.patient_hash=b.patient_hash 
        AND a.death_date_shifted<b.measure_date_shifted
        order by patient_hash;
quit;

proc freq data=zombies;
    tables vital_status_source;
run;     

proc print data=zombies;
    format death_date_shifted dtdate9.;
run;

