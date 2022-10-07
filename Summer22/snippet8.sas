* snippet8.sas ;
%include "snippet3.sas";

proc sql;
    create table naaccr as
    select * from db.fh_hb_naaccr_jupyter
        where (sequence_number_hospital='0'
           or sequence_number_hospital='1') and
           (year(datepart(date_of_diagnosis_shifted))
           between 2016 and 2017) and
           site_primary like 'C50%';
quit;

proc freq data=naaccr;
    tables sequence_number_hospital site_primary;
run;     
