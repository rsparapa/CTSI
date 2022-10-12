## snippet3.R
library(DBI)
library(RPostgres)
user="JHUSERNAME" 
password="JHPASSWORD"
server="garth.ctsi.mcw.edu"

## db object to facilitate database 2-way communication
db=dbConnect(
    Postgres(),           
    dbname  ="fh_jupyter_hub_hbdb",
    user    =user,
    password=password,
    host    =server, ## LAN connection 
    port    =5432, 
    bigint  ="integer"    
)
