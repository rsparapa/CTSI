* snippet8.sas ;
data crdw.snippet8;
    set crdw.snippet7;
    by patient_hash dx_date_shifted;

    *I48 is AFIB except for these codes for AFLT;
    where dx_code not in:("I48.3", "I48.4", "I48.92") &
        enc_type in("ED", "EI", "IP", "OS");
    *see enc_type in docs: ER, in-patient or observation;
        
    array _year(2017:2022) afib17-afib22;

    array _afib(2017:2022, 1:12) 
        afib1701-afib1712 afib1801-afib1812 
        afib1901-afib1912 afib2001-afib2012 
        afib2101-afib2112 afib2201-afib2212
    ;
        
    keep patient_hash afib17-afib22 afib1701--afib2212;

    %_retain(var=prev_afib=dx_date afib1701--afib2212=0, 
        by=patient_hash);

    if first.patient_hash | (dx_date-prev_afib)>30 then do;
        prev_afib=dx_date;
        _afib(year(dx_date), month(dx_date))=day(dx_date);
    end;
    
    if last.patient_hash;

    afib17=0; afib18=0; afib19=0; afib20=0; afib21=0; afib22=0;
    
    do year=2017 to 2022;
        do month=1 to 12;
            if _afib(year, month)>0 then _year(year)+1;
        end;
    end;
run;

proc freq;
    tables afib17-afib22;
run;

proc format;
    value afib 
        0-1='0:1'
        2-12='2+'
    ;
run;

proc freq;
    tables afib17*afib18*afib19 afib20*afib21*afib22 / list;
    format afib17-afib22 afib.;
run;

proc contents varnum;
run;
