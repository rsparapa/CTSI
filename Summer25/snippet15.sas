* AAD: anti-arrhythmic drugs;
%_dblib(data=db.fh_hb_mar_table_jupyter, var=pharm_subclass);

data mar_table;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass
        mar_route ingredient_rxcui_name mar_event_time_shifted);
    where pharm_class='Antiarrhythmic' &
        '01JAN2017:00:00:00'dt<=mar_event_time_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=mar_table);

%_sort(data=mar_table, out=mar_table, by=patient_hash mar_event_time_shifted);

%_dblib(data=db.fh_hb_med_orders_table_jupyter, var=pharm_subclass);

data med_orders;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass 
        order_route ingredient_rxcui_name order_date_shifted);
    where pharm_class='Antiarrhythmic' & 
        '01JAN2017:00:00:00'dt<=order_date_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=med_orders);

%_sort(data=med_orders, out=med_orders, by=patient_hash order_date_shifted);

data aad;
    set mar_table 
        med_orders(rename=(order_route=mar_route
        order_date_shifted=mar_event_time_shifted
        order_date=mar_event_time));
    by patient_hash mar_event_time_shifted;
run;

data crdw.aad;
    length patient_hash $ 16;
    set aad;
    by patient_hash;

    aad=0; amio=0; type1a=0; type1b=0; type1c=0; type3=0; misc=0;

    array __aad(2017:2022) aad17-aad22;
    array __amio(2017:2022) amio17-amio22;
    array __type1a(2017:2022) type1a17-type1a22; 
    array __type1b(2017:2022) type1b17-type1b22; 
    array __type1c(2017:2022) type1c17-type1c22; 
    array __type3(2017:2022) type317-type322; 
    array __misc(2017:2022) misc17-misc22;
    
    array _aad(2017:2022, 12) 
        aad1701-aad1712 aad1801-aad1812 aad1901-aad1912
        aad2001-aad2012 aad2101-aad2112 aad2201-aad2212;
    array _amio(2017:2022, 12) 
        amio1701-amio1712 amio1801-amio1812 amio1901-amio1912
        amio2001-amio2012 amio2101-amio2112 amio2201-amio2212;
    array _type1a(2017:2022, 12) 
        type1a1701-type1a1712 type1a1801-type1a1812 type1a1901-type1a1912
        type1a2001-type1a2012 type1a2101-type1a2112 type1a2201-type1a2212;
    array _type1b(2017:2022, 12) 
        type1b1701-type1b1712 type1b1801-type1b1812 type1b1901-type1b1912
        type1b2001-type1b2012 type1b2101-type1b2112 type1b2201-type1b2212;
    array _type1c(2017:2022, 12) 
        type1c1701-type1c1712 type1c1801-type1c1812 type1c1901-type1c1912
        type1c2001-type1c2012 type1c2101-type1c2112 type1c2201-type1c2212;
    array _type3(2017:2022, 12) 
        type31701-type31712 type31801-type31812 type31901-type31912
        type32001-type32012 type32101-type32112 type32201-type32212;
    array _misc(2017:2022, 12) 
        misc1701-misc1712 misc1801-misc1812 misc1901-misc1912
        misc2001-misc2012 misc2101-misc2112 misc2201-misc2212;

    keep patient_hash aad amio type1a type1b type1c type3 misc
        aad17-aad22 amio17-amio22 type1a17-type1a22 type1b17-type1b22 
        type1c17-type1c22 type317-type322 misc17-misc22 
        aad1701-aad1712 aad1801-aad1812 aad1901-aad1912
        aad2001-aad2012 aad2101-aad2112 aad2201-aad2212
        amio1701--amio1712 amio1801--amio1812 amio1901--amio1912
        amio2001--amio2012 amio2101--amio2112 amio2201--amio2212
        type1a1701--type1a1712 type1a1801--type1a1812 type1a1901--type1a1912
        type1a2001--type1a2012 type1a2101--type1a2112 type1a2201--type1a2212
        type1b1701--type1b1712 type1b1801--type1b1812 type1b1901--type1b1912
        type1b2001--type1b2012 type1b2101--type1b2112 type1b2201--type1b2212
        type1c1701--type1c1712 type1c1801--type1c1812 type1c1901--type1c1912
        type1c2001--type1c2012 type1c2101--type1c2112 type1c2201--type1c2212
        type31701--type31712 type31801--type31812 type31901--type31912
        type32001--type32012 type32101--type32112 type32201--type32212
        misc1701--misc1712 misc1801--misc1812 misc1901--misc1912
        misc2001--misc2012 misc2101--misc2112 misc2201--misc2212;
    
    %_retain(default=0, by=patient_hash, var=
        aad1701--aad1712 aad1801--aad1812 aad1901--aad1912
        aad2001--aad2012 aad2101--aad2112 aad2201--aad2212
        amio1701--amio1712 amio1801--amio1812 amio1901--amio1912
        amio2001--amio2012 amio2101--amio2112 amio2201--amio2212
        type1a1701--type1a1712 type1a1801--type1a1812 type1a1901--type1a1912
        type1a2001--type1a2012 type1a2101--type1a2112 type1a2201--type1a2212
        type1b1701--type1b1712 type1b1801--type1b1812 type1b1901--type1b1912
        type1b2001--type1b2012 type1b2101--type1b2112 type1b2201--type1b2212
        type1c1701--type1c1712 type1c1801--type1c1812 type1c1901--type1c1912
        type1c2001--type1c2012 type1c2101--type1c2112 type1c2201--type1c2212
        type31701--type31712 type31801--type31812 type31901--type31912
        type32001--type32012 type32101--type32112 type32201--type32212
        misc1701--misc1712 misc1801--misc1812 misc1901--misc1912
        misc2001--misc2012 misc2101--misc2112 misc2201--misc2212
        );

    month=month(mar_event_time);
    year =year(mar_event_time);
    
    select;
    when(ingredient_rxcui_name='amiodarone') 
        _amio(year, month)+1; 
    when(pharm_subclass='Antiarrhythmics - Misc.') 
        _misc(year, month)+1; 
    when(pharm_subclass='Antiarrhythmics Type I-A') 
        _type1a(year, month)+1; 
    when(pharm_subclass='Antiarrhythmics Type I-B') 
        _type1b(year, month)+1; 
    when(pharm_subclass='Antiarrhythmics Type I-C') 
        _type1c(year, month)+1; 
    when(pharm_subclass='Antiarrhythmics Type III') 
        _type3(year, month)+1; 
    otherwise;
    end;
    
    if last.patient_hash;

    do year=2017 to 2022;
        __aad(year)=0;
        __amio(year)=0;
        __type1a(year)=0;
        __type1b(year)=0;
        __type1c(year)=0;
        __type3(year)=0;
        __misc(year)=0;

        do month=1 to 12;
        _aad(year, month)=_amio(year, month)+_misc(year, month)+
        _type1a(year, month)+_type1b(year, month)+_type1c(year, month)+
        _type3(year, month); 
        __aad(year)  =__aad(year)+(_aad(year, month)>0);
        __amio(year)  =__amio(year)+(_amio(year, month)>0);
        __type1a(year)=__type1a(year)+(_type1a(year, month)>0);
        __type1b(year)=__type1b(year)+(_type1b(year, month)>0);
        __type1c(year)=__type1c(year)+(_type1c(year, month)>0);
        __type3(year) =__type3(year)+(_type3(year, month)>0);
        __misc(year)  =__misc(year)+(_misc(year, month)>0);
        end;
    
        aad=aad+(__aad(year));
        amio=amio+(__amio(year));
        type1a=type1a+(__type1a(year));
        type1b=type1b+(__type1b(year));
        type1c=type1c+(__type1c(year));
        type3=type3+(__type3(year));
        misc=misc+(__misc(year));
    end;
run;

proc freq;
    tables aad amio type1a type1b type1c type3 misc;
run;

proc contents varnum;
run;
