* snippet10.sas ;
%_dblib(data=db.ekg_patient_tracings);

proc sort data=db.ekg_patient_tracings 
    out=crdw.ekg_patient_tracings;
    by patient_hash patient_trac_id;
run;

data crdw.ekg_patient_tracings;
    merge 
        crdw.snippet8(in=snippet8)
        crdw.snippet9(in=snippet9)
        crdw.ekg_patient_tracings(in=snippet10)
    ;
    by patient_hash;

    afib=snippet8;
    aflt=snippet9;
    
    if snippet10 & (snippet8 | snippet9);
run;

%_dbdata(out=crdw.ekg_patient_tracings);

proc freq;
    tables gender afib*aflt;
run;

proc contents varnum;
run;
