# YOU NEED TO BE CONNECTED TO YOUR INSTITUTION VIA VPN, OR BE AT THE INSTITUTION, FOR THIS CODE TO WORK
# Ctrl+c to copy


# 1. Load or install necessary packages
require(writexl) || {install.packages("writexl"); require(writexl)}
require(RMySQL) || {install.packages("RMySQL"); require(RMySQL)}
require(ggplot2) || {install.packages("ggplot2"); require(ggplot2)}

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
		*
	FROM `euronext`.`csh_sum_share_osl` 
	WHERE ('ISIN code = 'NO0010033590',`ISIN code` = 'NL0015001BF4' OR `ISIN code`='NO0010844038' OR `ISIN code`='NO0010936081' OR `ISIN code`='NO0010112675') 
	AND year(`Effect date`) BETWEEN 2020 AND 2024
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

# 7. Create a plot and save it in an object caled 'instrument_graph"
# Lag grafen og lagre den i et objekt som heter 'aksjegraf'

# 1. Sørg for at R tolker 'Effect date' som en ordentlig dato
titlon_data$`Effect date` <- as.Date(titlon_data$`Effect date`)

# 2. Fjern eventuelle rader der kursen mangler (kun for sikkerhets skyld)
titlon_data <- titlon_data[!is.na(titlon_data$`Adjusted Price`), ]

# 3. Tegn grafen på nytt
aksjegraf <- ggplot(data = titlon_data, aes(x = `Effect date`, y = `Adjusted Price`, color = `Instrument name`)) +
  # 'group = `Instrument name`' tvinger R til å koble punktene sammen per aksje
  # 'na.rm = TRUE' gjør at den hopper over tomme celler i stedet for å brekke linjen
  geom_line(aes(group = `Instrument name`), size = 0.8, na.rm = TRUE) +                                 
  labs(
    title = "Aksjekursutvikling (Titlon Data)",
    subtitle = "Utvikling i justert sluttkurs over valgt tidsperiode",
    x = "Dato",
    y = "Justert Kurs",
    color = "Selskap"
  ) +
  theme_minimal() +                                       
  theme(legend.position = "bottom")                       

# Vis grafen
print(aksjegraf)