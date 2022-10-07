* snippet7.sas ;
%include "snippet3.sas";

proc sql;
    create table muse as
    select year(datepart(acquisition_date_shifted)) as ekgyear
    from db.ekg_test_demographics;
quit;

proc freq data=muse;
    tables ekgyear;
run;     
