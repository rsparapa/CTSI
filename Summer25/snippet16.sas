* heart rate reducers: beta blockers, calcium blockers & digoxin;
%_dblib(data=db.fh_hb_mar_table_jupyter, var=pharm_subclass);

data mar_table;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass
        mar_route ingredient_rxcui_name mar_event_time_shifted);
    where (pharm_class in('Beta blockers', 'Calcium blockers') |
        ingredient_rxcui_name='digoxin') &
        '01JAN2017:00:00:00'dt<=mar_event_time_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=mar_table);

%_sort(data=mar_table, out=mar_table, by=patient_hash mar_event_time_shifted);

%_dblib(data=db.fh_hb_med_orders_table_jupyter, var=pharm_subclass);

data med_orders;
    set db.&dbdata(keep=patient_hash pharm_class pharm_subclass 
        order_route ingredient_rxcui_name order_date_shifted);
    where (pharm_class in('Beta blockers', 'Calcium blockers') |
        ingredient_rxcui_name='digoxin') &
        '01JAN2017:00:00:00'dt<=order_date_shifted<'01JAN2023:00:00:00'dt;
run;

%_dbdata(out=med_orders);

%_sort(data=med_orders, out=med_orders, by=patient_hash order_date_shifted);

data rate;
    set mar_table 
        med_orders(rename=(order_route=mar_route
        order_date_shifted=mar_event_time_shifted
        order_date=mar_event_time));
    by patient_hash mar_event_time_shifted;
run;

data crdw.rate;
    length patient_hash $ 16;
    set rate;
    by patient_hash;

    rate=0; digoxin=0; calcium=0; beta=0;

    array __rate(2017:2022) rate17-rate22;
    array __digoxin(2017:2022) digoxin17-digoxin22;
    array __calcium(2017:2022) calcium17-calcium22; 
    array __beta(2017:2022) beta17-beta22;
    
    array _rate(2017:2022, 12) 
        rate1701-rate1712 rate1801-rate1812 rate1901-rate1912
        rate2001-rate2012 rate2101-rate2112 rate2201-rate2212;
    array _digoxin(2017:2022, 12) 
        digoxin1701-digoxin1712 digoxin1801-digoxin1812 digoxin1901-digoxin1912
        digoxin2001-digoxin2012 digoxin2101-digoxin2112 digoxin2201-digoxin2212;
    array _calcium(2017:2022, 12) 
        calcium1701-calcium1712 calcium1801-calcium1812 calcium1901-calcium1912
        calcium2001-calcium2012 calcium2101-calcium2112 calcium2201-calcium2212;
    array _beta(2017:2022, 12) 
        beta1701-beta1712 beta1801-beta1812 beta1901-beta1912
        beta2001-beta2012 beta2101-beta2112 beta2201-beta2212;

    keep patient_hash rate digoxin calcium beta
        rate17-rate22 digoxin17-digoxin22 calcium17-calcium22 beta17-beta22 
        rate1701-rate1712 rate1801-rate1812 rate1901-rate1912
        rate2001-rate2012 rate2101-rate2112 rate2201-rate2212
        digoxin1701--digoxin1712 digoxin1801--digoxin1812 digoxin1901--digoxin1912
        digoxin2001--digoxin2012 digoxin2101--digoxin2112 digoxin2201--digoxin2212
        calcium1701--calcium1712 calcium1801--calcium1812 calcium1901--calcium1912
        calcium2001--calcium2012 calcium2101--calcium2112 calcium2201--calcium2212
        beta1701--beta1712 beta1801--beta1812 beta1901--beta1912
        beta2001--beta2012 beta2101--beta2112 beta2201--beta2212;
    
    %_retain(default=0, by=patient_hash, var=
        rate1701--rate1712 rate1801--rate1812 rate1901--rate1912
        rate2001--rate2012 rate2101--rate2112 rate2201--rate2212
        digoxin1701--digoxin1712 digoxin1801--digoxin1812 digoxin1901--digoxin1912
        digoxin2001--digoxin2012 digoxin2101--digoxin2112 digoxin2201--digoxin2212
        calcium1701--calcium1712 calcium1801--calcium1812 calcium1901--calcium1912
        calcium2001--calcium2012 calcium2101--calcium2112 calcium2201--calcium2212
        beta1701--beta1712 beta1801--beta1812 beta1901--beta1912
        beta2001--beta2012 beta2101--beta2112 beta2201--beta2212
        );

    month=month(mar_event_time);
    year =year(mar_event_time);
    
    select;
    when(ingredient_rxcui_name='digoxin') 
        _digoxin(year, month)+1; 
    when(pharm_class='Beta blockers')
        _beta(year, month)+1; 
    when(pharm_class='Calcium blockers')
        _calcium(year, month)+1; 
    otherwise;
    end;

    if last.patient_hash;

    do year=2017 to 2022;
        __rate(year)=0;
        __digoxin(year)=0;
        __calcium(year)=0;
        __beta(year)=0;

        do month=1 to 12;
        _rate(year, month)=_digoxin(year, month)+_calcium(year, month)+
            _beta(year, month);
        __rate(year)  =__rate(year)+(_rate(year, month)>0);
        __digoxin(year)  =__digoxin(year)+(_digoxin(year, month)>0);
        __calcium(year) =__calcium(year)+(_calcium(year, month)>0);
        __beta(year)  =__beta(year)+(_beta(year, month)>0);
        end;
    
        rate=rate+(__rate(year));
        digoxin=digoxin+(__digoxin(year));
        calcium=calcium+(__calcium(year));
        beta=beta+(__beta(year));
    end;
run;

proc freq;
    tables rate digoxin calcium beta;
run;

proc contents varnum;
run;
