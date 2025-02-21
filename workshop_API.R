library(celltracktech)
library(duckdb)
library(dotenv)

load_dot_env(file='.env')

start <- Sys.time()

# install.packages("duckdb", repos = c("https://duckdb.r-universe.dev", "https://cloud.r-project.org"))
# renv::install('duckdb', repos = c('https://duckdb.r-universe.dev', 'https://cloud.r-project.org'))

####SETTINGS#####
my_token <- Sys.getenv('WORKSHOP')
myproject <- "Meadows V2" #this is your project name on your CTT account
outpath <- "data" #where your downloaded files are to go 
con <- DBI::dbConnect(duckdb::duckdb(), 
                      dbdir = "./data/meadows.db", 
                      read_only = FALSE)


################
get_my_data(my_token,
            outpath, 
            con, 
            myproject=myproject, 
            begin=as.Date("2023-08-01"), 
            end=as.Date("2023-12-31"), 
            filetypes=c("raw", "node_health")
            )

import_node_data(d=con,
                 outpath=outpath,
                 myproject = myproject)

update_db(con, outpath, myproject)
DBI::dbDisconnect(con)

time_elapse <- Sys.time() - start
print(time_elapse)
