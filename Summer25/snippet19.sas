* snippet19.sas ;
%_dblib(data=db.ekg_waveform);

proc sort data=db.ekg_waveform out=ekg_waveform;
    by patient_trac_id;
    where waveform_type='Rhythm';
run;

proc freq;
    tables sample_base;
run;

proc sort data=crdw.snippet13(keep=patient_hash patient_trac_id) 
    out=snippet13;
    by patient_trac_id;
run;

data ekg_waveform;
    merge snippet13(in=snippet13) ekg_waveform;
    by patient_trac_id;
    if snippet13 & sample_base=500;
run;

%_dbdata(out=ekg_waveform);

proc sort data=ekg_waveform out=crdw.ekg_waveform;
    by waveform_id;
run;

proc contents varnum;
run;
