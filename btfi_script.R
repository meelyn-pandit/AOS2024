# Install celltracktech library - dev version -----------------------------
library(devtools)
devtools::install_github('cellular-tracking-technologies/celltracktech', ref='dev')
# renv::install('cellular-tracking-technologies/celltracktech', ref='dev')

# Load Libraries ----------------------------------------------------------
library(duckdb)
library(celltracktech)

# Create folders ----------------------------------------------------------

# Set your outpath - for you this is your desktop
outpath <- "C:/Users/jd111569/OneDrive - James Cook University/Desktop/" # where your downloaded files are to go

myproject = 'Black-throated finches in Australia'

# create dates and nodes lists
dates = c('20240101', '20240102', '20240103')
nodes = c('node01', 'node02', 'node03', 'node04')

# create dates and nodes folder
for(i in dates) {
  for(j in nodes) {
    create_outpath(paste0(outpath, myproject, '/', 'nodes/', i, '/', j))
  }
}


# Connect to Database using DuckDB -----------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = "./data/btfi.duckdb", 
                      read_only = FALSE)

create_duck(con)

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


# SQL queries -------------------------------------------------------------

con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = "./data/btfi.duckdb", 
                      read_only = FALSE)

# list tables in database
DBI::dbListTables(con)

# list last 10 records in raw
raw = DBI::dbGetQuery(con, "SELECT * FROM raw ")
head(raw)

# list first 10 records in blu
blu = DBI::dbGetQuery(con, "SELECT * FROM blu")
head(blu)

# list first 10 records in gps
gps = DBI::dbGetQuery(con, "SELECT * FROM gps ")
head(gps)

# list first 10 records in node_health
node_health = DBI::dbGetQuery(con, 'SELECT * FROM node_health')
head(node_health)

# list the number of unique nodes in your project
node_table = DBI::dbGetQuery(con, 'SELECT * FROM nodes')
head(node_table)

# list the data files that were used to create your database
df_table = DBI::dbGetQuery(con, 'SELECT * FROM data_file')

DBI::dbDisconnect(con)
