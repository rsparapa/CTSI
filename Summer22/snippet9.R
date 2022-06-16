## snippet9.R
addmargins(table(naaccr$site_primary, 
           naaccr$behavior_code_icd_o_3))
write.csv(naaccr, "naaccr.csv", row.names=FALSE, na="") 
str(naaccr)
?str
