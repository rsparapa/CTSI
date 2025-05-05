* snippet13.sas ;
data snippet13;
    merge 
        crdw.ekg_test_demographics
        crdw.ekg_resting_ecg_meas
    ;
    by patient_trac_id;

    if ventricular_rate>=100 &
        diagnosis_stmt not in:(
        "** ** ** Pediatric ECG Analysis ** ** **",
        "*** Poor data quality,", 
        "*** Suspect arm lead reversal,");

    if atrial_rate=. | atrial_rate>=ventricular_rate;
run;

proc sort data=snippet13;
    by patient_hash acquisition_date_shifted;
run;

proc univariate noprint;
    var acquisition_date;
    by patient_hash;
    output out=dates min=first_date max=last_date;
run;

data crdw.snippet13;
    merge dates snippet13;
    by patient_hash;
    diff=last_date-first_date;
    if diff>30;
    attrib first_date last_date format=date7. label='';
run;

proc contents varnum;
run;

proc univariate plot;
    var diff ventricular_rate atrial_rate;
run;

proc freq;
    where diagnosis_stmt=:'**';
    tables diagnosis_stmt;
    format diagnosis_stmt $40.;
run;

options ps=49 ls=122;

proc print;
    where diagnosis_stmt=:'**';
    var diagnosis_stmt;
run;
