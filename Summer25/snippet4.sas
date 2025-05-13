* snippet4.sas ;

proc sql;
   connect to postgres as crdw 
       (user=&user password="&password"
       server="garth.ctsi.mcw.edu" 
       database="fh_jupyter_hub_hbdb");

   create table schema as
   select * 
       from connection to crdw
       (select *
       from information_schema.columns
       where table_schema = 'public');

   disconnect from crdw;
quit;

data schema;
    set schema;
    format _all_;
run;

data char;
    set schema;
    where data_type in:("character", "text");
run;

data zero;
    set char(obs=1 firstobs=1 keep=table_name column_name);
    delete;
run;

data length;
    set zero;
run;

%macro main;

%let nobs=%_nobs(data=char);

%do i=1 %to &nobs;
    data _null_;
        set char(obs=&i firstobs=&i);
        call symput("table", trim(table_name));
        call symput("column", trim(column_name));
        stop;
    run;

   proc sql;
   connect to postgres as crdw 
       (user=&user password="&password" 
       server="garth.ctsi.mcw.edu" 
       database="fh_jupyter_hub_hbdb");

   create table len as
   select * 
       from connection to crdw
       (select max(length(&column)) as len from &table);

   disconnect from crdw;
quit;

data len;
    set zero len;
    table_name="&table";
    column_name="&column";
run;

data length;
    set length len;
    by table_name column_name;
run;

%end;

%mend main;

%main;

proc print uniform data=length;
    by table_name;
    where len>200;
run;
