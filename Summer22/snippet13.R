## snippet13.R
medispan=dbGetQuery(db, 
           "select distinct pharm_class, pharm_subclass, 
            substring(gpi from 1 for 2) as gpi_group,
            substring(gpi from 3 for 2) as gpi_class,
            substring(gpi from 5 for 2) as gpi_subclass,
            ingredient_rxcui_name
            from fh_hb_mar_table_jupyter 
            order by pharm_class, pharm_subclass,
            ingredient_rxcui_name")
write.csv(medispan,"medispan.csv",row.names=FALSE,na="")
