* snippet6.sas ;
%include "snippet3.sas";

proc sql;
    create table naaccr as
    select year(datepart(date_of_diagnosis_shifted)) as dxyear
    from db.fh_hb_naaccr_jupyter;
quit;

proc freq data=naaccr;
    tables dxyear;
run;     
