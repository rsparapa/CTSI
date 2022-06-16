## snippet10.R
a=dbGetQuery(db, "select geocode_result 
                  from fh_hb_demographics_jupyter")
table(a$geocode_result, useNA='ifany')
b=dbGetQuery(db, "select adi_narank 
                  from fh_hb_demographics_jupyter
                  where geocode_result='geocoded'")
table(b$adi_narank, useNA='ifany')
unk = (is.na(b$adi_narank) | 
       b$adi_narank %in% c('GQ', 'PH', 'GQ-PH', 'QDI'))
table(unk)
b$adi=0
b$adi[unk]=NA
b$adi[!unk]=as.integer(b$adi_narank[!unk])
summary(b$adi)
plot(density(b$adi, from=1, to=100, na.rm=TRUE), 
     xlab='ADI', ylab='Distribution', 
     main='', sub='1:least, 100:most')
abline(h=0.01, col=8)
