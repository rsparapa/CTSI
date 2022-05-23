
%_cimport(infile=pedsf.ndc.bn.table.all.sites.csv,
    firstobs=5, header=3, out=oral_meds, keep=brand_name _2018,
    where=brand_name^='MISSING BRAND NAME',
    by=brand_name);

%_verify(data=oral_meds, out=oral_meds, var=_2018, missing=#);

proc freq;
    tables brand_name;
    weight _2018;
run;

%_cimport(infile=medispan.csv, out=medispan,
    upcase=ingredient_rxcui_name, sort=nodupkey,
    by=ingredient_rxcui_name pharm_class);

data oral_meds;
    merge oral_meds(rename=(brand_name=ingredient_rxcui_name))
        medispan(in=medispan);
    by ingredient_rxcui_name;
    if not(first.ingredient_rxcui_name & last.ingredient_rxcui_name)
    then pharm_class='Assorted Classes';
    if _2018>0 & medispan & last.ingredient_rxcui_name;
run;

proc print uniform n;
    var ingredient_rxcui_name pharm_class;
run;
