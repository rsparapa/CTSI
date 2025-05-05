*anti-coagulants;
%_dblib(data=db.fh_hb_mar_table_jupyter, var=pharm_subclass);

data mar_table;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass
        mar_route ingredient_rxcui_name mar_event_time_shifted);
    where (pharm_subclass in('Direct Factor Xa Inhibitors', 
        'Thrombin Inhibitors') | ingredient_rxcui_name='warfarin' | 
        (pharm_subclass='Heparins And Heparinoid-Like Agents'  
        & ingredient_rxcui_name^='heparin')) &
        '01JAN2017:00:00:00'dt<=mar_event_time_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=mar_table);

%_sort(data=mar_table, out=mar_table, by=patient_hash mar_event_time_shifted);

%_dblib(data=db.fh_hb_med_orders_table_jupyter, var=pharm_subclass);

data med_orders;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass 
        order_route ingredient_rxcui_name order_date_shifted);
    where (pharm_subclass in('Direct Factor Xa Inhibitors', 
        'Thrombin Inhibitors') | ingredient_rxcui_name='warfarin' | 
        (pharm_subclass='Heparins And Heparinoid-Like Agents'  
        & ingredient_rxcui_name^='heparin')) &
        '01JAN2017:00:00:00'dt<=order_date_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=med_orders);

%_sort(data=med_orders, out=med_orders, by=patient_hash order_date_shifted);

data antic;
    set mar_table 
        med_orders(rename=(order_route=mar_route
        order_date_shifted=mar_event_time_shifted
        order_date=mar_event_time));
    by patient_hash mar_event_time_shifted;
run;

data crdw.antic;
    length patient_hash $ 16;
    set antic;
    by patient_hash;

    antic=0; warf=0; factorxa=0; thrombin=0; lmwh=0;

    array __antic(2017:2022) antic17-antic22;
    array __warf(2017:2022) warf17-warf22;
    array __factorxa(2017:2022) factorxa17-factorxa22; 
    array __thrombin(2017:2022) thrombin17-thrombin22; 
    array __lmwh(2017:2022) lmwh17-lmwh22;
    
    array _antic(2017:2022, 12) 
        antic1701-antic1712 antic1801-antic1812 antic1901-antic1912
        antic2001-antic2012 antic2101-antic2112 antic2201-antic2212;
    array _warf(2017:2022, 12) 
        warf1701-warf1712 warf1801-warf1812 warf1901-warf1912
        warf2001-warf2012 warf2101-warf2112 warf2201-warf2212;
    array _factorxa(2017:2022, 12) 
        factorxa1701-factorxa1712 factorxa1801-factorxa1812 factorxa1901-factorxa1912
        factorxa2001-factorxa2012 factorxa2101-factorxa2112 factorxa2201-factorxa2212;
    array _thrombin(2017:2022, 12) 
        thrombin1701-thrombin1712 thrombin1801-thrombin1812 thrombin1901-thrombin1912
        thrombin2001-thrombin2012 thrombin2101-thrombin2112 thrombin2201-thrombin2212;
    array _lmwh(2017:2022, 12) 
        lmwh1701-lmwh1712 lmwh1801-lmwh1812 lmwh1901-lmwh1912
        lmwh2001-lmwh2012 lmwh2101-lmwh2112 lmwh2201-lmwh2212;

    keep patient_hash antic warf factorxa thrombin lmwh antic17-antic22
        warf17-warf22 factorxa17-factorxa22 thrombin17-thrombin22 lmwh17-lmwh22 
        antic1701--antic1712 antic1801--antic1812 antic1901--antic1912
        antic2001--antic2012 antic2101--antic2112 antic2201--antic2212
        warf1701--warf1712 warf1801--warf1812 warf1901--warf1912
        warf2001--warf2012 warf2101--warf2112 warf2201--warf2212
        factorxa1701--factorxa1712 factorxa1801--factorxa1812 factorxa1901--factorxa1912
        factorxa2001--factorxa2012 factorxa2101--factorxa2112 factorxa2201--factorxa2212
        thrombin1701--thrombin1712 thrombin1801--thrombin1812 thrombin1901--thrombin1912
        thrombin2001--thrombin2012 thrombin2101--thrombin2112 thrombin2201--thrombin2212
        lmwh1701--lmwh1712 lmwh1801--lmwh1812 lmwh1901--lmwh1912
        lmwh2001--lmwh2012 lmwh2101--lmwh2112 lmwh2201--lmwh2212;
    
    %_retain(default=0, by=patient_hash, var=
        antic1701--antic1712 antic1801--antic1812 antic1901--antic1912
        antic2001--antic2012 antic2101--antic2112 antic2201--antic2212
        warf1701--warf1712 warf1801--warf1812 warf1901--warf1912
        warf2001--warf2012 warf2101--warf2112 warf2201--warf2212
        factorxa1701--factorxa1712 factorxa1801--factorxa1812 factorxa1901--factorxa1912
        factorxa2001--factorxa2012 factorxa2101--factorxa2112 factorxa2201--factorxa2212
        thrombin1701--thrombin1712 thrombin1801--thrombin1812 thrombin1901--thrombin1912
        thrombin2001--thrombin2012 thrombin2101--thrombin2112 thrombin2201--thrombin2212
        lmwh1701--lmwh1712 lmwh1801--lmwh1812 lmwh1901--lmwh1912
        lmwh2001--lmwh2012 lmwh2101--lmwh2112 lmwh2201--lmwh2212
        );

    month=month(mar_event_time);
    year =year(mar_event_time);
    
    select;
    when(ingredient_rxcui_name='warfarin') 
        _warf(year, month)+1; 
    when(pharm_subclass='Heparins And Heparinoid-Like Agents') 
        _lmwh(year, month)+1; 
    when(pharm_subclass='Direct Factor Xa Inhibitors') 
        _factorxa(year, month)+1; 
    when(pharm_subclass='Thrombin Inhibitors') 
        _thrombin(year, month)+1; 
    otherwise;
    end;

    if last.patient_hash;

    do year=2017 to 2022;
        __antic(year)=0;
        __warf(year)=0;
        __factorxa(year)=0;
        __thrombin(year)=0;
        __lmwh(year)=0;

        do month=1 to 12;
        _antic(year, month)=_warf(year, month)+_factorxa(year, month)+
            _thrombin(year, month)+_lmwh(year, month);
        __antic(year)=__antic(year)+(_antic(year, month)>0);
        __warf(year)  =__warf(year)+(_warf(year, month)>0);
        __factorxa(year)=__factorxa(year)+(_factorxa(year, month)>0);
        __thrombin(year)=__thrombin(year)+(_thrombin(year, month)>0);
        __lmwh(year)  =__lmwh(year)+(_lmwh(year, month)>0);
        end;
    
        antic=antic+(__antic(year));
        warf=warf+(__warf(year));
        factorxa=factorxa+(__factorxa(year));
        thrombin=thrombin+(__thrombin(year));
        lmwh=lmwh+(__lmwh(year));
    end;
run;

proc freq;
    tables antic warf factorxa thrombin lmwh;
run;

proc contents varnum;
run;
