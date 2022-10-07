* snippet9.sas ;
%include "snippet8.sas";

proc freq data=naaccr;
    tables site_primary*behavior_code_icd_o_3;
run;     

proc export replace data=naaccr outfile='naaccr.csv';
run;

proc contents varnum data=naaccr;
run;
