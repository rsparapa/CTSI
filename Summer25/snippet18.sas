
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
run;

proc sort data=persistent;
    by patient_hash patient_trac_id;
run;

data crdw.persistent;
    merge 
        persistent(in=persistent)
        crdw.interp(keep=patient_hash patient_trac_id
        afib aflut rename=(afib=aci_afib aflut=aci_aflt)) 
    ;
    /* automatic computerized interpretation (ACI) */
    by patient_hash patient_trac_id;
    
    if persistent;
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

proc format;
    value present
        1-high='1+'
    ;
run;

title 'VERITAS agreement with CRDW';

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

proc contents varnum;
run;
