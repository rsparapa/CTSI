## snippet4.R
## ' these are single quotes 
tables=dbGetQuery(db, 
             "select * 
              from information_schema.tables
              where table_schema = 'public'")
print(tables$table_name)
