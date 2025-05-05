*snippet25.sas;
endsas;

/* this script is not demanding
but its very slow: it takes 6 days! 
although SAS is written in fast C
SG PROCs are slow-poke Java code
*/

options orientation=landscape; 
footnote;

data snippet22;
    merge crdw.ekg_meas_matrix crdw.snippet22;
    by patient_hash patient_trac_id;
    if n(ms);
run;

%macro main;

data patient_hash;
    set snippet22;
    by patient_hash;
    keep patient_hash;
    if first.patient_hash;
run;

%let nobs=%_nobs(data=patient_hash);

%do i=1 %to &nobs;
    data _null_;
        set patient_hash(obs=&i firstobs=&i);
        call symput("patient_hash", trim(patient_hash));
    run;
    
ods graphics on / reset imagename="&patient_hash" imagefmt=pdf;

proc sgplot data=snippet22 aspect=0.25;
    where patient_hash="&patient_hash";
    by patient_trac_id nqrs print vrate;
    series x=ms y=ii;
    xaxis values=(0 to 10000 by 1000) grid minorgrid minorcount=4;
    yaxis values=(-3 to 3 by 1) grid minorgrid minorcount=1 label='mV';
run;

%_pdfjam(root=&patient_hash);

x "mv &patient_hash..pdf figures/";
%end;
    
%mend main;

%main;

