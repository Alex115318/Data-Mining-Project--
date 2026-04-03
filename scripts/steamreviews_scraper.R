# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# Scraper for steam reviews(webpage)

# Initialization ----------------------------------------------------------
# Installing packages, loading libraries and setting up the environment

library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)

# URL and GET Requests ----

appid <- "3606480" # Replace with the actual app ID, find the AppID from the steam webstore page
url <- paste0("https://store.steampowered.com/appreviews/", #paste0 is a function to paste string together without spaces
              appid, 
              "?json=1&filter=all&language=all&day_range=9223372036854775807&start_offset=0"
              )
print(url) #Check for the correct URL structure
response <- GET(url)
data <- fromJSON(rawToChar(response$content)) #fetches the data in a readable JSON format

## Clean the data by removing "author" related information ----
# Assuming 'data' is the parsed JSON from the API response

# Remove the 'author' branch from each review to avoid sensitive info
clean_reviews <- lapply(data$reviews, function(review) {
  review$author <- NULL  # Remove author info
  return(review)
})
 
# Convert the list of reviews to a data frame
reviews_df <- do.call(rbind, lapply(clean_reviews, as.data.frame))

# If you want to keep only specific fields (optional)
# reviews_df <- reviews_df[, c("recommendationid", "language", "review", "timestamp_created", "voted_up", "votes_up", "votes_funny", "weighted_vote_score")]

# Print the first few rows to check
head(reviews_df)