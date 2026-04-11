# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# Preprocessing for Number of Reviews

# Initialization ----
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("lubridate")

library(tidyverse)
library(ggplot2)
library(dplyr)
library(lubridate)

# Loading the CSV File ----
# The data is collected from the SteamDB website, which provides historical data on player reviews for various games
# that can be downloaded as CSV or XLSX files.

file.exists("data_raw/steamdb_chart_3606480.csv") # Check if the file exists in the specified path

# Read the CSV file into a data frame
revcount_data <- read.csv("data_raw/steamdb_chart_3606480.csv")

# Data Cleaning and Preprocessing ----

# Convert DateTime to only Date for easier filtering and analysis

revcount_data <- revcount_data %>%
  mutate(date_column = dmy(format(as.Date(DateTime, format = "%Y-%m-%d %H:%M:%S"), "%d-%m-%Y")))

#Remove the original DateTime column and rename the new date column to "Date"

revcount_data <- revcount_data %>% select(-DateTime) %>% rename(Date = date_column) 

## Save the cleaned data to a new CSV file for future analysis ----
write.csv(revcount_data, "data_preprocessed/Reviewnums_bo7_cleaned.csv", row.names = FALSE) 
# We keep the NAs now, but will remove them later, when we will merge the data with the CCUs
#It could be useful to exclude the rows with a low number of reviews, depending on the type of plot we use