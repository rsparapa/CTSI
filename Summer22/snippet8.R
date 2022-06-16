## snippet8.R
## ' these are single quotes
naaccr=dbGetQuery(db, 
          "select * from fh_hb_naaccr_jupyter
           where (sequence_number_hospital='0'
           or sequence_number_hospital='1') and
           (date_part('year', date_of_diagnosis_shifted)
           between 2016 and 2017) and
           site_primary like 'C50%'")
addmargins(table(naaccr$sequence_number_hospital))
addmargins(table(naaccr$site_primary))
