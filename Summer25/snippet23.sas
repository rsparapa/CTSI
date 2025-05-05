*snippet23.sas;

proc univariate noprint data=crdw.snippet22;
    var ii;
    by patient_hash patient_trac_id;
    output out=ii min=min max=max;
run;

proc univariate plot;
    var min max;
run;

data count;
    set crdw.snippet22;
    by patient_hash patient_trac_id;
    where ms=1;
    %_retain(var=count=0, by=patient_hash);
    count+1;
    if last.patient_hash;
run;

proc freq;
    tables count;
run;

options orientation=landscape; 

footnote;
ods graphics on / reset imagename="snippet23" imagefmt=pdf
    MAXOBS=23705000;

proc sgpanel data=crdw.snippet22 aspect=0.2;
    by patient_hash;
    panelby patient_trac_id / columns=1 rows=4;
    series x=ms y=ii;
    colaxis values=(0 to 10000 by 1000) grid minorgrid minorcount=4;
    rowaxis values=(-2 to 2 by 1) grid minorgrid minorcount=1 label='mV';
run;

%_pdfjam;
