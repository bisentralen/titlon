# YOU NEED TO BE CONNECTED TO YOUR INSTITUTION VIA VPN, OR BE AT THE INSTITUTION, FOR THIS CODE TO WORK
# Ctrl+c to copy


# 1. Load or install necessary packages
require(writexl) || {install.packages("writexl"); require(writexl)}
require(RMySQL) || {install.packages("RMySQL"); require(RMySQL)}

# 2. Connect using RMySQL.
# NB! Your username is changed every time you generate new code on the Titlon page.
con<-dbConnect(RMySQL::MySQL(),
               host      = "titlon.uit.no",
               user      = "YourUsername",
               password  = "YourPassword",
               db        = "OSE")

# 3. Check tables and fields (this is just for verification and it is optional)
dbListTables(con)
dbListFields(con,"equity")

# 4, Send the SQL-query
rs = dbSendQuery(con, "
	SELECT 
		`Effect date`, `Internal code`, `ISIN code`, `Instrument name`, `Short name`, `Trading Place`, `Issuing country code`, `Trading currency code`, `Segment`, `First price`, `Highest price`, `Lowest price`, `Last price`, `Turnover in euro`, `Volume`, `Number of trades`, `Best bid price`, `Best bid size`, `Best ask price`, `Best ask size`, `Price`, `Price Prev`, `log return`, `Corporate adjustment factor`, `Adjusted Price`, `Adjusted Price Prev`, `filename`, `date_inserted`, `ID` 
	FROM `euronext`.`csh_sum_share_osl` 
	WHERE (`ISIN code` = 'DK0060945467' OR `ISIN code`='NO0010844038' OR `ISIN code`='NO0010936081' OR `ISIN code`='NO0010921232') 
	AND year(`Effect date`) BETWEEN 2022 AND 2023
	ORDER BY `Instrument name`, `Effect date`, `Turnover in euro` DESC
")

# Year examples
# From 2020 - 2023: AND year(`Effect date`) BETWEEN 2022 AND 2024
# The specific years 2016, 2020, 2023: AND year(`Effect date`) IN (2016, 2020, 2023) 

# Sorting the data
# Sort by name and newest date first: ORDER BY `Instrument name`, `Effect date` DESC
# Sort by year, then Instrument name: ORDER BY year(`Effect date`), `Instrument name`, `Effect date`
# Sort by Instrument name, date and Highest turnover: ORDER BY `Instrument name`, `Effect date`, `Turnover in euro` DESC


# 5. Fetch the data in a dataframe
titlon_data=fetch(rs,-1)


# YOU NEED TO BE CONNECTED TO YOUR INSTITUTION VIA VPN, OR BE AT THE INSTITUTION, FOR THIS CODE TO WORK
# Ctrl+c to copy

# 6. Write data to csv and/or Excel
# csv
write.csv(titlon_data, file = "5th_planet_2025.csv", row.names = FALSE)
# Excel
write_xlsx(titlon_data, path ="5th_planet_2025.xlsx")

