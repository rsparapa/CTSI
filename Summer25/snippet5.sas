* snippet5.sas ;

%_dblib(data=db.fh_hb_demographics_jupyter);
*_dblib(data=db.fh_hb_demographics_jupyter, var=_none_);

data check;
    set db.&dbdata(obs=10);
*&dbdata is short for fh_hb_demographics_jupyter;
    drop death_date_shifted primary_care_provider_id;
*Drop 2 variables: members of DBDATES and DBCHAR;
*Will _DBDATA fail under such a circumstance?;
run;

%_dbdata(out=crdw.snippet5); *Of course not!;

proc print;
    var &dbdates; 
*&dbdates is a list of SAS dates and date-times;
run;

proc contents varnum;
run;
