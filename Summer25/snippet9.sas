* snippet9.sas ;
data crdw.snippet9;
    set crdw.snippet7;
    by patient_hash dx_date_shifted;

    *I48 is AFIB except for these codes for AFLT;
    where dx_code in:("I48.3", "I48.4", "I48.92") &
        enc_type in("ED", "EI", "IP", "OS"); 
    *see enc_type in docs: ER, in-patient or observation; 

    array _year(2017:2022) aflt17-aflt22;

    array _aflt(2017:2022, 1:12) 
        aflt1701-aflt1712 aflt1801-aflt1812 
        aflt1901-aflt1912 aflt2001-aflt2012 
        aflt2101-aflt2112 aflt2201-aflt2212
    ;
        
    keep patient_hash aflt17-aflt22 aflt1701--aflt2212;

    %_retain(var=prev_aflt=dx_date aflt1701--aflt2212=0, 
        by=patient_hash);

    if first.patient_hash | (dx_date-prev_aflt)>30 then do;
        prev_aflt=dx_date;
        _aflt(year(dx_date), month(dx_date))=day(dx_date);
    end;
    
    if last.patient_hash;

    aflt17=0; aflt18=0; aflt19=0; aflt20=0; aflt21=0; aflt22=0;
    
    do year=2017 to 2022;
        do month=1 to 12;
            if _aflt(year, month)>0 then _year(year)+1;
        end;
    end;
run;

proc freq;
    tables aflt17-aflt22;
run;

proc format;
    value aflt 
        0-1='0:1'
        2-12='2+'
    ;
run;

proc freq;
    tables aflt17*aflt18*aflt19 aflt20*aflt21*aflt22 / list;
    format aflt17-aflt22 aflt.;
run;

proc contents varnum;
run;
