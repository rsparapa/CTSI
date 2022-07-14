## snippet16.R
## ' these are single quotes
sx=dbGetQuery(db,
paste("select * from fh_hb_surgical_case_jupyter
       where log_type='Surgical Log' and
       or_status='Posted' and
       surgical_service='Trauma' and
       date_part('year', sched_start_time_shifted)=2018
       order by patient_hash, sched_start_time_shifted,
       encounter_hash"))
addmargins(table(sx$case_class, useNA='ifany'))
