## snippet6.R
## ' these are single quotes
naaccr=dbGetQuery(db, 
          "select
           date_part('year', date_of_diagnosis_shifted)
           as dxyear from fh_hb_naaccr_jupyter")
t(table(naaccr$dxyear))
