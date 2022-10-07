* snippet4.sas ;
%include "snippet3.sas";

proc sql;
    create table tables as
    select * from db.'information_schema.tables'n
        where table_schema = 'public';
quit;                   
 
proc print data=tables;
    var table_name;
run;   
