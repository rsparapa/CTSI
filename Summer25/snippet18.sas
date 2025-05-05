
data crdw.persistent;
    merge crdw.snippet13(in=snippet13)
        crdw.snippet14(in=snippet14) crdw.aad(in=inaad);
    by patient_hash;
    if snippet13;

    if snippet14=0 then do;
        ablation=0;
        cardioversion=0;
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

/*
proc contents varnum;
run;
*/

proc format;
    value present
        1-high='1+'
    ;
run;

options ps=49 ls=122;

proc freq;
    format ablation cardioversion amio aad present.;
    tables amio cardioversion ablation aad;
    tables amio*cardioversion*ablation*aad / list missing
        noprint out=persistent;
run;

%_sort(data=persistent, out=persistent, by=descending count);

proc print;
run;
