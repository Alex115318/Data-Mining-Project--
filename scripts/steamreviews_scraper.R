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
library(dplyr)
library(stringr)

# URL and GET Requests ----

## Define variables ----
appid <- "1938090" # Replace with the actual app ID, find the AppID from the steam webstore page URL
cursor <- "*" # Cursor is used for pagination, "*" means starting point, it will be updated in the loop to fetch next pages of reviews
has_more_reviews = TRUE # Flag to control the loop, it will be set to FALSE when there are no more reviews to fetch
all_reviews <- list() # Initialize an empty list to store all reviews

### Parameters for the URL:
### json=1: Return the response in JSON format.
### filter=all: Fetch all reviews, including those that are not recommended. 
### language=english: Fetch reviews in English.
### day_range=148: Fetch reviews from the last 365 days. This limits the reviews to a specific time frame. It is recommended to define this parameter, since older reviews date back years.
### start_offset=0: Start fetching reviews from the beginning (offset 0). This is used for pagination.
### filter_offtopic_activity=0: Include reviews that are marked as off-topic, e.g. review bombing activities.

base_url <- paste0("https://store.steampowered.com/appreviews/", 
                   appid, 
                   "?json=1&filter=all&language=english&day_range=148&start_offset=0&filter_offtopic_activity=0")
print(base_url) # Print the base URL to check if it's correct

## Create Loop for extracting reviews ----

while(has_more_reviews) {
  
  #Construct the GET request URL with the current cursor for pagination
  url <- paste0(base_url, 
                "&cursor=",
                cursor)
  
  # Make the GET request to the Steam API
  response <- GET(url)
  data <- fromJSON(rawToChar(response$content)) 
  
  #Check if the reviews exist
  if (is.null(data$reviews) || length(data$reviews) == 0) {
    has_more_reviews <- FALSE
    break 
  }
  
  # Append reviews to the list
  all_reviews <- c(all_reviews, data$reviews)
  
  # Update the cursor for the next request
  cursor <- data$cursor
  
  # Check if there are more reviews
  if (is.null(cursor) || cursor == "") {
    has_more_reviews <- FALSE
  }
  
  Sys.sleep(2) # Sleep for 2 second to avoid hitting the API rate limit
}

## We want to filter for the reviews for launch day. ----

#UNIX Timeframe is 1763082000 - 1763168400 (14th and 15th Nov 2025)
start_time <- 1763082000
end_time <- 1763168400

# Filter the list directly
filtered_reviews <- all_reviews[
  sapply(all_reviews, function(review) {
    # Check if timestamp_created exists and is within the range
    if (!is.null(review$timestamp_created)) {
      review$timestamp_created >= start_time & review$timestamp_created <= end_time
    } else {
      FALSE  # Exclude reviews without a timestamp
    }
  })
]
  
  
  
# Flatten the list and convert to a data frame
flattened_reviews <- unlist(all_reviews, recursive = TRUE, use.names = TRUE)

reviews_df <- do.call(rbind, lapply(flattened_reviews, as.data.frame))

# View the result
head(reviews_df)

# Print the number of reviews fetched
print(paste("Total reviews fetched:", nrow(reviews_df)))

#Save as CSV
write.csv(reviews_df, "bo7_steam_reviews.csv", row.names = FALSE)

## Clean the data by removing "author" related information ----
# Assuming 'data' is the parsed JSON from the API response

 


# If you want to keep only specific fields (optional)
reviews_df <- reviews_df[, c("recommendationid", "language", "review", "timestamp_created", "voted_up", "votes_up", "votes_funny", "weighted_vote_score")]

# Print the first few rows to check
head(reviews_df)