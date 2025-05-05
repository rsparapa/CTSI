* snippet7.sas ;
endsas;
/*
BEWARE: this takes 9 hours and is demanding
you need to submit it with TORQUE like so
qsas snippet7 -host cheddar
*/
* all AFIB/AFLT diagnoses: see https://icd10cmtool.cdc.gov;
%_dblib(data=db.fh_hb_diagnosis_jupyter, var=_none_);

data afib;
    set db.&dbdata(keep=patient_hash dx_date_shifted 
        dx_type dx_code dx_origin enc_type pdx);
    where "01JAN2017:00:00:00"dt<=dx_date_shifted<
        "01JAN2023:00:00:00"dt & dx_code=:"I48";
run;

proc sort data=afib;
    by patient_hash dx_date_shifted;
run;

%_dbdata(out=crdw.snippet7);

proc contents varnum;
run;

