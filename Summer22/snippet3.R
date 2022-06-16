## snippet3.R
library(DBI)
library(RPostgres)
user="JHUSERNAME" 
password="JHPASSWORD"
## db object to facilitate database 2-way communication
db=dbConnect(
    Postgres(),           
    dbname  ="fh_jupyter_hub_hbdb",
    user    =user,
    password=password,
    host    ="garth.ctsi.mcw.edu", ## LAN connection 
    port    =5432, 
    bigint  ="integer"    
)
