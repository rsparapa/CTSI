## snippet11.R
zombies=dbGetQuery(db,
                   "select distinct a.patient_hash, 
                    a.death_date_shifted,
                    a.vital_status_source
                    from fh_hb_demographics_jupyter a
                    inner join fh_hb_vitals_jupyter b 
                    on a.patient_hash=b.patient_hash 
                    AND a.death_date_shifted<
                    b.measure_date_shifted
                    order by patient_hash")
table(zombies$vital_status_source)
print(zombies)
str(zombies)
