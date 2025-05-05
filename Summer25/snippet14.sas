
data ablation;
    length px $ 5; 
    input px;
datalines;
33250 surgical
33251 surgical
33254 surgical
33255 surgical
33256 surgical
33265 surgical
33266 surgical
93650 cath
93653 cath
93654 cath
93656 cath
run;

data cardioversion;
    length px $ 5;
    input px;
datalines;
92960
92961
run;

data closure;
    length px $ 5;
    input px;
datalines;
33340 left atrial appendage closure
run;

data codes;
    set ablation cardioversion closure;
    by px;
run;

%_dblib(data=db.fh_hb_procs_jupyter, var=_none_);

data snippet14;
    set db.fh_hb_procs_jupyter(keep=patient_hash encounter_hash
        px_type px i2b2_date_shifted);
    where px_type='CH' & px %_inclause(data=codes, var=px) &
        '01JAN2016:00:00:00'dt<=i2b2_date_shifted<'01JAN2024:00:00:00'dt;
run;

%_dbdata(out=snippet14);

%_sort(data=snippet14, out=snippet14, sort=nodupkey,
    by=patient_hash i2b2_date px);

/*
data count;
    set snippet14;
    by patient_hash;
    %_retain(var=count=0, by=patient_hash);
    count+1;
    keep count;
    if last.patient_hash;
run;

proc freq;
    tables count;
run;
endsas;
*/

%let max=18;

data crdw.snippet14;
    length px $ &max;
    set snippet14;
    by patient_hash;
    array _px(&max) $ 5 px1-px&max;
    array _pxdate(&max) pxdate1-pxdate&max;
    format pxdate1-pxdate&max date7.;

    keep patient_hash px afib_closure ablation cardioversion closure 
        pxtotal px1-px&max pxdate1-pxdate&max;

    %_retain(var=pxtotal=0 px1--px&max='' pxdate1--pxdate&max, by=patient_hash);

    pxtotal+1;

    _px(pxtotal)=px;
    _pxdate(pxtotal)=i2b2_date;

    if last.patient_hash;

    px='';
    ablation=0; cardioversion=0; closure=0; afib_closure=0;
    
    do i=1 to pxtotal;
        if _px(i) %_inclause(data=ablation, var=px) then do;
            substr(px, i, 1)='A';
            ablation+1;
        end;
        else if _px(i) %_inclause(data=cardioversion, var=px) then do;
            substr(px, i, 1)='C';
            cardioversion+1;
        end;
        else if _px(i)='33340' then do;
            substr(px, i, 1)='0';
            closure+1;
        end;

        if _px(i) in('33340', '93656') then afib_closure+1;
    end;
run;

proc freq;
    tables pxtotal afib_closure ablation cardioversion closure;
run;

proc contents varnum;
run;
