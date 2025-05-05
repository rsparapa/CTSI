* snippet12.sas ;
%_dblib(data=db.ekg_resting_ecg_meas);

data ekg_resting_ecg_meas;
    merge 
        crdw.ekg_test_demographics(keep=patient_hash 
            patient_trac_id acquisition_date_shifted 
            acquisition_date in=ekg_test_demographics)
        db.ekg_resting_ecg_meas(in=ekg_resting_ecg_meas)
    ;
    by patient_trac_id;

    if ekg_test_demographics & ekg_resting_ecg_meas;
run;

%_dbdata(out=ekg_resting_ecg_meas);

proc sort data=ekg_resting_ecg_meas 
    out=crdw.ekg_resting_ecg_meas(index=(patient_trac_id/unique));
    by patient_hash acquisition_date_shifted;
run;

proc contents varnum;
run;

proc univariate plot;
    var ventricular_rate atrial_rate;
run;

ods graphics on / reset imagename="&fnroot" imagefmt=pdf;

footnote;

proc sgplot;
    scatter x=atrial_rate y=ventricular_rate;
run;

%_pdfjam;
