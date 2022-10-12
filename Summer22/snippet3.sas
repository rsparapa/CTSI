* snippet3.sas ;
%let user=user10; *JHUSERNAME; 
%let password=Jupuser#10; *JHPASSWORD;
%let server=mcgivers.ctsi.mcw.edu;

options
    validmemname = extend; /* enable multiple periods in table references */

libname db postgres
    database        = "fh_jupyter_hub_hbdb"
    user            = "&user"
    password        = "&password"
    server          = "&server" 
    port            = 5432
    client_encoding = "utf-8" /* otherwise unicode will generate an error */
    dbmax_text      = 24   /* the 1024 default is pretty extreme */ 
    sql_functions   = all; /* enable more date functions in SQL */

