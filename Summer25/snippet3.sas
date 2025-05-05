* snippet3.sas ;

proc sql;
   connect to postgres as crdw 
       (user=&user password=&password 
       server="garth.ctsi.mcw.edu" 
       database="fh_jupyter_hub_hbdb");

   create table schema as
   select * 
       from connection to crdw
       (select *
       from information_schema.columns
       where table_schema = 'public');
/* must use single quotes: NOT "public" */

   disconnect from crdw;
quit;

data crdw.schema;
    set schema;
    format _all_;
run;

options ps=49 ls=122;

proc contents varnum;
run;

proc freq;
    tables table_catalog table_schema data_type;
run;

proc freq;
    where data_type in:("character", "text");
    tables table_name;
run;

proc print uniform;
    where data_type in:("character", "text");
    var table_name column_name;
run;
