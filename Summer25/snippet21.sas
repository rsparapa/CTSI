*snippet21.sas;
%_dblib(data=db.ekg_lead_data);

%macro main;

%let nobs=%_nobs(data=crdw.ekg_waveform);

%do i=1 %to &nobs;

data _null_;
    set crdw.ekg_waveform(firstobs=&i obs=&i);
    call symput("waveform_id", trim(waveform_id));
    call symput("patient_hash", trim(patient_hash));
    call symput("patient_trac_id", trim(patient_trac_id));
run;

data _&i;
    length patient_hash patient_trac_id $ 16;
    set db.ekg_lead_data;
    where waveform_id="&waveform_id";
    patient_hash="&patient_hash";
    patient_trac_id="&patient_trac_id";
run;

%_dbdata(out=_&i);

proc sort data=_&i;
    by patient_hash patient_trac_id waveform_id lead_id;
run;

    %if &i=1 %then %do;
    data crdw.ekg_lead_data;
        set _1;
        by patient_hash patient_trac_id waveform_id lead_id;
    run;
    %end;
    %else %do;
    data crdw.ekg_lead_data;
        set _&i crdw.ekg_lead_data;
        by patient_hash patient_trac_id waveform_id lead_id;
    run;
    %end;

%end;

%mend main;

%main;

proc contents varnum;
run;
