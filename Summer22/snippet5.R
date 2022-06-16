## snippet5.R
## ' these are single quotes 
columns=dbGetQuery(db, 
             "select * 
              from information_schema.columns
              where table_schema = 'public'")
str(columns)
table(columns$table_name)
