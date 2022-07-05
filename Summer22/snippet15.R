## snippet15.R
## ' these are single quotes 
procs=dbGetQuery(db, 
           "select px from fh_hb_procs_jupyter
            where px_type='CH'") 
table(substr(procs$px, 1, 1))
table(substr(procs$px, 2, 2))
table(substr(procs$px, 3, 3))
table(substr(procs$px, 4, 4))
table(substr(procs$px, 5, 5))

