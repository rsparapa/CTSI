## snippet2.R
library(DBI)
library(RPostgres)
user="JHUSERNAME" 
password="JHPASSWORD"
## db object to facilitate database 2-way communication
db=dbConnect(
    Postgres(),           ## connect to PostgreSQL
    dbname  ="fh_jupyter_hub_hbdb",
    user    =user,
    password=password,
    host    ="localhost", ## loopback web connection 
    port    =5432, 
    bigint  ="integer"    ## see dbConnect documentation
)
