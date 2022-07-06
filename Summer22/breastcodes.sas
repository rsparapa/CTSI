
options ps=53 ls=76;
footnote;

%include "hcpcs.sas";

%macro main;
    
%_cimport(infile=breast.all.hcpcs.table.txt,
    firstobs=5, header=3, dlm=09, out=breast); 

%_verify(data=breast, out=breast, var=_1999-_2018, missing=#);
 
%_cimport(infile=colorectal.all.hcpcs.table.txt,
    firstobs=5, header=3, dlm=09, out=colorectal); 

%_verify(data=colorectal, out=colorectal, var=_1999-_2018, missing=#);

%do year=1999 %to 2018;
data breast&year;
    merge hcpcs(where=(add_dt<="01JAN&year"d & "31DEC&year"d<=term_dt))
        breast(rename=(_&year=breast&year))
        colorectal(rename=(_&year=colorectal&year));
    by hcpcs;
    keep hcpcs cpt breast&year short_description;
    if breast&year>0 & colorectal&year=.;

    cpt=(index('0123456789', substr(hcpcs, 1, 1))>0);
run;

%_sort(data=breast&year, out=breast&year, by=descending breast&year);
%end;

title 'CPT';
proc print uniform n noobs data=breast2016;
    where cpt;
    var hcpcs breast2016;
run;

title 'HCPCS';
proc print uniform n noobs data=breast2016;
    where short_description>' ';
    var hcpcs breast2016 short_description;
run;

proc export data=breast2016 outfile='breastcodes.csv';
run;

%mend main;

%main;
