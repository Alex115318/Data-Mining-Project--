# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# Processing of number of reviews and CCUs in a single CSV file and plotting

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

# Check if the files exists in the specified path
file.exists("data_preprocessed/Reviewnums_bo7_cleaned.csv") #This file contains the number of reviews by date since release. It counts positive and negative reviews.
file.exists("data_preprocessed/CCUs_bo7_cleaned.csv") #This file contains the number of CCUs by date since release.

# Load the CSV files into data frames
reviews_ppc <- read.csv("data_preprocessed/Reviewnums_bo7_cleaned.csv")
ccu_ppc <- read.csv("data_preprocessed/CCUs_bo7_cleaned.csv")

#Transform dates from character into date format
reviews_date <- as.Date(c(reviews_ppc$Date))
ccu_date <- as.Date(c(ccu_ppc$Date))

# Create Plots for graphical analysis ----

## Positive Reviews
positive_reviews <- data.frame(
  date = reviews_date,
  count = reviews_ppc$Positive.reviews,
  type = "Positive"
)

## Negative Reviews. For better plotting, we will convert the negative values to positive
negative_reviews <- data.frame(
  date = reviews_date,
  count = abs(reviews_ppc$Negative.reviews),
  type = "Negative"
)

class(positive_reviews$date) # Check the class of the date variable in positive_reviews
class(negative_reviews$date) # Check the class of the date variable in negative_reviews


## Combine the two data frames for plotting
reviewsplots_df <- rbind(positive_reviews, negative_reviews)

## Plotting for Reviews ----
ggplot() +
  # Histograms for reviews
  geom_bar(
    data = reviewsplots_df,
    aes(x = date, y = count, fill = type),
    stat = "identity",
    position = "dodge",
    alpha = 0.7
  ) +
  #Scale x axis for readability
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month"
  ) +
  # Customize colors for histograms
  scale_fill_manual(values = c("Positive" = "red", "Negative" = "blue")) +
  # Labels and title
  labs(
    title = "Reviews and Player Counts Over Time",
    x = "Date",
    y = "N. Reviews",
    fill = "Review Type"
  ) +
  # Theme
  theme_minimal() +
  theme(legend.position = "top")
  
## Saving plot
ggsave("plots/Reviews_plot.png", width = 10, height = 6)


## Create dfs for Player Counts 

## Player count
pplayer <- data.frame(
  date = ccu_date,
  count = ccu_ppc$Players,
  type = "Precise Players"
)

## Average player count
aplayer <- data.frame(
  date = ccu_date,
  count = ccu_ppc$Average.Players,
  type = "Average Players"
)

class(pplayer$date) # Check the class of the date variable in pplayer
class(aplayer$date) # Check the class of the date variable in aplayer

## Plotting for CCUs ----
ggplot() +
  # Line plot for pplayer
  geom_line(
    data = pplayer,
    aes(x = date, y = count, color = type, group = type),
    size = 1.5
  ) +
  # Line plot for aplayer
  geom_line(
    data = aplayer,
    aes(x = date, y = count, color = type, group = type),
    size = 1.5
  ) +
  # Scale x axis for readability
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month"
  ) +
  # Customize colors for lines
  scale_color_manual(values = c("Precise Players" = "green", "Average Players" = "orange")) +
  # Labels and title
  labs(
    title = "Player Counts Over Time",
    x = "Date",
    y = "N. Players",
    color = "Player Count Type"
  ) +
  # Theme
  theme_minimal() +
  theme(legend.position = "top")

## Saving plot
ggsave("plots/CCU_plot.png", width = 10, height = 6)