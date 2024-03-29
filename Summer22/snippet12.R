## snippet12.R
## ' these are single quotes 
##source('snippet11.R')
source('inclause.R')

zdates=dbGetQuery(db, 
        paste("select patient_hash, measure_date_shifted 
               from fh_hb_vitals_jupyter  
               where patient_hash in ",
              inclause(zombies$patient_hash), 
              "order by patient_hash, 
               measure_date_shifted"))           
max.zdates=c(tapply(zdates$measure_date_shifted, 
                    zdates$patient_hash, max))
class(max.zdates)='POSIXct'
print(cbind(format(zombies$death_date_shifted), 
            format(max.zdates)))
