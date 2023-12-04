# ===============================================================
#  R CONNECTION WITH MYSQL AND TESTS 
# ===============================================================
# Install packages
# install.packages("RMySQL")
# install.packages("RODBC")
# install.packages("DBI")
# install.packages("odbc")

# Load package
library(RMySQL)
library(RODBC)
library(DBI)
library(odbc)


# ===============================================
# Connect to database
mydb <- dbConnect(MySQL(), user = 'root', 
                 password = 'yours',
                 dbname = 'weather_db', 
                 host = 'localhost')

# ========================================================================
# Table manipulation

# We will use ???dbListTables??? function to list all tables in our database 
# and ???dbWriteTable??? to write a table from a data frame
 
dbListTables(mydb)

# dbWriteTable(mydb, "mtcars",
#             mtcars[1:5, ])

# ========================================================================
  # Error?
# Once the above problem happens, you can try the following code to resolve it:
  
     
# dbSendQuery(mydb, "SET GLOBAL local_infile = true;") 
 

# Then, remove the ???mtcars??? from the weather_db using: 
  
     
# dbRemoveTable(mydb, "mtcars")
 
# ========================================================================   
dbWriteTable(mydb, "mtcars",mtcars[1:5, ])
 

# We will use ???dbExistTable??? function to check whether a table exists 
# and ???dbRemoveTable??? to drop a table

dbExistsTable(mydb, "mtcars")
   
# dbRemoveTable(mydb, "mtcars")
 

# ========================================================================
  # Exploring data within a table

# We will use dbListFields function to list fields within a table 
# and dbSendQuery to send a query to the data base

dbListFields(mydb,
             'metoffice_dailyweatherdata')
 
# ========================================================================  
# dbSendQuery(mydb, 'Select * from country')
 

# ========================================================================
  # Fetch Results to R

# We will use ???dbFetch??? function to fetch results from a query to a data frame in R

# Data_frame = dbFetch(dbSendQuery(Connection_name,
#                                 ???SQL query"),n=number_of_rows)


# country_table = dbFetch(dbSendQuery(mydb,
#                                    'Select * from country'),n=-1)
 

# n = -1 or n = Inf is to retrieve all pending records.

# ========================================================================
  # Error?
   
# dbClearResult(dbListResults(mydb)[[1]])
 

# ========================================================================
# TEST with dbFetch:

country_table = dbFetch(dbSendQuery(mydb,
                                    'Select * from country'),n=-1)
 
   
loc_temp = dbFetch(dbSendQuery(mydb,
                                'SELECT c.location, m.obs_date,
                                        m.temperature
                                 FROM cat_locations AS c
                                 INNER JOIN metoffice_dailyweatherdata AS m
                                 ON c.LocationID = m.LocationId LIMIT 10'),n=-1)
# ======================================================================== 

 #  SESSION 6
# ========================================================================

  # Working with R and SQL

# We will use ???dbListTables??? function to list all tables in our database 
# and ???dbWriteTable??? to write a table from a data frame
   
dbListTables(mydb)


# dbListFields(Connection_name,Table_name) Lists the attributes of a table.

# dbReadTable reads a table as a data.frame.

dbListFields(mydb, "metoffice_dailyweatherdata")
dftempw <- dbReadTable(mydb, "tempw")
print(class(dftempw)) # we extract the tempw table as dataframe
summary(dftempw) # numerical summaries for each attribute
 

# ========================================================================
  # Copying R Data frames to a Database

# We can use the dbWriteTable function to create a database table from 
# R (data frame). We will use one of the tables (mtcars) that exist in R

 # - dbWriteTable(Connection_name,???table_name", data_frame)
                     
                     
# ========================================================================                
data(mtcars)
head(mtcars) # print the first few rows

# dbWriteTable(dbcon,"mtcars",mtcars) # writes the dataframe to the database
dfcars <- dbReadTable(mydb,"mtcars") # read the table from the database
summary(dfcars) # produce numerical summaries

# ========================================================================
  # Removing a table

# - We can check if a table exists in the database with dbExistsTable(Connection_name,"table_name")

# - we can remove a table using the dbRemoveTable(connection_name, "table_name") function:
 
    
# if the table exists remove it
if(dbExistsTable(mydb,"mtcars")){
 dbRemoveTable(mydb, "mtcars")
}else{
 print("Table does not exist")
}

# ========================================================================
  # Running SQL queries

# We can run SQL queries with dbSendQuery and with dbFetch we can fetch all the results. 
# Finally we can disconnect the database with dbDisconnect.

res<- dbSendQuery(mydb,"SELECT * FROM metoffice_dailyweatherdata WHERE LocationId='3002'")

dfres<- dbFetch(res)

summary(dfres)

# ========================================================================
# Disconnect database
# dbDisconnect(mydb)


# ========================================================================
# Databases with tidyverse
# We can also use a database conection with tidyverse (e.g. %>% pipes) using the library dplyr:
    
library(dplyr)

# We can then create a reference tible to one of the databases tables:

tweather <- tbl(mydb,"metoffice_dailyweatherdata")
tweather

# ========================================================================
# Select according to locationid and group by date to display average temperature and windspeed
  
tweather %>%
 filter(LocationId==3002) %>% # selects only the records that contain Location id 3002
 select(obs_date,temperature,windspeed) %>% # selects 3 attributes
 group_by(obs_date) %>%  # group by diferent dates
 summarize(AverageTemp = mean(temperature),
           Averagewind = mean(windspeed)) # for each group print the means


# ========================================================================
# R TASKS

# TASK 1

# Using R to work on the database ???weather.db???. Based on the tables ???timezones??? and ???zones???, please find out the distinct names of all time zones which have within +-2 hours difference from London (GMT).
# 
# STEP A: Extract the two tables from database as data frames in R. Then, based on these two data frames, finding the required time zones using ???joins??? from R package ???dplyr???.
# 
# STEP B: Using function ???dbFetch??? in R to manipulate the data in MySQL, and return the resulting table as data frame in R.
# 
# Remark 1: that column ???gmt_offset??? in table ???timezone??? gives the information for time zones. In ???gmt_offset???, 0 means the London (GMT), 3600 is ???3600 seconds??? (1 hour), and 7200 is  2??3600  seconds??? (2 hours).
# 
# Remark 2: You can use R package ???dplyr??? to get the function called ???inner_join()???

# ========================================================================
 # STEP A
  
#Extract tables for the Data Base
timezones = dbFetch(dbSendQuery(mydb, 'SELECT * FROM timezone'),n=-1)
head(timezones)

zones = dbFetch(dbSendQuery(mydb, 'SELECT * FROM zones'),n=-1)

head(zones)

  
#Filter timezones that are +-2 hours apart from London time
index.1 <- which(((timezones$gmt_offset>=-2*3600)&(timezones$gmt_offset <= 2* 3600))==1)

timezones_near_london <-timezones[index.1, ]

tail(timezones_near_london) # tail prints last 5 observations

# Change the row names (to avoid jumps, e.g. from row 338 to 512)
row.names(timezones_near_london) <- as.character(1:nrow(timezones_near_london))
  
#Join with zones data frame to get the names of the zones
zones_near_london_full <- inner_join(timezones_near_london, zones,by = "zone_id")

#Select distinct names of those zones
zones_near_london <- distinct(zones_near_london_full, zone_name)
zones_near_london

# ========================================================================
# STEP B

sql_zones_near_london = dbFetch(dbSendQuery(mydb,
                                           'SELECT DISTINCT zone_name 
                                           FROM (SELECT * 
                                                 FROM timezone
                                                 WHERE gmt_offset >= - 2*3600
                                                 AND gmt_offset <= 2*3600) l_time
                                                 INNER JOIN zones zon 
                                                 ON zon.zone_id = l_time.zone_id'), n=-1)

sql_zones_near_london = sql_zones_near_london

# ========================================================================
# TASK 2

# Write your results, one data frame obtained in question 1 from either 
# task 1 or 2, as a table in weather.db
  
#Write the new table in weather_db
dbSendQuery(mydb, "SET GLOBAL local_infile = true;")
dbWriteTable(mydb, "sql_zones_near_london", sql_zones_near_london)

# ========================================================================
# TASK 3

# Based on question 2, list all the tables and check whether your newly 
# created table exists in the weather_db (Hint: using dbListTables and dbExistsTable).

#List tables
print(dbListTables(mydb))

#Check if a table exists
dbExistsTable(mydb, "sql_zones_near_london")


# ========================================================================
# TASK 4

# Remove the new table from weather_db (Hint use dbRemoveTable)

dbRemoveTable(mydb, "sql_zones_near_london")

