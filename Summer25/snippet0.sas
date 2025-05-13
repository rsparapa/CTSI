* autoexec.sas ;

%global user password;

%let user=JHUSERNAME; 
%let password=JHPASSWORD;

proc pwencode in="&password";
run;

%let password=&_pwencode;

libname crdw "/data/shared/04224/afib/libname/crdw";

%_ifelse(%_exist(~/autoexec.sas), 
    %include "~/autoexec.sas");

*options validmemname = extend;
/* enable multiple periods in table references */

