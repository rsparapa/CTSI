## snippet14.R
procs=dbGetQuery(db, 
           "select px_type from fh_hb_procs_jupyter") 
table(procs$px_type,useNA='ifany')/length(procs$px_type)

##       09       10       CH       OT     <NA> 
## 0.001025 0.002704 0.879903 0.109712 0.006656 
