* snippet6.sas ;
/*
BEWARE: this takes 8 hours and is demanding
you need to submit it with TORQUE like so
qsas snippet6 -host cheddar
*/
* generate Medi-Span nomenclature: medispan.csv;
%_dblib(data=db.fh_hb_mar_table_jupyter,
    var=pharm_class pharm_subclass gpi mar_route 
        ingredient_rxcui_name);

data mar_table;
    set db.&dbdata(keep=pharm_class pharm_subclass gpi 
        mar_route ingredient_rxcui_name);
    where gpi>"" &
        ingredient_rxcui_name^="No ingredient mapped";
run;

%_dbdata(out=mar_table);

proc sort data=mar_table;
    by pharm_class pharm_subclass gpi ingredient_rxcui_name;
run;
%*_sort(data=mar_table, out=mar_table, 
    by=pharm_class pharm_subclass gpi ingredient_rxcui_name);

data mar_table;
    length mar_route $ 5;
    set mar_table;
    if mar_route^="Oral" then mar_route="Other";
run;

proc freq noprint data=mar_table;
    by pharm_class pharm_subclass gpi ingredient_rxcui_name;
    tables mar_route / out=mar_table(drop=percent);
run;

%_dblib(data=db.fh_hb_med_orders_table_jupyter,
    var=pharm_class pharm_subclass gpi order_route 
        ingredient_rxcui_name);

data med_orders;
    set db.&dbdata(keep=pharm_class pharm_subclass gpi order_route 
        ingredient_rxcui_name);
    where ingredient_rxcui_name^='No ingredient mapped' & gpi>'';
run;

%_dbdata(out=med_orders);

%_sort(data=med_orders, out=med_orders, 
    by=pharm_class pharm_subclass gpi ingredient_rxcui_name);

data med_orders;
    length order_route $ 5;
    set med_orders;
    if order_route^="Oral" then order_route="Other";
run;

proc freq noprint data=med_orders;
    by pharm_class pharm_subclass gpi ingredient_rxcui_name;
    tables order_route / out=med_orders(drop=percent);
run;

data medispan;
    length gpi $ 20 
      gpi_group gpi_class gpi_subclass gpi_base gpi_name gpi_form gpi_dose $ 2; 
    merge 
        mar_table(rename=(count=mar_count mar_route=route)) 
        med_orders(rename=(count=order_count order_route=route))
    ;
    by pharm_class pharm_subclass gpi ingredient_rxcui_name route;
    if mar_count=. then mar_count=0;
    if order_count=. then order_count=0;
    gpi_group=substr(gpi, 1, 2);
    gpi_class=substr(gpi, 3, 2);
    gpi_subclass=substr(gpi, 5, 2);
    gpi_base=substr(gpi, 7, 2);
    gpi_name=substr(gpi, 9, 2);
    gpi_form=substr(gpi, 11, 2);
    gpi_dose=substr(gpi, 13, 2);
    gpi=gpi_group||'-'||gpi_class||'-'||gpi_subclass||'-'||gpi_base||'-'||gpi_name||'-'||gpi_form||'-'||gpi_dose;
run;

%_vorder(data=medispan, out=crdw.medispan,
    var=pharm_class pharm_subclass ingredient_rxcui_name route
    mar_count order_count
    gpi_group gpi_class gpi_subclass gpi_base gpi_name gpi_form gpi_dose gpi);

proc export replace data=crdw.medispan outfile='medispan.csv';
run;

proc contents varnum;
run;
