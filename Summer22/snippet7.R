## snippet7.R
## ' these are single quotes
muse=dbGetQuery(db, 
          "select
           date_part('year',acquisition_date_shifted)
           as ekgyear from ekg_test_demographics")
t(table(muse$ekgyear))
