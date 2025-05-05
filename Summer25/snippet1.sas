* snippet1.sas ;

libname db postgres
    user            = "&user"
    password        = "&password"
    server          = "garth.ctsi.mcw.edu" 
    database        = "fh_jupyter_hub_hbdb"
    dbmax_text      = 16 
/*setting the length for very long character types*/  
    client_encoding = "utf-8" 
/*otherwise Unicode will generate an error*/
    sql_functions   = all;
/*enables all SAS functions for SQL*/

