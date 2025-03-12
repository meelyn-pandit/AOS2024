library(devtools)
# install_github('cellular-tracking-technologies/celltracktech',
#                ref = 'dev')
renv::install('cellular-tracking-technologies/celltracktech',
              ref = 'dev')
library(celltracktech)
library(duckdb) # added to package, need to re-install
library(dotenv)

# stores the time you run 
start <- Sys.time()

# load env file into environment
load_dot_env(file='.env')


# install duckdb through R-universe
# install.packages("duckdb", repos = c("https://duckdb.r-universe.dev", "https://cloud.r-project.org"))
# renv::install('duckdb', repos = c('https://duckdb.r-universe.dev', 'https://cloud.r-project.org'))

# Settings ----------------------------------------------------------------
my_token <- Sys.getenv('WORKSHOP') # load env variable into my_token
myproject <- "Meadows V2" #this is your project name on your CTT account
outpath <- "./data/meadows/" #where your downloaded files are to go

# Create outpath folder if it does not exist
create_outpath(outpath)


# Connect to Database using DuckDB -----------------------------------------------------
con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = "./data/meadows/meadows.duckdb", 
                      read_only = FALSE)

# Get data from CTT Server ------------------------------------------------
get_my_data(my_token,
            outpath, 
            con, 
            myproject=myproject, 
            begin=as.Date("2023-08-03"), 
            end=as.Date("2023-08-04"), 
            filetypes=c("raw", "node_health")
)


# Optional! Import Node data from SD Card ---------------------------------
import_node_data(d=con,
                 outpath=outpath,
                 myproject = myproject)


# Update your local database with the recently downloaded data ------------
update_db(con, outpath, myproject)


# Disconnect from your database to save memory ----------------------------
DBI::dbDisconnect(con)

time_elapse <- Sys.time() - start
print(time_elapse)

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

