
%_cimport(infile=pedsf.ndc.bn.table.all.sites.csv,
    firstobs=5, header=3, out=oral_meds, keep=brand_name _2018,
    where=brand_name^='MISSING BRAND NAME');

%_verify(data=oral_meds, out=oral_meds, var=_2018, missing=#);

proc freq order=freq;
    tables brand_name;
    weight _2018;
run;

proc import datafile='medispan.csv' out=medispan;
    guessingrows=max;
run;

%let m=%_nobs(data=medispan);

data oral_meds;
    set oral_meds;
    drop j k match;
    match=0;
    if _2018>0 then do i=1 to &m until(match);
        set medispan point=i;
        j=length(ingredient_rxcui_name);
        k=length(brand_name);
        match=(j>=k & substr(ingredient_rxcui_name, 1, k)=lowcase(brand_name));
        if match then output;
    end;
run;
    
proc print uniform n;
    var brand_name ingredient_rxcui_name;
run;
