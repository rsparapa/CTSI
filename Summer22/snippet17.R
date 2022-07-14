## snippet17.R
source('byvalue.R')
sx.=byvalue('patient_hash', sx)
table(sx.$first.patient_hash, useNA='ifany')
