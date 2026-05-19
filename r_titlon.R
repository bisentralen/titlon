
require(RMySQL) || {install.packages("RMySQL"); require(RMySQL)}

con<-dbConnect(RMySQL::MySQL(),
               host      = "titlon.uit.no",
               user      = "YourUsername",
               password  = "YourPassword",
               db        = "OSE")

dbListTables(con)
dbListFields(con,"equity")
rs = dbSendQuery(con, "
	SELECT  * FROM `euronext`.`csh_sum_share_osl` 
	WHERE (`ISIN code` = 'DK0060945467') 
	AND year(`Effect date`) >= 2025
	ORDER BY `Instrument name`, `Effect date`
")
titlon_data=fetch(rs,-1)

# Skriv ut data i tabell
# csv
write.csv(titlon_data, file = "5th_planet_2025.csv", row.names = FALSE)



# YOU NEED TO BE CONNECTED TO YOUR INSTITUTION VIA VPN, OR BE AT THE INSTITUTION, FOR THIS CODE TO WORK
# Ctrl+c to copy
