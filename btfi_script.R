library(devtools)
library(duckdb)

# install dev version of celltracktech library
devtools::install_github('cellular-tracking-technologies/celltracktech', ref='dev')

# create data directories
# Create your data directory if it does not exist
outpath <- "./data/btfi/" # where your downloaded files are to go

create_outpath(outpath)

# Connect to Database using DuckDB -----------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = "./data/btfi/btfi.duckdb", 
                      read_only = FALSE)

# Import node data into your database
import_node_data(d = con,
                 outpath = outpath,
                 myproject = myproject)

# update the database
update_db(d = con,
          outpath = outpath,
          myproject = myproject,
          fix = FALSE)

# disconnect from the database
DBI::dbDisconnect(con)