* snippet1.sas;

proc import datafile="DIR/naaccr.csv" out=naaccr;
guessingrows=max;
run;
%_verify(data=naaccr, out=naaccr);
%_constant(data=naaccr, out=naaccr);

