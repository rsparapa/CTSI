## snippet18.R
## ' these are single quotes
source('inclause.R')
dx=dbGetQuery(db,
paste("select * from fh_hb_diagnosis_jupyter
       where dx_type='10' and
       date_part('year', dx_date_shifted)=2018 and
       encounter_hash in", inclause(sx.$encounter_hash),
      "order by patient_hash, dx_date_shifted,
       encounter_hash"))
addmargins(table(dx$enc_type, useNA='ifany'))
