* snippet2.sas ;

* pass-through query;
proc sql;
   connect to postgres as crdw 
       (user=&user password="&password" 
       server="garth.ctsi.mcw.edu" 
       database="fh_jupyter_hub_hbdb");

   select * 
       from connection to crdw
       (select version());

   disconnect from crdw;
quit;
