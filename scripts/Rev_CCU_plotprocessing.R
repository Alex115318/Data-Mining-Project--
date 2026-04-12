# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# Processing of number of reviews and CCUs in a single CSV file for plotting

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

# Merge the two data frames by the "Date" column ----
merged_data <- merge(reviews_ppc, ccu_ppc, by = "Date")

# Save the merged data to a new CSV 
write.csv(merged_data, "data_preprocessed/merged_reviews_ccus.csv", row.names = FALSE)



# Create Plots for graphical analysis ----

## Positive Reviews
positive_reviews <- data.frame(
  date = merged_data$Date,
  count = merged_data$Positive.reviews,
  type = "Positive"
)

## Negative Reviews. For better plotting, we will convert the negative values to positive
negative_reviews <- data.frame(
  date = merged_data$Date,
  count = abs(merged_data$Negative.reviews),
  type = "Negative"
)

## Combine the two data frames for plotting
reviewsplots_df <- rbind(positive_reviews, negative_reviews)

## Plotting 
ggplot() +
  # Histograms for reviews
  geom_bar(
    data = reviewsplots_df,
    aes(x = date, y = count, fill = type),
    stat = "identity",
    position = "dodge",
    alpha = 0.7
  ) + # Curves for player counts
  geom_line(
    data = merged_data,
    aes(x = Date, y = Players / max(merged_data$Players, na.rm = TRUE) * max(reviewsplots_df$count, na.rm = TRUE)),
    color = "green",
    linetype = "solid",
    linewidth = 1
  ) +
  geom_line(
    data = merged_data,
    aes(x = Date, y = Average.Players / max(merged_data$Average.Players, na.rm = TRUE) * max(reviewsplots_df$count, na.rm = TRUE)),
    color = "orange",
    linetype = "dashed",
    linewidth = 1
  ) +
  # Customize colors for histograms
  scale_fill_manual(values = c("Positive" = "red", "Negative" = "blue")) +
  # Labels and title
  labs(
    title = "Reviews and Player Counts Over Time",
    x = "Date",
    y = "Count / Normalized Players",
    fill = "Review Type"
  ) +
  # Adjust y-axis to accommodate both histograms and curves
  scale_y_continuous(
    sec.axis = sec_axis(~ . / max(reviewsplots_df$count, na.rm = TRUE) * max(merged_data$Players, na.rm = TRUE), name = "Player Counts")
  ) +
  # Theme
  theme_minimal() +
  theme(legend.position = "top")
  