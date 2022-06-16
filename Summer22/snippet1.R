## snippet1.R
library(DBI)
library(RPostgres)
user="JHUSERNAME" 
password="JHPASSWORD"
db=dbConnect(
    Postgres(), 
    dbname  ="fh_jupyter_hub_hbdb",
    user    =user,
    password=password,
    host    ="localhost", 
    port    =5432, 
    bigint  ="integer"
)
