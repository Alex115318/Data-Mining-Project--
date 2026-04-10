# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# File Analyzer for CCUs

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
# The ConCurrent User count (CCU) refers to the number of active players in 
# any given day. The data contains a daily average count and a specific count at Midnight UTC.
# The data is collected from the SteamDB website, which provides historical data on player counts for various games
# that can be downloaded as CSV or XLSX files.

file.exists("data_raw/steamdb_chart_1938090.csv") # Check if the file exists in the specified path

# Read the CSV file into a data frame
ccu_data <- read.csv("data_raw/steamdb_chart_1938090.csv")

# Data Cleaning and Preprocessing ----

# The Data dates back to 2022, because it belongs to the same franchise, but releases yearly. 
# For our project we focus on the latest, CoD: Black Ops 7, which was released on 14th of November 2025.

## Tyding ----
# Convert DateTime to only Date for easier filtering and analysis

ccu_data <- ccu_data %>%
  mutate(date_column = dmy(format(as.Date(DateTime, format = "%Y-%m-%d %H:%M:%S"), "%d-%m-%Y")))

#Remove the original DateTime column and rename the new date column to "Date"

ccu_data <- ccu_data %>% select(-DateTime) %>% rename(Date = date_column) 

# Filter the data to include only entries from November 14, 2025, onwards
ccu_data <- ccu_data %>% filter(Date >= as.Date("2025-11-14"))

## Save the cleaned data to a new CSV file for future analysis ----
write.csv(ccu_data, "data_preprocessed/CCUs_bo7_cleaned.csv", row.names = FALSE) 
# We keep the NAs now, but will remove them later, when we will merge the data with the reviews