# Install celltracktech library - dev version -----------------------------

devtools::install_github('cellular-tracking-technologies/celltracktech', 
                         ref='dev')

# Load Libraries ----------------------------------------------------------
library(devtools)
library(duckdb)
library(celltracktech)


# Create folders ----------------------------------------------------------

# Create your data folder if it does not exist
outpath <- "./data/" # where your downloaded files are to go

myproject = 'Black-throated Finches in Australia'
create_outpath(outpath)

# create project and sensor station folder
create_outpath('./data/Black-throated Finches in Australia/V3023D36B0FC/')

# create nodes folder in project folder
create_outpath('./data/Black-throated Finches in Australia/nodes/node5/')


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
blu = DBI::dbGetQuery(con, "SELECT * FROM blu ")
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
