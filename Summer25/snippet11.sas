* snippet11.sas ;

%_dblib(data=db.ekg_test_demographics);

proc sort data=db.ekg_test_demographics out=ekg_test_demographics;
    where "01JAN2017:00:00:00"dt<=acquisition_date_shifted<
        "01JAN2023:00:00:00"dt;
    by patient_trac_id;
run;

%_dbdata(out=crdw.ekg_test_demographics);

proc contents varnum;
run;

proc sort data=crdw.ekg_test_demographics 
    out=ekg_test_demographics;
    by patient_trac_id;
run;

proc sort data=crdw.ekg_patient_tracings 
    out=ekg_patient_tracings;
    by patient_trac_id;
run;

data ekg_test_demographics;
    merge 
        ekg_patient_tracings(in=ekg_patient_tracings)
        ekg_test_demographics(in=ekg_test_demographics)
    ;
    by patient_trac_id;

    array _afib(2017:2022, 1:12) 
        afib1701-afib1712 afib1801-afib1812 afib1901-afib1912
        afib2001-afib2012 afib2101-afib2112 afib2201-afib2212
    ;

    array _aflt(2017:2022, 1:12) 
        aflt1701-aflt1712 aflt1801-aflt1812 aflt1901-aflt1912
        aflt2001-aflt2012 aflt2101-aflt2112 aflt2201-aflt2212
    ;

    if ekg_patient_tracings & ekg_test_demographics;

    drop month year afib17-afib22 aflt17-aflt22
        afib1701-afib1712 afib1801-afib1812 afib1901-afib1912
        afib2001-afib2012 afib2101-afib2112 afib2201-afib2212
        aflt1701-aflt1712 aflt1801-aflt1812 aflt1901-aflt1912
        aflt2001-aflt2012 aflt2101-aflt2112 aflt2201-aflt2212
    ;
    
    month=month(acquisition_date);
    year =year(acquisition_date);

    format afib_date aflt_date date7.;

    if _afib(year, month)>0 then 
        afib_date=mdy(month, _afib(year, month), year); 
    if _aflt(year, month)>0 then 
        aflt_date=mdy(month, _aflt(year, month), year); 

    afib=(acquisition_date=afib_date);
    aflt=(acquisition_date=aflt_date);

    if afib | aflt;

    if afib=0 then afib_date=.;
    if aflt=0 then aflt_date=.;
run;

%_sort(data=ekg_test_demographics, out=crdw.ekg_test_demographics,
    by=patient_hash acquisition_date_shifted, index=patient_trac_id/unique);

proc freq;
    tables afib*aflt;
run;

proc contents varnum;
run;

