* snippet3.sas ;
%let user=rsparapani; *JHUSERNAME; 
%let password=RSP#ygbzqp26t5W#Jyph2; *JHPASSWORD;

options
    validmemname = extend; /* enable multiple periods in table references */

libname db postgres
    database      = "fh_jupyter_hub_hbdb"
    user          = &user
    password      = &password
    server        = "garth.ctsi.mcw.edu" 
    port          = 5432
    client_encoding = 'utf-8' /* otherwise unicode will generate an error */
    dbmax_text      = 24   /* the default is pretty extreme */ 
    sql_functions   = all; /* enable more date functions in SQL */

