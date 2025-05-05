*snippet22.sas;
%let total=5000; *500 Hz X 10 s=5000;

data i ii %_list(v1-v6);
    set crdw.ekg_lead_data;

    keep patient_hash patient_trac_id waveform_id ms mv;
    
    wave_form_data=input(wave_form_data, $base64x13532.);

    ms=0; *time in ms;
    mv=0; *ECG in mV;
    
    do i=1 to &total;
        ms=2*i-1;
        mv=input(substr(wave_form_data, ms, 2), ib2.);
        if mv<lead_low_limit | mv>lead_high_limit then
            put waveform_id= lead_id= ms= mv=;
        mv=mv*lead_amplitude_units_per_bit/1000;

        select(lead_id);
        when('I')  output i;
        when('II') output ii;
        when('V1') output v1;
        when('V2') output v2;
        when('V3') output v3;
        when('V4') output v4;
        when('V5') output v5;
        when('V6') output v6;
        end;
    end;
run; 

data crdw.snippet22;
    merge 
        i( rename=(mv=i))
        ii(rename=(mv=ii))
        v1(rename=(mv=v1))
        v2(rename=(mv=v2))
        v3(rename=(mv=v3))
        v4(rename=(mv=v4))
        v5(rename=(mv=v5))
        v6(rename=(mv=v6))
    ;
    by patient_hash patient_trac_id waveform_id ms;
run;

proc univariate plot;
    var i ii v1-v6;
    id ms;
run;

proc contents varnum;
run;
