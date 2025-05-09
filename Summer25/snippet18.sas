

data persistent;
    merge crdw.snippet13(in=snippet13)
        crdw.snippet14(in=snippet14) crdw.aad(in=inaad);
    by patient_hash;
    if snippet13;

    if snippet14=0 then do;
        ablation=0;
        cardioversion=0;
        closure=0;
    end;

    if inaad=0 then do;
        amio=0;
        type1a=0;
        type1b=0;
        type1c=0;
        type3=0;
        misc=0;
        aad=0;
    end;
    else if amio then aad=0;

    tx=amio+cardioversion+ablation+aad+closure;
run;

proc sort data=persistent;
    by patient_hash patient_trac_id;
run;


%_dblib(data=db.fh_hb_demographics_jupyter);

data patient_hash;
    set persistent;
    by patient_hash;
    keep patient_hash;
    if first.patient_hash;
run;

proc sql;
    create table demographics as
    select *
        from patient_hash a
        inner join db.&dbdata b
        on a.patient_hash=b.patient_hash
        order by patient_hash;
quit;

%_dbdata(out=crdw.demographics);

proc contents varnum;
run;

data persistent;
    merge crdw.demographics persistent;
    by patient_hash;

    age=intck('year', birth_date, acquisition_date);
run;

data crdw.persistent;
    merge 
        persistent(in=persistent)
        crdw.interp(keep=patient_hash patient_trac_id
        afib aflut rename=(afib=aci_afib aflut=aci_aflt)) 
    /* automatic computerized interpretation (ACI) */
    ;
    by patient_hash patient_trac_id;
    
    if 40<=age<90;
run;

proc format;
    value age 
        40-64='40:64'
        65-79='65:79'
        80-89='80:89'
    ;

    value present
        1-high='1+'
    ;
run;

proc freq;
    tables age;
    format age age.;
run;

proc freq;
    where aci_afib=aci_aflt=.;
    tables acquisition_date;
    format acquisition_date year4.;
run;

proc freq;
    tables afib*aflt;
run;

title 'AFIB and not AFLT';
proc freq;
    where afib & aflt=0;
    tables aci_afib*aci_aflt;
run;

title 'AFLT';
proc freq;
    where aflt;
    tables aci_afib*aci_aflt;
run;

title;
options ps=49 ls=122;

title 'VERITAS agreement with CRDW';

proc freq;
    where aci_afib | aci_aflt;
    format age age. tx present.;
    tables tx*age;
run;

proc freq;
    where aci_afib | aci_aflt;
    format ablation cardioversion amio aad closure present.;
    tables amio cardioversion ablation aad closure;
    tables amio*cardioversion*ablation*aad*closure / list missing
        noprint out=persistent;
run;

%_sort(data=persistent, out=persistent, by=descending count);

proc print;
run;

options ps=54 ls=76;    

proc contents varnum data=crdw.persistent;
run;
