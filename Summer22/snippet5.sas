* snippet5.sas ;
%include "snippet3.sas";

proc sql;
    create table columns as
    select * from db.'information_schema.columns'n
        where table_schema = 'public';
quit;                   
 
proc contents varnum data=columns;
run;

proc freq data=columns;
    tables table_name;
run;   
