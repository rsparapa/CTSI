*snippet20.sas;
endsas;
/*
BEWARE: this takes hours and is demanding
you need to submit it with TORQUE like so
qsas snippet20 -host cheddar
BUT IT WILL CRASH WITHOUT AN ERROR MESSAGE
*/
%_dblib(data=db.ekg_lead_data);

proc sql;
    create table ekg_lead_data as
    select *
        from crdw.ekg_waveform a
        inner join db.ekg_lead_data b
        on a.waveform_id=b.waveform_id
        order by patient_hash, 
        patient_trac_id, a.waveform_id, lead_id;
quit;

%_dbdata(out=crdw.ekg_lead_data);

proc contents varnum;
run;

