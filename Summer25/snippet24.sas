*snippet24.sas;

data snippet22;
    set crdw.snippet22;
    by patient_hash patient_trac_id;
    keep patient_hash patient_trac_id;
    if first.patient_trac_id;
run;

proc sort data=snippet22;
    by patient_trac_id;
run;

%_dblib(data=db.ekg_meas_matrix);

proc sql;
    create table ekg_meas_matrix as
    select *
        from snippet22 a
        inner join db.ekg_meas_matrix b
        on a.patient_trac_id=b.patient_trac_id
        order by patient_hash, patient_trac_id;
quit;

%_dbdata(out=crdw.ekg_meas_matrix);

proc contents varnum;
run;

